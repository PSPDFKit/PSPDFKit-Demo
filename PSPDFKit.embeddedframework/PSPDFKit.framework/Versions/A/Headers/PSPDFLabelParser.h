//
//  PSPDFLabelParser.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//
//  Special thanks to Cédric Luthi for providing the code.
//

#import "PSPDFKitGlobal.h"

@class PSPDFDocumentProvider;

/// Parses Page Labels (see PDF Reference §8.3.1)
@interface PSPDFLabelParser : NSObject

/// Init label parser with document provider.
- (id)initWithDocumentProvider:(PSPDFDocumentProvider *)documentProvider;

/// Attached document provider.
@property (nonatomic, ps_weak, readonly) PSPDFDocumentProvider *documentProvider;

/// Parse document, returns labels (NSStrings)
- (NSDictionary *)parseDocument;

/// Returns a page label for a certain page. Returns nil if no pageLabel is available.
- (NSString *)pageLabelForPage:(NSUInteger)page;

/// Returns cached labels. Starts parsing if labels are not yet created.
@property (nonatomic, strong, readonly) NSDictionary *labels;

@end
