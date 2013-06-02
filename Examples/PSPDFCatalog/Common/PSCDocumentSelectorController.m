//
//  PSCDocumentSelectorController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCDocumentSelectorController.h"
#import "PSCFullTextSearchOperation.h"
#import "PSCDocumentSelectorCell.h"
#import <objc/message.h>

#define kPSCAllowStickySearchBar

@interface PSCDocumentSelectorController () <PSPDFCacheDelegate, PSCFullTextSearchOperationDelegate> {
    NSOperationQueue *_fullTextSearchQueue;
    UISearchDisplayController *_searchDisplayController;
    NSMutableArray *_filteredDocuments;
    NSMutableDictionary *_deletableFileStatus;
}
@property (nonatomic, copy) NSString *directory;
@property (nonatomic, copy) NSArray *filteredDocuments;
@property (nonatomic, copy) NSArray *sections;
// save state during view reloads
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic, assign) NSInteger savedScopeButtonIndex;
@property (nonatomic, assign) BOOL searchWasActive;
@property (nonatomic, strong) UISearchBar *searchBar;
@end

#define kPSCThumbnailSize CGSizeMake(44.f, 80.f)

@implementation PSCDocumentSelectorController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDirectory:(NSString *)directory delegate:(id<PSCDocumentSelectorControllerDelegate>)delegate {
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        self.contentSizeForViewInPopover = CGSizeMake(320.f, 600.f);

        // resolve directory, default to Documents if no name token is issued.
        _directory = PSPDFResolvePathNames(directory, [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]);
        self.title = [_directory lastPathComponent];
        self.navigationItem.rightBarButtonItem = self.editButtonItem;

        _delegate = delegate;
        _documents = [self.class documentsFromDirectory:_directory];
        _filteredDocuments = [NSMutableArray new];
        _deletableFileStatus = [NSMutableDictionary new];
        [[PSPDFCache sharedCache] addDelegate:self];

        _showSectionIndexes = YES;
        [self updateSections];

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

#ifdef kPSCAllowStickySearchBar
- (void)loadView {
    [super loadView];

    if (self.stickySearchBar) {
        /*
         For this scrolling behavior it is *essential* that the view controller is a subclass of UIViewController instead of UITableViewController, because UISearchDisplayController adds the dimming view to the searchContentsController's view and because UITableViewController's view is the table view, the dimming view is added to the table view and is only visible when the table view is scrolled to the top. If you can't change the superclass to UIViewController, you'll have to manually set the dimming view's frame by iterating through the table view's view hierarchy when the search begins which is very ugly.
         */
        UITableView *tableView = self.tableView;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.view = [[UIView alloc] initWithFrame:self.view.bounds];
        tableView.frame = self.view.bounds;
        [self.view addSubview:tableView];
    }
}

- (UITableView *)tableView {
    if ([super.tableView isKindOfClass:UITableView.class]) {
        return super.tableView;
    }else for(UIView *view in self.view.subviews) {
        if ([view isKindOfClass:UITableView.class]) return (UITableView *)view;
    }
    return nil;
}
#endif

- (void)viewDidLoad {
    [super viewDidLoad];

    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.bounds.size.width, 44.f)];
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.tableView.tableHeaderView = _searchBar;

    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDisplayController.delegate = self;
    _searchDisplayController.searchResultsDataSource = self;
    _searchDisplayController.searchResultsDelegate = self;

    // Restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm) {
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:self.savedSearchTerm];

        self.savedSearchTerm = nil;
    }

    /*
     The exact same behavior as the contacts app is only possible with using private API. Without using private API the section index control on the right of the table won't overlap the search bar.
     Choose for yourself if you want to use private API in the App Store or not. This code will degrade gracefully if the selector ever changes. (Thus, in the worst case the search bar no longer pins to the header)
     Obfustacting the string with using stringWithFormat is enough to pass the detection systems of the App Store, at least for now.
     Thanks to Fabian Kreiser for his great sample code: https://github.com/fabiankr/TableViewSearchBar
     */
#ifdef kPSCAllowStickySearchBar
    if (self.stickySearchBar) {
        SEL setPinsTableHeaderViewSelector = NSSelectorFromString([NSString stringWithFormat:@"%@set%@leHeaderView:", @"_", @"PinsTab"]);
        if ([self.tableView respondsToSelector:setPinsTableHeaderViewSelector]) {
            ((void(*)(id, SEL, BOOL))objc_msgSend)(self.tableView, setPinsTableHeaderViewSelector, YES);
        }
    }
#endif

    // Reload the table
    [self.tableView reloadData];
    self.tableView.scrollEnabled = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    // save the state of the search UI so that it can be restored if the view is re-created
    self.searchWasActive = self.searchDisplayController.isActive;
    self.savedSearchTerm = self.searchDisplayController.searchBar.text;
    self.savedScopeButtonIndex = self.searchDisplayController.searchBar.selectedScopeButtonIndex;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return PSIsIpad() ? YES : toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)setDocuments:(NSArray *)documents {
    if (documents != _documents) {
        _documents = [documents copy];
        [self updateSections];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Static

+ (NSArray *)documentsFromDirectory:(NSString *)directory {
    PSPDFAssert(directory);

    directory = PSPDFResolvePathNames(directory, [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]);

    NSError *error = nil;
    NSArray *documentContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:&error];

    NSMutableArray *folders = [NSMutableArray array];
    for (NSString *folder in documentContents) {
        // check if target path is a directory (all magazines are in directories)
        NSString *fullPath = [directory stringByAppendingPathComponent:folder];
        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir]) {
            if (!isDir && [[fullPath lowercaseString] hasSuffix:@"pdf"]) {
                PSPDFDocument *document = [PSPDFDocument documentWithURL:[NSURL fileURLWithPath:fullPath isDirectory:NO]];
                document.aspectRatioEqual = NO; // let them calculate!
                [folders addObject:document];
            }
        }
    }
    return [folders copy];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (SEL)titleSelector {
    return self.useDocumentTitles ? @selector(title) : @selector(fileName);
}

- (void)updateSections {
    if (_showSectionIndexes) {
        UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];

        SEL titleSelector = self.titleSelector;
        NSMutableArray *unsortedSections = [[NSMutableArray alloc] initWithCapacity:[[collation sectionTitles] count]];
        for (NSUInteger i = 0; i < [[collation sectionTitles] count]; i++) {
            [unsortedSections addObject:[NSMutableArray array]];
        }
        for (PSPDFDocument *document in self.documents) {
            NSInteger index = [collation sectionForObject:document collationStringSelector:titleSelector];
            [unsortedSections[index] addObject:document];
        }
        NSMutableArray *sortedSections = [[NSMutableArray alloc] initWithCapacity:unsortedSections.count];
        for (NSMutableArray *section in unsortedSections) {
            [sortedSections addObject:[collation sortedArrayFromArray:section collationStringSelector:titleSelector]];
        }

        self.sections = sortedSections;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource

- (PSPDFDocument *)documentForIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView {
    PSPDFDocument *document;
    if (tableView == self.tableView) {
        if (self.showSectionIndexes) {
            document = (self.sections)[indexPath.section][indexPath.row];
        } else {
            document = (self.documents)[indexPath.row];
        }
    } else {
        document = (self.filteredDocuments)[indexPath.row];
    }
    return document;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        if (self.showSectionIndexes) {
            return [(self.sections)[section] count];
        } else {
            return self.documents.count;
        }
    } else {
        return self.filteredDocuments.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PSCDocumentSelectorCell";

    PSCDocumentSelectorCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[PSCDocumentSelectorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    PSPDFDocument *document = [self documentForIndexPath:indexPath inTableView:tableView];
    // performSelector generates a warning.
    cell.textLabel.text = ((NSString*(*)(id, SEL))objc_msgSend)(document, self.titleSelector);
    cell.pagePreviewImage = [PSPDFCache.sharedCache imageFromDocument:document andPage:0 withSize:kPSCThumbnailSize options:PSPDFCacheOptionDiskLoadSync|PSPDFCacheOptionSizeAllowLargerScaleAsync|PSPDFCacheOptionMemoryStoreAlways|PSPDFCacheOptionActualityIgnore];
    cell.document = document; // For reference only

    return cell;
}

// Cache status.
- (BOOL)isDeletableFileAtPath:(NSString *)path {
    if (!path) return NO;

    NSNumber *deletable = _deletableFileStatus[path];
    if (!deletable) {
        BOOL isDeletable = [NSFileManager.defaultManager isDeletableFileAtPath:path];
        deletable = @(isDeletable);
        _deletableFileStatus[path] = deletable;
    }
    return deletable.boolValue;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    PSPDFDocument *document = nil;

    // Don't allow delete in search mode.
    if (tableView == self.tableView) {
        document = self.documents[indexPath.row];
    }

    return [self isDeletableFileAtPath:[document.fileURL.path stringByDeletingLastPathComponent]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (tableView == self.tableView) {

            PSPDFDocument *document = [self documentForIndexPath:indexPath inTableView:tableView];

            // If the document is within the bundle, deletion will fail.
            NSError *error = nil;
            if (![[NSFileManager defaultManager] removeItemAtPath:[document.fileURL path] error:&error]) {
                NSLog(@"Deletion failed: %@",[error localizedDescription]);
            }

            // Update internal data structures and UI.
            NSMutableArray *documents = [self.documents mutableCopy];
            [documents removeObjectAtIndex:indexPath.row];
            self.documents = documents;

            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.tableView && self.showSectionIndexes) {
        return [@[UITableViewIndexSearch] arrayByAddingObjectsFromArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    } else {
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView && self.showSectionIndexes) {
        if ([(self.sections)[section] count] > 0) {
            return [[UILocalizedIndexedCollation currentCollation] sectionTitles][section];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (void)scrollTableViewToSearchBarAnimated:(BOOL)animated {
    if (self.stickySearchBar) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:animated];
    }else {
        [self.tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:animated];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if ([title isEqualToString:UITableViewIndexSearch]) {
        [self scrollTableViewToSearchBarAnimated:NO];
        return NSNotFound;
    } else {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] - 1; // -1 because we add the search symbol
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        if (self.showSectionIndexes) {
            return self.sections.count;
        } else {
            return 1;
        }
    } else {
        return 1;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Pressed index %d.", indexPath.row);

    PSPDFDocument *document = [self documentForIndexPath:indexPath inTableView:tableView];
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

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Content Filtering

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    [_filteredDocuments removeAllObjects]; // First clear the filtered array.

    // ignore scope.
    if ([searchText length]) {
        // Getting the title can be quite expensive, so only use it if that one is already loaded.
        NSString *predicate = [NSString stringWithFormat:@"(isTitleLoaded == 1 && title CONTAINS[cd] '%@') || fileURL.path CONTAINS[cd] '%@'", searchText, searchText];
        NSArray *filteredContent = [_documents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicate]];
        [_filteredDocuments addObjectsFromArray:filteredContent];

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
                            [_filteredDocuments removeAllObjects];
                            [_filteredDocuments addObjectsFromArray:results];
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
        [_filteredDocuments removeAllObjects];
        [_filteredDocuments addObjectsFromArray:results];
        [self.searchDisplayController.searchResultsTableView reloadData];
    });
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFCacheDelegate

- (void)didCacheImage:(UIImage *)image fromDocument:(PSPDFDocument *)document andPage:(NSUInteger)page withSize:(CGSize)size {
    if (page == 0 && PSPDFSizeAspectRatioEqualToSize(kPSCThumbnailSize, size)) {
        // Gather all cells,
        NSMutableArray *cells = [self.tableView.visibleCells mutableCopy];
        if (self.searchDisplayController.searchResultsTableView.visibleCells) {
            [cells addObjectsFromArray:self.searchDisplayController.searchResultsTableView.visibleCells];
        }
        // Check cells against document match.
        for (PSCDocumentSelectorCell *cell in cells) {
            if ([cell isKindOfClass:PSCDocumentSelectorCell.class]) {
                if (cell.document == document) {
                    [cell setPagePreviewImage:image animated:YES];
                }
            }
        }
    }
}

@end
