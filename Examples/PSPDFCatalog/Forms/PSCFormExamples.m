//
//  PSCFormExamples.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCFormExamples.h"

@implementation PSCFormExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Example of a PDF Interactive Form";
        self.category = PSCExampleCategoryForms;
        self.priority = 20;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    
    NSData *PDFData = [NSData dataWithContentsOfURL:[samplesURL URLByAppendingPathComponent:@"Form_example.pdf"]];
    PSPDFDocument *document = [PSPDFDocument documentWithData:PDFData];
    return [[PSPDFViewController alloc] initWithDocument:document];
}

@end


@implementation PSCFormDigitallySignedModifiedExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Example of a PDF Interactive Form with a Digital Signature";
        self.category = PSCExampleCategoryForms;
        self.priority = 20;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    
    NSData *PDFData = [NSData dataWithContentsOfURL:[samplesURL URLByAppendingPathComponent:@"Form_example_signed.pdf"]];
    PSPDFDocument *document = [PSPDFDocument documentWithData:PDFData];
    return [[PSPDFViewController alloc] initWithDocument:document];
}

@end
