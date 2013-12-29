//
//  PSPDFGalleryItem.h
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

/// An item in a gallery.
@interface PSPDFGalleryItem : NSObject

/// The caption of the item.
@property (nonatomic, copy, readonly) NSString *caption;

/// The content URL of the item.
@property (nonatomic, strong, readonly) NSURL *contentURL;

/// Indicates if the content of contentURL is considered valid.
@property (nonatomic, assign, readonly, getter = hasValidContent) BOOL validContent;

/// Factory method to create an array of items from JSON data.
+ (NSArray *)itemsFromJSONData:(NSData *)data error:(NSError **)error;

/// Create an item from a given dictionary. The dictionary will usually be parsed JSON.
- (id)initWithDictionary:(NSDictionary *)dictionary error:(NSError **)error;

/// Initialize with `contentURL` and `caption`. `contentURL` can be local or remote; `caption` is optional.
- (id)initWithContentURL:(NSURL *)contentURL caption:(NSString *)caption;

/// Indicates whether contentURL is referencing a local resource.
@property (nonatomic, assign, readonly, getter = isLocalContentURL) BOOL localContentURL;

@end
