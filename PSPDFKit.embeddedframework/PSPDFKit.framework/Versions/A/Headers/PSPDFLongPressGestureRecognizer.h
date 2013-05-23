//
//  PSPDFLongPressGestureRecognizer.h
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

// Customized gesture recognizer that allows instant activation with a special delegate call
@interface PSPDFLongPressGestureRecognizer : UILongPressGestureRecognizer
@end

@protocol PSPDFLongPressGestureRecognizerDelegate <UIGestureRecognizerDelegate>

/// Allows immediate handling of the touchesBegan event.
- (BOOL)pressRecognizerShouldHandlePressImmediately:(PSPDFLongPressGestureRecognizer *)recognizer;

@end
