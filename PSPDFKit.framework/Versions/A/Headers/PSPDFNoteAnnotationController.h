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

@end

/// Note annotation controller (Post it)
@interface PSPDFNoteAnnotationController : PSPDFBaseViewController

/// Designated initalizer.
- (id)initWithAnnotation:(PSPDFNoteAnnotation *)textOrHighlightAnnotation editable:(BOOL)allowEditing;

@property(nonatomic, strong) PSPDFNoteAnnotation *annotation;

@property(nonatomic, assign, readonly) BOOL allowEditing;

@property(nonatomic, ps_weak) id<PSPDFNoteAnnotationControllerDelegate> delegate;

@end


@interface PSPDFNoteAnnotationController (SubclassingHooks)

/// Called when we're about to show the annotation delete menu.
- (void)deleteAnnotation:(UIBarButtonItem *)barButtonItem;

@end