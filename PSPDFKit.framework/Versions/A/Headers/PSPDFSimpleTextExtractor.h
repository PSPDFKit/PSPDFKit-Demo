//
//  PSPDFSimpleTextExtractor.h
//  PSPDFKitExample
//
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

// This is a very simple class to extract text from pdf. It's used for *legacy* search mode
// because many pdf text formats are not converted properly here.
// Use this if you fast text extraction. 
// Also used as a failover for the more advanced text extraction algorithm.
@interface PSPDFSimpleTextExtractor : NSObject

/// Returns full page text of a certain CGPDFPageRef page.
- (NSString *)pageContentWithPageRef:(CGPDFPageRef)pageRef;

@end
