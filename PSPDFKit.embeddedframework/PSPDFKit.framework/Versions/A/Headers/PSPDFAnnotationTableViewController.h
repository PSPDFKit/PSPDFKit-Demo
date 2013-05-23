//
//  PSPDFAnnotationTableViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFStatefulTableViewController.h"
#import "PSPDFStyleable.h"

@class PSPDFDocument, PSPDFAnnotation, PSPDFAnnotationTableViewController;

/// Delegate for the PSPDFAnnotationTableViewController.
@protocol PSPDFAnnotationTableViewControllerDelegate <NSObject>

/// Will be called when the user touches an annotation cell.
- (void)annotationTableViewController:(PSPDFAnnotationTableViewController *)annotationController didSelectAnnotation:(PSPDFAnnotation *)annotation;

@end

// Needed to optimize animations in the PSPDFAnnotationCell.
extern const char kPSPDFIsResizingAnnotationTableViewPopover;

/// Shows an overview of all annotations in the current document.
@interface PSPDFAnnotationTableViewController : PSPDFStatefulTableViewController <PSPDFStyleable>

/// Designated initializer.
- (id)initWithDocument:(PSPDFDocument *)document delegate:(id<PSPDFAnnotationTableViewControllerDelegate>)delegate;

/// Attached PDF controller.
@property (nonatomic, weak) PSPDFDocument *document;

/// Set to filter custom annotations. By default this is nil, which means it uses the `editableAnnotationTypes' of the PSPDFDocument.
/// This set takes strings like PSPDFAnnotationTypeStringHighlight, PSPDFAnnotationTypeStringInk, ...
@property (nonatomic, copy) NSOrderedSet *visibleAnnotationTypes;

/// The delegate.
@property (nonatomic, weak) id<PSPDFAnnotationTableViewControllerDelegate> delegate;

@end

@interface PSPDFAnnotationTableViewController (SubclassingHooks)

/// Defaults to PSPDFAnnotationCell.class
@property (nonatomic, strong) Class cellClass;

@end
