//
//  PSPDFOutlineViewController.h
//  PSPDFKit
//
//  Copyright 2011-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFDocument, PSPDFOutlineViewController, PSPDFOutlineElement, PSPDFOutlineCell;

/// Delegate for the PSPDFOutlineViewController.
@protocol PSPDFOutlineViewControllerDelegate <NSObject>

/// Called when we tapped on a cell in the outlineController.
/// Return NO if event is not processed.
- (BOOL)outlineController:(PSPDFOutlineViewController *)outlineController didTapAtElement:(PSPDFOutlineElement *)outlineElement;

@end

/// Outline (Table of Contents) view controller.
@interface PSPDFOutlineViewController : UITableViewController <UISearchDisplayDelegate>

/// Designated initializer.
- (id)initWithDocument:(PSPDFDocument *)document delegate:(id<PSPDFOutlineViewControllerDelegate>)delegate;

/// Allow to long-press to copy the title. Defaults to YES.
@property (nonatomic, assign) BOOL allowCopy;

/// Allows search. Defaults to YES.
@property (nonatomic, assign) BOOL searchEnabled;

/**
 How many lines should be displayed for a cell. Defaults to 4.

 Set this to 1 for PSPDFKit v1 behavior (tail truncation, one line)
 Set to 0 to show the full text, no matter how long the entry is.
 */
@property (nonatomic, assign) NSUInteger maximumNumberOfLines;

/// Left intent width. Defaults to 32.f.
@property (nonatomic, assign) CGFloat outlineIntentLeftOffset;

/// Intent multiplier (will be added x times the intent level). Defaults to 15.f.
@property (nonatomic, assign) CGFloat outlineIndentMultiplier;

/// Delegate to communicate with PSPDFViewController.
@property (nonatomic, weak) IBOutlet id<PSPDFOutlineViewControllerDelegate> delegate;

/// Attached document.
@property (nonatomic, weak) PSPDFDocument *document;

@end


@interface PSPDFOutlineViewController (SubclassingHooks)

// subclass if you change the default cell height of 44 pixels.
- (void)updatePopoverSize;

// Cell delegate - expand/shrink content.
- (void)outlineCellDidTapDisclosureButton:(PSPDFOutlineCell *)cell;

@end
