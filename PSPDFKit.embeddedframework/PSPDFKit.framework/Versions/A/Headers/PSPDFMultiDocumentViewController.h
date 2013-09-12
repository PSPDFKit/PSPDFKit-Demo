//
//  PSPDFMultiDocumentViewController.h
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
#import "PSPDFBaseViewController.h"
#import "PSPDFDocument.h"

@class PSPDFMultiDocumentViewController;

/// Delegate for the PSPDFMultiDocumentViewController.
@protocol PSPDFMultiDocumentViewControllerDelegate <NSObject>
@optional

/// Will be called when the documents array changes.
- (BOOL)multiPDFController:(PSPDFMultiDocumentViewController *)multiPDFController shouldChangeDocuments:(NSArray *)newDocuments;

/// Will be called after the documents array changed.
- (void)multiPDFController:(PSPDFMultiDocumentViewController *)multiPDFController didChangeDocuments:(NSArray *)oldDocuments;

/// Will be called when the visibleDocument changes.
- (BOOL)multiPDFController:(PSPDFMultiDocumentViewController *)multiPDFController shouldChangeVisibleDocument:(PSPDFDocument *)newDocument;

/// Will be called after the visibleDocument changed.
- (void)multiPDFController:(PSPDFMultiDocumentViewController *)multiPDFController didChangeVisibleDocument:(PSPDFDocument *)oldDocument;

@end

/// Allows displaying multiple PSPDFDocuments.
@interface PSPDFMultiDocumentViewController : PSPDFBaseViewController

/// Initialize the controller.
/// Set a custom pdfViewController to use a subclass. If nil, a default instance will be created.
- (id)initWithPDFViewController:(PSPDFViewController *)pdfController;

/// Currently visible document.
@property (nonatomic, strong) PSPDFDocument *visibleDocument;

/// Documents that are currently loaded.
@property (nonatomic, copy) NSArray *documents;

/// Add one or multiple documents to the documents array at the specified index.
/// Documents that are already within documents (or are equal to those) are ignored.
/// If index is invalid or NSUIntegerMax they're appended at the end.
- (void)addDocuments:(NSArray *)documents atIndex:(NSUInteger)index;

/// Removes one or multiple documents to the documents array.
/// Documents that are not in the documents array will be ignored.
- (void)removeDocuments:(NSArray *)documents;

/// Delegate to capture events.
@property (nonatomic, weak) IBOutlet id<PSPDFMultiDocumentViewControllerDelegate> delegate;

/// Set to YES to enable automatic state persisting. Will be saved to NSUserDefaults. Defaults to NO.
@property (nonatomic, assign) BOOL enableAutomaticStatePersistence;

/// Persists the state to NSUserDefaults.
- (void)persistState;

/// Restores state from NSUserDefaults. Returns YES on success.
/// Will set the visibleDocument that is saved in the state.
- (BOOL)restoreState;

/// Restores the state and merges with new documents. First document in the array will be visibleDocument.
- (BOOL)restoreStateAndMergeWithDocuments:(NSArray *)documents;

/// Defaults to kPSPDFMultiDocumentsPersistKey.
/// Change if you use multiple instances of PSPDFMultiDocumentViewController.
@property (nonatomic, copy) NSString *statePersistenceKey;

/// The embedded PDFViewController. Access to customize the properties.
@property (nonatomic, strong, readonly) PSPDFViewController *pdfController;

/// If YES, a tap on the right side of the last page in a document will move to the next document, a tap on the left side of the first page will move to the previous document. Defaults to NO.
/// @warning Only works if scrollOnTapPageEndEnabled is set to YES in the pdfController.
@property (nonatomic, assign) BOOL changeDocumentOnTapPageEndMargin;

/// Whether to show thumbnails only for the current document in thumbnail view mode, or for all documents. Defaults to YES.
@property (nonatomic, assign) BOOL multiDocumentThumbnails;

/// Whether to show the document title for the current document in the toolbar. Defaults to YES.
@property (nonatomic, assign) BOOL showTitle;

@end

@interface PSPDFMultiDocumentViewController (SubclassingHooks)

/// Override this initializer to allow all use cases (storyboard loading, etc)
- (void)commonInitWithPDFController:(PSPDFViewController *)pdfController NS_REQUIRES_SUPER;

// Prepares the controller to interact with the multi document container.
- (void)swizzlePDFController:(PSPDFViewController *)pdfController;

@end
