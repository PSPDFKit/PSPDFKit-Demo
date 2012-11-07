//
//  PSCGoToPageButtonItem.h
//  PSPDFCatalog
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

/// Allows to jump to a specific page or page label.
@interface PSCGoToPageButtonItem : PSPDFBarButtonItem

/// Match partial label string names. Defaults to YES.
@property (nonatomic, assign) BOOL enablePartialLabelMatching;

@end
