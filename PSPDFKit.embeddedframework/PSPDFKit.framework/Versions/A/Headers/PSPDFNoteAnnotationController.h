//
//  PSPDFTextAnnotationController.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFBaseViewController.h"

@class PSPDFNoteAnnotation, PSPDFPageView, PSPDFNoteAnnotationController;

@protocol PSPDFNoteAnnotationControllerDelegate <NSObject>

/// Called when the noteController has deleted the annotation.
- (void)noteAnnotationController:(PSPDFNoteAnnotationController *)noteAnnotationController didDeleteAnnotation:(PSPDFNoteAnnotation *)annotation;

/// Called when the noteController changes the annotation look (color/iconName)
- (void)noteAnnotationController:(PSPDFNoteAnnotationController *)noteAnnotationController didChangeAnnotation:(PSPDFNoteAnnotation *)annotation originalAnnotation:(PSPDFNoteAnnotation *)originalAnnotation;

@end

/// Note annotation controller (Post it)
@interface PSPDFNoteAnnotationController : PSPDFBaseViewController

/// Designated initalizer.
- (id)initWithAnnotation:(PSPDFNoteAnnotation *)textOrHighlightAnnotation editable:(BOOL)allowEditing;

@property(nonatomic, strong) PSPDFNoteAnnotation *annotation;

@property(nonatomic, assign, readonly) BOOL allowEditing;

/// Allow to customize the textView (font etc)
/// Is created in init to be easily customizable
@property(nonatomic, strong, readonly) UITextView *textView;

@property(nonatomic, ps_weak) id<PSPDFNoteAnnotationControllerDelegate> delegate;

@end


@interface PSPDFNoteAnnotationController (SubclassingHooks)

/// Called when we're about to show the annotation delete menu.
- (void)deleteAnnotation:(UIBarButtonItem *)barButtonItem;

@end