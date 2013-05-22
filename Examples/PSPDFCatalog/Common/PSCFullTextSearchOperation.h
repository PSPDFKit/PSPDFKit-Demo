//
//  PSCFullTextSearchOperation.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

@class PSCFullTextSearchOperation;

/// Full-Text Search delegate. Use completionBlock for the final update.
@protocol PSCFullTextSearchOperationDelegate <NSObject>

/// New search results have been added.
- (void)fullTextSearchOperationDidUpdateResults:(PSCFullTextSearchOperation *)operation;

@end

/// Sample operation how to perform full-text search across multiple documents.
/// Note that this WILL BE SLOW for many documents. I am working on a better solution.
/// (There's a reason why this is PSC* space and not in PSPDF)
@interface PSCFullTextSearchOperation : NSOperation

/// Designated initializer
- (id)initWithDocuments:(NSArray *)documents searchTerm:(NSString *)searchTerm;

/// Documents to search
@property (nonatomic, copy, readonly) NSArray *documents;

/// Search term.
@property (nonatomic, copy, readonly) NSString *searchTerm;

/// Operation delegate.
@property (atomic, weak) id<PSCFullTextSearchOperationDelegate> delegate;

/// Array of documents that match for a certain search term.
/// Access after operation has finished.
@property (nonatomic, copy, readonly) NSArray *results;

@end
