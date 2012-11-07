//
//  PSCCustomBookmarkBarButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSCCustomBookmarkBarButtonItem.h"

// Simple subclass, replacing the image.
@implementation PSCCustomBookmarkBarButtonItem

// We are lazy and use a systemItem for the example.
- (UIBarButtonSystemItem)systemItem {
    BOOL hasBookmark = [self bookmarkNumberForVisiblePages] != nil;
    return hasBookmark ? UIBarButtonSystemItemBookmarks : UIBarButtonSystemItemTrash;
}

// Image has priority, so nil that out.
- (UIImage *)image {
    return nil;
}

@end
