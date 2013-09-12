//
//  PSPDFTabBarButton.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"

@interface PSPDFTabBarCloseButton : UIButton
@end

/// Tab bar button
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
