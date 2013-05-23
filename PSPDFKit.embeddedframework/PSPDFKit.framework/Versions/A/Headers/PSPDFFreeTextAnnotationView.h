//
//  PSPDFFreeTextAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFHostingAnnotationView.h"
#import "PSPDFResizableView.h"

@class PSPDFFreeTextAnnotation;

/// Free Text View. Allows inline text editing.
@interface PSPDFFreeTextAnnotationView : PSPDFHostingAnnotationView <PSPDFResizableTrackedViewDelegate, UITextViewDelegate>

/// Designated initializer.
- (id)initWithAnnotation:(PSPDFAnnotation *)freeTextAnnotation;

/// Start editing, shows the keyboard.
- (void)beginEditing;

/// Ends editing, hides the keyboard
- (void)endEditing;

/// Internally used textView. Only valid during begin and before endEditing.
@property (nonatomic, strong, readonly) UITextView *textView;

/// The dragging view, if we are currently dragged.
@property (nonatomic, weak) PSPDFResizableView *resizableView;

@end

@interface PSPDFFreeTextAnnotationView (SubclassingHooks)

// Creates a textView on the fly once we enter edit mode.
- (UITextView *)textViewForEditing;

@end
