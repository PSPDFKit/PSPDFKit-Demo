//
//  UINavigationBar+PSPDFKit.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 11/20/11.
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (PSPDFKit)

// swizzles navigation methodes; allows custom back button animation
+ (void)pspdfkit_swizzleNavigationMethodes;

@end
