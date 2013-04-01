//
//  PSPDFEmptyTableViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>

/// Shows a message when the controller is empty.
@interface PSPDFEmptyTableViewController : UITableViewController

/// Empty label.
@property (nonatomic, strong, readonly) UILabel *emptyLabel;

/// Implement in subclass.
- (BOOL)isEmpty;

/// Call to check and update state.
/// @note `animated` currently is just a placeholder.
- (void)updateEmptyStateAnimated:(BOOL)animated;

@end
