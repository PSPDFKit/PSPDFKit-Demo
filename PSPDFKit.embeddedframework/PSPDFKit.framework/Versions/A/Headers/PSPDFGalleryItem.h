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
#import <CoreGraphics/CoreGraphics.h>

@class PSPDFLinkAnnotation;

/// Notification. Posted when the `contentState` of a `PSPDFGalleryItem` changes.
extern NSString *const PSPDFGalleryItemContentStateDidChangeNotification;

typedef NS_ENUM(NSUInteger, PSPDFGalleryItemContentState) {
    /// The item is waiting to load its content.
    PSPDFGalleryItemContentStateWaiting,

    /// The item is currently loading its content.
    PSPDFGalleryItemContentStateLoading,

    /// The item's content is ready.
    PSPDFGalleryItemContentStateReady,

    /// The item has encountered an error while loading its content.
    PSPDFGalleryItemContentStateError
};

/// Returns a string from `PSPDFGalleryItemContentState`.
extern NSString *NSStringFromPSPDFGalleryItemContentState(PSPDFGalleryItemContentState state);

/// The abstract class for an item in a gallery. Most items will have content that needs to be loaded,
/// hence this class allows for asynchronous state changes. It is the responsibility of the subclass
/// to implement loading, for example by implementing the `PSPDFRemoteContentObject` protocol.
@interface PSPDFGalleryItem : NSObject

/// @name Item Properties

/// The caption of the item.
@property (nonatomic, copy, readonly) NSString *caption;

/// The content URL of the item.
@property (nonatomic, copy, readonly) NSURL *contentURL;

/// The options dictionary of the item. Subclasses should implement
/// dedicated setters to access the supported options.
@property (nonatomic, copy, readonly) NSDictionary *options;

/// @name Content

/// The state of the item's content. Defaults to `PSPDFGalleryItemContentStateWaiting`.
@property (nonatomic, assign, readonly) PSPDFGalleryItemContentState contentState;

/// The content of the item. Defaults to `nil`.
@property (nonatomic, strong, readonly) id content;

/// Indicates if the content of contentURL is considered valid.
@property (nonatomic, assign, readonly, getter=hasValidContent) BOOL validContent;

/// The error that occurred while loading the content. Only valid if `contentState`
/// is `PSPDFGalleryItemContentStateError`.
/// @note This property is not related to the error pointer that can be provided when creating
/// an `PSPDFGalleryItem`.
@property (nonatomic, strong, readonly) NSError *error;

/// The progress of loading the content. Only valid if `contentState`
/// is `PSPDFGalleryItemContentStateLoading`.
@property (nonatomic, assign, readonly) CGFloat progress;

/// @name Creating Items

/// Factory method to create an array of items from JSON data. Returns `nil` in case of an error.
+ (NSArray *)itemsFromJSONData:(NSData *)data error:(NSError *__autoreleasing*)error;

/// Factory method that creates a single gallery item directly from a link annotation.
/// Returns `nil` in case of an error.
+ (PSPDFGalleryItem *)itemFromLinkAnnotation:(PSPDFLinkAnnotation *)annotation error:(NSError *__autoreleasing*)error;

/// Creates an item from a given dictionary. The dictionary will usually be parsed JSON.
/// @warning This method triggers an assertion if `contentURL` is invalid.
/// @note This is the designated initializer.
- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

/// Creates an item with the given `contentURL`, `caption` and `options`. `contentURL` is required.
- (instancetype)initWithContentURL:(NSURL *)contentURL caption:(NSString *)caption options:(NSDictionary *)options;

@end

@interface PSPDFGalleryItem (Protected)

// Updates `contentState` and posts a `PSPDFGalleryItemContentStateDidChangeNotification` notification.
@property (nonatomic, assign, readwrite) PSPDFGalleryItemContentState contentState;

@property (nonatomic, strong, readwrite) id content;

@end

/// @name Constants

/// String. The type of an item.
extern NSString *const PSPDFGalleryItemTypeKey;

/// String. The content URL of an item.
extern NSString *const PSPDFGalleryItemContentURLKey;

/// String. The caption of an item.
extern NSString *const PSPDFGalleryItemCaptionKey;

/// String. The options of an item.
extern NSString *const PSPDFGalleryItemOptionsKey;

/// @name Options

/// Boolean. Indicates if the content should automatically start playing.
extern NSString *const PSPDFGalleryOptionAutoplay;

/// Boolean. Indicates if controls should be displayed.
extern NSString *const PSPDFGalleryOptionControls;

/// Boolean. Indicates if the content should loop forever.
extern NSString *const PSPDFGalleryOptionLoop;
