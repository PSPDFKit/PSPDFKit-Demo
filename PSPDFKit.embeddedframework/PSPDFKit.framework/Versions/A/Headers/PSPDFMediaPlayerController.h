//
//  PSPDFMediaPlayerController.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger, PSPDFMediaPlayerControlStyle) {
    /// Shows no controls whatsoever.
    PSPDFMediaPlayerControlStyleNone,
    
    /// Shows the default control set.
    PSPDFMediaPlayerControlStyleDefault
};

typedef NS_ENUM(NSUInteger, PSPDFMediaPlayerControllerContentState) {
    /// The player has no idea what the content state is and hasn't started.
    PSPDFMediaPlayerControllerContentStateUnknown,
    
    /// The player is currently loading information about the content.
    PSPDFMediaPlayerControllerContentStateLoading,
    
    /// The player has found that the content is playable.
    PSPDFMediaPlayerControllerContentStatePlayable,
    
    /// The player has encountered an error. This might be because the Internet
    /// connection is unavailable to fetch a remote iteam or because the item is
    /// unsupported. You can query `contentError` to find out what exactly went wrong.
    PSPDFMediaPlayerControllerContentStateError
};

typedef NS_ENUM(NSUInteger, PSPDFMediaPlayerControllerState) {
    /// The player is currently loading information about the content.
    PSPDFMediaPlayerControllerStatePreparing,
    
    /// The player has found that the content is playable.
    PSPDFMediaPlayerControllerStateReady
};

@protocol PSPDFMediaPlayerControllerDelegate;

@class PSPDFMediaPlayerView;

/// A simply media player.
@interface PSPDFMediaPlayerController : NSObject

/// Initialize the player controller with the URL of the media file.
- (id)initWithContentURL:(NSURL *)contentURL;

/// The content URL of the item that the player plays.
@property (nonatomic, strong, readonly) NSURL *contentURL;

/// If an error occured while preparing the content for playback, this will bet set.
@property (nonatomic, strong, readonly) NSError *contentError;

/// The player view managed by the media controller. Defaults to nil.
@property (nonatomic, strong) PSPDFMediaPlayerView *view;

/// Starts playing the media.
- (void)play;

/// Pauses the media.
- (void)pause;

/// Seet to `time`.
- (void)seekToTime:(CMTime)time;

/// If the media is currently playing, this returns YES.
@property (nonatomic, assign, readonly, getter=isPlaying) BOOL playing;

/// The current state of the content.
@property (nonatomic, assign, readonly) PSPDFMediaPlayerControllerContentState contentState;

/// The current state of the player. The player will only perform actions if it is ready.
@property (nonatomic, assign, readonly) PSPDFMediaPlayerControllerState state;

/// Indicates that the cover view should be hidden.
@property (nonatomic, assign) BOOL hideCoverView;

/// The player's delegate.
@property (nonatomic, weak) id <PSPDFMediaPlayerControllerDelegate> delegate;

/// Set this to YES if you want to hide the toolbar. This property might be ignored
/// if it is set to NO in case the `PSPDFMediaPlayerCoverView` is visible. Use view.toolbar.hidden
/// to access the actual visibility state of the toolbar. Normally you don't need to change
/// this property yourself because `PSPDFMediaPlayerController` handles it for you.
/// Defaults to YES.
@property (nonatomic, assign) BOOL shouldHideToolbar;
- (void)setShouldHideToolbar:(BOOL)shouldHideToolbar animated:(BOOL)animated;

/// Indicates that the player has started playing, although it might not be playing right now.
/// Defaults to NO.
@property (nonatomic, assign, readonly) BOOL didStartPlaying;

/// The tap gesture recognizer used for toggling the toolbar.
@property (nonatomic, strong, readonly) UITapGestureRecognizer *tapGestureRecognizer;

/// Enables playback looping. Defaults to `NO`.
@property (nonatomic, assign) BOOL loopEnabled;

/// The control style of the media player. Defaults to `PSPDFMediaPlayerControlStyleDefault`.
@property (nonatomic, assign) PSPDFMediaPlayerControlStyle controlStyle;

@end

@interface PSPDFMediaPlayerController (Advanced)

// The internally used player. The `AVPlayer` in use might change during the lifecycle
// of an `PSPDFMediaPlayerController`! Use with caution!
@property (nonatomic, strong, readonly) AVPlayer *player;

@end

@protocol PSPDFMediaPlayerControllerDelegate <NSObject>

@optional

- (void)mediaPlayerControllerDidStartPlaying:(PSPDFMediaPlayerController *)controller;
- (void)mediaPlayerControllerDidPause:(PSPDFMediaPlayerController *)controller;
- (void)mediaPlayerControllerDidFinishPlaying:(PSPDFMediaPlayerController *)controller;
- (void)mediaPlayerController:(PSPDFMediaPlayerController *)controller didHideToolbar:(BOOL)hidden;
- (void)mediaPlayerController:(PSPDFMediaPlayerController *)controller contentStateDidChange:(PSPDFMediaPlayerControllerContentState)contentState;
- (void)mediaPlayerController:(PSPDFMediaPlayerController *)controller stateDidChange:(PSPDFMediaPlayerControllerState)state;

@end
