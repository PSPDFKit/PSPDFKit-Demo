//
//  PSPDFDownload.h
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/24/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "PSPDFMagazine.h"
#import "ASIProgressDelegate.h"

typedef enum {
    PSPDFStoreDownloadIdle,
    PSPDFStoreDownloadLoading,
    PSPDFStoreDownloadFinished,
    PSPDFStoreDownloadFailed,
} PSPDFStoreDownloadStatus;

@interface PSPDFDownload : NSObject <ASIProgressDelegate> {
    ASIHTTPRequest *request_;
    UIProgressView *progressView_;
    PSPDFMagazine  *magazine_;
    NSURL          *url_;
    PSPDFStoreDownloadStatus status_;
    float downloadProgress_;
    BOOL cancelled_;
}

/// initialize a new pdf download, autoreleased
+ (PSPDFDownload *)PDFDownloadWithURL:(NSURL *)url;

/// initialize a new pdf download
- (id)initWithURL:(NSURL *)url;

/// start download
- (void)startDownload;

/// cancel running download
- (void)cancelDownload;

/// download url
@property(nonatomic, retain, readonly) NSURL *url;

/// magazine that's being downloaded
@property(nonatomic, retain) PSPDFMagazine *magazine;

@property(nonatomic, assign, readonly) PSPDFStoreDownloadStatus status;

@property(nonatomic, assign, readonly) float downloadProgress;

@property(nonatomic, copy, readonly) NSError *error;

@property(nonatomic, assign, readonly, getter=isCancelled) BOOL cancelled;

@end
