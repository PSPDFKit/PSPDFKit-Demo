//
//  PSPDFAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFAnnotation;

/// conforming to this protocol indicates instances can present an annotation and react events such as page show/hide (to pause video, for example)
@protocol PSPDFAnnotationView <NSObject>

@optional

/// Represented annotation this object is presenting.
@property(nonatomic, retain) PSPDFAnnotation *annotation;

/// page will be displayed. only available in pageCurl mode.
- (void)willShowPage:(NSUInteger)page;

/// page is displayed.
- (void)didShowPage:(NSUInteger)page;

/// page will be hidden. only available in pageCurl mode.
- (void)willHidePage:(NSUInteger)page;

/// page is hidden.
- (void)didHidePage:(NSUInteger)page;

/// called when the parent page size is changed. (e.g. rotation!)
- (void)didChangePageFrame:(CGRect)frame;

@end
