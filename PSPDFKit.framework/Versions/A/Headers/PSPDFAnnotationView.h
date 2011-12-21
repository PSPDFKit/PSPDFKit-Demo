//
//  PSPDFAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PSPDFAnnotation;

/// conforming to this protocol indicates instances can present an annotation and react events such as page show/hide (to pause video, for example)
@protocol PSPDFAnnotationView <NSObject>

@optional

/// Represented annotation this object is presenting.
@property(nonatomic, retain) PSPDFAnnotation *annotation;

/// page is displayed.
- (void)didShowPage:(NSUInteger)page;

/// page is hidden.
- (void)didHidePage:(NSUInteger)page;

/// called when the parent page size is changed. (e.g. rotation!)
- (void)didChangePageFrame:(CGRect)frame;

@end
