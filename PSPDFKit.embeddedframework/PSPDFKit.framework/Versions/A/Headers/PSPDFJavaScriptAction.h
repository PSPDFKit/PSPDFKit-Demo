//
//  PSPDFJavaScriptAction.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAction.h"

@class PSPDFDocument;

/// Only very rudimentary support for JavaScript exists.
/// Currently only a script like 'this.pageNum = 190' is supported.
@interface PSPDFJavaScriptAction : PSPDFAction

/// Designated initializer.
- (id)initWithScript:(NSString *)script;
- (id)initWithPDFDictionary:(CGPDFDictionaryRef)actionDictionary documentRef:(CGPDFDocumentRef)documentRef;

/// The script.
@property (nonatomic, copy) NSString *script;

/// Tries to execute the JavaScript. Experimental.
- (void)executeScript;

/// Calculate new page from JavaScript.
/// @return page number (might not be valid) or NSNotFound.
- (NSUInteger)pageIndexWithCurrentPage:(NSUInteger)currentPage fromDocument:(PSPDFDocument *)document;

@end
