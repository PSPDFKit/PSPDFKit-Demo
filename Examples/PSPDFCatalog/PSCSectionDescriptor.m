//
//  PSCSectionDescriptor.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCSectionDescriptor.h"

#if !__has_feature(objc_arc)
#error "Compile this file with ARC"
#endif

@implementation PSCSectionDescriptor {
    NSMutableArray *_contentDescriptors;
}

+ (instancetype)sectionWithTitle:(NSString *)title footer:(NSString *)footer {
    return [[self alloc] initWithTitle:title footer:footer];
}

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

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p title:%@ footer:%@ content:%@>", self.class, self, self.title, self.footer, self.contentDescriptors];
}

@end

@implementation PSContent

+ (instancetype)contentWithTitle:(NSString *)title block:(PSControllerBlock)block {
    return [(PSContent *)[self alloc] initWithTitle:title block:block];
}

- (id)initWithTitle:(NSString *)title block:(PSControllerBlock)block {
    if ((self = [super init])) {
        _title = title;
        _block = block;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p title:%@>", self.class, self, self.title];
}

@end
