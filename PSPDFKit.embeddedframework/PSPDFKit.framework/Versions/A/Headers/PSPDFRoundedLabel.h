//
//  PSPDFRoundedLabel.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>

/// Simple rounded label.
@interface PSPDFRoundedLabel : UILabel

/// Corner radius. Defaults to 10.
@property (nonatomic, assign) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;

/// Label background. Defaults to [UIColor colorWithWhite:0.f alpha:0.6f]
@property (nonatomic, strong) UIColor *rectColor UI_APPEARANCE_SELECTOR;

@end
