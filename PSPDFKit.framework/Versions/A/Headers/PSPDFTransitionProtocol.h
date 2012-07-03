//
//  PSPDFTransitionProtocol.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFPageView, PSPDFViewController;

@protocol PSPDFTransitionProtocol <NSObject>

- (void)setPage:(NSUInteger)page animated:(BOOL)animated;

- (NSArray *)visiblePageNumbers;

- (PSPDFPageView *)pageViewForPage:(NSUInteger)page;

@property(nonatomic, unsafe_unretained) PSPDFViewController *pdfController;

@end
