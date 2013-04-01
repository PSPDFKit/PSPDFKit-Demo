//
//  PSPDFAnnotationCell.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
@class  PSPDFAnnotation;

/// Represents an annotation.
@interface PSPDFAnnotationCell : UITableViewCell

/// The annotation that will be displayed.
@property (nonatomic, strong) PSPDFAnnotation *annotation;

@end

@interface PSPDFAnnotationCell (SubclassingHooks)

/// Helper to get a image icon for an annotation
+ (UIImage *)imageForAnnotation:(PSPDFAnnotation *)annotation;

@end
