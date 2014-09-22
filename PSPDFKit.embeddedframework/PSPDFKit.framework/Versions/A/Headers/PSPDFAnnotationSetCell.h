//
//  PSPDFAnnotationSetCell.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAnnotationSet.h"
#import "PSPDFSelectableCollectionViewCell.h"

/// Annotation Set cell, displays an annotation set.
@interface PSPDFAnnotationSetCell : PSPDFSelectableCollectionViewCell

/// The annotation set.
@property (nonatomic, strong) PSPDFAnnotationSet *annotationSet;

// If set, resizes to cell bounds.
//@property (nonatomic, assign) BOOL shouldResizeToCellBounds;

// Edge insets for the set image.
@property (nonatomic, assign) UIEdgeInsets edgeInsets UI_APPEARANCE_SELECTOR;

@end
