//
//  PSCGridController.m
//  PSPDFCatalog
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PSCGridController.h"
#import "PSCImageGridViewCell.h"
#import "PSCMagazine.h"
#import "PSCMagazineFolder.h"
#import "PSCKioskPDFViewController.h"
#import "PSCSettingsController.h"
#import "PSCDownload.h"
#import "PSCImageGridViewCell.h"
#import "PSCShadowView.h"
#import "SDURLCache.h"

#if !__has_feature(objc_arc)
#error "Compile this file with ARC"
#endif

#define kPSPDFGridFadeAnimationDuration 0.3f * PSPDFSimulatorAnimationDragCoefficient()

// the delete button target is small enough that we don't need to ask for confirmation.
#define kPSPDFShouldShowDeleteConfirmationDialog NO

@interface PSCGridController() <UISearchBarDelegate> {
    NSArray *_filteredData;
    NSUInteger _animationCellIndex;
    BOOL _animationDoubleWithPageCurl;
    BOOL _animateViewWillAppearWithFade;
}
@property (nonatomic, assign) BOOL immediatelyLoadCellImages; // UI tweak.
@property (nonatomic, assign, getter=isEditMode) BOOL editMode;
@property (nonatomic, strong) UIImageView *magazineView;
@property (nonatomic, strong) PSCMagazineFolder *magazineFolder;
@property (nonatomic, strong) PSCShadowView *shadowView;
@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation PSCGridController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if ((self = [super init])) {
        self.title = NSLocalizedString(@"PSPDFKit Kiosk Example", @"");

        // one-time init stuff
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            // setup disk saving url cache
            SDURLCache *URLCache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024   // 1MB mem cache
                                                                 diskCapacity:1024*1024*5 // 5MB disk cache
                                                                     diskPath:[SDURLCache defaultCachePath]];
            URLCache.ignoreMemoryOnlyStoragePolicy = YES;
            [NSURLCache setSharedURLCache:URLCache];
        });

        // custom back button for smaller wording
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Kiosk", @"") style:UIBarButtonItemStylePlain target:nil action:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(diskDataLoaded) name:kPSPDFStoreDiskLoadFinishedNotification object:nil];
    }
    return self;
}

- (id)initWithMagazineFolder:(PSCMagazineFolder *)aMagazineFolder {
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

- (void)updateGridForOrientation {
    // TODO: don't make this depending on the orientation.

    // on iPhone, the navigation toolbar is either 44 (portrait) or 30 (landscape) pixels
    CGSize size = [self PSPDFGridView:nil sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    UICollectionViewFlowLayout *flowLayout = ((UICollectionViewFlowLayout *)_gridView.collectionViewLayout);
    flowLayout.itemSize = size;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.magazineFolder) {
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", @"")
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(editButtonPressed)];
        self.navigationItem.rightBarButtonItem = editButton;
    }

    UIBarButtonItem *optionButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Options", @"")
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(optionsButtonPressed)];

    // only show the option button if we're at root (else we hide the back button)
    if ((self.navigationController.viewControllers)[0] == self) {
        self.navigationItem.leftBarButtonItem = optionButton;
    }else {
        // iOS5 supports easy additional buttons next to a native back button
        PSPDF_IF_IOS5_OR_GREATER(self.navigationItem.leftBarButtonItem = optionButton;
                                 self.navigationItem.leftItemsSupplementBackButton = YES;);
    }

    // add global shadow
    CGFloat toolbarHeight = self.navigationController.navigationBar.frame.size.height;
    self.shadowView = [[PSCShadowView alloc] initWithFrame:CGRectMake(0, -toolbarHeight, self.view.bounds.size.width, toolbarHeight)];
    _shadowView.shadowOffset = toolbarHeight;
    _shadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _shadowView.backgroundColor = [UIColor clearColor];
    _shadowView.userInteractionEnabled = NO;
    [self.view addSubview:_shadowView];

    // use custom view to match background with PSPDFViewController
    UIView *backgroundTextureView = [[UIView alloc] initWithFrame:CGRectMake(0, -toolbarHeight, self.view.bounds.size.width, self.view.bounds.size.height + toolbarHeight)];
    backgroundTextureView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroundTextureView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"linen_texture_dark"]];
    [self.view insertSubview:backgroundTextureView belowSubview:_shadowView];

    // init the collection view
    PSUICollectionViewFlowLayout *flowLayout = [PSUICollectionViewFlowLayout new];
    PSUICollectionView *collectionView = [[PSUICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];

    flowLayout.minimumLineSpacing = 30;
    flowLayout.minimumInteritemSpacing = 10;
    NSUInteger spacing = 20;
    flowLayout.sectionInset = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);

    [collectionView registerClass:[PSCImageGridViewCell class] forCellWithReuseIdentifier:NSStringFromClass([PSCImageGridViewCell class])];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.gridView = collectionView;

    [self.view insertSubview:self.gridView belowSubview:_shadowView];
    self.gridView.frame = self.view.bounds;
    [self updateGridForOrientation];
    self.gridView.dataSource = self; // auto-reloads
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;

    // add search bar
    CGFloat searchBarWidth = 290.f;
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectIntegral(CGRectMake((self.gridView.bounds.size.width-searchBarWidth)/2, -44.f, searchBarWidth, 44.f))];
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _searchBar.tintColor = [UIColor blackColor];
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.alpha = 0.5;
    _searchBar.delegate = self;
    // doesn't matter much if this fails, but the background doesn't look great within our grid.
    [PSPDFGetViewInsideView(_searchBar, @"UISearchBarBack") removeFromSuperview];
    self.gridView.contentInset = UIEdgeInsetsMake(64.f, 0, 0, 0);
    [self.gridView addSubview:self.searchBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (![self isViewLoaded]) {
        self.gridView.delegate = nil;
        self.gridView.dataSource = nil;
        self.gridView = nil;
        self.shadowView = nil;
        self.searchBar.delegate = nil;
        self.searchBar = nil;
    }
}

// default style
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // ensure our navigation bar is visible. PSPDFKit restores the properties,
    // but since we're doing a custom fade-out on the navigationBar alpha,
    // we also have to restore this properly.
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [UIView animateWithDuration:0.25f animations:^{
        self.navigationController.navigationBar.alpha = 1.f;
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    _shadowView.shadowEnabled = YES;

    // if navigationBar is offset, we're fixing that.
    if (self.navigationController.navigationBar) {
        CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
        CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
        if (navigationBarFrame.origin.y <= statusBarFrame.origin.y) {
            // compensate rotation
            navigationBarFrame.origin.y = fminf(statusBarFrame.size.height, statusBarFrame.size.width);
            self.navigationController.navigationBar.frame = navigationBarFrame;
        }
    }

    // only one delegate at a time (only one grid is displayed at a time)
    [PSCStoreManager sharedStoreManager].delegate = self;

    // ensure everything is up to date (we could change magazines in other controllers)
    self.immediatelyLoadCellImages = YES;
    [self updateGridForOrientation];
    [self diskDataLoaded]; // also reloads the grid
    self.immediatelyLoadCellImages = NO;

    if (_animateViewWillAppearWithFade) {
        [self.navigationController.view.layer addAnimation:PSPDFFadeTransition() forKey:kCATransition];
        _animateViewWillAppearWithFade = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // animate back to grid cell?
    if (self.magazineView) {

        // if something changed, just don't animate.
        if (_animationCellIndex >= [self.magazineFolder.magazines count]) {
            self.gridView.transform = CGAffineTransformIdentity;
            self.gridView.alpha = 1.0f;
            [self.view.layer addAnimation:PSPDFFadeTransition() forKey:kCATransition];
            [self.magazineView removeFromSuperview];
            self.magazineView = nil;
        }else {
            [self.gridView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_animationCellIndex inSection:0] atScrollPosition:PSTCollectionViewScrollPositionCenteredHorizontally animated:NO];
            [self.gridView layoutSubviews]; // ensure cells are laid out
            /*
            // ensure object is visible
            BOOL isCellVisible = [self.gridView isCellVisibleAtIndex:_animationCellIndex partly:YES];
            if (!isCellVisible) {
                [self.gridView scrollToObjectAtIndex:_animationCellIndex atScrollPosition:PSPDFGridViewScrollPositionTop animated:NO];
                [self.gridView layoutSubviews]; // ensure cells are laid out
            };*/

            // convert the coordinates into view coordinate system
            // we can't remember those, because the device might has been rotated.
            CGRect absoluteCellRect = [self.gridView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_animationCellIndex inSection:0]].frame;
            CGRect relativeCellRect = [self.gridView convertRect:absoluteCellRect toView:self.view];

            self.magazineView.frame = [self magazinePageCoordinatesWithDoublePageCurl:_animationDoubleWithPageCurl && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)];

            // start animation!
            [UIView animateWithDuration:0.3f delay:0.f options:0 animations:^{
                self.gridView.transform = CGAffineTransformIdentity;
                self.magazineView.frame = relativeCellRect;
                [[self.magazineView.subviews lastObject] setAlpha:0.f];
                self.gridView.alpha = 1.0f;
            } completion:^(BOOL finished) {
                [self.magazineView removeFromSuperview];
                self.magazineView = nil;
            }];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // only deregister if not attached to anything else
    if ([PSCStoreManager sharedStoreManager].delegate == self) {
        [PSCStoreManager sharedStoreManager].delegate = nil;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    PSPDF_IF_PRE_IOS5([self updateGridForOrientation];) // viewWillLayoutSubviews is iOS5 only
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self updateGridForOrientation];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)updateGrid {
    [self.gridView reloadData];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)presentModalViewControllerWithCloseButton:(UIViewController *)controller animated:(BOOL)animated {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:PSPDFLocalize(@"Close") style:UIBarButtonItemStyleBordered target:self action:@selector(closeModalView)];
    [self presentModalViewController:navController animated:animated];
}

// toggle the options/settings button.
- (void)optionsButtonPressed {
    BOOL alreadyDisplayed = PSPDFIsControllerClassInPopover(self.popoverController, [PSCSettingsController class]);
    if (alreadyDisplayed) {
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
    }else {
        PSCSettingsController *settingsController = [PSCSettingsController new];
        settingsController.owningViewController = self;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsController];
        if (PSIsIpad()) {
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:navController];
            [self.popoverController presentPopoverFromBarButtonItem:self.navigationItem.leftBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }else {
            [self presentModalViewControllerWithCloseButton:settingsController animated:YES];
        }
    }
}

// calculates where the document view will be on screen
- (CGRect)magazinePageCoordinatesWithDoublePageCurl:(BOOL)doublePageCurl {
    CGRect newFrame = self.view.frame;
    newFrame.origin.y -= self.navigationController.navigationBar.frame.size.height;
    newFrame.size.height += self.navigationController.navigationBar.frame.size.height;

    // compensate for transparent statusbar
    if (!PSIsIpad()) {
        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        BOOL isPortrait = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
        CGFloat statusBarHeight = isPortrait ? statusBarFrame.size.height : statusBarFrame.size.width;
        newFrame.origin.y -= statusBarHeight;
        newFrame.size.height += statusBarHeight;
    }

    // animation needs to be different if we are in pageCurl mode
    if (doublePageCurl) {
        newFrame.size.width /= 2;
        newFrame.origin.x += newFrame.size.width;
    }

    return newFrame;
}

// open magazine with nice animation
- (BOOL)openMagazine:(PSCMagazine *)magazine animated:(BOOL)animated cellIndex:(NSUInteger)cellIndex {
    [self.searchBar resignFirstResponder];

    // speed up displaying with parsing several things PSPDFViewController needs.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [magazine fillCache];
    });

    PSCKioskPDFViewController *pdfController = [[PSCKioskPDFViewController alloc] initWithDocument:magazine];

    // try to get full-size image, if that fails try thumbnail.
    UIImage *coverImage = [[PSPDFCache sharedCache] cachedImageForDocument:magazine page:0 size:PSPDFSizeNative];
    if (!coverImage) {
        coverImage = [[PSPDFCache sharedCache] cachedImageForDocument:magazine page:0 size:PSPDFSizeThumbnail];
    }
    
    if (animated && coverImage && !magazine.isLocked) {
        PSTCollectionViewCell *cell = [self.gridView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:cellIndex inSection:0]];
        cell.hidden = YES;
        CGRect cellCoords = [self.gridView convertRect:cell.frame toView:self.view];
        UIImageView *coverImageView = [[UIImageView alloc] initWithImage:coverImage];
        coverImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        coverImageView.frame = cellCoords;

        coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:coverImageView];
        self.magazineView = coverImageView;
        _animationCellIndex = cellIndex;

        // add a smooth status bar transition on the iPhone
        if (!PSIsIpad()) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
        }

        // if we have a different page, fade to that page.
        UIImageView *targetPageImageView = nil;
        if (pdfController.realPage != 0 && !pdfController.isDoublePageMode) {
            UIImage *targetPageImage = [[PSPDFCache sharedCache] cachedImageForDocument:magazine page:pdfController.realPage size:PSPDFSizeNative];
            if (targetPageImage) {
                targetPageImageView = [[UIImageView alloc] initWithImage:targetPageImage];
                targetPageImageView.frame = self.magazineView.bounds;
                targetPageImageView.contentMode = UIViewContentModeScaleAspectFit;
                targetPageImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                targetPageImageView.alpha = 0.f;
                [self.magazineView addSubview:targetPageImageView];
            }
        }

        [UIView animateWithDuration:0.3f delay:0.f options:0 animations:^{
            self.navigationController.navigationBar.alpha = 0.f;
            _shadowView.shadowEnabled = NO;
            self.gridView.transform = CGAffineTransformMakeScale(0.97, 0.97);

            _animationDoubleWithPageCurl = pdfController.pageTransition == PSPDFPageCurlTransition && [pdfController isDoublePageMode];
            CGRect newFrame = [self magazinePageCoordinatesWithDoublePageCurl:_animationDoubleWithPageCurl];
            coverImageView.frame = newFrame;
            targetPageImageView.alpha = 1.f;

            self.gridView.alpha = 0.0f;

        } completion:^(BOOL finished) {
            [self.navigationController.navigationBar.layer addAnimation:PSPDFFadeTransition() forKey:kCATransition];
            [self.navigationController pushViewController:pdfController animated:NO];

            cell.hidden = NO;
        }];
    }else {
        if (animated) {
            // add fake data so that we animate back
            _animateViewWillAppearWithFade = YES;
            [self.navigationController.view.layer addAnimation:PSPDFFadeTransition() forKey:kCATransition];
        }
        [self.navigationController pushViewController:pdfController animated:NO];
    }

    return YES;
}

- (void)diskDataLoaded {
    // not finished yet? return early.
    if ([[PSCStoreManager sharedStoreManager].magazineFolders count] == 0) {
        return;
    }

    // if we're in plain mode, pre-set a folder
    if (kPSPDFStoreManagerPlain) {
        self.magazineFolder = [[PSCStoreManager sharedStoreManager].magazineFolders lastObject];
    }

    [self.gridView reloadData];
}

- (void)editButtonPressed {
    if (self.isEditMode) {
        self.editMode = NO;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", @"")
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(editButtonPressed)];

    }else {
        self.editMode = YES;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"")
                                                                                  style:UIBarButtonItemStyleDone
                                                                                 target:self
                                                                                 action:@selector(editButtonPressed)];
    }
}

- (void)setEditMode:(BOOL)editMode {
    _editMode = editMode;
    // TODO
    //[self.gridView setEditing:editMode animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.magazineFolder) {
        _filteredData = self.magazineFolder.magazines;
    }else {
        _filteredData = [PSCStoreManager sharedStoreManager].magazineFolders;
    }

    NSString *searchString = _searchBar.text;
    if ([searchString length]) {
        NSString *predicate = [NSString stringWithFormat:@"title CONTAINS[cd] '%@' || fileURL.path CONTAINS[cd] '%@'", searchString, searchString];
        _filteredData = [_filteredData filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicate]];
    }else {
        _filteredData = [_filteredData copy];
    }

    NSUInteger count = [_filteredData count];
    return count;
}

- (CGSize)PSPDFGridView:(PSPDFGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation {
    return PSIsIpad() ? CGSizeMake(170, 240) : CGSizeMake(82, 130);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PSCImageGridViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PSCImageGridViewCell class]) forIndexPath:indexPath];

    cell.immediatelyLoadCellImages = self.immediatelyLoadCellImages;
    if (self.magazineFolder) {
        cell.magazine = _filteredData[indexPath.item];
    }else {
        cell.magazineFolder = _filteredData[indexPath.item];
    }

    return (UICollectionViewCell *)cell;
}

/*
- (PSPDFGridViewCell *)PSPDFGridView:(PSPDFGridView *)gridView cellForItemAtIndex:(NSInteger)cellIndex {
    CGSize size = [self PSPDFGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];

    PSPDFImageGridViewCell *cell = (PSPDFImageGridViewCell *)[self.gridView dequeueReusableCell];
    if (!cell) {
        cell = [[PSPDFImageGridViewCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    }

    cell.immediatelyLoadCellImages = self.immediatelyLoadCellImages;
    if (self.magazineFolder) {
        cell.magazine = _filteredData[cellIndex];
    }else {
        cell.magazineFolder = _filteredData[cellIndex];
    }

    return cell;
}*/

/*
- (BOOL)PSPDFGridView:(PSPDFGridView *)gridView canDeleteItemAtIndex:(NSInteger)index {
    BOOL canDelete;
    if (!self.magazineFolder) {
        NSArray *fixedMagazines = [self.magazineFolder.magazines filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isDeletable = NO || isAvailable = NO || isDownloading = YES"]];
        canDelete = [fixedMagazines count] == 0;
    }else {
        PSPDFMagazine *magazine = (self.magazineFolder.magazines)[index];
        canDelete = magazine.isAvailable && !magazine.isDownloading && magazine.isDeletable;
    }
    return canDelete;
}

- (void)PSPDFGridView:(PSPDFGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index {
    PSPDFMagazine *magazine;
    PSPDFMagazineFolder *folder;

    if (self.magazineFolder) {
        folder = self.magazineFolder;
        magazine = (self.magazineFolder.magazines)[index];
    }else {
        folder = ([PSPDFStoreManager sharedStoreManager].magazineFolders)[index];
        magazine = [folder firstMagazine];
    }

    BOOL canDelete = YES;
    NSString *message = nil;
    if ([folder.magazines count] > 1 && !self.magazineFolder) {
        message = [NSString stringWithFormat:NSLocalizedString(@"DeleteMagazineMultiple", @""), folder.title, [folder.magazines count]];
    }else {
        message = [NSString stringWithFormat:NSLocalizedString(@"DeleteMagazineSingle", @""), magazine.title];
        if (kPSPDFShouldShowDeleteConfirmationDialog) {
            canDelete = magazine.isAvailable || magazine.isDownloading;
        }
    }

    dispatch_block_t deleteBlock = ^{
        if (self.magazineFolder) {
            [[PSPDFStoreManager sharedStoreManager] deleteMagazine:magazine];
        }else {
            [[PSPDFStoreManager sharedStoreManager] deleteMagazineFolder:folder];
        }
    };

    if (kPSPDFShouldShowDeleteConfirmationDialog) {
        if (canDelete) {
            PSPDFActionSheet *deleteAction = [[PSPDFActionSheet alloc] initWithTitle:message];
            deleteAction.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [deleteAction setDestructiveButtonWithTitle:NSLocalizedString(@"Delete", @"") block:^{
                deleteBlock();
                // TODO should re-calculate index here.
                [self.gridView removeObjectAtIndex:index withAnimation:PSPDFGridViewItemAnimationFade];
            }];
            [deleteAction setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
            PSPDFImageGridViewCell *cell = (PSPDFImageGridViewCell *)[gridView cellForItemAtIndex:index];
            CGRect cellFrame = [cell convertRect:cell.imageView.frame toView:self.view];
            [deleteAction showFromRect:cellFrame inView:self.view animated:YES];
        }
    }else {
        deleteBlock();
        if (magazine.URL) {
            // magazines with URL can't really be deleted, just delete data & fade to gray.
            [self.gridView reloadObjectAtIndex:index withAnimation:PSPDFGridViewItemAnimationFade];
        }else {
            [self.gridView removeObjectAtIndex:index withAnimation:PSPDFGridViewItemAnimationFade];
        }
    }
}*/

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PSCMagazine *magazine;
    PSCMagazineFolder *folder;

    if (self.magazineFolder) {
        folder = self.magazineFolder;
        magazine = (_filteredData)[indexPath.item];
    }else {
        folder = (_filteredData)[indexPath.item];
        magazine = [folder firstMagazine];
    }

    PSCLog(@"Magazine selected: %d %@", indexPath.item, magazine);

    if ([folder.magazines count] == 1 || self.magazineFolder) {
        if (magazine.isDownloading) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Item is currently downloading.", @"")
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                              otherButtonTitles:nil] show];
        } else if(!magazine.isAvailable && !magazine.isDownloading) {
            [[PSCStoreManager sharedStoreManager] downloadMagazine:magazine];
        } else {
            [self openMagazine:magazine animated:YES cellIndex:indexPath.item];
        }
    }else {
        PSCGridController *gridController = [[PSCGridController alloc] initWithMagazineFolder:folder];

        // a full-page-fade animation doesn't work very well on iPad (under a ux aspect; technically it's fine)
        if (!PSIsIpad()) {
            CATransition* transition = [CATransition animation];
            transition.duration = kPSPDFGridFadeAnimationDuration;
            transition.type = kCATransitionFade;
            transition.subtype = kCATransitionFromTop;

            [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
            [self.navigationController pushViewController:gridController animated:NO];

        }else {
            [self.navigationController pushViewController:gridController animated:YES];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // resign keyboard if we scroll down
    if (self.gridView.contentOffset.y > 0) {
        [self.searchBar resignFirstResponder];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFStoreManagerDelegate

- (void)magazineStoreBeginUpdate {}
- (void)magazineStoreEndUpdate {}

- (void)magazineStoreFolderDeleted:(PSCMagazineFolder *)magazineFolder {
    if (!self.magazineFolder) {
        NSUInteger cellIndex = [[PSCStoreManager sharedStoreManager].magazineFolders indexOfObject:magazineFolder];
        if (cellIndex != NSNotFound) {
            [self.gridView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:cellIndex inSection:0]]];
        }else {
            PSCLog(@"index not found for %@", magazineFolder);
        }
    }
}

- (void)magazineStoreFolderAdded:(PSCMagazineFolder *)magazineFolder {
    if (!self.magazineFolder) {
        NSUInteger cellIndex = [[PSCStoreManager sharedStoreManager].magazineFolders indexOfObject:magazineFolder];
        if (cellIndex != NSNotFound) {
            [self.gridView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:cellIndex inSection:0]]];
        }else {
            PSCLog(@"index not found for %@", magazineFolder);
        }
    }
}

- (void)magazineStoreFolderModified:(PSCMagazineFolder *)magazineFolder {
    if (!self.magazineFolder) {
        NSUInteger cellIndex = [[PSCStoreManager sharedStoreManager].magazineFolders indexOfObject:magazineFolder];
        if (cellIndex != NSNotFound) {
            [self.gridView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:cellIndex inSection:0]]];
        }else {
            PSCLog(@"index not found for %@", magazineFolder);
        }
    }
}

- (void)openMagazine:(PSCMagazine *)magazine {
    NSUInteger cellIndex = [self.magazineFolder.magazines indexOfObject:magazine];
    if (cellIndex != NSNotFound) {
        [self openMagazine:magazine animated:YES cellIndex:cellIndex];
    }else {
        PSCLog(@"index not found for %@", magazine);
    }
}

- (void)magazineStoreMagazineDeleted:(PSCMagazine *)magazine {
    if (self.magazineFolder) {
        NSUInteger cellIndex = [self.magazineFolder.magazines indexOfObject:magazine];
        if (cellIndex != NSNotFound) {
            [self.gridView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:cellIndex inSection:0]]];
        }else {
            PSCLog(@"index not found for %@", magazine);
        }
    }
}

- (void)magazineStoreMagazineAdded:(PSCMagazine *)magazine {
    [self.gridView reloadData];
    // TODO: PSPDFGridView has some problems with inserting elements; will be fixed soon.
    /*
     if (self.magazineFolder) {
     NSUInteger cellIndex = [self.magazineFolder.magazines indexOfObject:magazine];
     if (cellIndex != NSNotFound) {
     [self.gridView insertObjectAtIndex:cellIndex withAnimation:PSPDFGridViewItemAnimationFade];
     }else {
     PSCLog(@"index not found for %@", magazine);
     }
     } */
}

- (void)magazineStoreMagazineModified:(PSCMagazine *)magazine {
    if (self.magazineFolder) {
        NSUInteger cellIndex = [self.magazineFolder.magazines indexOfObject:magazine];
        if (cellIndex != NSNotFound) {
            [self.gridView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:cellIndex inSection:0]]];
        }else {
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
    [UIView animateWithDuration:0.25f delay:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        searchBar.alpha = 0.5f;
    } completion:NULL];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _filteredData = nil;
    [self.gridView reloadData];
    self.gridView.contentOffset = CGPointMake(0, -self.gridView.contentInset.top);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

@end
