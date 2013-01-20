//
//  PSPDFOutlineCell.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFOutlineCell, PSPDFOutlineElement;

@protocol PSPDFOutlineCellDelegate <NSObject>

/// Delegate for expand/collapse button
- (void)outlineCellDidTapDisclosureButton:(PSPDFOutlineCell *)outlineCell;

@end


/// Single cell for the outline controller.
@interface PSPDFOutlineCell : UITableViewCell

/// Dynamically calculates the height for a cell.
+ (CGFloat)heightForCellWithOutlineElement:(PSPDFOutlineElement *)outlineElement constrainedToSize:(CGSize)constraintSize outlineIntentLeftOffset:(CGFloat)leftOffset outlineIntentMultiplier:(CGFloat)multiplier;

/// Delegate for cell button.
@property (nonatomic, weak) id<PSPDFOutlineCellDelegate> delegate;

/// Single outline element.
@property (nonatomic, strong) PSPDFOutlineElement *outlineElement;

@end

@interface PSPDFOutlineCell (Subclassing)

// Button that controls the open/close of cells
@property (nonatomic, strong) UIButton *disclosureButton;

// Subclass to change the font. Default is 17 for level 1; 15 for level > 1.
+ (UIFont *)fontForOutlineElement:(PSPDFOutlineElement *)outlineElement;

// Set transform according to expansion state.
- (void)updateOutlineButton;

// Button action. Animates and calls the delegate.
- (void)expandOrCollapse;

/// Defaults to 32.f. Should be changed on PSPDFOutlineViewController.
@property (nonatomic, assign) CGFloat outlineIntentLeftOffset;

/// Defaults to 15.f. Should be changed on PSPDFOutlineViewController.
@property (nonatomic, assign) CGFloat outlineIndentMultiplier;

@end
