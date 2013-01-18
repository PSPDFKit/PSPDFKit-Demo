//
//  PSPDFKeyboardAvoidingScrollView.h
//  PSPDFKit
//
//  Copyright 2011-2013 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>

///
/// ScrollView subclass that listens to keyboard events and moves itself up accordingly.
///
@interface PSPDFKeyboardAvoidingScrollView : UIScrollView

/// YES if keyboard is currently displayed.
@property (nonatomic, assign, readonly, getter=isKeyboardVisible) BOOL keyboardVisible;

/// Enable/Disable keyboard avoidance features. Defaults to YES.
/// @warning Don't change this while isShowingKeyboard is YES, else 
@property (nonatomic, assign, readonly) BOOL enableKeyboardAvoidance;

// Helper to find first responder.
- (UIView *)findFirstResponderBeneathView:(UIView *)view;

@end
