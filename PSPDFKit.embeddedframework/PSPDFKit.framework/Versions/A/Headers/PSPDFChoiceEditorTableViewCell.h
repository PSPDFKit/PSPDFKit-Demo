//
//  PSPDFChoiceEditorTableViewCell.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>
#import "PSPDFChoiceEditorViewController.h"

@interface PSPDFChoiceEditorTableViewCell : UITableViewCell

@property (nonatomic, weak) id<PSPDFChoiceEditorViewControllerDelegate> delegate;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, weak) PSPDFChoiceEditorViewController *parent;

/// Choose whether to be editable immediately or be selectable with an edit button.
/// To be called in tableView:cellForRowAtIndexPath:.
- (void)chooseEditable;

@end
