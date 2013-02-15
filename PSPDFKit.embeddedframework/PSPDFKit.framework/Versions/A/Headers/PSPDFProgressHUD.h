//
//  PSPDFProgressHUD.h
//
//  Created by Sam Vermette on 27.03.11.
//  Copyright 2011-2012 Sam Vermette. All rights reserved.
//
//  Code is Public Domain, no attribution required.
//  https://github.com/samvermette/SVProgressHUD
//

#import "PSPDFKitGlobal.h"

typedef NS_ENUM(NSUInteger, PSPDFProgressHUDMaskType) {
    PSPDFProgressHUDMaskTypeNone = 1, // allow user interactions while HUD is displayed
    PSPDFProgressHUDMaskTypeClear,    // don't allow
    PSPDFProgressHUDMaskTypeBlack,    // don't allow and dim the UI in the back of the HUD
    PSPDFProgressHUDMaskTypeGradient  // don't allow and dim the UI with a a-la-alert-view bg gradient
};

///
/// Simple Progress HUD.
///
@interface PSPDFProgressHUD : UIView

+ (void)show;
+ (void)showWithMaskType:(PSPDFProgressHUDMaskType)maskType;
+ (void)showWithStatus:(NSString *)status;
+ (void)showWithStatus:(NSString *)status maskType:(PSPDFProgressHUDMaskType)maskType;

+ (void)showProgress:(CGFloat)progress;
+ (void)showProgress:(CGFloat)progress status:(NSString *)status;
+ (void)showProgress:(CGFloat)progress status:(NSString *)status maskType:(PSPDFProgressHUDMaskType)maskType;

+ (void)setStatus:(NSString *)string; // change the HUD loading status while it's showing

// stops the activity indicator, shows a glyph + status, and dismisses HUD 1s later
+ (void)showSuccessWithStatus:(NSString *)string;
+ (void)showErrorWithStatus:(NSString *)string;
+ (void)showImage:(UIImage *)image status:(NSString *)status; // use 28x28 white pngs

+ (void)dismiss;

+ (BOOL)isVisible;

@end
