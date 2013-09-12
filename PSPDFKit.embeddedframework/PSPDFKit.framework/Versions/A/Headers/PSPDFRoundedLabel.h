//
//  PSPDFRoundedLabel.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

/// Simple rounded label.
@interface PSPDFRoundedLabel : UILabel

/// Corner radius. Defaults to 10 for iOS6 and 5 for iOS7.
@property (nonatomic, assign) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;

/// Label background. Defaults to [UIColor colorWithWhite:0.f alpha:0.6f]
@property (nonatomic, strong) UIColor *rectColor UI_APPEARANCE_SELECTOR;

@end
