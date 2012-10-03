//
//  PSPDFSearchHighlightView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFAnnotationView.h"

@class PSPDFSearchResult;

/// Highlight view used to show where the search keyword is within the document.
@interface PSPDFSearchHighlightView : UIView <PSPDFAnnotationView>

/// Initialize with a search result. Coordinates are recalculated automatically.
- (id)initWithSearchResult:(PSPDFSearchResult *)searchResult;

/// Animates the view with a size incrase pop.
- (void)popupAnimation;

@property (nonatomic, strong) PSPDFSearchResult *searchResult;

@end
