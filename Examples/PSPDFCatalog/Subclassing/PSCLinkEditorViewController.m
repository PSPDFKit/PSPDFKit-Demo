//
//  PSCLinkEditorViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSCLinkEditorViewController.h"

@implementation PSCLinkEditorViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (id)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithDocument:document])) {
        
        document.editableAnnotationTypes = [NSSet setWithObjects:
                                            PSPDFAnnotationTypeStringLink, // not added by default.
                                            PSPDFAnnotationTypeStringHighlight,
                                            PSPDFAnnotationTypeStringUnderline,
                                            PSPDFAnnotationTypeStringStrikeout,
                                            PSPDFAnnotationTypeStringNote,
                                            PSPDFAnnotationTypeStringFreeText,
                                            PSPDFAnnotationTypeStringInk,
                                            PSPDFAnnotationTypeStringSquare,
                                            PSPDFAnnotationTypeStringCircle,
                                            nil];
    }
    return self;
}

@end
