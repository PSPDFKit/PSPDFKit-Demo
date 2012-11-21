//
//  PSPDFBookmarkBarButtonItem.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFBarButtonItem.h"

@interface PSPDFBookmarkBarButtonItem : PSPDFBarButtonItem

/// Defaults to YES. Will be ignored if tapChangesBookmarkStatus is NO.
@property (nonatomic, assign) BOOL showBookmarkControllerOnLongPress;

/// Defauls to YES. NO will show the PSPDFBookmarkViewController instantly.
@property (nonatomic, assign) BOOL tapChangesBookmarkStatus;

@end


@interface PSPDFBookmarkBarButtonItem (SubclassingHooks)

- (NSNumber *)bookmarkNumberForVisiblePages;

@end
