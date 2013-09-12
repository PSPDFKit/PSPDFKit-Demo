//
//  PSPDFLineAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAbstractLineAnnotation.h"

/// PDF Line annotation.
@interface PSPDFLineAnnotation : PSPDFAbstractLineAnnotation

/// Designated initializer.
- (id)init;

/// Starting point.
@property (nonatomic, assign) CGPoint point1;

/// End point.
@property (nonatomic, assign) CGPoint point2;

@end
