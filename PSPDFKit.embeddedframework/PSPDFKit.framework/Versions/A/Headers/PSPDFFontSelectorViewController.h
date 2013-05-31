//
//  PSPDFFontSelectorViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBaseViewController.h"

@class PSPDFFontSelectorViewController;

/// Delegate for PSPDFFontSelectorViewController.
@protocol PSPDFFontSelectorViewControllerDelegate <NSObject>

/// A font has been selected.
- (void)fontSelectorViewController:(PSPDFFontSelectorViewController *)fontSelectorViewController didSelectFont:(UIFont *)selectedFont;

@end

/// Simple table view that allows to select a font.
@interface PSPDFFontSelectorViewController : UITableViewController

/// All available font family names. This is set on init by querying UIFont.familyNames.
@property (nonatomic, strong) NSArray *fontFamilyNames;

/// The currently selected font.
@property (nonatomic, strong) UIFont *selectedFont;

/// Delegate.
@property (nonatomic, weak) IBOutlet id<PSPDFFontSelectorViewControllerDelegate> delegate;

@end
