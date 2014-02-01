//
//  PSPDFHostingAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAnnotationView.h"
#import "PSPDFRenderQueue.h"

/// View that will render an annotation.
@interface PSPDFHostingAnnotationView : PSPDFAnnotationView <PSPDFRenderDelegate>

/// Image View that shows the rendered annotation.
@property (nonatomic, strong, readonly) UIImageView *annotationImageView;

/// If set to YES, the view will wait for calls to `enableAnnotationRendering` and `attachImage` from the `PSPDFPageView` until it shows content.
/// This prevents flickering, especially for transparent content. Defaults to YES.
@property (nonatomic, assign) BOOL shouldSyncRemovalFromSuperview;

@end
