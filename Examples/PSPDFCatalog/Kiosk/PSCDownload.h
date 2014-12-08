//
//  PSCDownload.h
//  PSPDFCatalog
//
//  Copyright (c) 2011-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
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
- (instancetype)initWithURL:(NSURL *)URL NS_DESIGNATED_INITIALIZER;

/// Start download.
- (void)startDownload;

/// Cancel running download.
- (void)cancelDownload;

/// Current download status.
@property (nonatomic, assign, readonly) PSCStoreDownloadStatus status;

/// Current download progress.
@property (nonatomic, assign, readonly) float downloadProgress;

/// Download URL.
@property (nonatomic, copy, readonly) NSURL *URL;

/// Magazine that's being downloaded.
@property (nonatomic, strong) PSCMagazine *magazine;

/// Exposed error.
@property (nonatomic, strong, readonly) NSError *error;

/// Download cancelled?
@property (nonatomic, assign, readonly, getter=isCancelled) BOOL cancelled;

@end
