//
//  PSPDFMagazineFolder.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCMagazineFolder.h"
#import "PSCMagazine.h"

@implementation PSCMagazineFolder

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Static

+ (PSCMagazineFolder *)folderWithTitle:(NSString *)title {
    return [[self.class alloc] initWithTitle:title];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (instancetype)init {
    if ((self = [super init])) {
        _magazines = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title {
    if ((self = [self init])) {
        _title = title;
    }
    return self;
}

- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"<%@ %p: %@, %tu magazines>", self.class, self, self.title, self.magazines.count];
    return description;
}

- (NSUInteger)hash {
    return self.title.hash;
}

- (BOOL)isEqual:(id)other {
    if ([other isKindOfClass:self.class]) {
        return [self isEqualToMagazineFolder:(PSCMagazineFolder *)other];
    }
    return NO;
}

- (BOOL)isEqualToMagazineFolder:(PSCMagazineFolder *)otherMagazineFolder {
    return self.title == otherMagazineFolder.title || [self.title isEqual:otherMagazineFolder.title];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)addMagazineFolderReferences {
    for (PSCMagazine *magazine in self.magazines) {
        magazine.folder = self;
    }
}

- (BOOL)isSingleMagazine {
    return self.magazines.count == 1;
}

- (PSCMagazine *)firstMagazine {
    return self.magazines.firstObject;
}

- (void)addMagazine:(PSCMagazine *)magazine {
    [(NSMutableArray *)self.magazines addObject:magazine];
    magazine.folder = self;
    [self sortMagazines];
}

- (void)removeMagazine:(PSCMagazine *)magazine {
    magazine.folder = nil;
    [(NSMutableArray *)self.magazines removeObject:magazine];
    [self sortMagazines];
}

- (void)sortMagazines {
    [(NSMutableArray *)self.magazines sortUsingComparator:^NSComparisonResult(PSPDFDocument *document1, PSPDFDocument *document2) {
        return [document1.files.lastObject compare:document2.files.lastObject];
    }];
}

- (void)setMagazines:(NSArray *)magazines {
    if (magazines != _magazines) {
        _magazines = [magazines mutableCopy];
        [self addMagazineFolderReferences];
        [self sortMagazines];
    }
}

@end
