//
//  PSPDFCenteredLabelView.h
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
#import "PSPDFActivityLabel.h"

// A non-touchable view with a centered label.
@interface PSPDFCenteredLabelView : UIView

// Will set the text and update the label bounds accordingly.
- (void)setCenteredLabelText:(NSString *)text;

// The centered label.
@property (nonatomic, strong) PSPDFActivityLabel *centeredLabel;

@end
