//
//  PSPDFTabBarButton.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSPDFTabBarCloseButton : UIButton
@end

@interface PSPDFTabBarButton : UIButton

/// Mark select/select state.
@property(nonatomic, assign, getter=isSelected) BOOL selected;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

/// The [x] close button.
@property(nonatomic, strong) PSPDFTabBarCloseButton *closeButton;

/// Show or hide the close button.
@property(nonatomic, assign) BOOL showCloseButton;

@end
