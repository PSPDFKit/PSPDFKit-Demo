//
//  PSPDFConfigurationDataSource.h
//  PSPDFKit
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

// Notification is sent whenever properties of the configuraton data source change.
extern NSString *const PSPDFConfigurationChangedNotification;

@protocol PSPDFConfigurationDataSource <NSObject>

// General state
- (PSPDFDocument *)document;
- (NSUInteger)page;
- (NSUInteger)viewMode; // PSPDFViewMode
- (CGRect)contentRect;

// TODO: shouldn't be in this class!
- (NSUInteger)HUDViewAnimation; // PSPDFHUDViewAnimation
- (BOOL)isHUDVisible;

// Page numbers
- (NSArray *)calculatedVisiblePageNumbers;
- (BOOL)isDoublePageMode;
- (BOOL)isRightPageInDoublePageMode:(NSUInteger)page;
- (BOOL)isDoublePageModeOnFirstPage;

// Style
- (UIColor *)tintColor;
- (UIColor *)barTintColor;
- (UIBarStyle)navigationBarStyle;

@end
