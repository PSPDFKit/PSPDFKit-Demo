//
//  PSPDFFreeTextAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFHostingAnnotationView.h"

// This feature is still experimental, will probably come in 2.7.3.
// Disabled by default.
// @warning This switch is temporary and will be removed once the feature is complete.
extern BOOL kPSPDFEnableInlineFreeTextAnnotations;

@class PSPDFFreeTextAnnotation;

///
/// Free Text View. Allows inline text editing.
///
@interface PSPDFFreeTextAnnotationView : PSPDFHostingAnnotationView <UITextViewDelegate>

/// Designated initializer.
- (id)initWithAnnotation:(PSPDFFreeTextAnnotation *)freeTextAnnotation;

/// Start editing, shows the keyboard.
- (void)startEditing;

/// Ends editing, hides the keyboard
- (void)endEditing;

/// Internally used TextView.
@property (nonatomic, strong) UITextView *textView;

@end
