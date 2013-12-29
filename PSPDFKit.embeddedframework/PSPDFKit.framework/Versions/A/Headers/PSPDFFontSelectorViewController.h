//
//  PSPDFFontSelectorViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBaseTableViewController.h"

@class PSPDFFontSelectorViewController;

/// Delegate for `PSPDFFontSelectorViewController`.
@protocol PSPDFFontSelectorViewControllerDelegate <PSPDFOverridable>

/// A font has been selected.
- (void)fontSelectorViewController:(PSPDFFontSelectorViewController *)fontSelectorViewController didSelectFont:(UIFont *)selectedFont;

@end

/// Simple table view that allows to select a font.
@interface PSPDFFontSelectorViewController : PSPDFBaseTableViewController

/// Allow to block specific fonts. PSPDFKit blocks several fonts by default that are less commonly used.
/// Set to nil to disable blocking any fonts. Array contains string names.
+ (void)setDefaultBlocklist:(NSArray *)defaultBlocklist;
+ (NSArray *)defaultBlocklist;

/// All available font family names as `PSPDFFontDescriptors`. This is set on init by querying `UIFont.familyNames`.
@property (nonatomic, copy) NSArray *fontFamilyDescriptors;

/// The currently selected font.
@property (nonatomic, strong) UIFont *selectedFont;

/// Allows search. Defaults to YES on iPad.
@property (nonatomic, assign) BOOL searchEnabled;

/// Enable font downloading from Apple's servers. Defaults to YES.
/// @note iOS 6+. See http://support.apple.com/kb/HT5484 for the full list.
@property (nonatomic, assign) BOOL showDownloadableFonts;

/// Delegate.
@property (nonatomic, weak) IBOutlet id<PSPDFFontSelectorViewControllerDelegate> delegate;

@end
