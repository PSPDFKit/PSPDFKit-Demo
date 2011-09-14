//
//  NSMutableAttributedString+PSPDFKitAdditions.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 9/14/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (PSPDFKitAdditions)

- (void)pspdfSetFontName:(NSString *)fontName size:(CGFloat)size range:(NSRange)range;
- (void)pspdfSetFont:(UIFont *)font range:(NSRange)range;
- (void)pspdfSetFontName:(NSString *)fontName size:(CGFloat)size;
- (void)pspdfSetFont:(UIFont *)font;

@end
