//
//  PSPDFTabbedViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFBaseViewController.h"
#import "PSPDFDocument.h"

@class PSPDFTabbedViewController;

@protocol PSPDFTabbedViewControllerDelegate <NSObject>
@optional

- (BOOL)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController willChangeDocumentSet:(NSArray *)newDocuments;
- (void)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController didChangeDocumentSet:(NSArray *)oldDocuments;

- (BOOL)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController willChangeVisibleDocument:(PSPDFDocument *)newDocument;
- (void)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController didChangeVisibleDocument:(PSPDFDocument *)oldDocument;

@end

/// Allows displaying multiple PSPDFDocument's, easily switchable via a top tab bar. iOS5 only.
@interface PSPDFTabbedViewController : PSPDFBaseViewController

/// Initialize the controller with a bunch of documents.
/// Set a custom pdfViewController to use a subclass. If nil, a default instance will be created.
- (id)initWithDocuments:(NSArray *)documents pdfViewController:(PSPDFViewController *)pdfViewController;

/// Documents that are currently loaded.
@property(nonatomic, strong) NSArray *documents;

/// Currently visible document.
@property(nonatomic, strong) PSPDFDocument *visibleDocument;

/// Delegate to capture events.
@property(nonatomic, ps_weak) id<PSPDFTabbedViewControllerDelegate> delegate;

/// The embedded PDFViewController. Access to customize the properties.
@property(nonatomic, strong) PSPDFViewController *pdfViewController;

/// Set to YES to enable automatic state persisting. Will be saved to NSUserDefaults. Defaults to NO.
@property(nonatomic, assign) BOOL enableAutomaticStatePersistance;

/// Defaults to kPSPDFTabbedDocumentsPersistKey.
/// Change if you use multiple instances of PSPDFTabbedViewController.
@property(nonatomic, copy) NSString *statePersistanceKey;

/// Persists the state to NSUserDefaults.
- (void)persistState;

/// Restores state from NSUserDefaults. Returns YES on success.
- (BOOL)restoreState;

@end
