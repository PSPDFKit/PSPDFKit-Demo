//
//  PSPDFChoiceEditorViewController.h
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
#import "PSPDFChoiceFormElementView.h"

@class PSPDFChoiceEditorViewController;

@protocol PSPDFChoiceEditorViewControllerDataSource <NSObject>

/// Number of predefined choices excluding editable choice.
- (NSUInteger)numberOfOptions;
- (NSUInteger)numberOfOptionsSelected;

/// YES if user can select multiple options.
- (BOOL)isMultiSelect;
- (NSString *)optionTextAtIndex:(NSUInteger)index;
- (BOOL)isSelectedAtIndex:(NSUInteger)index;
- (NSIndexSet *)selectedIndices;

/// YES if user can enter his own choice.
- (BOOL)isEdit;
- (NSString *)customText;

@end

@protocol PSPDFChoiceEditorViewControllerDelegate <NSObject>

- (void)choiceEditorController:(PSPDFChoiceEditorViewController *)choiceEditorController didSelectIndex:(NSUInteger)index shouldDismissController:(BOOL)shouldDismissController;
- (void)choiceEditorController:(PSPDFChoiceEditorViewController *)choiceEditorController didUpdateCustomText:(NSString *)text;
- (void)choiceEditorControllerDidSelectCustomText:(PSPDFChoiceEditorViewController *)choiceEditorController;
- (void)choiceEditorControllerDidEndEditingCustomText:(PSPDFChoiceEditorViewController *)choiceEditorController;

@end

/// Shows a list of choices for the choice form element.
@interface PSPDFChoiceEditorViewController : PSPDFBaseTableViewController

/// Designated initializer
- (id)initWithDataSource:(id <PSPDFChoiceEditorViewControllerDataSource>)datasource delegate:(id<PSPDFChoiceEditorViewControllerDelegate>)delegate;

/// The choice editor data source.
@property (nonatomic, weak) id<PSPDFChoiceEditorViewControllerDataSource> dataSource;

/// The choice editor delegate.
@property (nonatomic, weak) id<PSPDFChoiceEditorViewControllerDelegate> delegate;

// The view where the form is currently rendered into.
@property (nonatomic, weak) PSPDFChoiceFormElementView *formElementView;

/// Reload the table.
- (void)reloadData;

/// Select the next cell.
- (void)selectNextValueAnimated:(BOOL)animated;

/// Select the previous cell.
- (void)selectPreviousValueAnimated:(BOOL)animated;

/// If the choice controller allows custom editing, make this cell active and scroll to it.
- (BOOL)enableEditModeAnimated:(BOOL)animated;

@end
