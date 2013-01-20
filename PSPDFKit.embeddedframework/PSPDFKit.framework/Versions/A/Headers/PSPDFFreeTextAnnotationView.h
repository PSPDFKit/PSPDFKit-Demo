//
//  PSPDFFreeTextAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFHostingAnnotationView.h"
#import "PSPDFResizableView.h"

// Enables inline freetext annotation editing. Enabled by default.
// @warning This switch is temporary and will be removed in later updates.
extern BOOL kPSPDFEnableInlineFreeTextAnnotations;

@class PSPDFFreeTextAnnotation;

///
/// Free Text View. Allows inline text editing.
///
@interface PSPDFFreeTextAnnotationView : PSPDFHostingAnnotationView <PSPDFResizableTrackedViewDelegate, UITextViewDelegate>

/// Designated initializer.
- (id)initWithAnnotation:(PSPDFFreeTextAnnotation *)freeTextAnnotation;

/// Start editing, shows the keyboard.
- (void)startEditing;

/// Ends editing, hides the keyboard
- (void)endEditing;

/// Internally used textView.
@property (nonatomic, strong, readonly) UITextView *textView;

/// The dragging view, if we are currently dragged.
@property (nonatomic, weak) PSPDFResizableView *resizableView;

@end
