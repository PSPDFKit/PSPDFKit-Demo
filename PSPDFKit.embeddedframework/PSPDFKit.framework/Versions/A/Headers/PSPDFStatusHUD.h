//
//  PSPDFStatusHUD.h
//  PSPDFKit
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

@import Foundation;

typedef NS_ENUM(NSUInteger, PSPDFStatusHUDStyle) {
    PSPDFStatusHUDStyleNone = 0, // user interactions enabled, no UI mask
    PSPDFStatusHUDStyleClear,    // user interactions disabled, clear UI mask
    PSPDFStatusHUDStyleBlack,    // user interactions disabled, black UI mask
    PSPDFStatusHUDStyleGradient  // user interactions disabled, gradient UI mask
};

@interface PSPDFStatusHUD : NSObject

+ (NSArray *)items;
+ (void)popAllItemsAnimated:(BOOL)animated;

@end

@interface PSPDFStatusHUDItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UIView *view;

+ (instancetype)progressWithText:(NSString *)text;
+ (instancetype)indeterminateProgressWithText:(NSString *)text;
+ (instancetype)successWithText:(NSString *)text;
+ (instancetype)errorWithText:(NSString *)text;

- (void)setHUDStyle:(PSPDFStatusHUDStyle)style;
- (void)pushAnimated:(BOOL)animated;
- (void)pushAndPopWithDelay:(NSTimeInterval)interval animated:(BOOL)animated;
- (void)popAnimated:(BOOL)animated;

@end
