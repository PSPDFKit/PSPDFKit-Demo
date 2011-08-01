//
//  PSPDFSearchResult.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 7/20/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFKit.h"

@interface PSPDFSearchResult : NSObject {
    PSPDFDocument *document_;
    NSUInteger pageIndex_;
    NSString *previewText_;
}

@property (nonatomic, assign) PSPDFDocument *document;
@property (nonatomic, assign) NSUInteger pageIndex;
@property (nonatomic, copy) NSString *previewText;

@end
