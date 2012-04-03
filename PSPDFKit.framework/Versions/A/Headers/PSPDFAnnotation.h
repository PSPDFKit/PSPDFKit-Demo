//
//  PSPDFAnnotation.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
// 
//  Rect-Parsing code partially based on code by Sorin Nistor. Thanks!
//  Copyright (c) 2011-2012 Sorin Nistor. All rights reserved. This software is provided 'as-is', without any express or implied warranty.
//  In no event will the authors be held liable for any damages arising from the use of this software.
//  Permission is granted to anyone to use this software for any purpose, including commercial applications,
//  and to alter it and redistribute it freely, subject to the following restrictions:
//  1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
//     If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source distribution.
//
#import <Foundation/Foundation.h>
#import "PSPDFKitGlobal.h"

@class PSPDFDocument;

enum {
    PSPDFAnnotationTypeUndefined,
    PSPDFAnnotationTypeLink,   /// the default page or url link
    PSPDFAnnotationTypePage,
    PSPDFAnnotationTypeWebUrl, 
    PSPDFAnnotationTypeHighlight,
    PSPDFAnnotationTypeVideo,
    PSPDFAnnotationTypeYouTube,
    PSPDFAnnotationTypeAudio,
    PSPDFAnnotationTypeImage,    
    PSPDFAnnotationTypeBrowser,
    PSPDFAnnotationTypeCustom  /// any annotation format that is not recognized is custom, calling the delegate viewForAnnotation:
};
typedef NSUInteger PSPDFAnnotationType;

/// Defines a pdf annotation (only page/link is parsed right now).
/// Custom annotation links are supported to add multimedia elements.
@interface PSPDFAnnotation : NSObject

/// initalize with dictionary, parsing happens here. dict is not saved.
- (id)initWithPDFDictionary:(CGPDFDictionaryRef)annotationDictionary;

/// check if point is inside link.
- (BOOL)hitTest:(CGPoint)point;

/// calculates the exact annotation position in the current page.
- (CGRect)rectForPageRect:(CGRect)pageRect;

/// link if target is a page if siteLinkTarget is nil.
@property(nonatomic, assign) NSUInteger pageLinkTarget;

/// link if target is a website.
@property(nonatomic, strong) NSString *siteLinkTarget;

/// URL for PSPDFAnnotationTypeVideo.
@property(nonatomic, strong) NSURL *URL;

/// rectangle of specific annotation.
@property(nonatomic, assign) CGRect pdfRectangle;

/// current annotation type.
@property(nonatomic, assign) PSPDFAnnotationType type;

/// page for current annotation.
@property(nonatomic, assign) NSUInteger page;

/// corresponding document, weak.
@property(nonatomic, ps_weak) PSPDFDocument *document;

/// returns true if the annotation is not of type Page or WebUrl. (>= PSPDFAnnotationTypeFile)
@property(nonatomic, assign, getter=isOverlayAnnotation) BOOL overlayAnnotation;

/// arbitary text entered into a PDF writer by the user which is associated with the annotation or nil if there is no text
@property(nonatomic, strong, readonly) NSString *contents;

/// color associated with the annotation or nil if there is no color
@property(nonatomic, strong, readonly) UIColor *color;

/// If values between pspdfkit://[...] are set, this will contain those options.
@property(nonatomic, strong) NSDictionary *options;

/// Indicator if "modal" is set in options. Will add "modal" to options if setModal is used.
@property(nonatomic, assign, getter=isModal) BOOL modal;

/// Tries to extract a size out of options "size". Returns CGSizeZero if conversion fails.
@property(nonatomic, assign) CGSize size;

@end
