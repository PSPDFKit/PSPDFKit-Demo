//
//  PSPDFMagazineFolder.m
//  PSPDFCatalog
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCMagazineFolder.h"
#import "PSCMagazine.h"

#if !__has_feature(objc_arc)
#error "Compile this file with ARC"
#endif

@implementation PSCMagazineFolder {
    NSMutableArray *_magazines;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Static

+ (PSCMagazineFolder *)folderWithTitle:(NSString *)title {
    PSCMagazineFolder *folder = [[self.class alloc] init];
    folder.title = title;
    return folder;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if ((self = [super init])) {
        _magazines = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [self removeMagazineFolderReferences];
}

- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"<%@ %p: %@, %d magazines>", self.class, self, self.title, [self.magazines count]];
    return description;
}

- (NSUInteger)hash {
    return [self.title hash];
}

- (BOOL)isEqual:(id)other {
    if ([other isKindOfClass:self.class]) {
        return [self isEqualToMagazineFolder:(PSCMagazineFolder *)other];
    }
    return NO;
}

- (BOOL)isEqualToMagazineFolder:(PSCMagazineFolder *)otherMagazineFolder {
    return PSPDFEqualObjects(self.title, otherMagazineFolder.title);
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

// only deregister if delegate belongs to us
- (void)removeMagazineFolderReferences {
    for (PSCMagazine *magazine in _magazines) {
        if (magazine.folder == self) {
            magazine.folder = nil;
        }
    }
}

- (void)addMagazineFolderReferences {
    for (PSCMagazine *magazine in _magazines) {
        magazine.folder = self;
    }
}

- (BOOL)isSingleMagazine {
    return [self.magazines count] == 1;
}

- (PSCMagazine *)firstMagazine {
    PSCMagazine *firstMagazine = [self.magazines count] ? (self.magazines)[0] : nil;
    return firstMagazine;
}

- (void)addMagazine:(PSCMagazine *)magazine {
    [_magazines addObject:magazine];
    magazine.folder = self;
    [self sortMagazines];
}

- (void)removeMagazine:(PSCMagazine *)magazine {
    magazine.folder = nil;
    [_magazines removeObject:magazine];
    [self sortMagazines];
}

- (void)sortMagazines {
    [_magazines sortUsingComparator:^NSComparisonResult(PSPDFDocument *document1, PSPDFDocument *document2) {
        return [[document1.files lastObject] compare:[document2.files lastObject]];
    }];
}

- (void)setMagazines:(NSArray *)magazines {
    if (magazines != _magazines) {
        [self removeMagazineFolderReferences];
        _magazines = [magazines mutableCopy];
        [self addMagazineFolderReferences];
        [self sortMagazines];
    }
}

@end
