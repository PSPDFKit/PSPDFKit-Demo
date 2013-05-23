//
//  PSPDFActionJavaScript.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
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
