//
//  PSPDFShadowView.h
//  PSPDFCatalog
//
//  Copyright (c) 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

/// Simple UIView subclass to add a header shadow
@interface PSCShadowView : UIView

/// YES if top shadow is enabled. Defaults to YES.
@property (nonatomic, getter=isShadowEnabled) BOOL shadowEnabled;

/// top offset for shadow.
@property (nonatomic) CGFloat topShadowOffset;

@end
