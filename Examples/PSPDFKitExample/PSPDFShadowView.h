//
//  PSPDFShadowView.h
//  PSPDFKitExample
//
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>

/// Simple UIView subclass to add a header shadow
@interface PSPDFShadowView : UIView

/// YES if top shadow is enabled. Defaults to YES.
@property(nonatomic, getter=isShadowEnabled) BOOL shadowEnabled;

/// top offset for shadow.
@property(nonatomic) CGFloat shadowOffset;

@end
