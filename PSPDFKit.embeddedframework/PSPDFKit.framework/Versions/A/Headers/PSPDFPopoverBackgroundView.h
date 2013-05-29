//
//  PSPDFPopoverBackgroundView.m
//  PSPDFKit
//
//  Copyright (C) 2013 CRedit360, MIT licensed.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  Except as contained in this notice, the name(s) of the above copyright hol-
//  ders shall not be used in advertising or otherwise to promote the sale, use
//  or other dealings in this Software without prior written authorization.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "PSPDFKitGlobal.h"
#import <UIKit/UIPopoverBackgroundView.h>

/// Custom popover background that can be tinted.
@interface PSPDFPopoverBackgroundView : UIPopoverBackgroundView

/// The popover tint color. Can also be set with UIAppearance.
@property (nonatomic, strong) UIColor *tintColor UI_APPEARANCE_SELECTOR;

/// The popover border color. Can also be set with UIAppearance.
@property (nonatomic, strong) UIColor *borderColor UI_APPEARANCE_SELECTOR;

/// The popover glow color. Can also be set with UIAppearance.
@property (nonatomic, strong) UIColor *glowColor UI_APPEARANCE_SELECTOR;

@end
