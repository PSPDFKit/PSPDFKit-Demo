//
//  PSPDFProgressHUD.h
//  PSPDFKit
//
//  Based on code by Sam Vermette, MIT licensed.
//  Copyright 2011 Sam Vermette. All rights reserved.
//  https://github.com/samvermette/PSPDFProgressHUD
//

#import <UIKit/UIKit.h>

extern NSString *const PSPDFProgressHUDDidReceiveTouchEventNotification;
extern NSString *const PSPDFProgressHUDWillDisappearNotification;
extern NSString *const PSPDFProgressHUDDidDisappearNotification;

extern NSString *const PSPDFProgressHUDStatusUserInfoKey;

typedef NS_ENUM(NSUInteger, PSPDFProgressHUDMaskType) {
    PSPDFProgressHUDMaskTypeNone = 1, // allow user interactions while HUD is displayed
    PSPDFProgressHUDMaskTypeClear, // don't allow
    PSPDFProgressHUDMaskTypeBlack, // don't allow and dim the UI in the back of the HUD
    PSPDFProgressHUDMaskTypeGradient // don't allow and dim the UI with a a-la-alert-view bg gradient
};

/// Apple-like progress HUD.
@interface PSPDFProgressHUD : UIView

@property (readwrite, nonatomic, retain) UIColor *hudBackgroundColor UI_APPEARANCE_SELECTOR;
@property (readwrite, nonatomic, retain) UIColor *hudForegroundColor UI_APPEARANCE_SELECTOR;
@property (readwrite, nonatomic, retain) UIColor *hudStatusShadowColor UI_APPEARANCE_SELECTOR;
@property (readwrite, nonatomic, retain) UIFont *hudFont UI_APPEARANCE_SELECTOR;

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

+ (void)popActivity;

+ (void)dismiss;

+ (BOOL)isVisible;

@end
