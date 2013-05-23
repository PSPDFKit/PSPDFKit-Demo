//
//  PSPDFKeyboardAvoidingScrollView.h
//  PSPDFKit
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

/// ScrollView subclass that listens to keyboard events and moves itself up accordingly.
@interface PSPDFKeyboardAvoidingScrollView : UIScrollView

/// YES if keyboard is currently displayed.
/// @warning Keep in mind that there are many other ways for the keyboard. E.g. this will return NO if the keyboard is in split view mode or a physical keyboard is attached.
@property (nonatomic, assign, readonly, getter=isKeyboardVisible) BOOL keyboardVisible;

/// Return YES if we have a first responder inside the scrollView that is a text input.
@property (nonatomic, assign, readonly) BOOL firstResponderIsTextInput;

/// Enable/Disable keyboard avoidance features. Defaults to YES.
/// @warning Don't change this while isShowingKeyboard is YES, else
@property (nonatomic, assign) BOOL enableKeyboardAvoidance;

/// Helper to resign first responder if the view is within the scrollView.
- (BOOL)resignFirstResponderIfInsideView;

/// Block will be called when the keyboard gets visible.
@property (nonatomic, copy) void(^keyboardWillShowBlock)(PSPDFKeyboardAvoidingScrollView *, NSNotification *);

/// Block will be called when the keyboard gets invisible.
@property (nonatomic, copy) void(^keyboardWillHideBlock)(PSPDFKeyboardAvoidingScrollView *, NSNotification *);

@end
