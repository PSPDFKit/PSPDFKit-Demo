//
//  PSPDFMultiDocumentThumbnailViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFThumbnailViewController.h"

/// Allows displaying thumbnails for multiple PSPDFDocuments.
@interface PSPDFMultiDocumentThumbnailViewController : PSPDFThumbnailViewController

/// Designated initializer.
- (id)initWithDocuments:(NSArray *)documents;

/// Documents that are currently loaded.
@property (nonatomic, copy) NSArray *documents;

/// Whether to show only the first page of each document, or all pages. Defaults to NO.
@property (nonatomic, assign) BOOL firstPageOnly;

@end
