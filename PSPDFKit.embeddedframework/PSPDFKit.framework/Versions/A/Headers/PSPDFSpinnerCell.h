//
//  PSPDFSpinnerCell.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

// Base class that shows centered labels and a spinner label.
@interface PSPDFSpinnerCell : UITableViewCell

@end

@interface PSPDFSpinnerCell (SubclassingHooks)

// Spinner that is displayed while search is in progress.
@property (nonatomic, strong, readonly) UIActivityIndicatorView *spinner;

// Re-align text.
- (void)alignTextLabel;

@end
