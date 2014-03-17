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

/// Displays and manages a sound annotation.
@interface PSPDFSoundAnnotationView : PSPDFLinkAnnotationBaseView

/// Saves the attached sound annotation.
@property (nonatomic, strong, readonly) PSPDFSoundAnnotation *soundAnnotation;

/// Play or Pause current sound annotation.
- (void)playOrPause;

/// Pause/Continue Recording.
- (void)recordOrPause;

/// Finish if we're currently recording.
- (void)finishRecording;

@end


@interface PSPDFSoundAnnotationView (Private)

// Updates the frame of the view to match whether or not this annotation is currently recording or playing.
- (void)updateFrameForCurrentViewMode;

@end

@interface PSPDFSoundAnnotationView (SubclassingHooks)

// Internally used buttons.
@property (nonatomic, strong) UIButton *defaultButton;
@property (nonatomic, strong) UIButton *playbackButton;
@property (nonatomic, strong) UIButton *recordingButton;
@property (nonatomic, strong) UIButton *doneButton;

@end
