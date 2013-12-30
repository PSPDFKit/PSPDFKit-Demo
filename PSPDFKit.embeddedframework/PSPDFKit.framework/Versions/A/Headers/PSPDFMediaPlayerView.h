//
//  PSPDFMediaPlayerView.h
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

@class PSPDFMediaPlayerCoverView, PSPDFMediaPlayerToolbar, PSPDFMediaPlayerAudioPlaceholderView;

/// A view capable of displaying media. Use in combination with `AVPlayer`.
@interface PSPDFMediaPlayerView : UIView

/// The player layer of this view.
@property (nonatomic, strong, readonly) AVPlayerLayer *playerLayer;

/// The cover view.
@property (nonatomic, strong) PSPDFMediaPlayerCoverView *coverView;

/// The playback UI toolbar.
@property (nonatomic, strong) PSPDFMediaPlayerToolbar *toolbar;

/// This overlay view is positioned exactly obove the visible area of the video. If AVPlayer does
/// not play a video but rather audio, this view will be set to the bounds of `PSPDFMediaPlayerView`.
/// This view is hidden by default.
/// @note On iOS 6 and earlier, the view's frame will always be set to the bounds of `PSPDFMediaPlayerView`.
@property (nonatomic, strong) UIView *overlayView;

/// Defaults to hidden.
@property (nonatomic, strong) PSPDFMediaPlayerAudioPlaceholderView *audioPlaceholderView;

@end
