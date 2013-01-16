//
//  PSPDFPageLabelView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFLabelView.h"

/// Displays the current page position at the bottom of the screen.
/// This class connects to the pdfController via KVO.
@interface PSPDFPageLabelView : PSPDFLabelView

/// Show button to show the thumbnail grid on the right side of the label. Defaults to NO.
@property (nonatomic, assign) BOOL showThumbnailGridButton;

@end
