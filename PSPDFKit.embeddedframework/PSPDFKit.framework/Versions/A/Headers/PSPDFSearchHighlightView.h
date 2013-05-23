//
//  PSPDFSearchHighlightView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAnnotationViewProtocol.h"

@class PSPDFSearchResult;

/// Highlight view used to show where the search keyword is within the document.
@interface PSPDFSearchHighlightView : UIView <PSPDFAnnotationViewProtocol>

/// Initialize with a search result. Coordinates are recalculated automatically.
- (id)initWithSearchResult:(PSPDFSearchResult *)searchResult;

/// Animates the view with a short "pop" size animation.
- (void)popupAnimation;

/// Attached search result.
@property (nonatomic, strong) PSPDFSearchResult *searchResult;

/// Default backgroundColor is Yellow, 50% alpha.
@property (nonatomic, strong) UIColor *selectionBackgroundColor;

@end
