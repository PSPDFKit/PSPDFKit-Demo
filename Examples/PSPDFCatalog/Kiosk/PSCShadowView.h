//
//  PSPDFShadowView.h
//  PSPDFCatalog
//
//  Copyright (c) 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

/// Simple UIView subclass to add a header shadow
@interface PSCShadowView : UIView

/// YES if top shadow is enabled. Defaults to YES.
@property (nonatomic, getter=isShadowEnabled) BOOL shadowEnabled;

/// top offset for shadow.
@property (nonatomic) CGFloat shadowOffset;

@end
