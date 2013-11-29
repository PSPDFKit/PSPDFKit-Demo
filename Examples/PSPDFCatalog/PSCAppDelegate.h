//
//  PSCAppDelegate.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#if !defined(__clang__) || __clang_major__ < 5
#error This project must be compiled with ARC and Xcode 5.
#endif

@interface PSCAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UINavigationController *catalog;
@property (nonatomic, strong) UIWindow *window;

@end
