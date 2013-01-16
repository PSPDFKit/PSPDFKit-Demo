//
//  PSPDFFontSelectorViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFBaseViewController.h"

@class PSPDFFontSelectorViewController;

@protocol PSPDFFontSelectorViewControllerDelegate <NSObject>

- (void)fontSelectorViewController:(PSPDFFontSelectorViewController *)fontSelectorViewController didSelectFont:(UIFont *)selectedFont;

@end

@interface PSPDFFontSelectorViewController : UITableViewController

@property (nonatomic, strong) NSArray *fontFamilyNames;
@property (nonatomic, strong) UIFont *selectedFont;

@property (nonatomic, weak)	id<PSPDFFontSelectorViewControllerDelegate> delegate;

@end
