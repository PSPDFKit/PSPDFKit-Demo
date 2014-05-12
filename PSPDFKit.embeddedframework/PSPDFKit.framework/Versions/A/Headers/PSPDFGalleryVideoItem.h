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

typedef NS_ENUM(NSUInteger, PSPDFGalleryVideoItemCoverMode) {
    /// The cover is not visible. Correspondents to `none`.
    PSPDFGalleryVideoItemCoverModeNone,
    
    /// The cover is visible and a video preview is displayed. Correspondents to `preview`.
    PSPDFGalleryVideoItemCoverModePreview,
    
    /// The cover is visible and an image is displayed. Correspondents to `image`.
    PSPDFGalleryVideoItemCoverModeImage,
    
    /// The cover is visible and the underlaying PDF shines through. Correspondents to `clear`.
    PSPDFGalleryVideoItemCoverModeClear
};

/// Converts an `NSString` into `PSPDFGalleryVideoItemQuality`.
extern PSPDFGalleryVideoItemQuality PSPDFGalleryVideoItemQualityFromString(NSString *string);

/// Converts an `NSString` into `PSPDFGalleryVideoItemCoverMode`.
extern PSPDFGalleryVideoItemCoverMode PSPDFGalleryVideoItemCoverModeFromString(NSString *string);

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
@property (nonatomic, copy) NSArray *preferredVideoQualities;

/// The initial seek time. Defaults to `0.0`.
@property (nonatomic, assign) NSTimeInterval seekTime;

/// The start of the video in seconds. Defaults to `nil`.
@property (nonatomic, strong) NSNumber *startTime;

/// The end time of the video in seconds. Defaults to `nil`.
@property (nonatomic, strong) NSNumber *endTime;

/// Calculates the playable range from `startTime` and `endTime`.
- (CMTimeRange)playableRange;

/// The cover mode used. Defaults to `PSPDFGalleryVideoItemCoverModePreview`.
@property (nonatomic, assign) PSPDFGalleryVideoItemCoverMode coverMode;

/// The cover image URL. Defaults to `nil`.
/// @note The `coverMode` must be set to `PSPDFGalleryVideoItemCoverModeImage` for this
/// property to have an effect.
@property (nonatomic, copy) NSURL *coverImageURL;

@property (nonatomic, strong) NSNumber *coverPreviewCaptureTime;

/// @name Content

/// An `PSPDFGalleryVideoItem` has an URL to a video as its content.
- (NSURL *)content;

@end

@interface PSPDFGalleryVideoItem (Protected)

// This method is the designated initializer for all internal classes of the class cluster.
- (id)initInternallyWithDictionary:(NSDictionary *)dictionary error:(NSError **)error;

@end

/// @name Constants

/// Boolean. Indicates if the content should automatically start playing.
extern NSString *const PSPDFGalleryOptionAutoplay;

/// Boolean. Indicates if controls should be displayed.
extern NSString *const PSPDFGalleryOptionControls;

/// Boolean. Indicates if the content should loop forever.
extern NSString *const PSPDFGalleryOptionLoop;

/// NSString. Indicates the cover mode.
extern NSString *const PSPDFGalleryOptionCoverMode;

/// NSURL. Indicates which image should be presented as a cover view.
extern NSString *const PSPDFGalleryOptionCoverImage;

/// NSNumber. The time in the video where the preview should be captured.
extern NSString *const PSPDFGalleryOptionCoverPreviewCaptureTime;

/// NSArray. The prefered video qualities.
extern NSString *const PSPDFGalleryOptionPreferredVideoQualities;

/// NSNumber. The start time of the video.
extern NSString *const PSPDFGalleryOptionStartTime;

/// NSNumber. The end time of the video.
extern NSString *const PSPDFGalleryOptionEndTime;

/// @name Deprecated Constants

/// Mixed value. This is a mixture of boolean values and an URL to a cover image.
/// Use `PSPDFGalleryOptionCoverImage` and `PSPDFGalleryOptionCoverMode` instead.
extern NSString *const PSPDFGalleryOptionCover;
