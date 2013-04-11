//
//  PSPDFActionJavaScript.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFAction.h"

@class PSPDFDocument;

/// Only very rudimentary support for JavaScript exists.
/// Currently only a script like 'this.pageNum = 190' is supported.
@interface PSPDFActionJavaScript : PSPDFAction

/// Designated initalizer.
- (id)initWithScript:(NSString *)script;

/// The script.
@property (nonatomic, copy) NSString *script;

/// Calculate new page from JavaScript.
/// @return page number (might not be valid) or NSNotFound.
- (NSUInteger)pageIndexWithCurrentPage:(NSUInteger)currentPage fromDocument:(PSPDFDocument *)document;

@end
