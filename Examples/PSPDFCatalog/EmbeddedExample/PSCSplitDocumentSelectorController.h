//
//  SplitTableViewController.h
//  PSPDFCatalog
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSCDocumentSelectorController.h"

@class  PSCSplitPDFViewController;

@interface PSCSplitDocumentSelectorController : PSCDocumentSelectorController <PSCDocumentSelectorControllerDelegate>

@property (nonatomic, unsafe_unretained) PSCSplitPDFViewController *masterVC;

@end
