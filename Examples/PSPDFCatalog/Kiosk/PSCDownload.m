//
//  PSCDownload.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCDownload.h"
#import "PSCStoreManager.h"
#import "AFHTTPRequestOperation.h"
#import "AFDownloadRequestOperation.h"

@interface PSCDownload ()
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, copy) NSURL *URL;
@property (nonatomic, assign) PSCStoreDownloadStatus status;
@property (nonatomic, assign) float downloadProgress;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) AFHTTPRequestOperation *request;
@end

@implementation PSCDownload

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (instancetype)initWithURL:(NSURL *)URL {
    if ((self = [super init])) {
        _URL = URL;
    }
    return self;
}

- (void)dealloc {
    [_progressView removeFromSuperview];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p: %@ progress:%.1f>", self.class, self, self.magazine.title, self.downloadProgress];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (NSString *)downloadDirectory {
    return [PSCStoreManager.storagePath stringByAppendingPathComponent:@"downloads"];
}

- (PSCMagazine *)magazine {
    if (!_magazine) {
        self.magazine = [[PSCMagazine alloc] init];
        _magazine.downloading = YES;
    }
    return _magazine;
}

- (void)setStatus:(PSCStoreDownloadStatus)status {
    _status = status;

    // remove progress view, animated
    if (self.progressView && _status != PSCStoreDownloadStatusLoading) {
        [UIView animateWithDuration:0.25f delay:0.f options:0 animations:^{
            self.progressView.alpha = 0.f;
        } completion:^(BOOL finished) {
            if (finished) {
                self.progressView.hidden = YES;
                [self.progressView removeFromSuperview];
            }
        }];
    }
}

- (BOOL)isCancelled {
    return self.status == PSCStoreDownloadStatusCancelled;
}

- (void)startDownload {
    NSString *dirPath = self.downloadDirectory;
    NSString *destPath = [dirPath stringByAppendingPathComponent:self.URL.lastPathComponent];

    // create folder
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if (![fileManager fileExistsAtPath:dirPath]) {
        NSError *fileError = nil;
        if (![fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:&fileError]) {
            PSCLog(@"Error while creating directory: %@", fileError.localizedDescription);
        }
    }
    PSCLog(@"downloading pdf from %@ to %@", self.URL, destPath);

    // create request
    NSURLRequest *request = [NSURLRequest requestWithURL:self.URL];
    AFDownloadRequestOperation *pdfRequest = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:self.downloadDirectory shouldResume:YES];
    __weak AFDownloadRequestOperation *pdfRequestWeak = pdfRequest;
    [pdfRequest setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
        PSCLog(@"Download background time expired for %@", pdfRequestWeak);
    }];
    [pdfRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        PSCLog(@"Download finished: %@", self.URL);

        if (self.isCancelled) {
            self.status = PSCStoreDownloadStatusFailed;
            self.magazine.downloading = NO;
            return;
        }

        NSString *fileName = self.request.request.URL.lastPathComponent;
        NSString *destinationPath = [self.downloadDirectory stringByAppendingPathComponent:fileName];
        NSURL *destinationURL = [NSURL fileURLWithPath:destinationPath];
        self.magazine.available = YES;
        self.magazine.downloading = NO;
        self.status = PSCStoreDownloadStatusFinished;
        // This is readonly, but we're lazy here.
        [self.magazine setValue:destinationURL forKey:@"fileURL"];

        // Start caching thumbnail and full-image sizes so that the document will render faster.
        [PSPDFKit.sharedInstance.cache cacheDocument:self.magazine pageSizes:@[BOXED(CGSizeMake(170.f, 220.f)), BOXED(UIScreen.mainScreen.bounds.size)] withDiskCacheStrategy:PSPDFDiskCacheStrategyNearPages aroundPage:0];

        // don't back up the downloaded pdf - iCloud is for self-created files only.
        NSError *error = nil;
        if (![destinationURL setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:&error]){
            NSLog(@"Error excluding %@ from backup %@", destinationURL, error);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PSCLog(@"Download failed: %@. Reason: %@.", self.URL, error.localizedDescription);
        self.status = PSCStoreDownloadStatusFailed;
        self.error = pdfRequestWeak.error;
        self.magazine.downloading = NO;
    }];
    [pdfRequest setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
        self.downloadProgress = totalBytesReadForFile/(float)totalBytesExpectedToReadForFile;

    }];
    [pdfRequest start];

    // save request
    self.request = pdfRequest;
    [PSCStoreManager.sharedStoreManager addMagazinesToStore:@[self.magazine]];
}

- (void)cancelDownload {
    self.status = PSCStoreDownloadStatusCancelled;
    [self.request cancel];
}

@end
