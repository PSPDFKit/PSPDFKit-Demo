//
//  PSPDFMagazineFolder.m
//  PSPDFKitExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "AppDelegate.h"
#import "PSPDFMagazineFolder.h"
#import "PSPDFMagazine.h"

@implementation PSPDFMagazineFolder

@synthesize magazines = magazines_;
@synthesize title;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Static

+ (PSPDFMagazineFolder *)folderWithTitle:(NSString *)title {
    PSPDFMagazineFolder *folder = [[[self class] alloc] init];
    folder.title = title;
    return folder;
}

// only deregister if delegate belongs to us
- (void)removeMagazineFolderReferences {
    for (PSPDFMagazine *magazine in magazines_) {
        if (magazine.folder == self) {
            magazine.folder = nil;
        }
    }
}

- (void)addMagazineFolderReferences {
    for (PSPDFMagazine *magazine in magazines_) {
        magazine.folder = self;
    }    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if ((self = [super init])) {
        magazines_ = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [self removeMagazineFolderReferences];
}

- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"<PSPDFMagazineFolder %@, %d magazines>", self.title, [self.magazines count]];
    return description;
}

- (NSUInteger)hash {
    return [self.title hash];
}

- (BOOL)isEqual:(id)other {
    if ([other isKindOfClass:[self class]]) {
        if (![self.title isEqual:[other title]] || !self.title || ![other title]) {
            return NO;
        }
        return YES;
    }
    else return NO;  
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (BOOL)isSingleMagazine {
    return [self.magazines count] == 1; 
}

- (PSPDFMagazine *)firstMagazine {
    PSPDFMagazine *firstMagazine = [self.magazines count] ? [self.magazines objectAtIndex:0] : nil; 
    return firstMagazine;
}

- (void)addMagazine:(PSPDFMagazine *)magazine {
    [magazines_ addObject:magazine];
    magazine.folder = self;
    [self sortMagazines];
}

- (void)removeMagazine:(PSPDFMagazine *)magazine {
    magazine.folder = nil;
    [magazines_ removeObject:magazine];
    [self sortMagazines];
}

- (void)sortMagazines {
    [magazines_ sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:NO]]];
}

- (void)setMagazines:(NSArray *)magazines {
    if (magazines != magazines_) {
        [self removeMagazineFolderReferences];
        magazines_ = [magazines mutableCopy];
        [self addMagazineFolderReferences];
        [self sortMagazines];
    }
}

@end
