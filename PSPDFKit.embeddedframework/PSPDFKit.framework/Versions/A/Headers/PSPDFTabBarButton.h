//
//  PSPDFTabBarButton.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@interface PSPDFTabBarCloseButton : UIButton
@end

/// One tab-bar element.
@interface PSPDFTabBarButton : UIButton

/// Mark select/select state.
@property (nonatomic, assign, getter=isSelected) BOOL selected;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

/// The [x] close button.
@property (nonatomic, strong) PSPDFTabBarCloseButton *closeButton;

/// Show or hide the close button.
@property (nonatomic, assign) BOOL showCloseButton;

/// Minimum tab width. Defaults to 0.
@property (nonatomic, assign) CGFloat minTabWidth;

/// Maximum tab width. Defaults to 300.
@property (nonatomic, assign) CGFloat maxTabWidth;

@end
