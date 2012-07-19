//
//  PSPDFDownload.m
//  PSPDFKitExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFDownload.h"
#import "PSPDFStoreManager.h"
#import "AppDelegate.h"
#import "AFNetworking/AFNetworking/AFHTTPRequestOperation.h"
#import "AFDownloadRequestOperation/AFDownloadRequestOperation.h"
#include <sys/xattr.h>

@interface PSPDFDownload () {
    UIProgressView *progressView_;
}
@property(nonatomic, strong) NSURL *URL;
@property(nonatomic, assign) PSPDFStoreDownloadStatus status;
@property(nonatomic, assign) float downloadProgress;
@property(nonatomic, strong) NSError *error;
@property(nonatomic, strong) AFHTTPRequestOperation *request;
@property(nonatomic, assign, getter=isCancelled) BOOL cancelled;
@end

@implementation PSPDFDownload

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

+ (PSPDFDownload *)PDFDownloadWithURL:(NSURL *)URL {
    return [[[self class] alloc] initWithURL:URL];
}

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
    return [NSString stringWithFormat:@"<%@: %@ progress:%.1f>", NSStringFromClass([self class]), self.magazine.title, self.downloadProgress];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (NSString *)downloadDirectory {
    NSString *downloadDirectory = [[PSPDFStoreManager storagePath] stringByAppendingPathComponent:@"downloads"];
    return downloadDirectory;
}

- (PSPDFMagazine *)magazine {
    if (!_magazine) {
        self.magazine = [[PSPDFMagazine alloc] init];
        _magazine.downloading = YES;
    }
    return _magazine;
}

- (void)setStatus:(PSPDFStoreDownloadStatus)aStatus {
    _status = aStatus;

    // remove progress view, animated
    if (progressView_ && (_status == PSPDFStoreDownloadFinished || _status == PSPDFStoreDownloadFailed)) {
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

- (void)startDownload {
    NSString *dirPath = [self downloadDirectory];
    NSString *destPath = [dirPath stringByAppendingPathComponent:[self.URL lastPathComponent]];

    // create folder
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if (![fileManager fileExistsAtPath:dirPath]) {
        NSError *fileError = nil;
        if(![fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:&fileError]) {
            PSELog(@"Error while creating directory: %@", [fileError localizedDescription]);
        }
    }

    PSELog(@"downloading pdf from %@ to %@", self.URL, destPath);

    // create request
    NSURLRequest *request = [NSURLRequest requestWithURL:self.URL];
    AFDownloadRequestOperation *pdfRequest = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:[self downloadDirectory] shouldResume:YES];
    __ps_weak AFDownloadRequestOperation *pdfRequestWeak = pdfRequest;
    [pdfRequest setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
        PSELog(@"Download background time expired for %@", pdfRequestWeak);
    }];
    [pdfRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        PSELog(@"Download finished: %@", self.URL);

        if (self.isCancelled) {
            self.status = PSPDFStoreDownloadFailed;
            self.magazine.downloading = NO;
            return;
        }

        NSString *fileName = [self.request.request.URL lastPathComponent];
        NSString *destinationPath = [[self downloadDirectory] stringByAppendingPathComponent:fileName];
        NSURL *destinationURL = [NSURL fileURLWithPath:destinationPath];
        self.magazine.available = YES;
        self.magazine.downloading = NO;
        self.magazine.fileURL = destinationURL;
        self.status = PSPDFStoreDownloadFinished;

        // start crunching!
        [[PSPDFCache sharedCache] cacheDocument:self.magazine startAtPage:0 size:PSPDFSizeNative];
        [[PSPDFCache sharedCache] cacheThumbnailsForDocument:self.magazine];

        // don't back up the downloaded pdf - iCloud is for self-created files only.
        [self addSkipBackupAttributeToFile:destinationURL];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PSELog(@"Download failed: %@. Reason: %@.", self.URL, [error localizedDescription]);
        self.status = PSPDFStoreDownloadFailed;
        self.error = pdfRequestWeak.error;
        self.magazine.downloading = NO;
    }];
    [pdfRequest setProgressiveDownloadProgressBlock:^(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
        self.downloadProgress = totalBytesReadForFile/(float)totalBytesExpectedToReadForFile;

    }];    
    [pdfRequest start];

    self.request = pdfRequest; // save request
    [[PSPDFStoreManager sharedStoreManager] addMagazinesToStore:@[self.magazine]];
}

- (void)cancelDownload {
    self.cancelled = YES;
    [_request cancel];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

// set a flag that the files shouldn't be backuped to iCloud.
// https://developer.apple.com/library/ios/#qa/qa1719/_index.html
- (void)addSkipBackupAttributeToFile:(NSURL *)url {
    u_int8_t b = 1;
    setxattr([[url path] fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
}

@end
