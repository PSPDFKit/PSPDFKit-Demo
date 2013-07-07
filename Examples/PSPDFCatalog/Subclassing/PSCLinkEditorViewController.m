//
//  PSCLinkEditorViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCLinkEditorViewController.h"

@implementation PSCLinkEditorViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (id)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithDocument:document])) {
        document.editableAnnotationTypes = [NSOrderedSet orderedSetWithObjects:
                                            PSPDFAnnotationTypeStringLink, // not added by default.
                                            PSPDFAnnotationTypeStringHighlight,
                                            PSPDFAnnotationTypeStringUnderline,
                                            PSPDFAnnotationTypeStringStrikeout,
                                            PSPDFAnnotationTypeStringNote,
                                            PSPDFAnnotationTypeStringFreeText,
                                            PSPDFAnnotationTypeStringInk,
                                            PSPDFAnnotationTypeStringSquare,
                                            PSPDFAnnotationTypeStringCircle,
                                            PSPDFAnnotationTypeStringStamp,
                                            nil];
    }
    return self;
}

@end
