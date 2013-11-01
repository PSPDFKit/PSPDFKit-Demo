//
//  PSCAssetLoader.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAssetLoader.h"

@implementation PSCAssetLoader

+ (PSPDFDocument *)sampleDocumentWithName:(NSString *)name {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:name]];
    return document;
}

+ (PSPDFDocument *)temporaryDocumentWithString:(NSString *)string {
    NSMutableData *pdfData = [NSMutableData new];
    UIGraphicsBeginPDFContextToData(pdfData, CGRectMake(0.f, 0.f, 210.f*3, 297.f*3), nil);
    UIGraphicsBeginPDFPage();
    [string drawAtPoint:CGPointMake(20.f, 20.f) withAttributes:nil];
    UIGraphicsEndPDFContext();
    return [PSPDFDocument documentWithData:pdfData];
}

@end
