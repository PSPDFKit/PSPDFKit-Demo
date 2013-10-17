//
//  PSPDFGalleryItem.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import <PSPDFKit/PSPDFURLConnection.h>
#import <PSPDFKit/PSPDFRemoteContentObject.h>

/// An item in a gallery.
@interface PSPDFGalleryItem : NSObject <PSPDFRemoteContentObject>

/// Factory method to create an array of items from JSON data.
+ (NSArray *)itemsFromJSONData:(NSData *)data error:(NSError **)error;

/// Create an item from a given dictionary. The dictionary will usually be parsed JSON.
- (instancetype)initWithDictionary:(NSDictionary *)dictionary error:(NSError **)error;

/// The caption of the item.
@property (nonatomic, copy, readonly) NSString *caption;

/// The content URL of the item.
@property (nonatomic, strong, readonly) NSURL *contentURL;

/// @name PSPDFRemoteContentObject

/// The remote content of the object. This property is managed by PSPDFDownloadManager.
@property (nonatomic, strong) UIImage *remoteContent;

/// The loading state of the object. This property is managed by PSPDFDownloadManager.
@property (nonatomic, assign, getter = isLoadingRemoteContent) BOOL loadingRemoteContent;

/// The download progress of the object. Only meaningful if loadingRemoteContent is YES.
/// This property is managed by PSPDFDownloadManager.
@property (nonatomic, assign) CGFloat remoteContentProgress;

/// The remote content error of the object. This property is managed by PSPDFDownloadManager.
@property (nonatomic, strong) NSError *remoteContentError;

@end
