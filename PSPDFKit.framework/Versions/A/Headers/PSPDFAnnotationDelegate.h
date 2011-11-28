//
//  PSPDFAnnotationDelegate.h
//  PSPDFKit
//
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

/// can be implemented by annotation subclasses to react on page show/hide events (e.g. pause video)
@protocol PSPDFAnnotationDelegate <NSObject>

@optional

/// page is displayed.
- (void)didShowPage:(NSUInteger)page;

/// page is hidden.
- (void)didHidePage:(NSUInteger)page;

/// called when the parent page size is changed. (e.g. rotation!)
- (void)didChangePageFrame:(CGRect)frame;

@end
