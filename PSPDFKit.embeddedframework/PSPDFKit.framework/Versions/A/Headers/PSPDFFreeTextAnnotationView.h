//
//  PSPDFFreeTextAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFHostingAnnotationView.h"
#import "PSPDFResizableView.h"

@class PSPDFFreeTextAnnotation;

/// Free Text View. Allows inline text editing.
@interface PSPDFFreeTextAnnotationView : PSPDFHostingAnnotationView <PSPDFResizableTrackedViewDelegate, UITextViewDelegate>

/// Designated initializer.
- (id)initWithAnnotation:(PSPDFFreeTextAnnotation *)freeTextAnnotation;

/// Start editing, shows the keyboard.
- (void)beginEditing;

/// Ends editing, hides the keyboard
- (void)endEditing;

/// Internally used textView.
/// @warning If you set this, do early on and not while edit mode is active.
@property (nonatomic, strong) UITextView *textView;

/// The dragging view, if we are currently dragged.
@property (nonatomic, weak) PSPDFResizableView *resizableView;

@end
