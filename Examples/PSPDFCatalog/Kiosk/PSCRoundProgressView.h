//
//  PSCRoundProgressView.h
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

@import UIKit;

// Progress view, similar to the app download animation on iOS 7.
@interface PSCRoundProgressView : UIView

// Set the progress. (Default is not animated)
@property (nonatomic, assign) CGFloat progress;
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
