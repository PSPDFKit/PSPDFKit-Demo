//
//  PSPDFBookmarkViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFStatefulTableViewController.h"
#import "PSPDFStyleable.h"
#import "PSPDFBookmarkTableViewCell.h"

@class PSPDFDocument, PSPDFBookmark, PSPDFBookmarkViewController;

/// Delegate for the bookmark controller.
@protocol PSPDFBookmarkViewControllerDelegate <PSPDFOverridable>

/// Query the page that should be bookmarked when pressed the [+] button.
- (NSUInteger)currentPageForBookmarkViewController:(PSPDFBookmarkViewController *)bookmarkController;

/// Called when a cell is touched.
- (void)bookmarkViewController:(PSPDFBookmarkViewController *)bookmarkController didSelectBookmark:(PSPDFBookmark *)bookmark;

@end

/// Show list of bookmarks for the current document and allows editing/reordering of the bookmarks.
@interface PSPDFBookmarkViewController : PSPDFStatefulTableViewController <PSPDFBookmarkTableViewCellDelegate, PSPDFStyleable>

/// Designated initializer.
- (id)initWithDocument:(PSPDFDocument *)document delegate:(id<PSPDFBookmarkViewControllerDelegate>)delegate;

/// Will also reload tableView if changed.
@property (nonatomic, strong) PSPDFDocument *document;

/// Allow to long-press to copy the title. Defaults to YES.
@property (nonatomic, assign) BOOL allowCopy;

/// Delegate.
@property (nonatomic, weak) IBOutlet id<PSPDFBookmarkViewControllerDelegate> delegate;

// PSPDFStyleable attribute.
@property (nonatomic, assign) BOOL isInPopover;

@end


@interface PSPDFBookmarkViewController (SubclassingHooks)

- (void)createBarButtonItems;
- (void)updateBookmarkView;
- (void)addBookmarkAction:(id)sender;
- (void)doneAction:(id)sender;

@end
