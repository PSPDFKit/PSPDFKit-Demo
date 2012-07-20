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
- (void)outlineController:(PSPDFOutlineViewController *)outlineController didTapAtElement:(PSPDFOutlineElement *)outlineElement;

@end

/// Outline (Table of Contents) view conroller.
@interface PSPDFOutlineViewController : UITableViewController

/// Designated initializer.
- (id)initWithDocument:(PSPDFDocument *)document delegate:(id<PSPDFOutlineViewControllerDelegate>)delegate;

/// Allow to long-press to copy the title. Defaults to YES.
@property(nonatomic, assign) BOOL allowCopy;

@property(nonatomic, ps_weak) id<PSPDFOutlineViewControllerDelegate> delegate;

@property(nonatomic, ps_weak) PSPDFDocument *document;

@end


@interface PSPDFOutlineViewController (Subclassing)

// subclass if you change the default cell height of 44 pixels.
- (void)updatePopoverSize;

// Cell delegate - expand/shrink content.
- (void)outlineCellDidTapDisclosureButton:(PSPDFOutlineCell *)cell;

@end
