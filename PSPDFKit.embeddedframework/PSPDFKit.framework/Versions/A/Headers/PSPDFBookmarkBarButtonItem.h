//
//  PSPDFBookmarkBarButtonItem.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
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
