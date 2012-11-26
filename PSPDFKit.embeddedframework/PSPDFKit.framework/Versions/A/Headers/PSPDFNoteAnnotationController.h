//
//  PSPDFTextAnnotationController.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFStyleable.h"
#import "PSPDFBaseViewController.h"

@class PSPDFGradientView, PSPDFAnnotation, PSPDFPageView, PSPDFNoteAnnotationController;

@protocol PSPDFNoteAnnotationControllerDelegate <NSObject>

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

/// Designated initalizer.
- (id)initWithAnnotation:(PSPDFAnnotation *)nnotation editable:(BOOL)allowEditing;

/// Attached annotation.
/// Allowed types are PSPDFNoteAnnotation, PSPDFHighlightAnnotation and PSPDFFreeTextAnnotation.
@property (nonatomic, strong) PSPDFAnnotation *annotation;

/// If NO, the Edit/Delete buttons are not displayed and the text will be readonly.
@property (nonatomic, assign, readonly) BOOL allowEditing;

/// If YES, the edit button will be displayed to show color/icon editing. Defaults to YES.
/// Will be ignored if allowEditing is NO or annotation type is not PSPDFAnnotationTypeNote.
/// Set before showing/initializing the view. (View will be initialized as soon as you're adding a UIPopover)
@property (nonatomic, assign) BOOL showColorAndIconOptions;

/// Allow to customize the textView. (font etc)
/// Is created in init to be easily customizable.
@property (nonatomic, strong, readonly) UITextView *textView;

/// Attached delegate.
@property (nonatomic, weak) id<PSPDFNoteAnnotationControllerDelegate> delegate;

@end


@interface PSPDFNoteAnnotationController (SubclassingHooks)

/// Called when we're about to show the annotation delete menu.
- (void)deleteAnnotation:(UIBarButtonItem *)barButtonItem;

/// Returns "Delete Note", "Delete Free Text", "Delete Highlight" etc.
- (NSString *)deleteAnnotationActionTitle;

@property (nonatomic, strong) PSPDFGradientView *backgroundView;
@property (nonatomic, strong) UIView *optionsView;

@end
