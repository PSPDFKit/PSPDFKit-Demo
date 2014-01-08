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

/// Boolean. Indicates if the content should automatically start playing.
extern NSString *const PSPDFGalleryOptionAutoplay;

/// Boolean. Indicates if controls should be displayed.
extern NSString *const PSPDFGalleryOptionControls;

/// Boolean. Indicates if the content should loop forever.
extern NSString *const PSPDFGalleryOptionLoop;

/// NSURL. Indicates which image should be presented as a cover view.
extern NSString *const PSPDFGalleryOptionCover;

/// An item in a gallery.
@interface PSPDFGalleryItem : NSObject

/// The caption of the item.
@property (nonatomic, copy, readonly) NSString *caption;

/// The content URL of the item.
@property (nonatomic, strong, readonly) NSURL *contentURL;

/// The options dictionary of the item. Subclasses should implement
/// dedicated setters to access the supported options.
@property (nonatomic, copy, readonly) NSDictionary *options;

/// Indicates if the content of contentURL is considered valid.
@property (nonatomic, assign, readonly, getter = hasValidContent) BOOL validContent;

/// Factory method to create an array of items from JSON data.
+ (NSArray *)itemsFromJSONData:(NSData *)data error:(NSError **)error;

/// Create an item from a given dictionary. The dictionary will usually be parsed JSON.
- (id)initWithDictionary:(NSDictionary *)dictionary error:(NSError **)error;

/// Initialize with `contentURL` and `caption`. `contentURL` can be local or remote; `caption` is optional.
- (id)initWithContentURL:(NSURL *)contentURL caption:(NSString *)caption;

@end
