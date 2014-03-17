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
#import <AVFoundation/AVFoundation.h>
#import "PSPDFGalleryItem.h"

typedef NS_ENUM(NSUInteger, PSPDFGalleryVideoItemQuality) {
    PSPDFGalleryVideoItemQualityUnknown,
    PSPDFGalleryVideoItemQuality240p,
	PSPDFGalleryVideoItemQuality360p,
	PSPDFGalleryVideoItemQuality720p,
	PSPDFGalleryVideoItemQuality1080p
};

/// Converts a string into `PSPDFGalleryVideoItemQuality`.
extern PSPDFGalleryVideoItemQuality PSPDFGalleryVideoItemQualityFromString(NSString *string);

/// A video item in a gallery. This class uses the class cluster design pattern.
@interface PSPDFGalleryVideoItem : PSPDFGalleryItem

/// @name Options

/// Indicates if the item should start playing automatically. Defaults to `NO`.
@property (nonatomic, assign) BOOL autoplayEnabled;

/// Indicates if the playback controls should be visible. Defaults to `YES`.
@property (nonatomic, assign) BOOL controlsEnabled;

/// Indicates if the playback should loop. Defaults to `NO`.
@property (nonatomic, assign) BOOL loopEnabled;

/// Contains the order of the prefered video qualities. This only works for videos where
/// the source is capable of providing different qualities.
@property (nonatomic, copy) NSArray *preferedQualities;

/// The initial seek time. Defaults to `0.0`.
@property (nonatomic, assign) NSTimeInterval seekTime;

/// @name Content

/// The cover image URL.
@property (nonatomic, strong, readonly) NSURL *coverImageURL;

/// An `PSPDFGalleryVideoItem` has an URL to a video as its content.
- (NSURL *)content;

@end

@interface PSPDFGalleryVideoItem (Protected)

// This method is the designated initializer for all internal classes of the class cluster.
- (id)initInternallyWithDictionary:(NSDictionary *)dictionary error:(NSError **)error;

@property (nonatomic, strong, readwrite) NSURL *coverImageURL;

@end

/// @name Constants

/// Boolean. Indicates if the content should automatically start playing.
extern NSString *const PSPDFGalleryOptionAutoplay;

/// Boolean. Indicates if controls should be displayed.
extern NSString *const PSPDFGalleryOptionControls;

/// Boolean. Indicates if the content should loop forever.
extern NSString *const PSPDFGalleryOptionLoop;

/// NSURL. Indicates which image should be presented as a cover view.
extern NSString *const PSPDFGalleryOptionCover;

/// NSArray. The prefered video qualities.
extern NSString *const PSPDFGalleryOptionPreferedVideoQualities;
