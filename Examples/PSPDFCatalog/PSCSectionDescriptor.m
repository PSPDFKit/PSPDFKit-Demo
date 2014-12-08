//
//  PSCSectionDescriptor.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCSectionDescriptor.h"

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCSectionDescriptor

@implementation PSCSectionDescriptor {
    NSMutableArray *_contentDescriptors;
}

+ (instancetype)sectionWithTitle:(NSString *)title footer:(NSString *)footer {
    return [[self alloc] initWithTitle:title footer:footer];
}

- (instancetype)initWithTitle:(NSString *)title footer:(NSString *)footer {
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

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p title:%@ footer:%@ content:%@>", self.class, self, self.title, self.footer, self.contentDescriptors];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSContent

@implementation PSContent

+ (instancetype)contentWithTitle:(NSString *)title description:(NSString *)description block:(PSControllerBlock)block {
    return [(PSContent *)[self alloc] initWithTitle:title description:description block:block];
}

+ (instancetype)contentWithTitle:(NSString *)title block:(PSControllerBlock)block {
    return [self contentWithTitle:title description:nil block:block];
}

- (instancetype)initWithTitle:(NSString *)title description:(NSString *)description block:(PSControllerBlock)block {
    if ((self = [super init])) {
        _title = title;
        _contentDescription = description;
        _block = block;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p title:%@ description:%@>", self.class, self, self.title, self.contentDescription];
}

@end
