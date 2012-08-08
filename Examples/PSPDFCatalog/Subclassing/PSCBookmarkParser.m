//
//  PSCBookmarkParser.m
//  PSPDFCatalog
//
//  Copyright (c) 2012 PSPDFKit. All rights reserved.
//

#import "PSCBookmarkParser.h"

@implementation PSCBookmarkParser

- (BOOL)addBookmarkForPage:(NSUInteger)page {
    NSLog(@"Add Bookmark: %d", page);
    return [super addBookmarkForPage:page];
}

- (BOOL)removeBookmarkForPage:(NSUInteger)page {
    NSLog(@"Remove Bookmark: %d", page);
    return [super removeBookmarkForPage:page];
}

// block bookmark loading
- (NSArray *)loadBookmarks {
    return [NSArray array];
}

- (void)saveBookmarks {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:@"Bookmark Subclass Message" message:[NSString stringWithFormat:@"Intercepted bookmark saving; current bookmarks are: %@", self.bookmarks] delegate:nil cancelButtonTitle:PSPDFLocalize(@"Ok") otherButtonTitles:nil] show];
    });
}

@end
