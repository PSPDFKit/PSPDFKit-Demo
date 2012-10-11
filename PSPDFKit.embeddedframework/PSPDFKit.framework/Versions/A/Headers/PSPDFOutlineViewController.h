//
//  PSPDFOutlineViewController.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFDocument, PSPDFOutlineViewController, PSPDFOutlineElement, PSPDFOutlineCell;

/// Delegate for the PSPDFOutlineViewController.
@protocol PSPDFOutlineViewControllerDelegate <NSObject>

/// Called when we tapped on a cell in the outlinController.
/// Return NO if event is not processed.
- (BOOL)outlineController:(PSPDFOutlineViewController *)outlineController didTapAtElement:(PSPDFOutlineElement *)outlineElement;

@end

/**
    Outline (Table of Contents) view conroller.
 
    As always, you can easily customize this controller using the overrideClassName system in PSPDFViewController.
 */
@interface PSPDFOutlineViewController : UITableViewController

/// Designated initializer.
- (id)initWithDocument:(PSPDFDocument *)document delegate:(id<PSPDFOutlineViewControllerDelegate>)delegate;

/// Allow to long-press to copy the title. Defaults to YES.
@property (nonatomic, assign) BOOL allowCopy;

/**
    How many lines should be displayed for a cell. Defaults to 4.
 
    Set this to 1 for PSPDFKit v1 behavior (tail trunication, one line)
    Set to 0 to show the full text, no matter how long the entry is.
 */
@property (nonatomic, assign) NSUInteger maximumNumberOfLines;

/// Delegate to communicate with PSPDFViewController.
@property (nonatomic, ps_weak) id<PSPDFOutlineViewControllerDelegate> delegate;

/// Attached document.
@property (nonatomic, ps_weak) PSPDFDocument *document;

@end


@interface PSPDFOutlineViewController (Subclassing)

// subclass if you change the default cell height of 44 pixels.
- (void)updatePopoverSize;

// Cell delegate - expand/shrink content.
- (void)outlineCellDidTapDisclosureButton:(PSPDFOutlineCell *)cell;

@end
