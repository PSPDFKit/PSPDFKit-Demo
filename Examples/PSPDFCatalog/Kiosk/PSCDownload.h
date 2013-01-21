//
//  PSCDownload.h
//  PSPDFCatalog
//
//  Copyright 2011-2013 Peter Steinberger. All rights reserved.
//

#import "PSCMagazine.h"

typedef NS_ENUM(NSUInteger, PSCStoreDownloadStatus) {
    PSCStoreDownloadStatusIdle,
    PSCStoreDownloadStatusLoading,
    PSCStoreDownloadStatusFinished,
    PSCStoreDownloadStatusFailed,
    PSCStoreDownloadStatusCancelled
};

/// Wrapper that helps downloading a PDF.
@interface PSCDownload : NSObject

/// Initialize a new PDF download.
- (id)initWithURL:(NSURL *)URL;

/// Start download.
- (void)startDownload;

/// Cancel running download.
- (void)cancelDownload;

/// Current download status.
@property (nonatomic, assign, readonly) PSCStoreDownloadStatus status;

/// Current download progress.
@property (nonatomic, assign, readonly) float downloadProgress;

/// Download URL.
@property (nonatomic, strong, readonly) NSURL *URL;

/// Magazine that's being downloaded.
@property (nonatomic, strong) PSCMagazine *magazine;

/// Exposed error.
@property (nonatomic, strong, readonly) NSError *error;

/// Download cancelled?
@property (nonatomic, assign, readonly, getter=isCancelled) BOOL cancelled;

@end
