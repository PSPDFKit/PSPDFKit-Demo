//
//  UIBarButtonItem+PSCBlockSupport.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (PSCBlockSupport)

// Simple block-based API for UIBarButtonItem.
- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style block:(void (^)(id))block;

@end
