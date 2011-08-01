//
//  PSPDFDownload.m
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/24/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFDownload.h"
#import "ASIHTTPRequest.h"
#import "AppDelegate.h"

@implementation PSPDFDownload

@synthesize url = url_;

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
    [url_ release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)start {
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
    [pdfRequest setNumberOfTimesToRetryOnTimeout:0];
    [pdfRequest setTimeOutSeconds:20.0];
    [pdfRequest setShouldContinueWhenAppEntersBackground:YES];
    [pdfRequest setShowAccurateProgress:YES];
    [pdfRequest setDownloadDestinationPath:destPath];
    
    [pdfRequest setCompletionBlock:^(void) {
        PSELog(@"Download finished: %@", self.url);
        
        // cruel way to update
        [XAppDelegate updateFolders];
    }];
    
    [pdfRequest setFailedBlock:^(void) {
        PSELog(@"Download failed: %@. reason:%@", self.url, [pdfRequest.error localizedDescription]);
    }];
    
    [pdfRequest startAsynchronous];
}



@end
