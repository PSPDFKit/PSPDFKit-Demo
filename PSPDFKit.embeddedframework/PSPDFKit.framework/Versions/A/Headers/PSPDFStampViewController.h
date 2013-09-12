//
//  PSPDFStampViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAnnotationGridViewController.h"
#import "PSPDFTextStampViewController.h"

@class PSPDFStampViewController, PSPDFStampAnnotation;

/// Allows adding signatures or drawings as ink annotations.
@interface PSPDFStampViewController : PSPDFAnnotationGridViewController <PSPDFAnnotationGridViewControllerDataSource, PSPDFTextStampViewControllerDelegate>

/// Return default available set of stamp annotations.
+ (NSArray *)defaultStampAnnotations;

/// Allows to set a different set of default annotations. Thread safe.
/// Setting `defaultStampAnnotations` will restore the default set of stamp annotations.
+ (void)setDefaultStampAnnotations:(NSArray *)defaultStampAnnotations;

/// Designated initializer.
- (id)initWithDelegate:(id<PSPDFAnnotationGridViewControllerDelegate>)delegate;

/// Available stamp types. Set before showing controller.
@property (nonatomic, copy) NSArray *stamps;

/// Adds a special stamp that forwards to an interface (PSPDFTextStampViewController) where custom stamps can be created. Defaults to YES.
@property (nonatomic, assign) BOOL customStampEnabled;

@end
