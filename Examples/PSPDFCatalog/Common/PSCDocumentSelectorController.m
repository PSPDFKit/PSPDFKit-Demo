//
//  PSCDocumentSelectorController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSCDocumentSelectorController.h"
#import "PSCFullTextSearchOperation.h"

@interface PSCDocumentSelectorController () <PSPDFCacheDelegate, PSCFullTextSearchOperationDelegate> {
    NSOperationQueue *_fullTextSearchQueue;
    UISearchDisplayController *_searchDisplayController;
    UISearchBar *_searchBar;
    NSMutableArray *_documents;
    NSMutableArray *_filteredContent;
}
@property (nonatomic, copy) NSString *directory;
// save state during view reloads
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic, assign) NSInteger savedScopeButtonIndex;
@property (nonatomic, assign) BOOL searchWasActive;
@end

@implementation PSCDocumentSelectorController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDirectory:(NSString *)directory delegate:(id<PSCDocumentSelectorControllerDelegate>)delegate {
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        self.contentSizeForViewInPopover = CGSizeMake(320.f, 600.f);

        // resolve directory, default to Documents if no name token is issued.
        _directory = PSPDFResolvePathNames(directory, [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) ps_firstObject]);
        self.title = [_directory lastPathComponent];
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        
        _delegate = delegate;
        _documents = [[self.class documentsFromDirectory:_directory] mutableCopy];
        _filteredContent = [NSMutableArray new];
        [[PSPDFCache sharedCache] addDelegate:self];

        // set up FTS queue
        _fullTextSearchQueue = [NSOperationQueue new];
        [_fullTextSearchQueue setName:@"PSCFullTextSearchQueue"];
        [_fullTextSearchQueue setMaxConcurrentOperationCount:1];
    }
    return self;
}

- (void)dealloc {
    _searchDisplayController.delegate = nil;
    _searchDisplayController.searchResultsDelegate = nil;
    _searchDisplayController.searchResultsDataSource = nil;
    [[PSPDFCache sharedCache] removeDelegate:self];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.tableView.tableHeaderView = _searchBar;
    
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDisplayController.delegate = self;
    _searchDisplayController.searchResultsDataSource = self;
    _searchDisplayController.searchResultsDelegate = self;
    
    // restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm) {
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:self.savedSearchTerm];

        self.savedSearchTerm = nil;
    }

    // as of Apple's example code
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    // save the state of the search UI so that it can be restored if the view is re-created
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return PSIsIpad() ? YES : toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Static

+ (NSArray *)documentsFromDirectory:(NSString *)directory {
    NSParameterAssert(directory);

    directory = PSPDFResolvePathNames(directory, [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) ps_firstObject]);

    NSError *error = nil;
    NSArray *documentContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:&error];

    NSMutableArray *folders = [NSMutableArray array];
    for (NSString *folder in documentContents) {
        // check if target path is a directory (all magazines are in directories)
        NSString *fullPath = [directory stringByAppendingPathComponent:folder];
        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir]) {
            if (!isDir && [[fullPath lowercaseString] hasSuffix:@"pdf"]) {
                PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[NSURL fileURLWithPath:fullPath isDirectory:NO]];
                document.aspectRatioEqual = NO; // let them calculate!
                [folders addObject:document];
            }
        }
    }
    return [folders copy];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_filteredContent count];
    }
	else {
        return [_documents count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PSPDFDocumentSelectorCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    PSPDFDocument *document;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        document = _filteredContent[indexPath.row];
    }
	else {
        document = _documents[indexPath.row];
    }

    cell.textLabel.text = document.title;
    cell.imageView.image = [[PSPDFCache sharedCache] cachedImageForDocument:document page:0 size:PSPDFSizeTiny];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    PSPDFDocument *document = nil;

    // don't allow delete in search mode
    if (tableView != self.searchDisplayController.searchResultsTableView) {
        document = _documents[indexPath.row];
    }

    return [[NSFileManager defaultManager] isDeletableFileAtPath:[[document.fileURL path] stringByDeletingLastPathComponent]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (tableView != self.searchDisplayController.searchResultsTableView) {

            PSPDFDocument *document = _documents[indexPath.row];
            NSError *error = nil;
            if (![[NSFileManager defaultManager] removeItemAtPath:[document.fileURL path] error:&error]) {
                NSLog(@"Deletion failed: %@",[error localizedDescription]);
            }

            // update internal data strucures and UI.
            [_documents removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"pressed index %d", indexPath.row);

    PSPDFDocument *document;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        document = _filteredContent[indexPath.row];
    }else {
        document = _documents[indexPath.row];
    }
    [_delegate documentSelectorController:self didSelectDocument:document];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UISearchDisplayController

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {

    [self filterContentForSearchText:searchString scope:
     [self.searchDisplayController.searchBar scopeButtonTitles][[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];

    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

/*
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];

    // Return YES to cause the search result table view to be reloaded.
    return YES;
}*/

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Content Filtering

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
	[_filteredContent removeAllObjects]; // First clear the filtered array.

    // ignore scope
    if ([searchText length]) {

        // problem is, getting the title is SLOW.
        NSString *predicate = [NSString stringWithFormat:@"title CONTAINS[cd] '%@' || fileURL.path CONTAINS[cd] '%@'", searchText, searchText];
        NSArray *filteredContent = [_documents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicate]];
        [_filteredContent addObjectsFromArray:filteredContent];

        if (self.fullTextSearchEnabled) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [_fullTextSearchQueue cancelAllOperations];
                PSCFullTextSearchOperation *operation = [[PSCFullTextSearchOperation alloc] initWithDocuments:self.documents searchTerm:searchText];
                operation.delegate = self;
                __weak PSCFullTextSearchOperation *weakOperation = operation;
                [operation setCompletionBlock:^{
                    PSCFullTextSearchOperation *strongOperation = weakOperation;
                    if (!strongOperation.isCancelled) {
                        NSArray *results = strongOperation.results;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_filteredContent removeAllObjects];
                            [_filteredContent addObjectsFromArray:results];
                            [self.searchDisplayController.searchResultsTableView reloadData];
                        });
                    }
                }];
                [_fullTextSearchQueue addOperation:operation];
            });
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCFullTextSearchOperationDelegate

- (void)fullTextSearchOperationDidUpdateResults:(PSCFullTextSearchOperation *)operation {
    NSArray *results = operation.results;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_filteredContent removeAllObjects];
        [_filteredContent addObjectsFromArray:results];
        [self.searchDisplayController.searchResultsTableView reloadData];
    });
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFCacheDelegate

- (void)didCachePageForDocument:(PSPDFDocument *)document page:(NSUInteger)page image:(UIImage *)cachedImage size:(PSPDFSize)size {
    if (size == PSPDFSizeTiny && page == 0 && cachedImage) {
        for (PSPDFDocument *aDocument in _documents) {
            if (document == aDocument) {
                NSUInteger index = [_documents indexOfObject:document];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];

                //  also update the search table view
                if ([_filteredContent count]) {
                    NSUInteger searchIndex = [_filteredContent indexOfObject:document];
                    [self.searchDisplayController.searchResultsTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:searchIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                }
                break;
            }
        }
    }
}

@end
