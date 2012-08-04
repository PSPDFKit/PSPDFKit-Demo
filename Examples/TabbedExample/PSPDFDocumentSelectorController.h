//
//  PSPDFDocumentSelectorController.h
//  TabbedExample
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

@class PSPDFDocumentSelectorController;
@class PSPDFDocument;

@protocol PSPDFDocumentSelectorControllerDelegate <NSObject>

- (void)documentSelectorController:(PSPDFDocumentSelectorController *)controller didSelectDocument:(PSPDFDocument *)document;

@end

/// Shows all documents available in the Sample directory.
@interface PSPDFDocumentSelectorController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>

/// Returns an array of PSPDFDocument's found in the "directoryName" directory.
+ (NSArray *)documentsFromDirectory:(NSString *)directoryName;

/// Delegate to get the didSelect event.
@property (nonatomic, weak) id<PSPDFDocumentSelectorControllerDelegate> delegate;

@end
