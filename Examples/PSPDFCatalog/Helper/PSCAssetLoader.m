//
//  PSCAssetLoader.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAssetLoader.h"

NSString *const PSPDFQuickStartAsset = @"PSPDFKit QuickStart Guide.pdf";
NSString *const PSPDFQuickStartAssetLandscape = @"PSPDFKit QuickStart Guide Landscape.pdf";
NSString *const PSPDFDeveloperGuideAsset = @"amazon-dynamo-sosp2007.pdf";
NSString *const PSPDFHackerMagazineAsset = @"hackermonthly-issue.pdf";
NSString *const PSPDFCaseStudyAsset = @"Case Study Box.pdf";

@implementation PSCAssetLoader

+ (PSPDFDocument *)documentWithName:(NSString *)name {
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
    PSPDFDocument *document = [PSPDFDocument documentWithData:pdfData];
    document.title = string;
    return document;
}

@end
