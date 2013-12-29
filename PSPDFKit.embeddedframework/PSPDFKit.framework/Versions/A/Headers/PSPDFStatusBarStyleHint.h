//
//  PSPDFStatusBarStyleHint.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

/// Allows better guessing of the status bar style. Implement in your `UIViewController` subclass and use the presentation options in `PSPDFViewController` to use.
/// @note As of iOS 7 the system has adopted this as well.
@protocol PSPDFStatusBarStyleHint <NSObject>

/// Returns the preferred status bar style.
- (UIStatusBarStyle)preferredStatusBarStyle;

@end
