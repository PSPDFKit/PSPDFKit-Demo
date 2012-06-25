//
//  PSPDFTextAnnotationController.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFBaseViewController.h"
@class PSPDFAnnotation;

@interface PSPDFNoteAnnotationController : PSPDFBaseViewController

- (id)initWithAnnotation:(PSPDFAnnotation *)textOrHighlightAnnotation editable:(BOOL)allowEditing;

@property(nonatomic, strong) PSPDFAnnotation *annotation;

//@property(no)

@end
