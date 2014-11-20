//
//  UIImage+PSCTinting.h
//  PSPDFCatalog
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

@interface UIImage (PSCTinting)

- (UIImage *)psc_imageTintedWithColor:(UIColor *)color fraction:(CGFloat)fraction;

@end
