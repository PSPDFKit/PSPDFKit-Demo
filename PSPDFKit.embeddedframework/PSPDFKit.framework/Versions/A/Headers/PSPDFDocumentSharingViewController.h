//
//  PSPDFDocumentSharingViewController.h
//  PSPDFKit
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFStaticTableViewController.h"
#import "PSPDFStyleable.h"
#import "PSPDFOverridable.h"

@class PSPDFDocument;

typedef NS_OPTIONS(NSUInteger, PSPDFDocumentSharingOptions) {
    PSPDFDocumentSharingOptionCurrentPageOnly              = 1<<0, // Only page set in .page of PSPDFViewController.
    PSPDFDocumentSharingOptionVisiblePages                 = 1<<1, // All visible pages. (ignored if only one visible)
    PSPDFDocumentSharingOptionAllPages                     = 1<<2, // Send whole document.

    PSPDFDocumentSharingOptionEmbedAnnotations             = 1<<3, // Save annotations in the PDF.
    PSPDFDocumentSharingOptionFlattenAnnotations           = 1<<4, // Render annotations into the PDF.
    PSPDFDocumentSharingOptionAnnotationsSummary           = 1<<5, // Save annotations + add summary.
    PSPDFDocumentSharingOptionRemoveAnnotations            = 1<<6, // Remove all annotations.

    PSPDFDocumentSharingOptionOfferMergeFiles              = 1<<8, // Allow to choose between multiple files or merging.
    PSPDFDocumentSharingOptionForceMergeFiles              = 2<<8, // Forces file merging.
};

@class PSPDFDocumentSharingViewController;

/// The delegate for the PSPDFDocumentSharingViewController.
@protocol PSPDFDocumentSharingViewControllerDelegate <PSPDFOverridable>

/// Content has been prepared.
/// `resultingObjects` can either be NSURL or NSData.
- (void)documentSharingViewController:(PSPDFDocumentSharingViewController *)shareController didFinishWithSelectedOptions:(PSPDFDocumentSharingOptions)selectedSharingOption resultingObjects:(NSArray *)resultingObjects fileNames:(NSArray *)fileNames annotationSummary:(NSString *)annotationSummary error:(NSError *)error;

@optional

/// Controller has been cancelled.
- (void)documentSharingViewControllerDidCancel:(PSPDFDocumentSharingViewController *)shareController;

/// Commit button has been pressed. Content will be prepared now, unless you implement this delegate and return NO here.
- (BOOL)documentSharingViewController:(PSPDFDocumentSharingViewController *)shareController shouldPrepareWithSelectedOptions:(PSPDFDocumentSharingOptions)selectedSharingOption selectedPages:(NSIndexSet *)selectedPages;

@end

/// Shows an interface to select the way the PDF should be exported.
@interface PSPDFDocumentSharingViewController : PSPDFStaticTableViewController <PSPDFStyleable>

/// Initialize with a `document` and optionally `visiblePages`.
/// `completionHandler` will be called if the user selects an option. Will not be called in case of cancellation.
- (id)initWithDocument:(PSPDFDocument *)document visiblePages:(NSOrderedSet *)visiblePages allowedSharingOptions:(PSPDFDocumentSharingOptions)sharingOptions delegate:(id <PSPDFDocumentSharingViewControllerDelegate>)delegate;

/// The current document.
@property (nonatomic, strong, readonly) PSPDFDocument *document;

/// The currently visible page numbers. Can be nil.
/// @warning Modify before the view is loaded.
@property (nonatomic, copy) NSOrderedSet *visiblePages;

/// The active sharing option combinations, as numbers in an ordered set.
/// @warning Modify before the view is loaded.
@property (nonatomic, assign) PSPDFDocumentSharingOptions sharingOptions;

/// Button title for "commit".
@property (nonatomic, copy) NSString *commitButtonTitle;

/// The document sharing controller delegate.
@property (nonatomic, weak) id <PSPDFDocumentSharingViewControllerDelegate> delegate;

// PSPDFStyleable attribute.
@property (nonatomic, assign) BOOL isInPopover;

@end

@interface PSPDFDocumentSharingViewController (SubclassingHooks)

// Generates an annotation summary for all `pages` in `document`.
+ (NSString *)annotationSummaryForDocument:(PSPDFDocument *)document pages:(NSIndexSet *)pages;

@end
