//
//  PSPDFStaticTableViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBaseTableViewController.h"
#import "PSPDFAnnotation.h"
#import "PSPDFLineHelper.h"
#import "PSPDFTableViewCell.h"

// Helps to create controllers that show static table view content.
@interface PSPDFStaticTableViewController : PSPDFBaseTableViewController

// Table view sections (`PSPDFSectionModel`)
@property (nonatomic, copy) NSArray *sections;

// If enabled, will disable scrolling if the content fits.
@property (nonatomic, assign) BOOL disableScrollingIfContentFits;

// Calls the update block on all visible cells.
- (void)updateVisibleCells;

@end

@class PSPDFSectionModel;

// Defines the content for a `UITableViewCells`.
// Currently this is only used in `PSPDFStaticTableViewController`!
@interface PSPDFCellModel : NSObject

+ (instancetype)cellWithTitle:(NSString *)title;

@property (nonatomic, weak) PSPDFSectionModel *section;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) UIView *accessoryView;
@property (nonatomic, strong) Class cellClass; // Defaults to `UITableViewCell.class`.
@property (nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;
@property (nonatomic, assign) CGFloat height; // Defaults to 44.f
@property (nonatomic, copy) NSDictionary *userInfo; // save custom data.

// Returns YES if cell is currently checked.
@property (nonatomic, assign, getter=isChecked) BOOL checked;

// Action blocks for creating, updating and tapping.
@property (nonatomic, copy) void (^updateBlock)(PSPDFStaticTableViewController *viewController, UITableViewCell *cell);
@property (nonatomic, copy) void (^createBlock)(PSPDFStaticTableViewController *viewController, UITableViewCell *cell);
@property (nonatomic, copy) void (^actionBlock)(PSPDFStaticTableViewController *viewController, UITableViewCell *cell);

// Edit cells. If set, a tap will show/hide these additional cells.
@property (nonatomic, copy) NSArray *editingCellModels;
@property (nonatomic, assign, getter=isEditing) BOOL editing;

// Calculates the needed height for `width`. Useful if `subtitle` is set.
- (CGFloat)heightForWidth:(CGFloat)width;

@end

// Defines the content for a section in `UITableView`.
@interface PSPDFSectionModel : NSObject

+ (instancetype)sectionWithTitle:(NSString *)headerTitle;

@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, copy) NSString *footerTitle;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;

// Reading this will include `editingCellModels`.
@property (nonatomic, copy) NSArray *cells;

@end

// Shows a color.
@interface PSPDFColorCell : PSPDFNeverAnimatingTableViewCell

@property (nonatomic, strong) UIColor *color;

@end

// Shows a line end.
@interface PSPDFLineEndCell : PSPDFColorCell

- (void)setLineEnd:(PSPDFLineEndType)lineEnd annotation:(PSPDFAnnotation *)annotation forStart:(BOOL)isStart;

@end

// Handles changing the checkboxes on tap.
@interface PSPDFCheckboxSectionModel : PSPDFSectionModel
@property (nonatomic, strong) PSPDFCellModel *checkedCellModel;
@property (nonatomic, copy) void (^updateBlock)(PSPDFStaticTableViewController *viewController, PSPDFCheckboxSectionModel *checkboxSectionModel);
@end

// Automatically handles checkbox setting within a section.
@interface PSPDFCheckBoxCellModel : PSPDFCellModel
@end

