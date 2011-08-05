//
//  PSPDFOutlineElement.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 8/2/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@interface PSPDFOutlineElement : NSObject {
    NSString *title_;
    NSUInteger page_;
    NSArray *elements_;
    NSUInteger level_;
}

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
