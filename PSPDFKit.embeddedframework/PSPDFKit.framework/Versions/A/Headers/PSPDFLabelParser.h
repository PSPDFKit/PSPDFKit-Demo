//
//  PSPDFLabelParser.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//
//  Special thanks to Cédric Luthi for providing the code.
//

#import "PSPDFKitGlobal.h"

@class PSPDFDocument;

/// Parses Page Labels (see PDF Reference §8.3.1)
@interface PSPDFLabelParser : NSObject

/// Init label parser with document.
- (id)initWithDocument:(PSPDFDocument *)document;

/// Parse document, returns labels (NSStrings)
- (NSDictionary *)parseDocument;

/// Returns a page label for a certain page. Returns nil if no pageLabel is available.
- (NSString *)pageLabelForPage:(NSUInteger)page;

/// Returns cached labels. Starts parsing if labels are not yet created.
@property(nonatomic, strong, readonly) NSDictionary *labels;

@end
