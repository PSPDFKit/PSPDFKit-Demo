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
/// @warning Keep in mind that there are many other ways for the keyboard. E.g. this will return NO if the keyboard is in split view mode or a physical keyboard is attached.
@property (nonatomic, assign, readonly, getter=isKeyboardVisible) BOOL keyboardVisible;

/// Return YES if we have a first responder inside the scrollView that is a text input.
@property (nonatomic, assign, readonly) BOOL firstResponderIsTextInput;

/// Enable/Disable keyboard avoidance features. Defaults to YES.
/// @warning Don't change this while isShowingKeyboard is YES, else 
@property (nonatomic, assign) BOOL enableKeyboardAvoidance;

// Helper to find first responder.
- (UIView *)findFirstResponderBeneathView:(UIView *)view;

// Helper to resign first responder if the view is within the scrollView.
- (BOOL)resignFirstResponderIfInsideView;

@end
