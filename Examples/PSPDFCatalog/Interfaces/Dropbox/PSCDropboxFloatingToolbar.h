//
//  PSCDropboxFloatingToolbar.h
//  PSPDFCatalog
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

@interface PSCDropboxFloatingToolbar : PSPDFGradientView

/// Buttons will be placed next to each other.
@property (nonatomic, strong) NSArray *buttons;

/// Margin between the buttons. Defaults to 5.
@property (nonatomic, assign) CGFloat margin;

@end
