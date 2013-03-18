//
//  PSCDropboxFloatingToolbar.h
//  PSPDFCatalog
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSCDropboxFloatingToolbar : PSPDFGradientView

/// Buttons will be placed next to each other.
@property (nonatomic, strong) NSArray *buttons;

/// Margin between the buttons. Defaults to 5.
@property (nonatomic, assign) CGFloat margin;

@end
