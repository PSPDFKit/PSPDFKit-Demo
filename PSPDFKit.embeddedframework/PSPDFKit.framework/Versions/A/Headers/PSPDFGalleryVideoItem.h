//
//  PSPDFGalleryVideoItem.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <AVFoundation/AVFoundation.h>
#import "PSPDFGalleryItem.h"
#import "PSPDFRemoteContentObject.h"

typedef NS_ENUM(NSUInteger, PSPDFGalleryVideoItemStatus) {
    PSPDFGalleryVideoItemStatusUnknown,
    PSPDFGalleryVideoItemStatusPlayable,
    PSPDFGalleryVideoItemStatusUnsupported,
    PSPDFGalleryVideoItemStatusError
};

/// Notification that is posted when the status of an `PSPDFGalleryVideoItem` changes.
extern NSString *const PSPDFGalleryVideoItemStatusDidChangeNotification;

/// A video item in a gallery.
@interface PSPDFGalleryVideoItem : PSPDFGalleryItem <PSPDFRemoteContentObject>

/// You can use this property safely as soon as the status of the video item
/// is `PSPDFGalleryVideoItemStatusPlayable`.
@property (nonatomic, strong, readonly) AVPlayerItem *playerItem;

/// The current status. When this property changes, a
/// `PSPDFGalleryVideoItemStatusDidChangeNotification` notification is posted.
@property (nonatomic, assign, readonly) PSPDFGalleryVideoItemStatus status;

/// If status is `PSPDFGalleryVideoItemStatusError`, this describes that error.
@property (nonatomic, strong, readonly) NSError *error;

/// Indicates if the item should start playing automatically. Defaults to `NO`.
@property (nonatomic, assign) BOOL autoplayEnabled;

/// Indicates if the playback controls should be visible. Defaults to `YES`.
@property (nonatomic, assign) BOOL controlsEnabled;

/// Indicates if the playback should loop. Defaults to `NO`.
@property (nonatomic, assign) BOOL loopEnabled;

/// The URL of an image that should be displayed as the cover view as specified in the options.
/// If this is nil, no cover image will be displayed. Defaults to `nil`.
@property (nonatomic, strong) NSURL *coverImageURL;

/// The cover images if it has been downloaded.
@property (nonatomic, strong, readonly) UIImage *coverImage;

// PSPDFRemoteContentObject
@property (nonatomic, strong) UIImage *remoteContent;
@property (nonatomic, assign, getter = isLoadingRemoteContent) BOOL loadingRemoteContent;

@end
