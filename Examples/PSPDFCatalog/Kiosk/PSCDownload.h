//
//  PSCDownload.h
//  PSPDFCatalog
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSCMagazine.h"

typedef NS_ENUM(NSUInteger, PSPDFStoreDownloadStatus) {
    PSPDFStoreDownloadIdle,
    PSPDFStoreDownloadLoading,
    PSPDFStoreDownloadFinished,
    PSPDFStoreDownloadFailed,
};

@interface PSCDownload : NSObject

/// Initialize a new PDF download.
+ (PSCDownload *)PDFDownloadWithURL:(NSURL *)URL;

/// Initialize a new PDF download.
- (id)initWithURL:(NSURL *)URL;

/// Start download.
- (void)startDownload;

/// Cancel running download.
- (void)cancelDownload;

/// Current download status.
@property (nonatomic, assign, readonly) PSPDFStoreDownloadStatus status;

/// Current download progress.
@property (nonatomic, assign, readonly) float downloadProgress;

/// Download URL.
@property (nonatomic, strong, readonly) NSURL *URL;

/// Magazine that's being downloaded.
@property (nonatomic, strong) PSCMagazine *magazine;

@property (nonatomic, strong, readonly) NSError *error;

@property (nonatomic, assign, readonly, getter=isCancelled) BOOL cancelled;

@end
