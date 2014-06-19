//
//  PSCVerticalAnnotationToolbar.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

// Example how to add a always-visible vertical toolbar
@interface PSCVerticalAnnotationToolbar : UIView

- (id)initWithAnnotationStateManager:(PSPDFAnnotationStateManager *)annotationStateManager;

@property (nonatomic, strong) PSPDFAnnotationStateManager *annotationStateManager;

@end
