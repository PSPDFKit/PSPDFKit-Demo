//
//  PSPDFBookmarkBarButtonItem.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFBarButtonItem.h"

@interface PSPDFBookmarkBarButtonItem : PSPDFBarButtonItem

/// Defaults to NO. Will be ignored if tapChangesBookmarkStatus is NO.
@property (nonatomic, assign) BOOL showBookmarkControllerOnLongPress;

/// Defaults to YES. NO will show the PSPDFBookmarkViewController instantly.
@property (nonatomic, assign) BOOL tapChangesBookmarkStatus;

@end


@interface PSPDFBookmarkBarButtonItem (SubclassingHooks)

- (NSNumber *)bookmarkNumberForVisiblePages;

@end
