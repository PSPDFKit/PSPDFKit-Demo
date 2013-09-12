//
//  PSPDFFontStyleViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBaseTableViewController.h"

@class PSPDFFontStyleViewController;

/// Font style delegate.
@protocol PSPDFFontStyleViewControllerDelegate <PSPDFOverridable>

/// Delegate is fired when a font is selected.
- (void)fontStyleViewController:(PSPDFFontStyleViewController *)fontStyleViewController didSelectFont:(UIFont *)selectedFont;

@end

/// Select the font style (bold, italic, etc IF font is available.
@interface PSPDFFontStyleViewController : PSPDFBaseTableViewController

/// Designated initializer.
- (id)initWithFontFamilyName:(NSString *)fontFamilyName;

/// Font name. Set before showing.
@property (nonatomic, copy) NSString *fontFamilyName;

/// Font descriptors (PSPDFFontDescriptors), will be evaluated in init.
@property (nonatomic, copy) NSArray *fontDescriptors;

/// The final selected font.
@property (nonatomic, strong) UIFont *selectedFont;

/// Delegate after font has been selected.
@property (nonatomic, weak) IBOutlet id<PSPDFFontStyleViewControllerDelegate> delegate;

@end
