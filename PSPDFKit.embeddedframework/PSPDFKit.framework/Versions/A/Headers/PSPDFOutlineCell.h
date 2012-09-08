//
//  PSPDFOutlineCell.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFOutlineCell, PSPDFOutlineElement;

@protocol PSPDFOutlineCellDelegate <NSObject>

/// Delegate for expand/collapse button
- (void)outlineCellDidTapDisclosureButton:(PSPDFOutlineCell *)outlineCell;

@end


/// Single cell for the outline controller
@interface PSPDFOutlineCell : UITableViewCell

/// Dynamically claculates the height for a cell.
+ (CGFloat)heightForCellWithOutlineElement:(PSPDFOutlineElement *)outlineElement constrainedToSize:(CGSize)constraintSize;

/// Delegate for cell button
@property(nonatomic, ps_weak) id<PSPDFOutlineCellDelegate> delegate;

/// Single outline Element
@property(nonatomic, strong) PSPDFOutlineElement *outlineElement;

@end

@interface PSPDFOutlineCell (Subclassing)

// Button that controls the open/close of cells
@property(nonatomic, strong) UIButton *disclosureButton;

// Subclass to change the font. Default is 17 for level 1; 15 for level > 1.
+ (UIFont *)fontForOutlineElement:(PSPDFOutlineElement *)outlineElement;

// Set transform according to expansion state.
- (void)updateOutlineButton;

// Button action. Animates and calls the delegate.
- (void)expandOrCollapse;

@end