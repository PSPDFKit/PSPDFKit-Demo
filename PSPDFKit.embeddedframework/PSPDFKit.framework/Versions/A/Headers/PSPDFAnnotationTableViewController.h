//
//  PSPDFAnnotationTableViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFEmptyTableViewController.h"
#import "PSPDFStyleable.h"

@class PSPDFDocument, PSPDFAnnotation, PSPDFAnnotationTableViewController;

/// Delegate for the PSPDFAnnotationTableViewController.
@protocol PSPDFAnnotationTableViewControllerDelegate <NSObject>

/// Will be called when the user touches an annotation cell.
- (void)annotationTableViewController:(PSPDFAnnotationTableViewController *)annotationController didSelectAnnotation:(PSPDFAnnotation *)annotation;

@end

// Needed to optimize animations in the PSPDFAnnotationCell.
const char kPPSPDFIsResizingAnnotationTableViewPopover;

/// Shows an overview of all annotations in the current document.
@interface PSPDFAnnotationTableViewController : PSPDFEmptyTableViewController <PSPDFStyleable>

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
