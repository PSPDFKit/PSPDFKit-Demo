//
//  PSPDFStaticTableViewController.h
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

// Helps to create controllers that show static table view content.
@interface PSPDFStaticTableViewController : UITableViewController

// Table view sections (PSPDFSectionModel)
@property (nonatomic, strong) NSArray *sections;

// Calls the update block on all visible cells.
- (void)updateVisibleCells;

// Calculates the size needed for the static content.
- (CGSize)staticContentPopoverSize;

@end


// Defines the content for a UITableViewCells.
@interface PSPDFCellModel : NSObject

+ (instancetype)cellWithTitle:(NSString *)title;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIView *accessoryView;
@property (nonatomic, strong) Class cellClass; // Defaults to UITableViewCell if nil.
@property (nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;
@property (nonatomic, assign) CGFloat height; // Defaults to 44.f
@property (nonatomic, copy) void (^actionBlock)(PSPDFStaticTableViewController *viewController, UITableViewCell *cell);
@property (nonatomic, copy) void (^updateBlock)(PSPDFStaticTableViewController *viewController, UITableViewCell *cell);
@property (nonatomic, copy) void (^createBlock)(PSPDFStaticTableViewController *viewController, UITableViewCell *cell);

@end

// Defines the content for a section in UITableView.
@interface PSPDFSectionModel : NSObject

+ (instancetype)sectionWithTitle:(NSString *)title;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *cells;

@end


// Shows a color.
@interface PSPDFColorCell : UITableViewCell

@property (nonatomic, strong) UIColor *color;

@end
