//
//  PSCGoToPageButtonItem.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

/// Allows to jump to a specific page or page label.
@interface PSCGoToPageButtonItem : PSPDFBarButtonItem

/// Match partial label string names. Defaults to YES.
@property (nonatomic, assign) BOOL enablePartialLabelMatching;

@end
