//
//  PSPDFSearchResult.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFKitGlobal.h"

@class Selection, PSPDFDocument;

/// Search result object.
@interface PSPDFSearchResult : NSObject

/// Referenced document.
@property(nonatomic, ps_weak) PSPDFDocument *document;

/// referenced page.
@property(nonatomic, assign) NSUInteger pageIndex;

/// preview text snippet.
@property(nonatomic, copy) NSString *previewText;

/// Text coordinates. May not be set, expensive calculation.
@property(nonatomic, strong) Selection *selection;

/// Range within full page text.
@property(nonatomic, assign) NSRange range;

@end
