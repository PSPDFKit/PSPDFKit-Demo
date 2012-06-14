//
//  PSPDFLongPressGestureRecognizer.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSPDFKitGlobal.h"

// Customized gesture recognizer that allows instant activation with a special delegate call
@interface PSPDFLongPressGestureRecognizer : UILongPressGestureRecognizer
@end


@protocol PSPDFLongPressGestureRecognizerDelegate <UIGestureRecognizerDelegate>

- (BOOL)pressRecognizerShouldHandlePressImmediately:(PSPDFLongPressGestureRecognizer *)recognizer;

@end
