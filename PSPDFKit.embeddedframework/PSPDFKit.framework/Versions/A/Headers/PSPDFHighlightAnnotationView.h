//
//  PSPDFHighlightAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFLinkAnnotationBaseView.h"

/// Display a tappable highlight annotation.
@interface PSPDFHighlightAnnotationView : PSPDFLinkAnnotationBaseView

/// Embedded UIButton.
@property (nonatomic, readonly) UIButton *button;

/// Called when button is pressed.
- (void)touchDown;

/// Called when button is released.
- (void)touchUp;

@end
