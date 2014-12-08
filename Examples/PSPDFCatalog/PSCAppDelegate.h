//
//  PSCAppDelegate.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#if !defined(__clang__) || __clang_major__ < 6  || !defined(__IPHONE_8_0)
#error This project must be compiled with ARC and Xcode 6.0 with SDK 8.
#endif

@interface PSCAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UINavigationController *catalog;
@property (nonatomic, strong) UIWindow *window;

@end
