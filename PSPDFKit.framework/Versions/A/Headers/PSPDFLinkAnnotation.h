//
//  PSPDFLinkAnnotation.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 8/6/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
// 
//  Based on code by Sorin Nistor. Many, Many thanks!
//  Copyright (c) 2011 Sorin Nistor. All rights reserved. This software is provided 'as-is', without any express or implied warranty.
//  In no event will the authors be held liable for any damages arising from the use of this software.
//  Permission is granted to anyone to use this software for any purpose, including commercial applications,
//  and to alter it and redistribute it freely, subject to the following restrictions:
//  1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
//     If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source distribution.
//

#import <CoreFoundation/CoreFoundation.h>

@class PSPDFDocument;

@interface PSPDFLinkAnnotation : NSObject {
    NSString *siteLinkTarget_;
    NSUInteger pageLinkTarget_;
    CGRect pdfRectangle;
    NSUInteger page_;
    PSPDFDocument *document;
}

/// initalize with dictionary, parsing happens here. dict is not saved.
- (id)initWithPDFDictionary:(CGPDFDictionaryRef)annotationDictionary;

/// check if point is inside link
- (BOOL)hitTest:(CGPoint)point;

/// link target is a page if siteLinkTarget is nil
@property(nonatomic, assign) NSUInteger pageLinkTarget;

/// link target is a website
@property(nonatomic, retain) NSString *siteLinkTarget;

/// rectangle of specific annotation
@property(nonatomic, assign) CGRect pdfRectangle;

/// page for current annotation
@property(nonatomic, assign) NSUInteger page;

/// corresponding document, weak
@property(nonatomic, assign) PSPDFDocument *document;

@end
