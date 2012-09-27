//
//  PSCClearTabsButtonItem.h
//  PSPDFCatalog
//
//  Copyright (c) 2012 PSPDFKit. All rights reserved.
//

/// Button to clear all open tabs in a PSPDFTabbedViewController.
@interface PSCClearTabsButtonItem : PSPDFBarButtonItem

/// Saves the actionSheet if currently displayed.
@property (nonatomic, strong) UIActionSheet *actionSheet;

@end
