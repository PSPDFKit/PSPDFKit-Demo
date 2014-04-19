//
//  PSPDFSoundAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>
#import "PSPDFLinkAnnotationBaseView.h"

@class PSPDFSoundAnnotation;
@class PSPDFSoundAnnotationEditViewController;

/// Displays and manages a sound annotation.
@interface PSPDFSoundAnnotationView : PSPDFLinkAnnotationBaseView

/// The sound annotation
@property (nonatomic, strong, readonly) PSPDFSoundAnnotation *soundAnnotation;

/// Edit view controller that manages the audio control views
@property (nonatomic, strong, readonly) PSPDFSoundAnnotationEditViewController *editViewController;

/// Shows the sound editor view
- (void)showEditorAnimated:(BOOL)animated;

/// Hides the sound editor view
- (void)hideEditorAnimated:(BOOL)animated;

/// Returns YES if the sound editor view is visible, otherwise NO
- (BOOL)editorVisible;

/// Returns YES when the page view can show an edit menu
- (BOOL)shouldShowEditMenu;

@end

@class PSPDFAudioPlotView;
@class PSPDFMicrophonePlotView;

@interface PSPDFSoundAnnotationEditViewController : UIViewController
@property (nonatomic, strong, readonly) PSPDFMicrophonePlotView *microphonePlotView;
@property (nonatomic, strong, readonly) PSPDFAudioPlotView *plotView;
@property (nonatomic, strong, readonly) UIButton *recordingButton;
@property (nonatomic, strong, readonly) UIButton *playbackButton;
@property (nonatomic, strong, readonly) UIButton *doneButton;
@property (nonatomic, strong, readonly) UILabel *playbackTimeLabel;
@property (nonatomic, strong, readonly) UILabel *totalTimeLabel;
@property (nonatomic, strong, readonly) UILabel *statusLabel;
@property (nonatomic, strong, readonly) UISlider *progressSlider;
@end;
