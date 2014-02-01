//
//  PSPDFMediaPlayerToolbar.h
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
#import <MediaPlayer/MediaPlayer.h>

@class PSPDFMediaPlayerScrubberView;

/// The playback UI toolbar.
@interface PSPDFMediaPlayerToolbar : UIToolbar

/// Updates the state of the toolbar to indicate that the player is current
/// playing or paused.
@property (nonatomic, assign, getter = isPlaying) BOOL playing;

/// The play button item.
@property (nonatomic, strong) UIBarButtonItem *playButtonItem;

/// The pause button item.
@property (nonatomic, strong) UIBarButtonItem *pauseButtonItem;

/// The scrubber item.
@property (nonatomic, strong) UIBarButtonItem *scrubberItem;

/// The external playback item. Contains `volumeView`.
@property (nonatomic, strong) UIBarButtonItem *externalPlaybackItem;
@property (nonatomic, strong) MPVolumeView *volumeView;

/// Hides or shows the volume view. Defaults to `YES`.
@property (nonatomic, assign, getter = isExternalPlaybackItemHidden) BOOL externalPlaybackItemHidden;
- (void)setExternalPlaybackItemHidden:(BOOL)externalPlaybackItemHidden animated:(BOOL)animated;

/// The scrubber view, which is contained within `scrubberItem`.
@property (nonatomic, strong, readonly) PSPDFMediaPlayerScrubberView *scrubberView;

@end
