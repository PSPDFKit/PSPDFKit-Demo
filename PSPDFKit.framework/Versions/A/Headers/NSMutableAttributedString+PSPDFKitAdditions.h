//
//  NSMutableAttributedString+PSPDFKitAdditions.h
//  PSPDFKit
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@interface NSMutableAttributedString (PSPDFKitAdditions)

- (void)pspdfSetFontName:(NSString *)fontName size:(CGFloat)size range:(NSRange)range;
- (void)pspdfSetFont:(UIFont *)font range:(NSRange)range;
- (void)pspdfSetFontName:(NSString *)fontName size:(CGFloat)size;
- (void)pspdfSetFont:(UIFont *)font;

@end
