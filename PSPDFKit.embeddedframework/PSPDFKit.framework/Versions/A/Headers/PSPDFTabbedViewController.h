//
//  PSPDFTabbedViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFMultiDocumentViewController.h"
#import "PSPDFTabBarView.h"

@class PSPDFTabbedViewController, PSPDFTabBarView;

/// Delegate for the PSPDFTabbedViewController.
@protocol PSPDFTabbedViewControllerDelegate <PSPDFMultiDocumentViewControllerDelegate>
@optional

/// Will be called when the documents array changes.
- (BOOL)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController shouldChangeDocuments:(NSArray *)newDocuments;

/// Will be called after the documents array changed.
- (void)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController didChangeDocuments:(NSArray *)oldDocuments;

/// Will be called when the visibleDocument changes.
- (BOOL)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController shouldChangeVisibleDocument:(PSPDFDocument *)newDocument;

/// Will be called after the visibleDocument changed.
- (void)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController didChangeVisibleDocument:(PSPDFDocument *)oldDocument;

/// Delegate that will be called after shouldChangeDocuments if the close button has been invoked.
- (BOOL)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController shouldCloseDocument:(PSPDFDocument *)closedDocument;

/// Delegate that will be called after didChangeDocuments if the close button has been invoked.
- (void)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController didCloseDocument:(PSPDFDocument *)closedDocument;

@end

/// Allows displaying multiple PSPDFDocuments, easily switchable via a top tab bar.
@interface PSPDFTabbedViewController : PSPDFMultiDocumentViewController <PSPDFTabBarViewDelegate, PSPDFTabBarViewDataSource>

/// Initialize the controller.
/// Set a custom pdfViewController to use a subclass. If nil, a default instance will be created.
- (id)initWithPDFViewController:(PSPDFViewController *)pdfController;

/// Add one or multiple documents to the documents array at the specified index.
/// Documents that are already within documents (or are equal to those) are ignored.
/// If index is invalid or NSUIntegerMax they're appended at the end.
/// @note Animated is a placeholder, doesn't yet animate.
- (void)addDocuments:(NSArray *)documents atIndex:(NSUInteger)index animated:(BOOL)animated;

/// Removes one or multiple documents to the documents array.
/// Documents that are not in the documents array will be ignored.
/// @note Animated is a placeholder, doesn't yet animate.
- (void)removeDocuments:(NSArray *)documents animated:(BOOL)animated;

/// Delegate to capture events.
@property (nonatomic, weak) IBOutlet id<PSPDFTabbedViewControllerDelegate> delegate;

/// Defaults to kPSPDFTabbedDocumentsPersistKey.
/// Change if you use multiple instances of PSPDFTabbedViewController.
@property (nonatomic, copy) NSString *statePersistenceKey;

/// Minimum tab width. Defaults to 100.
@property (nonatomic, assign) CGFloat minTabWidth;

/// Enabled by default. Will create a new tab entry for PDF actions that open an external file.
@property (nonatomic, assign) BOOL openDocumentActionInNewTab;

/// Tab bar view.
@property (nonatomic, strong, readonly) PSPDFTabBarView *tabBar;

@end
