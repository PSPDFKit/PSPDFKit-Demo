//
//  PSPDFAnnotationCell.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"

@class PSPDFAnnotation;

/// Represents an annotation.
@interface PSPDFAnnotationCell : UITableViewCell

/// The annotation that will be displayed.
@property (nonatomic, strong) PSPDFAnnotation *annotation;

@end

@interface PSPDFAnnotationCell (SubclassingHooks)

/// Helper to get a image icon for an annotation
+ (UIImage *)imageForAnnotation:(PSPDFAnnotation *)annotation;

@end
