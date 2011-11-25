//
//  PSPDFDownload.m
//  PSPDFKitExample
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFDownload.h"
#import "ASIHTTPRequest.h"
#import "PSPDFStoreManager.h"
#import "AppDelegate.h"
#include <sys/xattr.h>

@interface PSPDFDownload()
//@property(nonatomic, retain) PSPDFMagazine *magazine;
@property(nonatomic, strong) NSURL *url;
@property(nonatomic, assign) PSPDFStoreDownloadStatus status;
@property(nonatomic, assign) float downloadProgress;
@property(nonatomic, copy) NSError *error;
@property(nonatomic, strong) ASIHTTPRequest *request;
@property(nonatomic, assign, getter=isCancelled) BOOL cancelled;
@end

@implementation PSPDFDownload

@synthesize url = url_;
@synthesize magazine = magazine_;
@synthesize request = request_;
@synthesize status = status_;
@synthesize downloadProgress = downloadProgress_;
@synthesize error = error_;
@synthesize cancelled = cancelled_;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

// set a flag that the files shouldn't be backuped to iCloud.
// http://adcdownload.apple.com//ios/ios_5.0.1_beta/iclouddonotbackupattribute.pdf
- (void)addSkipBackupAttributeToFile:(NSURL *)url {
    u_int8_t b = 1;
    setxattr([[url path] fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

+ (PSPDFDownload *)PDFDownloadWithURL:(NSURL *)url; {
    PSPDFDownload *pdfDownload = [[[self class] alloc] initWithURL:url];
    return pdfDownload;
}

- (id)initWithURL:(NSURL *)url; {
    if ((self = [super init])) {
        url_ = url;
    }
    return self;
}

- (void)dealloc {
    [progressView_ removeFromSuperview];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<PSPDFDownload: %@ progress:%f", self.magazine.title, self.downloadProgress];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (NSString *)downloadDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);    
    NSString *downloadDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"downloads"];
    return downloadDirectory;
}

- (PSPDFMagazine *)magazine {
    if (!magazine_) {
        self.magazine = [[PSPDFMagazine alloc] init];
        magazine_.downloading = YES;
    }
    return magazine_;
}

- (void)setStatus:(PSPDFStoreDownloadStatus)aStatus {
    [self willChangeValueForKey:@"status"];
    status_ = aStatus;
    [self didChangeValueForKey:@"status"];
    
    // remove progress view, animated
    if (progressView_ && (status_ == PSPDFStoreDownloadFinished || status_ == PSPDFStoreDownloadFailed)) {
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

- (void)setProgressDelegate:(id<ASIProgressDelegate>)progressDelegate; {
    [request_ setDownloadProgressDelegate:progressDelegate];
}

- (void)startDownload {
    NSError *error = nil;
    NSString *dirPath = [self downloadDirectory];
    NSString *destPath = [dirPath stringByAppendingPathComponent:[self.url lastPathComponent]];  
    
    // create folder
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if (![fileManager fileExistsAtPath:dirPath]) {
        [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    PSELog(@"downloading pdf from %@ to %@", self.url, destPath);
    
    // create request
    ASIHTTPRequest *pdfRequest = [ASIHTTPRequest requestWithURL:self.url];
    [pdfRequest setAllowResumeForFileDownloads:YES];
    [pdfRequest setShowAccurateProgress:YES];
    [pdfRequest setNumberOfTimesToRetryOnTimeout:0];
    [pdfRequest setTimeOutSeconds:30.0];
    [pdfRequest setShouldContinueWhenAppEntersBackground:YES];
    [pdfRequest setDownloadDestinationPath:destPath];
    [pdfRequest setDownloadProgressDelegate:self]; // add ui tracking
    
    [pdfRequest setCompletionBlock:^(void) {
        PSELog(@"Download finished: %@", self.url);
        
        if (self.isCancelled) {
            self.status = PSPDFStoreDownloadFailed;
            self.magazine.downloading = NO;
            return;
        }
        
        self.status = PSPDFStoreDownloadFinished;
        NSString *fileName = [self.request.url lastPathComponent];
        NSString *destinationPath = [[self downloadDirectory] stringByAppendingPathComponent:fileName];
        NSURL *destinationUrl = [NSURL fileURLWithPath:destinationPath];
        [self.magazine setFileUrl:destinationUrl];
        self.magazine.available = YES;
        self.magazine.downloading = NO;
        
        // don't back up the downloaded pdf - iCloud is for self-created files only.
        [self addSkipBackupAttributeToFile:destinationUrl];
    }];
    
    __ps_weak ASIHTTPRequest *pdfRequestWeak = pdfRequest;
    [pdfRequest setFailedBlock:^(void) {
        PSELog(@"Download failed: %@. reason:%@", self.url, [pdfRequestWeak.error localizedDescription]);
        self.status = PSPDFStoreDownloadFailed;
        self.error = pdfRequestWeak.error;
        self.magazine.downloading = NO;
    }];
    self.status = PSPDFStoreDownloadLoading;
    [pdfRequest startAsynchronous];
    
    self.request = pdfRequest; // save request
    [[PSPDFStoreManager sharedPSPDFStoreManager] addMagazinesToStore:[NSArray arrayWithObject:self.magazine]];
}

- (void)cancelDownload {
    self.cancelled = YES;
    [request_ cancel];
}

- (void)setProgress:(float)theProgress {
    self.downloadProgress = theProgress;
}

@end
