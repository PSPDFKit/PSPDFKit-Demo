//
//  PSPDFVideoAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PSPDFLinkAnnotationBaseView.h"

@class PSPDFVideoAnnotationCoverView;

/// Displays audio/movie annotations with an embedded MPMoviePlayerController.
@interface PSPDFVideoAnnotationView : PSPDFLinkAnnotationBaseView

/// Movie URL. (can be local, or external)
@property (nonatomic, strong) NSURL *URL;

/// YES to enable auto-start as soon as the view is loaded. Defaults to NO.
@property (nonatomic, assign, getter=isAutoplayEnabled) BOOL autoplayEnabled;

/// If this is set to YES, the video will play with it's own audio session, and will *ignore* the silent switch.
/// This is was people expect when they press play on a video, and they will often report a bug because they forgot
/// that the silent switch is set to YES (esp. on the iPad it is not very visible).
/// Defaults to NO. If you have a lot of autostarting content, you might want to set this to NO.
/// Just be aware of user reactions. You might want to check if the silent switch is set and show an alert.
/// Property will reset itself after setting a new annotation.
@property (nonatomic, assign) BOOL useApplicationAudioSession;

/// Instance of the MPMoviePlayerController.
@property (nonatomic, strong, readonly) MPMoviePlayerController *player;

/// Cover view is only set if cover option is set.
@property (nonatomic, strong) PSPDFVideoAnnotationCoverView *coverView;

/// Video has a zIndex of 10.
@property (nonatomic, assign) NSUInteger zIndex;

@end

/// If the cover option is set, this is showed until the play button is pressed.
/// @note doesn't work with overrideClassNames (since within an annotation view, we don't have a connection to the PSPDFViewController)
@interface PSPDFVideoAnnotationCoverView : UIView

/// The cover image (might be w/o actual image set)
@property (nonatomic, strong) UIImageView *coverImage;

/// The play button.
@property (nonatomic, strong) UIButton *playButton;

@end


@interface PSPDFVideoAnnotationView (SubclassingHooks)

/// Looks into (self.linkAnnotation.options)[@"cover"] for the cover URL.
/// Might return something else; check type before using it as an NSURL.
- (NSURL *)coverURL;

/// Adds the coverView if not yet added.
- (void)addCoverView;

@end
