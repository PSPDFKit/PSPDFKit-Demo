//
//  PSCSectionDescriptor.m
//  PSPDFCatalog
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSCSectionDescriptor.h"

@implementation PSContent

- (id)initWithTitle:(NSString *)title class:(Class)class {
    if ((self = [super init])) {
        _title = title;
        _classToInvoke = class;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title block:(PSControllerBlock)block {
    if ((self = [super init])) {
        _title = title;
        _block = block;
    }
    return self;
}

@end

@implementation PSCSectionDescriptor

- (id)initWithTitle:(NSString *)title footer:(NSString *)footer {
    if ((self = [super init])) {
        _title = title;
        _footer = footer;
        _contentDescriptors = [NSMutableArray new];
    }
    return self;
}

- (void)setContentDescriptors:(NSArray *)contentDescriptors {
    _contentDescriptors = [contentDescriptors mutableCopy];
}

- (void)addContent:(PSContent *)contentDescriptor {
    [_contentDescriptors addObject:contentDescriptor];
}

@end
