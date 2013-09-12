//
//  PSPDFTableViewCell.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

@interface PSPDFTableViewCell : UITableViewCell

// We need to explicitly disable animations here, else image weirdly animates because of an implicit animation context when the popover animates.
// Don't do this when we edit, since we do want the animation there.
- (void)performBlockWithoutAnimationIfResizingPopover:(dispatch_block_t)block;

@end

// Simple subclass that disables animations during layoutSubviews if the popover is being resized.
// This fixes an unexpected animation when the tableView is updated while a popover resizes.
@interface PSPDFNonAnimatingTableViewCell : PSPDFTableViewCell

@end

// Never allows animations during layoutSubviews.
@interface PSPDFNeverAnimatingTableViewCell : PSPDFTableViewCell

@end
