//
//  PSPDFTextFieldFormElementView.h
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
#import "PSPDFFormInputAccessoryView.h"

@class PSPDFTextFieldFormElement;

/// Free Text View. Allows inline text editing.
@interface PSPDFTextFieldFormElementView : PSPDFHostingAnnotationView <PSPDFResizableTrackedViewDelegate, UITextViewDelegate, UITextFieldDelegate, PSPDFFormInputAccessoryViewDelegate>

/// Start editing, shows the keyboard.
- (void)beginEditing;

/// Ends editing, hides the keyboard.
- (void)endEditing;

/// Internally used textView. Only valid during begin and before endEditing.
@property (nonatomic, strong, readonly) UITextView *textView;

/// Internally used textField. Only valid during begin and before endEditing.
@property (nonatomic, strong) UITextField *textField;

/// Is this a multiline text view?
@property (nonatomic, readonly) BOOL isMultiline;

/// Is this a secure text view for displaying passwords?
@property (nonatomic, readonly) BOOL isPassword;

/// Whether view is in edit mode.
@property (nonatomic) BOOL editMode;

/// The dragging view, if we are currently dragged.
@property (nonatomic, weak) PSPDFResizableView *resizableView;

/// Associated PSPDFPageView.
@property (nonatomic, weak) PSPDFPageView *pageView;

@end

@interface PSPDFTextFieldFormElementView (SubclassingHooks)

// Creates a textView on the fly once we enter edit mode.
- (void)setTextViewForEditing;

@end
