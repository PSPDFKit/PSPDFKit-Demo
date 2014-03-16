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

@import Foundation;

/// Allows better guessing of the status bar style. Implement in your `UIViewController` subclass and use the presentation options in `PSPDFViewController` to use.
/// @note As of iOS 7 the system has adopted this as well.
@protocol PSPDFStatusBarStyleHint <NSObject>

@optional

/// This property will be read if there is only an accessor (to force a different style)
/// or written, if there is a setter implemented as well.
/// @note This is manually queried by PSPDFKit if UIViewControllerBasedStatusBarAppearance is set to NO.
@property (nonatomic, assign) UIStatusBarStyle preferredStatusBarStyle;

/// Controls if the status bar should be visible or not.
/// Matches the method of iOS 7.
@property (nonatomic, assign) BOOL prefersStatusBarHidden;

@end
