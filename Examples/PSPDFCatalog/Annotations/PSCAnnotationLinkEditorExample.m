//
//  PSCAnnotationLinkEditorExample.m
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCAssetLoader.h"
#import "PSCExample.h"

@interface PSCAnnotationLinkEditorExample : PSCExample @end
@implementation PSCAnnotationLinkEditorExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Annotation Link Editor";
        self.contentDescription = @"Allows to customize and create link annotations.";
        self.category = PSCExampleCategoryAnnotations;
        self.priority = 71;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    document.editableAnnotationTypes = [NSOrderedSet orderedSetWithObjects:
                                        // Annotations
                                        PSPDFAnnotationStringLink, // important!

                                        PSPDFAnnotationStringHighlight,
                                        PSPDFAnnotationStringUnderline,
                                        PSPDFAnnotationStringSquiggly,
                                        PSPDFAnnotationStringStrikeOut,
                                        PSPDFAnnotationStringFreeText,
                                        PSPDFAnnotationStringNote,
                                        PSPDFAnnotationStringInk,
                                        PSPDFAnnotationStringSquare,
                                        PSPDFAnnotationStringCircle,
                                        PSPDFAnnotationStringPolygon,
                                        PSPDFAnnotationStringPolyLine,
                                        PSPDFAnnotationStringLine,
                                        PSPDFAnnotationStringSignature,
                                        PSPDFAnnotationStringStamp,
                                        PSPDFAnnotationStringImage,
                                        PSPDFAnnotationStringSound,
                                        PSPDFAnnotationStringCaret,
                                        PSPDFAnnotationStringWidget,
                                        // PSPDFAnnotationStringLink,

                                        // Special tools
                                        PSPDFAnnotationStringEraser,
                                        PSPDFAnnotationStringSelectionTool,
                                        PSPDFAnnotationStringSavedAnnotations,
                                        nil];

    return [[PSPDFViewController alloc] initWithDocument:document];
}

@end
