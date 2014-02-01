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

#import <Foundation/Foundation.h>
#import "PSPDFGalleryItem.h"
#import "PSPDFRemoteContentObject.h"

/// A video item in a gallery.
@interface PSPDFGalleryVideoItem : PSPDFGalleryItem <PSPDFRemoteContentObject>

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
