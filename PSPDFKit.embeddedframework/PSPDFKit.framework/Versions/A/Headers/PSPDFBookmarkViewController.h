//
//  PSPDFBookmarkViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFStatefulTableViewController.h"
#import "PSPDFStyleable.h"
#import "PSPDFBookmarkTableViewCell.h"

@class PSPDFDocument, PSPDFBookmark, PSPDFBookmarkViewController;

/// Delegate for the bookmark controller.
@protocol PSPDFBookmarkViewControllerDelegate <NSObject>

/// Query the page that should be bookmarked when pressed the [+] button.
- (NSUInteger)currentPageForBookmarkViewController:(PSPDFBookmarkViewController *)bookmarkController;

/// Called when a cell is touched.
- (void)bookmarkViewController:(PSPDFBookmarkViewController *)bookmarkController didSelectBookmark:(PSPDFBookmark *)bookmark;

@end

extern const char kPSPDFBookmarkViewControllerIsResizingPopover;

/// Show list of bookmarks for the current document and allows editing/reordering of the bookmarks.
@interface PSPDFBookmarkViewController : PSPDFStatefulTableViewController <PSPDFBookmarkTableViewCellDelegate, PSPDFStyleable>

/// Designated initializer.
- (instancetype)initWithDocument:(PSPDFDocument *)document delegate:(id<PSPDFBookmarkViewControllerDelegate>)delegate;

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
- (void)updatePopoverSize;
- (void)updateBookmarkView;
- (void)addBookmarkAction:(id)sender;
- (void)doneAction:(id)sender;

@end
