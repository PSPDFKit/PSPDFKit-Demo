//
//  PSPDFLongPressGestureRecognizer.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

// Customized gesture recognizer that allows instant activation with a special delegate call
@interface PSPDFLongPressGestureRecognizer : UILongPressGestureRecognizer
@end

@protocol PSPDFLongPressGestureRecognizerDelegate <UIGestureRecognizerDelegate>

/// Allows immediate handling of the touchesBegan event.
- (BOOL)pressRecognizerShouldHandlePressImmediately:(PSPDFLongPressGestureRecognizer *)recognizer;

@end
