//
//  PSCDownload.m
//  PSPDFCatalog
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSCDownload.h"
#import "PSCStoreManager.h"
#import "AFHTTPRequestOperation.h"
#import "AFDownloadRequestOperation.h"

@interface PSCDownload () {
    UIProgressView *progressView_;
}
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, assign) PSCStoreDownloadStatus status;
@property (nonatomic, assign) float downloadProgress;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) AFHTTPRequestOperation *request;
@end

@implementation PSCDownload

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithURL:(NSURL *)URL {
    if ((self = [super init])) {
        _URL = URL;
    }
    return self;
}

- (void)dealloc {
    [progressView_ removeFromSuperview];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p: %@ progress:%.1f>", self.class, self, self.magazine.title, self.downloadProgress];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (NSString *)downloadDirectory {
    return [[PSCStoreManager storagePath] stringByAppendingPathComponent:@"downloads"];
}

- (PSCMagazine *)magazine {
    if (!_magazine) {
        self.magazine = [[PSCMagazine alloc] init];
        _magazine.downloading = YES;
    }
    return _magazine;
}

- (void)setStatus:(PSCStoreDownloadStatus)aStatus {
    _status = aStatus;

    // remove progress view, animated
    if (progressView_ && _status != PSCStoreDownloadStatusLoading) {
        [UIView animateWithDuration:0.25 delay:0 options:0 animations:^{
            progressView_.alpha = 0.f;
        } completion:^(BOOL finished) {
            if (finished) {
                progressView_.hidden = YES;
                [progressView_ removeFromSuperview];
            }
        }];
    }
}

- (BOOL)isCancelled {
    return self.status == PSCStoreDownloadStatusCancelled;
}

- (void)startDownload {
    NSString *dirPath = [self downloadDirectory];
    NSString *destPath = [dirPath stringByAppendingPathComponent:[self.URL lastPathComponent]];

    // create folder
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if (![fileManager fileExistsAtPath:dirPath]) {
        NSError *fileError = nil;
        if (![fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:&fileError]) {
            PSCLog(@"Error while creating directory: %@", [fileError localizedDescription]);
        }
    }
    PSCLog(@"downloading pdf from %@ to %@", self.URL, destPath);

    // create request
    NSURLRequest *request = [NSURLRequest requestWithURL:self.URL];
    AFDownloadRequestOperation *pdfRequest = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:[self downloadDirectory] shouldResume:YES];
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

        NSString *fileName = [self.request.request.URL lastPathComponent];
        NSString *destinationPath = [[self downloadDirectory] stringByAppendingPathComponent:fileName];
        NSURL *destinationURL = [NSURL fileURLWithPath:destinationPath];
        self.magazine.available = YES;
        self.magazine.downloading = NO;
        self.magazine.fileURL = destinationURL;
        self.status = PSCStoreDownloadStatusFinished;

        // start crunching!
        [[PSPDFCache sharedCache] cacheDocument:self.magazine startAtPage:0 size:PSPDFSizeNative];
        [[PSPDFCache sharedCache] cacheThumbnailsForDocument:self.magazine];

        // don't back up the downloaded pdf - iCloud is for self-created files only.
        [self addSkipBackupAttributeToItemAtURL:destinationURL];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PSCLog(@"Download failed: %@. Reason: %@.", self.URL, [error localizedDescription]);
        self.status = PSCStoreDownloadStatusFailed;
        self.error = pdfRequestWeak.error;
        self.magazine.downloading = NO;
    }];
    [pdfRequest setProgressiveDownloadProgressBlock:^(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
        self.downloadProgress = totalBytesReadForFile/(float)totalBytesExpectedToReadForFile;

    }];    
    [pdfRequest start];

    self.request = pdfRequest; // save request
    [[PSCStoreManager sharedStoreManager] addMagazinesToStore:@[self.magazine]];
}

- (void)cancelDownload {
    self.status = PSCStoreDownloadStatusCancelled;
    [_request cancel];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

// set a flag that the files shouldn't be backuped to iCloud.
// https://developer.apple.com/library/ios/#qa/qa1719/_index.html
#include <sys/xattr.h>
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
    assert([[NSFileManager defaultManager] fileExistsAtPath:[URL path]]);
    BOOL success = NO;

    // Weak-linking of NSURLIsExcludedFromBackupKey works in Xcode 4.5 and above.
    // http://stackoverflow.com/questions/9620651/use-nsurlisexcludedfrombackupkey-without-crashing-on-ios-5-0
    if (kCFCoreFoundationVersionNumber >= 690.1) { // iOS_5_1
        NSError *error = nil;
        success = [URL setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:&error];
        if (!success){
            PSPDFLogError(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }
    // only works with 5.0.1 and above
    }else {
        success = YES;
        u_int8_t b = 1;
        setxattr([[URL path] fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
    }
    return success;
}

@end
