//
//  PSPDFOutlineViewController.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFDocument, PSPDFOutlineViewController, PSPDFOutlineElement;

/// Delegate for the PSPDFOutlineViewController.
@protocol PSPDFOutlineViewControllerDelegate <NSObject>

/// Called when we tapped on a cell in the outlinController.
- (void)outlineController:(PSPDFOutlineViewController *)outlineController didTapAtElement:(PSPDFOutlineElement *)outlineElement;

@end

/// Outline (Table of Contents) view conroller.
@interface PSPDFOutlineViewController : UITableViewController

/// Designated initializer.
- (id)initWithDocument:(PSPDFDocument *)document delegate:(id<PSPDFOutlineViewControllerDelegate>)delegate;

@property(nonatomic, ps_weak) id<PSPDFOutlineViewControllerDelegate> delegate;

@property(nonatomic, ps_weak) PSPDFDocument *document;

@end
