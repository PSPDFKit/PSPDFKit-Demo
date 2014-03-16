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

@import UIKit;

@class PSPDFMediaPlayerVideoView, PSPDFMediaPlayerCoverView, PSPDFMediaPlayerToolbar, PSPDFMediaPlayerPlaceholderView;

/// A view capable of displaying media. Use in combination with `AVPlayer`.
@interface PSPDFMediaPlayerView : UIView

/// The view used for displaying the video content.
@property (nonatomic, strong) PSPDFMediaPlayerVideoView *videoView;

/// The cover view.
@property (nonatomic, strong) PSPDFMediaPlayerCoverView *coverView;

/// The playback UI toolbar.
@property (nonatomic, strong) PSPDFMediaPlayerToolbar *toolbar;

/// Defaults to hidden.
@property (nonatomic, strong) PSPDFMediaPlayerPlaceholderView *placeholderView;

@end
