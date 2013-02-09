//
//  PSCFullTextSearchOperation.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSCFullTextSearchOperation.h"

@interface PSCFullTextSearchOperation() <PSPDFTextSearchDelegate> {
    dispatch_semaphore_t _searchBlockSemaphore;
    NSMutableOrderedSet *_internalResults;
}
@property (nonatomic, copy) NSArray *documents;
@property (nonatomic, copy) NSString *searchTerm;
@property (nonatomic, copy) NSArray *results;
@end

@implementation PSCFullTextSearchOperation

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDocuments:(NSArray *)documents searchTerm:(NSString *)searchTerm {
    if ((self = [super init])) {
        _documents = documents;
        _searchTerm = [searchTerm copy];
        _internalResults = [NSMutableOrderedSet new];
        _searchBlockSemaphore = dispatch_semaphore_create(0);
    }
    return self;
}

- (void)dealloc {
    PSPDFDispatchRelease(_searchBlockSemaphore);
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

// thread entry point
- (void)main {
    for (PSPDFDocument *document in self.documents) {
        @autoreleasepool {
            if (self.isCancelled) break;

            // create extra textSearch class so we don't interfere with delegates
            PSPDFTextSearch *textSearch = [document.textSearch copy];
            textSearch.delegate = self;

            // because of the semaphore we need to call this from another thread.
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [textSearch searchForString:self.searchTerm];
            });

            dispatch_semaphore_wait(_searchBlockSemaphore, DISPATCH_TIME_FOREVER); // wait until completion.
            textSearch.delegate = nil; // just do be safe
            [document clearCache]; // else we will eventually run out of memory
        }
    }

    self.results = [[_internalResults array] copy];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFTextSearchDelegate

- (void)didUpdateSearch:(PSPDFTextSearch *)textSearch forTerm:(NSString *)searchTerm newSearchResults:(NSArray *)searchResults forPage:(NSUInteger)page {
    if ([searchResults count]) {
        //NSLog(@"found term in %@", textSearch.document);
        [_internalResults addObject:textSearch.document];

        // update results + notify delegate
        self.results = [[_internalResults array] copy];
        [self.delegate fullTextSearchOperationDidUpdateResults:self];

        // stop search in current document - we already found a result
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [textSearch cancelAllOperationsAndWait];
        });
        dispatch_semaphore_signal(_searchBlockSemaphore);
    }else if (self.isCancelled) {
        dispatch_semaphore_signal(_searchBlockSemaphore);
    }
}

- (void)willStartSearch:(PSPDFTextSearch *)textSearch forTerm:(NSString *)searchTerm isFullSearch:(BOOL)isFullSearch {
    NSLog(@"Full-Text search: looking in %@.", textSearch.document);
}

- (void)didFinishSearch:(PSPDFTextSearch *)textSearch forTerm:(NSString *)searchTerm searchResults:(NSArray *)searchResults isFullSearch:(BOOL)isFullSearch {
    dispatch_semaphore_signal(_searchBlockSemaphore);
}

- (void)didCancelSearch:(PSPDFTextSearch *)textSearch forTerm:(NSString *)searchTerm isFullSearch:(BOOL)isFullSearch {
    dispatch_semaphore_signal(_searchBlockSemaphore);
}

@end
