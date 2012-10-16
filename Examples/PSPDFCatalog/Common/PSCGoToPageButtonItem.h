//
//  PSCGoToPageButtonItem.h
//  PSPDFCatalog
//
//  Copyright (c) 2012 PSPDFKit. All rights reserved.
//

/// Allows to jump to a specific page or page label. iOS5+
@interface PSCGoToPageButtonItem : PSPDFBarButtonItem

/// Match partial label string names. Defaults to YES.
@property (nonatomic, assign) BOOL enablePartialLabelMatching;

@end
