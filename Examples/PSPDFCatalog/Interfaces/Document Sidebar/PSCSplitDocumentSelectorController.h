//
//  PSCSplitDocumentSelectorController.h
//  PSPDFCatalog
//
//  Copyright (c) 2011-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

@class  PSCSplitPDFViewController;

@interface PSCSplitDocumentSelectorController : PSPDFDocumentPickerController <PSPDFDocumentPickerControllerDelegate>

@property (nonatomic, weak) PSCSplitPDFViewController *masterController;

@end
