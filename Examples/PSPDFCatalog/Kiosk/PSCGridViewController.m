//
//  PSCGridController.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCGridViewController.h"
#import "PSCImageGridViewCell.h"
#import "PSCMagazine.h"
#import "PSCMagazineFolder.h"
#import "PSCKioskPDFViewController.h"
#import "PSCSettingsController.h"

#define _(string) NSLocalizedString(string, @"")
#define kPSCLargeThumbnailSize CGSizeMake(170.f, 240.f)

@interface PSCGridViewController() <UISearchBarDelegate, UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) BOOL immediatelyLoadCellImages; // UI tweak.
@property (nonatomic, assign) BOOL animationDoubleWithPageCurl;
@property (nonatomic, copy) NSArray *filteredData;

@property (nonatomic, strong) PSCMagazine *lastOpenedMagazine;
@property (nonatomic, strong) PSCMagazineFolder *magazineFolder;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIImage *coverImage;
@property (nonatomic, strong) UIImage *targetPageImage;
@property (nonatomic, assign) NSUInteger cellIndex;
@property (nonatomic, strong) UIImageView *magazineCoverView;
@property (nonatomic, strong) UIImageView *magazineCurrentPageView;
@end

@implementation PSCGridViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (instancetype)init {
    if ((self = [super init])) {
        self.title = _(@"PSPDFKit Kiosk Example");

        // custom back button for smaller wording
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:_(@"Kiosk") style:UIBarButtonItemStylePlain target:nil action:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(diskDataLoaded) name:PSCStoreDiskLoadFinishedNotification object:nil];
    }
    return self;
}

- (instancetype)initWithMagazineFolder:(PSCMagazineFolder *)aMagazineFolder {
    if ((self = [self init])) {
        self.title = aMagazineFolder.title;
        _magazineFolder = aMagazineFolder;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _searchBar.delegate = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.magazineFolder) {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }

#ifdef PSPDFCatalog
	UIBarButtonItem *optionButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] landscapeImagePhone:[UIImage imageNamed:@"settings-landscape"] style:UIBarButtonItemStylePlain target:self action:@selector(optionsButtonPressed)];

    // Only show the option button if we're at root (else we hide the back button).
    if ((self.navigationController.viewControllers)[0] == self) {
        self.navigationItem.leftBarButtonItem = optionButton;
    } else {
        self.navigationItem.leftBarButtonItem = optionButton;
        self.navigationItem.leftItemsSupplementBackButton = YES;
    }
#endif

	// Custom transition support
	self.navigationController.delegate = self;

    // Init the collection view
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];

    flowLayout.minimumLineSpacing = 30;
    NSUInteger spacing = 14;
    flowLayout.minimumInteritemSpacing = spacing;
    flowLayout.sectionInset = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);

    [collectionView registerClass:PSCImageGridViewCell.class forCellWithReuseIdentifier:NSStringFromClass(PSCImageGridViewCell.class)];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.collectionView = collectionView;

	[self.view addSubview:self.collectionView];
    self.collectionView.frame = CGRectIntegral(self.view.bounds);
    self.collectionView.dataSource = self; // auto-reloads

    // Add the search bar.
    CGFloat searchBarWidth = 290.f;
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectIntegral(CGRectMake((self.collectionView.bounds.size.width-searchBarWidth)/2, -44.f, searchBarWidth, 44.f))];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    searchBar.tintColor = UIColor.blackColor;
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.alpha = 0.5;
    searchBar.delegate = self;
    self.searchBar = searchBar;

    // Doesn't matter much if this fails, but the background doesn't look great within our grid.
    [PSCGetViewInsideView(searchBar, @"UISearchBarBack") removeFromSuperview];

    // Set the return key and keyboard appearance of the search bar.
    // Since we do live-filtering, the search bar should just dismiss the keyboard.
    for (UITextField *searchBarTextField in searchBar.subviews) {
        if ([searchBarTextField conformsToProtocol:@protocol(UITextInputTraits)]) {
            @try {
                searchBarTextField.enablesReturnKeyAutomatically = NO;
                searchBarTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
            }
            @catch (__unused NSException * e) {} break;
        }
    }

    CGFloat topLayoutHeight = 55.f;
    self.collectionView.contentInset = UIEdgeInsetsMake(topLayoutHeight, 0, 0, 0);
    [self.collectionView addSubview:self.searchBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Only one delegate at a time (only one grid is displayed at a time)
    PSCStoreManager.sharedStoreManager.delegate = self;

    // Ensure everything is up to date (we could change magazines in other controllers)
    self.immediatelyLoadCellImages = YES;
    [self diskDataLoaded]; // also reloads the grid
    self.immediatelyLoadCellImages = NO;

    [self setProgressIndicatorVisible:PSCStoreManager.sharedStoreManager.isDiskDataLoaded animated:NO];

    // Reload view, request new images.
    [self updateGrid];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // Ensure we're not in editing mode.
    [self setEditing:NO animated:animated];

    // Only deregister if not attached to anything else.
    if (PSCStoreManager.sharedStoreManager.delegate == self) PSCStoreManager.sharedStoreManager.delegate = nil;

	// Relenglush the delegate
	if ([self isMovingFromParentViewController]) {
		self.navigationController.delegate = nil;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)updateGrid {
    BOOL restoreKeyboard = NO;
    if (self.searchBar.isFirstResponder) {
        restoreKeyboard = YES;
    }

    // This, sadly steals our first responder.
    [self.collectionView reloadData];
    if (restoreKeyboard) {
        // Block the fade-in-animation.
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [self.searchBar becomeFirstResponder];
        [CATransaction commit];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Progress display

- (void)setProgressIndicatorVisible:(BOOL)visible animated:(BOOL)animated {
    if (visible) {
        if (!self.activityView) {
            UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [activityView sizeToFit];
            activityView.center = self.view.center;
            activityView.frame = CGRectIntegral(activityView.frame);
            activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
            [activityView startAnimating];
            self.activityView = activityView;
        }
    }
    if (visible) {
        self.activityView.alpha = 0.f;
        [self.view addSubview:self.activityView];
    }
    [UIView animateWithDuration:animated ? 0.25f : 0.f delay:0.f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction animations:^{
        self.activityView.alpha = visible ? 1.f : 0.f;
    } completion:^(BOOL finished) {
        if (finished && !visible) {
            [self.activityView removeFromSuperview];
        }
    }];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)presentModalViewControllerWithCloseButton:(UIViewController *)controller animated:(BOOL)animated {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:PSPDFBundleImage(@"x") style:UIBarButtonItemStyleDone target:self action:@selector(closeModalView)];
    [self presentViewController:navController animated:animated completion:NULL];
}

// Toggle the options/settings button.
- (void)optionsButtonPressed {
    BOOL alreadyDisplayed = PSCIsControllerClassAndVisible(self.popoverController, [PSCSettingsController class]);
    if (alreadyDisplayed) {
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
    } else {
        PSCSettingsController *settingsController = [PSCSettingsController new];
        settingsController.owningViewController = self;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsController];
        if (PSCIsIPad()) {
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:navController];
            [self.popoverController presentPopoverFromBarButtonItem:self.navigationItem.leftBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        } else {
            [self presentModalViewControllerWithCloseButton:settingsController animated:YES];
        }
    }
}

// Calculates where the document view will be on screen.
- (CGRect)magazinePageCoordinatesWithDoublePageCurl:(BOOL)doublePageCurl {
    CGRect newFrame = self.view.frame;

    // Animation needs to be different if we are in pageCurl mode.
    if (doublePageCurl) {
        newFrame.size.width /= 2;
        newFrame.origin.x += newFrame.size.width;
    }
    return newFrame;
}

// Open magazine with a nice animation.
- (BOOL)openMagazine:(PSCMagazine *)magazine animated:(BOOL)animated cellIndex:(NSUInteger)cellIndex {
	if (!magazine) return NO;

    self.lastOpenedMagazine = magazine;
	self.cellIndex = cellIndex;

    [self.searchBar resignFirstResponder];

    // Speed up displaying with parsing several things PSPDFViewController needs.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [magazine fillCache];
    });

	PSCKioskPDFViewController *pdfController = [[PSCKioskPDFViewController alloc] initWithDocument:magazine];

	// Try to get full-size image, if that fails try getting the thumbnail.
	self.coverImage = [PSPDFKit.sharedInstance.cache imageFromDocument:magazine page:0 size:UIScreen.mainScreen.bounds.size options:PSPDFCacheOptionDiskLoadSync|PSPDFCacheOptionRenderSync|PSPDFCacheOptionMemoryStoreAlways];
	// Prepare the target page image, if it differes from the cover image
	if (animated && pdfController.page != 0 && !pdfController.isDoublePageMode) {
		self.targetPageImage = [PSPDFKit.sharedInstance.cache imageFromDocument:self.lastOpenedMagazine page:pdfController.page size:UIScreen.mainScreen.bounds.size options:PSPDFCacheOptionDiskLoadSync|PSPDFCacheOptionRenderSkip|PSPDFCacheOptionMemoryStoreAlways];
	}

	[self.navigationController pushViewController:pdfController animated:animated];

    return YES;
}

- (void)diskDataLoaded {
    // Update indicator
    [self setProgressIndicatorVisible:PSCStoreManager.sharedStoreManager.isDiskDataLoaded animated:YES];

    // Not finished yet? Return early.
    if (PSCStoreManager.sharedStoreManager.magazineFolders.count == 0) return;

    // If we're in plain mode, pre-set a folder.
    if (PSPDFStoreManagerPlain) self.magazineFolder = PSCStoreManager.sharedStoreManager.magazineFolders.lastObject;

    // Preload all magazines (copy to prevent mutation errors).
    NSArray *magazines = [self.magazineFolder.magazines copy];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        for (PSCMagazine *magazine in magazines) {
            [PSPDFKit.sharedInstance.cache imageFromDocument:magazine page:0 size:kPSCLargeThumbnailSize options:PSPDFCacheOptionDiskLoadSkip|PSPDFCacheOptionRenderQueueBackground|PSPDFCacheOptionMemoryStoreNever];
        }
    });

    [self updateGrid];
}

- (BOOL)canEditCell:(PSCImageGridViewCell *)cell {
    BOOL editing = self.isEditing;
    if (editing) {
        if (cell.magazine) {
            editing =  cell.magazine.isDownloading || (cell.magazine.isAvailable && cell.magazine.isDeletable);
        } else {
            NSArray *fixedMagazines = [self.magazineFolder.magazines filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isDeletable = NO || isAvailable = NO || isDownloading = YES"]];
            editing = fixedMagazines.count == 0;
        }
    }
    return editing;
}

- (void)updateEditingAnimated:(BOOL)animated {
    for (PSCImageGridViewCell *cell in self.collectionView.visibleCells) {
        if ([cell isKindOfClass:PSCImageGridViewCell.class]) {

            BOOL editing = [self canEditCell:cell];
            if (editing) cell.showDeleteImage = editing;
            cell.deleteButton.alpha = editing ? 0.f : 1.f;

            [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
                cell.deleteButton.alpha = editing ? 1.f : 0.f;
            } completion:^(BOOL finished) {
                if (finished) {
                    cell.showDeleteImage = editing;
                }
            }];
        }
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self updateEditingAnimated:animated];
}

- (void)setEditing:(BOOL)editing {
    [super setEditing:editing];
    [self updateEditingAnimated:NO];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.magazineFolder) {
        _filteredData = self.magazineFolder.magazines;
    } else {
        _filteredData = PSCStoreManager.sharedStoreManager.magazineFolders;
    }

    NSString *searchString = _searchBar.text;
    if ([searchString length]) { // title CONTAINS[cd] '%@' ||
        _filteredData = [_filteredData filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"fileURL.path CONTAINS[cd] %@", searchString]];
    } else {
        _filteredData = [_filteredData copy];
    }

    return _filteredData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PSCImageGridViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PSCImageGridViewCell.class) forIndexPath:indexPath];

    // connect the delete button
    if (cell.deleteButton.allTargets.count == 0) {
        [cell.deleteButton addTarget:self action:@selector(processDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    cell.immediatelyLoadCellImages = self.immediatelyLoadCellImages;
    if (self.magazineFolder) {
        cell.magazine = _filteredData[indexPath.item];
    } else {
        cell.magazineFolder = _filteredData[indexPath.item];
    }
    cell.showDeleteImage = [self canEditCell:cell];

    return (UICollectionViewCell *)cell;
}

- (void)processDeleteAction:(UIButton *)button {
    [self processDeleteActionForCell:(PSCImageGridViewCell *)button.superview.superview];
}

- (void)processDeleteActionForCell:(PSCImageGridViewCell *)cell {
    PSCMagazine *magazine = cell.magazine;
    PSCMagazineFolder *folder = cell.magazineFolder;

    dispatch_block_t deleteBlock = ^{
        if (self.magazineFolder) {
            if (magazine.isDownloading) {
                [PSCStoreManager.sharedStoreManager cancelDownloadForMagazine:magazine];
            } else {
                [PSCStoreManager.sharedStoreManager deleteMagazine:magazine];
            }
        } else {
            [PSCStoreManager.sharedStoreManager deleteMagazineFolder:folder];
        }
    };

    deleteBlock();
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return PSCIsIPad() ? kPSCLargeThumbnailSize : CGSizeMake(82.f, 130.f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PSCMagazine *magazine;
    PSCMagazineFolder *folder;

    if (self.magazineFolder) {
        folder = self.magazineFolder;
        magazine = (_filteredData)[indexPath.item];
    } else {
        folder = (_filteredData)[indexPath.item];
        magazine = [folder firstMagazine];
    }

    PSCLog(@"Magazine selected: %tu %@", indexPath.item, magazine);

    if (folder.magazines.count == 1 || self.magazineFolder) {
        if (magazine.isDownloading) {
            [[[UIAlertView alloc] initWithTitle:_(@"Item is currently downloading.")
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:_(@"OK")
                              otherButtonTitles:nil] show];
        } else if (!magazine.isAvailable && !magazine.isDownloading) {
            if (!self.isEditing) {
                [PSCStoreManager.sharedStoreManager downloadMagazine:magazine];
                [collectionView deselectItemAtIndexPath:indexPath animated:YES];
            }
        } else {
            [self openMagazine:magazine animated:YES cellIndex:indexPath.item];
        }
    } else {
        PSCGridViewController *gridController = [[PSCGridViewController alloc] initWithMagazineFolder:folder];

        // A full-page-fade animation doesn't work very well on iPad. (under a ux aspect; technically it's fine)
        if (!PSCIsIPad()) {
            CATransition *transition = PSCFadeTransitionWithDuration(0.3f);
            [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
            [self.navigationController pushViewController:gridController animated:NO];

        } else {
            [self.navigationController pushViewController:gridController animated:YES];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // resign keyboard if we scroll down
    if (self.collectionView.contentOffset.y > 0) {
        [self.searchBar resignFirstResponder];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFStoreManagerDelegate

- (BOOL)isSearchModeActive {
    return self.searchBar.text.length > 0;
}

- (void)magazineStoreBeginUpdate {}
- (void)magazineStoreEndUpdate {}

- (void)magazineStoreFolderDeleted:(PSCMagazineFolder *)magazineFolder {
    // don't animate if we're in search mode
    if (self.isSearchModeActive) return;

    if (!self.magazineFolder) {
        NSUInteger cellIndex = [PSCStoreManager.sharedStoreManager.magazineFolders indexOfObject:magazineFolder];
        if (cellIndex != NSNotFound) {
            [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:cellIndex inSection:0]]];
        } else {
            PSCLog(@"index not found for %@", magazineFolder);
        }
    }
}

- (void)magazineStoreFolderAdded:(PSCMagazineFolder *)magazineFolder {
    // Don't animate if we're in search mode
    if (self.isSearchModeActive) return;

    if (!self.magazineFolder) {
        NSUInteger cellIndex = [PSCStoreManager.sharedStoreManager.magazineFolders indexOfObject:magazineFolder];
        if (cellIndex != NSNotFound) {
            [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:cellIndex inSection:0]]];
        } else {
            PSCLog(@"index not found for %@", magazineFolder);
        }
    }
}

- (void)magazineStoreFolderModified:(PSCMagazineFolder *)magazineFolder {
    // don't animate if we're in search mode
    if (self.isSearchModeActive) return;

    if (!self.magazineFolder) {
        NSUInteger cellIndex = [PSCStoreManager.sharedStoreManager.magazineFolders indexOfObject:magazineFolder];
        if (cellIndex != NSNotFound) {
            [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:cellIndex inSection:0]]];
        } else {
            PSCLog(@"index not found for %@", magazineFolder);
        }
    }
}

- (void)openMagazine:(PSCMagazine *)magazine {
    NSUInteger cellIndex = [self.magazineFolder.magazines indexOfObject:magazine];
    if (cellIndex != NSNotFound) {
        [self openMagazine:magazine animated:YES cellIndex:cellIndex];
    } else {
        PSCLog(@"index not found for %@", magazine);
    }
}

- (void)magazineStoreMagazineDeleted:(PSCMagazine *)magazine {
    // don't animate if we're in search mode
    if (self.isSearchModeActive) return;

    if (self.magazineFolder) {
        NSUInteger cellIndex = [self.magazineFolder.magazines indexOfObject:magazine];
        if (cellIndex != NSNotFound) {
            [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:cellIndex inSection:0]]];
        } else {
            PSCLog(@"index not found for %@", magazine);
        }
    }
}

- (void)magazineStoreMagazineAdded:(PSCMagazine *)magazine {
    // don't animate if we're in search mode
    if (self.isSearchModeActive) return;

    if (self.magazineFolder) {
        NSUInteger cellIndex = [self.magazineFolder.magazines indexOfObject:magazine];
        if (cellIndex != NSNotFound) {
            [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:cellIndex inSection:0]]];
        } else {
            PSCLog(@"index not found for %@", magazine);
        }
    }
}

- (void)magazineStoreMagazineModified:(PSCMagazine *)magazine {
    // don't animate if we're in search mode
    if (self.isSearchModeActive) return;

    if (self.magazineFolder) {
        NSUInteger cellIndex = [self.magazineFolder.magazines indexOfObject:magazine];
        if (cellIndex != NSNotFound) {
            [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:cellIndex inSection:0]]];
        } else {
            PSCLog(@"index not found for %@", magazine);
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.25f delay:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        searchBar.alpha = 1.f;
    } completion:NULL];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    UIScrollView *wrap = (UIScrollView *)searchBar.superview;
    searchBar.frame = CGRectMake(wrap.frame.origin.x, wrap.frame.origin.y, searchBar.frame.size.width, searchBar.frame.size.height);
    [wrap.superview addSubview:searchBar];
    [wrap removeFromSuperview];

    [UIView animateWithDuration:0.25f delay:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        searchBar.alpha = 0.5f;
    } completion:NULL];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _filteredData = nil;

    [self updateGrid];
    self.collectionView.contentOffset = CGPointMake(0.f, -self.collectionView.contentInset.top);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    // UISearchBar tries to scroll to visiblity even though it is already visible.
    // We wrap it into a dummy scroll view to prevent this logic.
    UIScrollView *wrap = [[UIScrollView alloc] initWithFrame:searchBar.frame];
    [searchBar.superview addSubview:wrap];
    searchBar.frame = CGRectMake(0, 0, searchBar.frame.size.width, searchBar.frame.size.height);
    [wrap addSubview:searchBar];
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
								   animationControllerForOperation:(UINavigationControllerOperation)operation
												fromViewController:(UIViewController *)fromVC
												  toViewController:(UIViewController *)toVC {

	BOOL pushingMagazine = operation == UINavigationControllerOperationPush && fromVC == self && [toVC isKindOfClass:[PSCKioskPDFViewController class]];
	BOOL popMagazine = operation == UINavigationControllerOperationPop && toVC == self && [fromVC isKindOfClass:[PSCKioskPDFViewController class]];

	// Custom zoom animation
	if (pushingMagazine || popMagazine) return self;

	// Standard UINavigationController animation
	return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
	return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	if (fromViewController == self) {
		// Fallback to a crossfade animation, if we can't get a usable cover image
		if (!self.coverImage || self.lastOpenedMagazine.isLocked) {
			[self animateCrossFadeTrasition:transitionContext];
		} else {
			[self animateZoomInTrasition:transitionContext];
		}
	} else {
		// Fallback to a crossfade animation, if we can't get a usable cover image
		// or if the index is left in an invalid state
		if (!self.coverImage || self.cellIndex >= self.magazineFolder.magazines.count) {
			[self animateCrossFadeTrasition:transitionContext];
		} else {
			[self animateZoomOutTrasition:transitionContext];
		}
	}
}

- (void)animateZoomInTrasition:(id<UIViewControllerContextTransitioning>)transitionContext {
	UIView *containerView = [transitionContext containerView];
	UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

	// Pushing to a magazine
	PSCKioskPDFViewController *pdfController = (PSCKioskPDFViewController *)toViewController;

	NSIndexPath *ip = [NSIndexPath indexPathForItem:self.cellIndex inSection:0];
	PSCImageGridViewCell *cell = (PSCImageGridViewCell *)[self.collectionView cellForItemAtIndexPath:ip];
	CGRect cellCoords = [cell.imageView convertRect:cell.imageView.bounds toView:containerView];

	_animationDoubleWithPageCurl = pdfController.configuration.pageTransition == PSPDFPageTransitionCurl && pdfController.isDoublePageMode;
	CGRect newFrame = [self magazinePageCoordinatesWithDoublePageCurl:_animationDoubleWithPageCurl];

	// Prepare the cover image view, match it's position to the position of the (now hidden) cell.
	UIImageView *coverImageView = self.magazineCoverView;
	coverImageView.image = self.coverImage;
	coverImageView.frame = cellCoords;
	[containerView addSubview:coverImageView];

	// If we have a different page, fade to that page.
	UIImageView *targetPageImageView = nil;
	if (self.targetPageImage) {
		targetPageImageView = self.magazineCurrentPageView;
		targetPageImageView.image = self.targetPageImage;
		targetPageImageView.frame = coverImageView.bounds;
		targetPageImageView.alpha = 0.f;
		[coverImageView addSubview:targetPageImageView];
	}

	cell.hidden = YES;

	[UIView animateWithDuration:0.3*2.4f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0.f options:0 animations:^{
		self.collectionView.transform = CGAffineTransformMakeScale(0.97f, 0.97f);
		self.collectionView.alpha = 0.0f;
		coverImageView.frame = newFrame;
		targetPageImageView.alpha = 1.f;
	} completion:^(BOOL finished) {
		[coverImageView removeFromSuperview];
		[containerView addSubview:toViewController.view];
		self.collectionView.transform = CGAffineTransformIdentity;
		self.collectionView.alpha = 1.0f;
		self.targetPageImage = nil;
		cell.hidden = NO;

		[transitionContext completeTransition:YES];
	}];
}

- (void)animateZoomOutTrasition:(id<UIViewControllerContextTransitioning>)transitionContext {
	UIView *containerView = [transitionContext containerView];
	UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

	UIImageView *coverImageView = self.magazineCoverView;

	// Modify the view hierrachy first, otherwise the cell frame might not be as expected
	[containerView addSubview:toViewController.view];
	[fromViewController.view removeFromSuperview];
	[containerView addSubview:coverImageView];

	NSIndexPath *ip = [NSIndexPath indexPathForItem:self.cellIndex inSection:0];
	[self.collectionView scrollToItemAtIndexPath:ip atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
	[self.collectionView layoutSubviews]; // ensure cells are laid out

	// Convert the coordinates into view coordinate system.
	// We can't remember those, because the device might have been rotated.
	PSCImageGridViewCell *cell = (PSCImageGridViewCell *)[self.collectionView cellForItemAtIndexPath:ip];
	CGRect cellCoords = [cell.imageView convertRect:cell.imageView.bounds toView:containerView];

	coverImageView.frame = [self magazinePageCoordinatesWithDoublePageCurl:_animationDoubleWithPageCurl && UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation)];

	// Update image for a nicer animation (get the correct page)
	UIImage *updatedImage = [PSPDFKit.sharedInstance.cache imageFromDocument:self.lastOpenedMagazine page:self.lastOpenedMagazine.lastViewState.page size:UIScreen.mainScreen.bounds.size options:PSPDFCacheOptionDiskLoadSync|PSPDFCacheOptionRenderSync|PSPDFCacheOptionMemoryStoreAlways];
	UIImageView *sourcePageImageView = nil;
	if (updatedImage) {
		sourcePageImageView = self.magazineCurrentPageView;
		sourcePageImageView.image = updatedImage;
		sourcePageImageView.frame = coverImageView.bounds;
		[coverImageView addSubview:sourcePageImageView];
	} else if (_magazineCurrentPageView) {
		// Use the cover image only
		[_magazineCurrentPageView removeFromSuperview];
	}

	self.collectionView.transform = CGAffineTransformMakeScale(0.97f, 0.97f);
	cell.hidden = YES;

	[UIView animateWithDuration:0.3*2.4f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0.f options:0 animations:^{
		self.collectionView.transform = CGAffineTransformIdentity;
		coverImageView.frame = cellCoords;
		sourcePageImageView.alpha = 0.f;
		self.collectionView.alpha = 1.f;
	} completion:^(BOOL finished) {
		[coverImageView removeFromSuperview];
		self.magazineCoverView = nil;
		self.magazineCurrentPageView = nil;
		self.cellIndex = 0;
		cell.hidden = NO;

		[transitionContext completeTransition:YES];
	}];
}

- (void)animateCrossFadeTrasition:(id<UIViewControllerContextTransitioning>)transitionContext {
	UIView *containerView = [transitionContext containerView];
	UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

	[containerView addSubview:toViewController.view];
	toViewController.view.alpha = 0.f;

	[UIView animateWithDuration:0.3 animations:^{
		toViewController.view.alpha = 1.f;
	} completion:^(BOOL finished) {
		[transitionContext completeTransition:YES];
	}];
}

- (UIImageView *)magazineCoverView {
	if (!_magazineCoverView) {
		_magazineCoverView = [[UIImageView alloc] init];
		_magazineCoverView.contentMode = UIViewContentModeScaleAspectFit;
		_magazineCoverView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	}
	return _magazineCoverView;
}

- (UIImageView *)magazineCurrentPageView {
	if (!_magazineCurrentPageView) {
		_magazineCurrentPageView = [[UIImageView alloc] init];
		_magazineCurrentPageView.contentMode = UIViewContentModeScaleAspectFit;
		_magazineCurrentPageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	}
	return _magazineCurrentPageView;
}

@end

// Fixes the missing action method crash on updating when the keyboard is visible.
#import <objc/runtime.h>

__attribute__((constructor)) static void PSPDFFixCollectionViewUpdateItemWhenKeyboardIsDisplayed(void) {
    @autoreleasepool {
        if (![UICollectionViewUpdateItem instancesRespondToSelector:@selector(action)]) {
            IMP updateIMP = imp_implementationWithBlock(^(id _self) {});
            Method method = class_getInstanceMethod([UICollectionViewUpdateItem class], @selector(action));
            const char *encoding = method_getTypeEncoding(method);
            if (!class_addMethod([UICollectionViewUpdateItem class], @selector(action), updateIMP, encoding)) {
                NSLog(@"Failed to add action: workaround");
            }
        }
    }
}

// Fixes a missing selector crash for [UISearchBar _isInUpdateAnimation:]
__attribute__((constructor)) static void PSPDFFixCollectionViewSearchBarDisplayed(void) {
    @autoreleasepool {
        SEL isInUpdate = NSSelectorFromString([NSString stringWithFormat:@"%@is%@Update%@", @"_", @"In", @"Animation"]);
        if (![UISearchBar instancesRespondToSelector:isInUpdate]) {
            IMP updateIMP = imp_implementationWithBlock(^(id _self) {return NO;});
            Method method = class_getInstanceMethod([UISearchBar class], isInUpdate);
            const char *encoding = method_getTypeEncoding(method);
            if (!class_addMethod([UISearchBar class], isInUpdate, updateIMP, encoding)) {
                NSLog(@"Failed to add [is In Update Animation:] workaround");
            }
        }
    }
}
