//
//  PSCAppDelegate.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#if !defined(__clang__) || __clang_major__ < 4
#error This project must be compiled with ARC (Xcode 4.6+ with Clang)
#endif

#define kDevelopersGuideFileName @"DevelopersGuide.pdf"
#define kPaperExampleFileName    @"amazon-dynamo-sosp2007.pdf"
#define kPSPDFCatalog            @"PSPDFKit.pdf"
#define kHackerMagazineExample   @"hackermonthly12.pdf"

@interface PSCAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UINavigationController *catalog;
@property (nonatomic, strong) UIWindow *window;

@end
