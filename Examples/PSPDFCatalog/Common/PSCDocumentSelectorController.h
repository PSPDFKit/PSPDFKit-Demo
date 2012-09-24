//
//  PSCDocumentSelectorController.h
//  PSPDFCatalog
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

@class PSCDocumentSelectorController;
@class PSPDFDocument;

@protocol PSCDocumentSelectorControllerDelegate <NSObject>

- (void)documentSelectorController:(PSCDocumentSelectorController *)controller didSelectDocument:(PSPDFDocument *)document;

@end

/// Shows all documents available in the Sample directory.
@interface PSCDocumentSelectorController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>

/// Returns an array of PSPDFDocument's found in the "directoryName" directory.
+ (NSArray *)documentsFromDirectory:(NSString *)directoryName;

/// Designated initializer.
- (id)initWithDelegate:(id<PSCDocumentSelectorControllerDelegate>)delegate;

/// Delegate to get the didSelect event.
@property (nonatomic, ps_weak) id<PSCDocumentSelectorControllerDelegate> delegate;

@property (nonatomic, strong, readonly) NSArray *content;

@end
