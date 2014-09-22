//
//  PSPDFFontPickerViewController.h
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
#import "PSPDFModernizer.h"
#import "PSPDFOverridable.h"

@class PSPDFFontPickerViewController;

/// Delegate for `PSPDFFontPickerViewController`, calls back when a font is selected.
@protocol PSPDFFontPickerViewControllerDelegate <PSPDFOverridable>

/// A font has been selected.
- (void)fontPickerViewController:(PSPDFFontPickerViewController *)fontPickerViewController didSelectFont:(UIFont *)selectedFont;

@end

/// Font picker that allows to select a font and customize the style.
@interface PSPDFFontPickerViewController : PSPDFBaseTableViewController

/// Initalize with a list of displayed `UIFontDescriptors`.
/// If `fontFamilyDescriptors` is nil, a default list of all commonly used font families is used.
- (instancetype)initWithFontFamilyDescriptors:(NSArray *)fontFamilyDescriptors NS_DESIGNATED_INITIALIZER;

/// All available font family names as `UIFontDescriptors`.
@property (nonatomic, copy, readonly) NSArray *fontFamilyDescriptors;

/// The currently selected font.
@property (nonatomic, strong) UIFont *selectedFont;

/// Allows search. Defaults to YES on iPad.
@property (nonatomic, assign) BOOL searchEnabled;

/// Enable font downloading from Apple's servers. Defaults to YES.
/// @note See http://support.apple.com/kb/HT5484 for the full list.
@property (nonatomic, assign) BOOL showDownloadableFonts;

/// The font picker delegate - notifies when a font is selected.
@property (nonatomic, weak) IBOutlet id<PSPDFFontPickerViewControllerDelegate> delegate;

@end


@interface UIFontDescriptor (Blacklisting)

/// By default certain less commonly used fonts are blocked automatically.
/// Array expects a list of regular expression strings.
/// @note Needs to be set before the font picker is displayed.
+ (void)setPSPDFDefaultBlacklist:(NSArray *)defaultBlacklist;
+ (NSArray *)pspdf_defaultBlacklist;

@end
