//
//  PSPDFBookmarkViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFBaseViewController.h"
#import "PSPDFStyleable.h"

@class PSPDFDocument, PSPDFBookmark, PSPDFBookmarkViewController;

/// Delegate for the bookmark controller.
@protocol PSPDFBookmarkViewControllerDelegate <NSObject>

/// Query the page that should be bookmarked when pressed the [+] button.
- (NSUInteger)currentPageForBookmarkViewController:(PSPDFBookmarkViewController *)bookmarkController;

/// Called when a cell is touched.
- (void)bookmarkViewController:(PSPDFBookmarkViewController *)bookmarkController didSelectBookmark:(PSPDFBookmark *)bookmark;

@end

/**
 Show list of bookmarks for the current document and allows editing/reordering of the bookmarks.
 */
@interface PSPDFBookmarkViewController : UITableViewController <PSPDFStyleable>

/// Designated initializer.
- (instancetype)initWithDocument:(PSPDFDocument *)document;

/// Will also reload tableView if changed.
@property (nonatomic, strong) PSPDFDocument *document;

/// Delegate.
@property (nonatomic, weak) id<PSPDFBookmarkViewControllerDelegate> delegate;

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

// Custom cell used for bookmarks.
@interface PSPDFBookmarkTableViewCell : UITableViewCell <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) PSPDFBookmark *bookmark;
@end
