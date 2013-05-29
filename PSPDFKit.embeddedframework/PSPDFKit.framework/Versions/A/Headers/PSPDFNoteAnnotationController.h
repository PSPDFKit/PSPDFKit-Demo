//
//  PSPDFNoteAnnotationController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFStyleable.h"
#import "PSPDFBaseViewController.h"

@class PSPDFGradientView, PSPDFAnnotation, PSPDFPageView, PSPDFNoteAnnotationController;

@protocol PSPDFNoteAnnotationControllerDelegate <NSObject>

@optional

/// Called when the noteController has deleted the annotation.
- (void)noteAnnotationController:(PSPDFNoteAnnotationController *)noteAnnotationController didDeleteAnnotation:(PSPDFAnnotation *)annotation;

/// Called when the noteController changes the annotation look (color/iconName)
- (void)noteAnnotationController:(PSPDFNoteAnnotationController *)noteAnnotationController didChangeAnnotation:(PSPDFAnnotation *)annotation originalAnnotation:(PSPDFAnnotation *)originalAnnotation;

/// Called before the controller is closed.
- (void)noteAnnotationController:(PSPDFNoteAnnotationController *)noteAnnotationController willDismissWithAnnotation:(PSPDFAnnotation *)annotation;

@end

/// Note annotation controller for editing PSPDFAnnotations.
/// For Note annotations, special options will be displayed.
@interface PSPDFNoteAnnotationController : PSPDFBaseViewController <PSPDFStyleable>

/// Initializes with annotation, allows to override the editable state.
- (id)initWithAnnotation:(PSPDFAnnotation *)annotation editable:(BOOL)allowEditing;

/// Initializes with annotation, automatically sets the editable state.
- (id)initWithAnnotation:(PSPDFAnnotation *)annotation;

/// Attached annotation.
/// Allowed types are PSPDFNoteAnnotation, PSPDFHighlightAnnotation and PSPDFFreeTextAnnotation.
@property (nonatomic, strong) PSPDFAnnotation *annotation;

/// If NO, the Edit/Delete buttons are not displayed and the text will be readonly.
/// @note While you could set `allowEditing` here with a value different than the annotation, it's not advised to do so as the content won't be saved.
/// Use annotation.isEditable && [self.document.editableAnnotationTypes containsObject:annotation.typeString] to test for edit capabilities.
@property (nonatomic, assign) BOOL allowEditing;

/// If YES, the edit button will be displayed to show color/icon editing. Defaults to YES.
/// Will be ignored if allowEditing is NO or annotation type is not PSPDFAnnotationTypeNote.
@property (nonatomic, assign) BOOL showColorAndIconOptions;

/// Allow to customize the textView. (font etc)
/// Is created in init to be easily customizable.
@property (nonatomic, strong, readonly) UITextView *textView;

/// Set a global block that allows to customize the UITextView and other properties of PSPDFNoteAnnotationController.
/// Will be called in viewWillAppear. This is the best way to customize the font.
+ (void)setTextViewCustomizationBlock:(void (^)(PSPDFNoteAnnotationController *))block;

/// Attached delegate.
@property (nonatomic, weak) IBOutlet id<PSPDFNoteAnnotationControllerDelegate> delegate;

@end


@interface PSPDFNoteAnnotationController (SubclassingHooks)

// Called when we're about to show the annotation delete menu.
- (void)deleteAnnotation:(UIBarButtonItem *)barButtonItem;

// Returns "Delete Note", "Delete Free Text", "Delete Highlight" etc.
- (NSString *)deleteAnnotationActionTitle;

// Background gradient.
@property (nonatomic, strong) PSPDFGradientView *backgroundView;

// Option view (note annotations)
@property (nonatomic, strong) UIView *optionsView;

// Tap gesture on the textView to enable/disable edit mode.
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end
