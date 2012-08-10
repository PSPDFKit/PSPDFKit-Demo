//
//  PSCDocumentSelectorController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSCDocumentSelectorController.h"

@interface PSCDocumentSelectorController () <PSPDFCacheDelegate> {
    UISearchDisplayController *_searchDisplayController;
    UISearchBar *_searchBar;
    NSArray *_content;
    NSMutableArray *_filteredContent;
}
// save state during view reloads
@property(nonatomic, copy) NSString *savedSearchTerm;
@property(nonatomic, assign) NSInteger savedScopeButtonIndex;
@property(nonatomic, assign) BOOL searchWasActive;
@end

@implementation PSCDocumentSelectorController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDelegate:(id<PSCDocumentSelectorControllerDelegate>)delegate {
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        self.contentSizeForViewInPopover = CGSizeMake(320.f, 600.f);
        self.title = NSLocalizedString(@"Files", @"");

        _delegate = delegate;
        _content = [[[self class] documentsFromDirectory:@"Samples"] copy];
        _filteredContent = [NSMutableArray new];
        [[PSPDFCache sharedCache] addDelegate:self];
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

+ (NSArray *)documentsFromDirectory:(NSString *)directoryName {
    NSMutableArray *folders = [NSMutableArray array];

    NSError *error = nil;
    NSString *sampleFolder = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:directoryName];
    NSArray *documentContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sampleFolder error:&error];

    for (NSString *folder in documentContents) {
        // check if target path is a directory (all magazines are in directories)
        NSString *fullPath = [sampleFolder stringByAppendingPathComponent:folder];
        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir]) {
            if (!isDir && [[fullPath lowercaseString] hasSuffix:@"pdf"]) {
                PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[NSURL fileURLWithPath:fullPath isDirectory:NO]];
                document.aspectRatioEqual = NO; // let them calculate!
                [folders addObject:document];
            }
        }
    }
    return folders;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_filteredContent count];
    }
	else {
        return [_content count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PSPDFDocumentSelectorCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    PSPDFDocument *document;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        document = [_filteredContent objectAtIndex:indexPath.row];
    }
	else {
        document = [_content objectAtIndex:indexPath.row];
    }

    cell.textLabel.text = document.title;
    cell.imageView.image = [[PSPDFCache sharedCache] cachedImageForDocument:document page:0 size:PSPDFSizeTiny];

    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"pressed index %d", indexPath.row);

    PSPDFDocument *document;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        document = [_filteredContent objectAtIndex:indexPath.row];
    }else {
        document = [_content objectAtIndex:indexPath.row];
    }
    [_delegate documentSelectorController:self didSelectDocument:document];

    // hide controller
    if (PSIsIpad()) {
        [PSPDFBarButtonItem dismissPopoverAnimated:YES];
    }else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UISearchDisplayController

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {

    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];

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
        NSString *predicate = [NSString stringWithFormat:@"title CONTAINS[cd] '%@' || fileURL.path CONTAINS[cd] '%@'", searchText, searchText];
        NSArray *filteredContent = [_content filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicate]];
        [_filteredContent addObjectsFromArray:filteredContent];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFCacheDelegate

- (void)didCachePageForDocument:(PSPDFDocument *)document page:(NSUInteger)page image:(UIImage *)cachedImage size:(PSPDFSize)size {
    if (size == PSPDFSizeTiny && page == 0 && cachedImage) {
        for (PSPDFDocument *aDocument in _content) {
            if (document == aDocument) {
                NSUInteger index = [_content indexOfObject:document];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];

                //  also update the search table view
                if ([_filteredContent count]) {
                    NSUInteger searchIndex = [_filteredContent indexOfObject:document];
                    [self.searchDisplayController.searchResultsTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:searchIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                }
                break;
            }
        }
    }
}

@end
