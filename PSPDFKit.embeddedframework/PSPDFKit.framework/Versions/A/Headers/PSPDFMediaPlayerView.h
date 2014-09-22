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

@class PSPDFMediaPlayerVideoView, PSPDFMediaPlayerCoverView, PSPDFMediaPlayerToolbar, PSPDFMediaPlayerPlaceholderView, PSPDFErrorView;

// A view capable of displaying media. Use in combination with `AVPlayer`.
@interface PSPDFMediaPlayerView : UIView

// The view used for displaying the video content.
@property (nonatomic, strong) PSPDFMediaPlayerVideoView *videoView;

// The cover view.
@property (nonatomic, strong) PSPDFMediaPlayerCoverView *coverView;

// The playback UI toolbar.
@property (nonatomic, strong) PSPDFMediaPlayerToolbar *toolbar;

// The placeholder view is displayed if the media has no video track.
@property (nonatomic, strong) PSPDFMediaPlayerPlaceholderView *placeholderView;

// The loading view.
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

// The error view.
@property (nonatomic, strong) PSPDFErrorView *errorView;

// The zoom scale. Set this property if the view is used in a `UIScrollView` to optimize
// the way the view hierarchy is presented.
@property (nonatomic, assign) CGFloat zoomScale;

@end
