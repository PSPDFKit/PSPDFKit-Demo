//
//  PSPDFOutlineCell.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"

@class PSPDFOutlineCell, PSPDFOutlineElement;

/// The delegate of an outline cell.
@protocol PSPDFOutlineCellDelegate <NSObject>

/// Delegate for expand/collapse button
- (void)outlineCellDidTapDisclosureButton:(PSPDFOutlineCell *)outlineCell;

@end

/// Single cell for the outline controller.
@interface PSPDFOutlineCell : UITableViewCell

/// Dynamically calculates the height for a cell.
+ (CGFloat)heightForCellWithOutlineElement:(PSPDFOutlineElement *)outlineElement constrainedToSize:(CGSize)constraintSize outlineIntentLeftOffset:(CGFloat)leftOffset outlineIntentMultiplier:(CGFloat)multiplier showPageLabel:(BOOL)showPageLabel;

/// Delegate for cell button.
@property (nonatomic, weak) IBOutlet id<PSPDFOutlineCellDelegate> delegate;

/// Single outline element.
@property (nonatomic, strong) PSPDFOutlineElement *outlineElement;

/// Shows the expand/collapse button.
@property (nonatomic, assign) BOOL showExpandCollapseButton;

/// Enables the page label on the right side of the cell.
@property (nonatomic, assign) BOOL showPageLabel;

@end

@interface PSPDFOutlineCell (SubclassingHooks)

// Button that controls the open/close of cells
@property (nonatomic, strong) UIButton *disclosureButton;

// The page label displayed on the right side. Only valid if `showPageLabel` is set.
@property (nonatomic, strong) UILabel *pageLabel;

// Subclass to change the font. Default is 17 for level 1; 15 for level > 1.
+ (UIFont *)fontForOutlineElement:(PSPDFOutlineElement *)outlineElement;

// Set transform according to expansion state.
- (void)updateDisclosureButton;

// Button action. Animates and calls the delegate.
- (void)expandOrCollapse;

/// Defaults to 32.f. Should be changed on PSPDFOutlineViewController.
@property (nonatomic, assign) CGFloat outlineIntentLeftOffset;

/// Defaults to 15.f. Should be changed on PSPDFOutlineViewController.
@property (nonatomic, assign) CGFloat outlineIndentMultiplier;

@end
