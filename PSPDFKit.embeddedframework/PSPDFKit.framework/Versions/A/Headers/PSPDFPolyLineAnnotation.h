//
//  PSPDFPolyLineAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAbstractLineAnnotation.h"

@interface PSPDFPolyLineAnnotation : PSPDFAbstractLineAnnotation

/// Designated initializer.
- (id)init;

/// The points of the polygon.
///
/// Contains NSValue objects that box a CGPoint.
/// @warning These values are generated on the fly from an internal representation, so use carefully.
@property (nonatomic, copy) NSArray *points;

@end
