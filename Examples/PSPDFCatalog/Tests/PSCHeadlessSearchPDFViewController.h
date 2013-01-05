//
//  PSCHeadlessSearchPDFViewController.h
//  PSPDFCatalog
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFViewController.h"

/// Example how to have a "persistent" search mode.
@interface PSCHeadlessSearchPDFViewController : PSPDFViewController <PSPDFViewControllerDelegate>

@property (nonatomic, copy) NSString *highlightedSearchText;

@end
