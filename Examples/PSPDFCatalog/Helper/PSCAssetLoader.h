//
//  PSCAssetLoader.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

#define kDevelopersGuideFileName @"DevelopersGuide.pdf"
#define kPaperExampleFileName    @"amazon-dynamo-sosp2007.pdf"
#define kHackerMagazineExample   @"hackermonthly-issue039.pdf"
#define kPSPDFQuickStart         @"PSPDFKit QuickStart Guide.pdf"
#define kCaseStudyBox            @"Case Study Box.pdf"

@interface PSCAssetLoader : NSObject

// Load sample file with file `name`.
+ (PSPDFDocument *)sampleDocumentWithName:(NSString *)name;

// Generates a test PDF with `string` as content.
+ (PSPDFDocument *)temporaryDocumentWithString:(NSString *)string;

@end
