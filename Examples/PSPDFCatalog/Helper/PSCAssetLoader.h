//
//  PSCAssetLoader.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

extern NSString *const PSPDFQuickStartAsset;
extern NSString *const PSPDFQuickStartAssetLandscape;
extern NSString *const PSPDFDeveloperGuideAsset;
extern NSString *const PSPDFHackerMagazineAsset;
extern NSString *const PSPDFCaseStudyAsset;

@interface PSCAssetLoader : NSObject

// Load sample file with file `name`.
+ (PSPDFDocument *)documentWithName:(NSString *)name;

// Generates a test PDF with `string` as content.
+ (PSPDFDocument *)temporaryDocumentWithString:(NSString *)string;

@end
