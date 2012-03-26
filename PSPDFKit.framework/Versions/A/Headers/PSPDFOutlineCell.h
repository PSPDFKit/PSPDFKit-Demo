//
//  PSPDFOutlineCell.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFKitGlobal.h"

@class PSPDFOutlineCell, PSPDFOutlineElement;

@protocol PSPDFOutlineCellDelegate <NSObject>

/// Delegate for expand/collapse button
- (void)outlineCellDidTapDisclosureButton:(PSPDFOutlineCell *)outlineCell;

@end


/// Single cell for the outline controller
@interface PSPDFOutlineCell : UITableViewCell {
    UIButton *outlineDisclosure_;
}

/// Delegate for cell button
@property(nonatomic, ps_weak) id<PSPDFOutlineCellDelegate> delegate;

/// Single outline Element
@property(nonatomic, strong) PSPDFOutlineElement *outlineElement;

@end
