//
//  PSCAssetLoader.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

#define kDevelopersGuideFileName @"DevelopersGuide.pdf"
#define kPaperExampleFileName    @"amazon-dynamo-sosp2007.pdf"
#define kHackerMagazineExample   @"hackermonthly-issue039.pdf"

@interface PSCAssetLoader : NSObject

+ (PSPDFDocument *)sampleDocumentWithName:(NSString *)name;

@end
