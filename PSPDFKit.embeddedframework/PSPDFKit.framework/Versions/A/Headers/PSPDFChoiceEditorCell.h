//
//  PSPDFChoiceEditorCell.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

@import UIKit;
#import "PSPDFChoiceEditorViewController.h"

@interface PSPDFChoiceEditorCell : UITableViewCell

@property (nonatomic, weak) id<PSPDFChoiceEditorViewControllerDelegate> delegate;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *editButton;

@property (nonatomic, weak) PSPDFChoiceEditorViewController *parent;

/// Choose whether to be editable immediately or be selectable with an edit button.
/// To be called in `tableView:cellForRowAtIndexPath:`.
- (void)chooseEditable;

// Enters the cell edit mode.
- (void)enterEditMode;

@end
