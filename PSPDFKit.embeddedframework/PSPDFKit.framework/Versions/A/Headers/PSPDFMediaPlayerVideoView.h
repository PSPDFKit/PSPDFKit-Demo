//
//  PSPDFMediaPlayerVideoView.h
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

/// This view is backed by an `AVPlayerLayer` layer, so it can be used to display the
/// actual video content.
@interface PSPDFMediaPlayerVideoView : UIView

/// The player layer of this view.
@property (nonatomic, strong, readonly) AVPlayerLayer *playerLayer;

/// This overlay view is positioned exactly obove the visible area of the video. If AVPlayer does not play a video but rather audio, this view will be set to the bounds of `PSPDFMediaPlayerView`.
/// This view is hidden by default.
/// @note On iOS 6, the view's frame will always be set to the bounds of `PSPDFMediaPlayerView`.
@property (nonatomic, strong) UIView *overlayView;

@end
