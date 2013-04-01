//
//  PSPDFFontStyleViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFBaseViewController.h"

@class PSPDFFontStyleViewController;

@protocol PSPDFFontStyleViewControllerDelegate <NSObject>

- (void)fontStyleViewController:(PSPDFFontStyleViewController *)fontStyleViewController didSelectFont:(UIFont *)selectedFont;

@end

/// Select the font style (bold, italic, etc IF font is available0
@interface PSPDFFontStyleViewController : UITableViewController

/// Designated initializer.
- (id)initWithFontFamilyName:(NSString *)fontFamilyName;

/// Font name. Set before showing.
@property (nonatomic, strong) NSString *fontFamilyName;

/// Font names, will be evaluated in init.
@property (nonatomic, strong) NSArray *fontNames;

/// The final selected font.
@property (nonatomic, strong) UIFont *selectedFont;

/// Delegate after font has been selected.
@property (nonatomic, weak) IBOutlet id<PSPDFFontStyleViewControllerDelegate> delegate;

@end
