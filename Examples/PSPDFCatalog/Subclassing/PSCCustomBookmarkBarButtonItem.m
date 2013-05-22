//
//  PSCCustomBookmarkBarButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
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
