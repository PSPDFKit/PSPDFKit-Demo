//
//  SplitTableViewController.h
//  PSPDFCatalog
//
//  Copyright (c) 2011-2013 Peter Steinberger. All rights reserved.
//

#import "PSCDocumentSelectorController.h"

@class  PSCSplitPDFViewController;

@interface PSCSplitDocumentSelectorController : PSCDocumentSelectorController <PSCDocumentSelectorControllerDelegate>

@property (nonatomic, weak) PSCSplitPDFViewController *masterVC;

@end
