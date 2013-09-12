//
//  PSPDFChoiceEditorViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBaseTableViewController.h"

@class PSPDFChoiceEditorViewController;

@protocol PSPDFChoiceEditorViewControllerDataSource <NSObject>

/// Number of predefined choices excluding editable choice.
- (NSUInteger)numberOfOptions;
- (NSUInteger)numberOfOptionsSelected;

/// YES if user can select multiple options.
- (BOOL)isMultiSelect;
- (NSString *)optionTextAtIndex:(NSUInteger)index;
- (BOOL)isSelectedAtIndex:(NSUInteger)index;

/// YES if user can enter his own choice.
- (BOOL)isEdit;
- (NSString *)customText;

@end

@protocol PSPDFChoiceEditorViewControllerDelegate <NSObject>

- (void)choiceEditorViewController:(PSPDFChoiceEditorViewController *)choiceEditorViewController didSelectIndex:(NSUInteger)index;
- (void)choiceEditorViewController:(PSPDFChoiceEditorViewController *)choiceEditorViewController didUpdateCustomText:(NSString *)text;
- (void)choiceEditorViewControllerDidSelectCustomText:(PSPDFChoiceEditorViewController *)choiceEditorViewController;
- (void)choiceEditorViewControllerDidEndEditingCustomText:(PSPDFChoiceEditorViewController *)choiceEditorViewController;

@end

/// Shows a list of choices for the choice form element.
@interface PSPDFChoiceEditorViewController : PSPDFBaseTableViewController

- (instancetype)initChoiceEditorViewControllerWithDataSource:(id <PSPDFChoiceEditorViewControllerDataSource>)datasource delegate:(id<PSPDFChoiceEditorViewControllerDelegate>)delegate;

@property (nonatomic, weak) id<PSPDFChoiceEditorViewControllerDataSource> dataSource;
@property (nonatomic, weak) id<PSPDFChoiceEditorViewControllerDelegate> delegate;

- (void)reloadData;

@end
