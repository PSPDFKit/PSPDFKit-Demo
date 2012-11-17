//
//  PSPDFPopoverBackgroundView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2012 Damien Debin / SmartApps (http://smartapps.fr/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "PSPDFKitGlobal.h"
#import <UIKit/UIPopoverBackgroundView.h>

/// Custom popover background that can be tinted.
@interface PSPDFPopoverBackgroundView : UIPopoverBackgroundView

@property (nonatomic, assign) CGFloat arrowOffset;
@property (nonatomic, assign) UIPopoverArrowDirection arrowDirection;

// adjust content inset (~ border width)
+ (void)setContentInset:(CGFloat)contentInset;

// set tint color used for arrow and popover background
+ (void)setTintColor:(UIColor *)tintColor;

// enable/disable shadow under popover
+ (void)setShadowEnabled:(BOOL)shadowEnabled;

// set arrow width (base) / height
+ (void)setArrowBase:(CGFloat)arrowBase;
+ (void)setArrowHeight:(CGFloat)arrowHeight;

// set custom images for background and top/right/bottom/left arrows
+ (void)setBackgroundImage:(UIImage *)background top:(UIImage *)top right:(UIImage *)right bottom:(UIImage *)bottom left:(UIImage *)left;

// rebuild pre-rendered arrow/background images
+ (void)rebuildArrowImages;

@end
