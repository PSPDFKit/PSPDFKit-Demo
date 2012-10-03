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
@interface PSPDFNoteAnnotationController : PSPDFBaseViewController <PSPDFStyleable>

/// Designated initalizer.
- (id)initWithAnnotation:(PSPDFAnnotation *)nnotation editable:(BOOL)allowEditing;

/// Attached annotation.
/// Allowed types are PSPDFNoteAnnotation, PSPDFHighlightAnnotation and PSPDFFreeTextAnnotation.
@property (nonatomic, strong) PSPDFAnnotation *annotation;

/// If NO, the Edit/Delete buttons are not displayed
@property (nonatomic, assign, readonly) BOOL allowEditing;

/// Allow to customize the textView (font etc)
/// Is created in init to be easily customizable
@property (nonatomic, strong, readonly) UITextView *textView;

/// Attached delegate.
@property (nonatomic, ps_weak) id<PSPDFNoteAnnotationControllerDelegate> delegate;

@end


@interface PSPDFNoteAnnotationController (SubclassingHooks)

/// Called when we're about to show the annotation delete menu.
- (void)deleteAnnotation:(UIBarButtonItem *)barButtonItem;

@property (nonatomic, strong) PSPDFGradientView *backgroundView;
@property (nonatomic, strong) UIView *optionsView;

@end