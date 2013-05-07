//
//  PSPDFStatusBarStyleHint.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Allows better guessing of the status bar style. Implement in your UIViewController subclass and use the presentation options in PSPDFViewController to use.
@protocol PSPDFStatusBarStyleHint <NSObject>

/// Returns the preferred status bar style.
- (UIStatusBarStyle)preferredStatusBarStyle;

@end
