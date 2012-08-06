//
//  PSCAppDelegate.h
//  PSPDFCatalog
//
//  Copyright (c) 2012 PSPDFKit. All rights reserved.
//

#if !defined(__clang__) || __clang_major__ < 4
#error This project must be compiled with ARC (Xcode 4.4+ with LLVM 4 and above)
#endif

@interface PSCAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UINavigationController *catalog;
@property (nonatomic, strong) UIWindow *window;

@end
