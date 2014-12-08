//
//  PSCDropboxFloatingToolbar.h
//  PSPDFCatalog
//
//  Copyright (c) 2013-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

@interface PSCDropboxFloatingToolbar : PSPDFGradientView

/// Buttons will be placed next to each other.
@property (nonatomic, copy) NSArray *buttons;

/// Margin between the buttons. Defaults to 5.
@property (nonatomic, assign) CGFloat margin;

@end
