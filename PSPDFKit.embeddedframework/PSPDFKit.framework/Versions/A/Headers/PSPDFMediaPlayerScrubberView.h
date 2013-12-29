//
//  PSPDFMediaPlayerScrubberView.h
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
#import <CoreMedia/CMTime.h>

/// The scrubber view used in `PSPDFMediaPlayerView`. This view displays a slider
/// and two labels. The slider is used to display the current play progress and
/// for seeking. The labels display the current time (= elapsed time) and the
/// remaining time.
@interface PSPDFMediaPlayerScrubberView : UIView

/// The current time.
@property (nonatomic, assign) CMTime currentTime;

/// The duration.
@property (nonatomic, assign) CMTime duration;

/// The current time label.
@property (nonatomic, strong, readonly) UILabel *currentTimeLabel;

/// The remaining time label.
@property (nonatomic, strong, readonly) UILabel *remainingTimeLabel;

/// The slider. `value` is considered relative, so the range of
/// `value` should be between 0.0 and 1.0.
@property (nonatomic, strong, readonly) UISlider *slider;

@end
