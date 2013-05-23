//
//  PSPDFPageLabelView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFLabelView.h"

/// Displays the current page position at the bottom of the screen.
/// @note This class connects to the pdfController via KVO.
@interface PSPDFPageLabelView : PSPDFLabelView

/// Show button to show the thumbnail grid on the right side of the label. Defaults to NO.
@property (nonatomic, assign) BOOL showThumbnailGridButton;

@end

@interface PSPDFPageLabelView (SubclassingHooks)

/// Calculates the new frame of this view and it's subviews. Subclass to change frame position.
- (void)updateFrame;

@end
