//
//  PSPDFLabelParser.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//
//  Special thanks to Cédric Luthi for providing the code.
//

#import <Foundation/Foundation.h>

@class PSPDFDocument;

@interface PSPDFLabelParser : NSObject

/// Init label parser with document.
- (id)initWithDocument:(PSPDFDocument *)document;

/// Parse document, returns labels (NSStrings)
- (NSArray *)parseDocument;

/// Returns cached labels. Starts parsing if labels are not yet created.
@property(nonatomic, strong, readonly) NSArray *labels;

@end
