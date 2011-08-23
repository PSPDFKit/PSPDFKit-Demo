//
//  PSPDFDownload.m
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/24/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFDownload.h"
#import "ASIHTTPRequest.h"
#import "PSPDFStoreManager.h"
#import "AppDelegate.h"

@interface PSPDFDownload()
@property(nonatomic, retain) PSPDFMagazine *magazine;
@property(nonatomic, retain) NSURL *url;
@property(nonatomic, assign) PSPDFStoreDownloadStatus status;
@property(nonatomic, assign) float downloadProgress;
@property(nonatomic, copy) NSError *error;
@property(nonatomic, retain) ASIHTTPRequest *request;
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
#pragma mark - NSObject

+ (PSPDFDownload *)PDFDownloadWithURL:(NSURL *)url; {
    PSPDFDownload *pdfDownload = [[[[self class] alloc] initWithURL:url] autorelease];
    return pdfDownload;
}

- (id)initWithURL:(NSURL *)url; {
    if ((self = [super init])) {
        url_ = [url retain];
    }
    return self;
}

- (void)dealloc {
    [progressView_ removeFromSuperview];
    [progressView_ release];
    [request_ release];
    [url_ release];
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<PSPDFDownload: %@ progress:%f", self.magazine.title, self.downloadProgress];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (PSPDFMagazine *)magazine {
    if (!magazine_) {
        // build potential download path
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);    
        NSString *dirPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"downloads"];
        NSString *fileName = [self.request.url lastPathComponent];
        dirPath = [dirPath stringByAppendingPathComponent:fileName];
        self.magazine = [PSPDFMagazine magazineWithPath:dirPath];
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);    
    NSString *dirPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"downloads"];
    NSString *destPath = [dirPath stringByAppendingPathComponent:[self.url lastPathComponent]];  
    
    // create folder
    if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    PSELog(@"downloading pdf from %@ to %@", self.url, destPath);
    
    // create request
    ASIHTTPRequest *pdfRequest = [ASIHTTPRequest requestWithURL:self.url];
    [pdfRequest setAllowResumeForFileDownloads:YES];
    [pdfRequest setShowAccurateProgress:YES];
    [pdfRequest setNumberOfTimesToRetryOnTimeout:0];
    [pdfRequest setTimeOutSeconds:20.0];
    [pdfRequest setShouldContinueWhenAppEntersBackground:YES];
    [pdfRequest setDownloadDestinationPath:destPath];
    [pdfRequest setDownloadProgressDelegate:self]; // add ui tracking
    
    [pdfRequest setCompletionBlock:^(void) {
        PSELog(@"Download finished: %@", self.url);
        
        if (self.isCancelled) {
            self.status = PSPDFStoreDownloadFailed;
            return;
        }
        
        self.status = PSPDFStoreDownloadFinished;
        self.magazine.downloading = NO;
    }];
    
    [pdfRequest setFailedBlock:^(void) {
        PSELog(@"Download failed: %@. reason:%@", self.url, [pdfRequest.error localizedDescription]);
        self.status = PSPDFStoreDownloadFailed;
        self.error = pdfRequest.error;
    }];
    self.status = PSPDFStoreDownloadLoading;
    [pdfRequest startAsynchronous];
    
    self.request = pdfRequest; // save request
    [[PSPDFStoreManager sharedPSPDFStoreManager] downloadLoadedData:self];
}

- (void)cancelDownload {
    self.cancelled = YES;
    [request_ cancel];
}

- (void)setProgress:(float)theProgress {
    self.downloadProgress = theProgress;
}

@end
