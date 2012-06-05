//
//  PSPDFTabbedViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFBaseViewController.h"
#import "PSPDFDocument.h"

@class PSPDFTabbedViewController;

/// Delegate for the PSPDFTabbedViewController.
@protocol PSPDFTabbedViewControllerDelegate <NSObject>
@optional

/// Will be called when the documents array changes.
- (BOOL)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController willChangeDocuments:(NSArray *)newDocuments;

/// Will be called after the documents array changed.
- (void)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController didChangeDocuments:(NSArray *)oldDocuments;

/// Will be called when the visibleDocument changes.
- (BOOL)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController willChangeVisibleDocument:(PSPDFDocument *)newDocument;

/// Will be called after the visibleDocument changed.
- (void)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController didChangeVisibleDocument:(PSPDFDocument *)oldDocument;

@end

/// Allows displaying multiple PSPDFDocument's, easily switchable via a top tab bar. iOS5 only.
@interface PSPDFTabbedViewController : PSPDFBaseViewController

/// Initialize the controller.
/// Set a custom pdfViewController to use a subclass. If nil, a default instance will be created.
- (id)initWithPDFViewController:(PSPDFViewController *)pdfViewController;

/// Currently visible document.
@property(nonatomic, strong) PSPDFDocument *visibleDocument;

/// Documents that are currently loaded.
@property(nonatomic, strong) NSArray *documents;

/// Add one or multiple documents to the documents array at the specified index.
/// Documents that are already within documents (or are equal to those) are ignored.
/// If index is invalid or NSUIntegerMax they're appended at the end.
/// Note: animated is a placeholder, doesn't yet animate.
- (void)addDocuments:(NSArray *)documents atIndex:(NSUInteger)index animated:(BOOL)animated;

/// Removes one or multiple documents to the documents array.
/// Documents that are not in the documents array will be ignored.
/// Note: animated is a placeholder, doesn't yet animate.
- (void)removeDocuments:(NSArray *)documents animated:(BOOL)animated;

/// Delegate to capture events.
@property(nonatomic, ps_weak) id<PSPDFTabbedViewControllerDelegate> delegate;

/// Set to YES to enable automatic state persisting. Will be saved to NSUserDefaults. Defaults to NO.
@property(nonatomic, assign) BOOL enableAutomaticStatePersistance;

/// Persists the state to NSUserDefaults.
- (void)persistState;

/// Restores state from NSUserDefaults. Returns YES on success.
/// Will set the visibleDocument that is saved in the state.
- (BOOL)restoreState;

/// Restores the state and merges with new documents. First document in the array will be visibleDocument.
- (BOOL)restoreStateAndMergeWithDocuments:(NSArray *)documents;

/// Defaults to kPSPDFTabbedDocumentsPersistKey.
/// Change if you use multiple instances of PSPDFTabbedViewController.
@property(nonatomic, copy) NSString *statePersistanceKey;

/// The embedded PDFViewController. Access to customize the properties.
@property(nonatomic, strong, readonly) PSPDFViewController *pdfViewController;

@end
