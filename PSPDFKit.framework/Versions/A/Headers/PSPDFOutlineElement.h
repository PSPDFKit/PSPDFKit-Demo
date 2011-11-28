//
//  PSPDFOutlineElement.h
//  PSPDFKit
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@interface PSPDFOutlineElement : NSObject

/// init
- (id)initWithTitle:(NSString *)title page:(NSUInteger)page elements:(NSArray *)elements level:(NSUInteger)level;

/// outline title
@property(nonatomic, retain) NSString *title;

/// page reference
@property(nonatomic, assign) NSUInteger page;

/// child elements
@property(nonatomic, retain, readonly) NSArray *elements;

// current outline level
@property(nonatomic, assign) NSUInteger level;

@end
