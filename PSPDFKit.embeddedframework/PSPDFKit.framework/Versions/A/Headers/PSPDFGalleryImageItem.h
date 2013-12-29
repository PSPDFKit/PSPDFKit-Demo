//
//  PSPDFGalleryImageItem.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFGalleryItem.h"
#import "PSPDFRemoteContentObject.h"

/// An image item in a gallery.
@interface PSPDFGalleryImageItem : PSPDFGalleryItem <PSPDFRemoteContentObject>

/// @name PSPDFRemoteContentObject

/// The remote content of the object. This property is managed by `PSPDFDownloadManager`.
@property (nonatomic, strong) UIImage *remoteContent;

/// The loading state of the object. This property is managed by `PSPDFDownloadManager`.
@property (nonatomic, assign, getter = isLoadingRemoteContent) BOOL loadingRemoteContent;

/// The download progress of the object. Only meaningful if `loadingRemoteContent` is YES.
/// This property is managed by `PSPDFDownloadManager`.
@property (nonatomic, assign) CGFloat remoteContentProgress;

/// The remote content error of the object. This property is managed by `PSPDFDownloadManager`.
@property (nonatomic, strong) NSError *remoteContentError;

@end
