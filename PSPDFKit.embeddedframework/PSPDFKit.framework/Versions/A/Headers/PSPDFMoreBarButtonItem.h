//
//  PSPDFMoreBarButtonItem.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBarButtonItem.h"

/// Presents an `UIActionSheet` for bar button items that don't fit into the toolbar.
@interface PSPDFMoreBarButtonItem : PSPDFBarButtonItem

/// If there's only one valid action in the list, instead directly use this button.
/// Defaults to YES.
@property (nonatomic, assign) BOOL shouldConsolidateIfOnlyOneOptionAvailable;

@end
