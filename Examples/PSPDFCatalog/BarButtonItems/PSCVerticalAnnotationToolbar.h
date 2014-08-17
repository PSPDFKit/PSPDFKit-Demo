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

- (instancetype)initWithAnnotationStateManager:(PSPDFAnnotationStateManager *)annotationStateManager NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong) PSPDFAnnotationStateManager *annotationStateManager;

@end
