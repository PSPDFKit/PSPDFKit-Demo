//
//  PSCGridController.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
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
#import "PSCShadowView.h"

#if !__has_feature(objc_arc)
#error "Compile this file with ARC"
#endif

#define _(string) NSLocalizedString(string, @"")

#define PSCGridFadeAnimationDuration 0.3f * PSPDFSimulatorAnimationDragCoefficient()
#define kPSCLargeThumbnailSize CGSizeMake(170, 240)

// The delete button target is small enough that we don't need to ask for confirmation.
#define PSCShouldShowDeleteConfirmationDialog NO

@interface PSCGridViewController() <UISearchBarDelegate> {
    NSArray *_filteredData;
    NSUInteger _animationCellIndex;
    BOOL _animationDoubleWithPageCurl;
    BOOL _animateViewWillAppearWithFade;
}
@property (nonatomic, assign) BOOL immediatelyLoadCellImages; // UI tweak.
@property (nonatomic, strong) UIImageView *magazineView;
@property (nonatomic, strong) PSCMagazine *lastOpenedMagazine;
@property (nonatomic, strong) PSCMagazineFolder *magazineFolder;
@property (nonatomic, strong) PSCShadowView *shadowView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@end

@implementation PSCGridViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if ((self = [super init])) {
        self.title = _(@"PSPDFKit Kiosk Example");

        // custom back button for smaller wording
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:_(@"Kiosk") style:UIBarButtonItemStylePlain target:nil action:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(diskDataLoaded) name:PSCStoreDiskLoadFinishedNotification object:nil];
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

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.magazineFolder) {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }

#ifdef PSPDFCatalog
    UIBarButtonItem *optionButton = [[UIBarButtonItem alloc] initWithTitle:_(@"Options")
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(optionsButtonPressed)];

    // Only show the option button if we're at root. (else we hide the back button)
    if ((self.navigationController.viewControllers)[0] == self) {
        self.navigationItem.leftBarButtonItem = optionButton;
    }else {
        self.navigationItem.leftBarButtonItem = optionButton;
        self.navigationItem.leftItemsSupplementBackButton = YES;
    }
#endif

    // Add global shadow.
    CGFloat toolbarHeight = self.navigationController.navigationBar.frame.size.height;
    self.shadowView = [[PSCShadowView alloc] initWithFrame:CGRectMake(0, -toolbarHeight, self.view.bounds.size.width, toolbarHeight)];
    _shadowView.topShadowOffset = toolbarHeight;
    _shadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _shadowView.backgroundColor = [UIColor clearColor];
    _shadowView.userInteractionEnabled = NO;
    [self.view addSubview:_shadowView];

    // Use custom view to match background with PSPDFViewController.
    UIView *backgroundTextureView = [[UIView alloc] initWithFrame:CGRectMake(0, -toolbarHeight, self.view.bounds.size.width, self.view.bounds.size.height + toolbarHeight)];
    backgroundTextureView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    backgroundTextureView.backgroundColor = PSCDefaultBackgroundColor();
    [self.view insertSubview:backgroundTextureView belowSubview:_shadowView];

    // Init the collection view.
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];

    flowLayout.minimumLineSpacing = 30;
    NSUInteger spacing = 14;
    flowLayout.minimumInteritemSpacing = spacing;
    flowLayout.sectionInset = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);

    [collectionView registerClass:PSCImageGridViewCell.class forCellWithReuseIdentifier:NSStringFromClass(PSCImageGridViewCell.class)];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.collectionView = collectionView;

    [self.view insertSubview:self.collectionView belowSubview:_shadowView];
    self.collectionView.frame = CGRectIntegral(self.view.bounds);
    self.collectionView.dataSource = self; // auto-reloads

    // Add the search bar.
    CGFloat searchBarWidth = 290.f;
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectIntegral(CGRectMake((self.collectionView.bounds.size.width-searchBarWidth)/2, -44.f, searchBarWidth, 44.f))];
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    _searchBar.tintColor = UIColor.blackColor;
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.alpha = 0.5;
    _searchBar.delegate = self;

    // Doesn't matter much if this fails, but the background doesn't look great within our grid.
    [PSCGetViewInsideView(_searchBar, @"UISearchBarBack") removeFromSuperview];

    // Set the return key and keyboard appearance of the search bar.
    // Since we do live-filtering, the search bar should just dismiss the keyboard.
    for (UITextField *searchBarTextField in [_searchBar subviews]) {
        if ([searchBarTextField conformsToProtocol:@protocol(UITextInputTraits)]) {
            @try {
                searchBarTextField.enablesReturnKeyAutomatically = NO;
                searchBarTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
            }
            @catch (NSException * e) {} break;
        }
    }

    PSC_IF_PRE_IOS7(self.collectionView.contentInset = UIEdgeInsetsMake(64.f, 0, 0, 0);)

    // TODO iOS7. Wait for topLayoutGuide to not crash after accessing.
    PSC_IF_IOS7_OR_GREATER(CGFloat topLayoutHeight = 55.f;
                           self.collectionView.contentInset = UIEdgeInsetsMake(64.f + topLayoutHeight, 0, 0, 0);)

    [self.collectionView addSubview:self.searchBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.barStyle = PSCIsUIKitFlatMode() ? UIBarStyleBlack :  UIBarStyleDefault;

    // Ensure our navigation bar is visible. PSPDFKit restores the properties,
    // But since we're doing a custom fade-out on the navigationBar alpha,
    // We also have to restore this properly.
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [UIView animateWithDuration:0.25f animations:^{
        self.navigationController.navigationBar.alpha = 1.f;
    }];
    [UIApplication.sharedApplication setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    if (PSCIsUIKitFlatMode()) {
        PSC_IF_IOS7_OR_GREATER([UIApplication.sharedApplication setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];)
    }else {
        [UIApplication.sharedApplication setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }

    _shadowView.shadowEnabled = YES;

    // If navigationBar is offset, we're fixing that.
    PSCFixNavigationBarForNavigationControllerAnimated(self.navigationController, animated);

    // Only one delegate at a time (only one grid is displayed at a time)
    PSCStoreManager.sharedStoreManager.delegate = self;

    // Ensure everything is up to date (we could change magazines in other controllers)
    self.immediatelyLoadCellImages = YES;
    [self diskDataLoaded]; // also reloads the grid
    self.immediatelyLoadCellImages = NO;

    if (_animateViewWillAppearWithFade) {
        [self.navigationController.view.layer addAnimation:PSCFadeTransition() forKey:kCATransition];
        _animateViewWillAppearWithFade = NO;
    }

    [self setProgressIndicatorVisible:PSCStoreManager.sharedStoreManager.isDiskDataLoaded animated:NO];

    // Reload view, request new images.
    [self updateGrid];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // If navigationBar is offset, we're fixing that.
    PSCFixNavigationBarForNavigationControllerAnimated(self.navigationController, animated);

    // Animate back to grid cell?
    if (self.magazineView) {
        // If something changed, just don't animate.
        if (_animationCellIndex >= self.magazineFolder.magazines.count) {
            self.collectionView.transform = CGAffineTransformIdentity;
            self.collectionView.alpha = 1.0f;
            [self.view.layer addAnimation:PSCFadeTransition() forKey:kCATransition];
            [self.magazineView removeFromSuperview];
            self.magazineView = nil;
        }else {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_animationCellIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            [self.collectionView layoutSubviews]; // ensure cells are laid out

            // Convert the coordinates into view coordinate system.
            // We can't remember those, because the device might has been rotated.
            CGRect absoluteCellRect = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_animationCellIndex inSection:0]].frame;
            CGRect relativeCellRect = [self.collectionView convertRect:absoluteCellRect toView:self.view];

            self.magazineView.frame = [self magazinePageCoordinatesWithDoublePageCurl:_animationDoubleWithPageCurl && UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation)];

            // Update image for a nicer animation (get the correct page)
            UIImage *coverImage = [self imageForMagazine:self.lastOpenedMagazine];
            if (coverImage) self.magazineView.image = coverImage;

            // Start animation!
            [UIView animateWithDuration:0.3f delay:0.f options:0 animations:^{
                self.collectionView.transform = CGAffineTransformIdentity;
                self.magazineView.frame = relativeCellRect;
                [self.magazineView.subviews.lastObject setAlpha:0.f];
                self.collectionView.alpha = 1.f;
            } completion:^(BOOL finished) {
                [self.magazineView removeFromSuperview];
                self.magazineView = nil;
            }];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // Ensure we're not in editing mode.
    [self setEditing:NO animated:animated];

    // Only deregister if not attached to anything else.
    if (PSCStoreManager.sharedStoreManager.delegate == self) PSCStoreManager.sharedStoreManager.delegate = nil;
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
    controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:PSPDFLocalize(@"Close") style:UIBarButtonItemStyleBordered target:self action:@selector(closeModalView)];
    [self presentViewController:navController animated:animated completion:NULL];
}

// Toggle the options/settings button.
- (void)optionsButtonPressed {
    BOOL alreadyDisplayed = PSCIsControllerClassAndVisible(self.popoverController, [PSCSettingsController class]);
    if (alreadyDisplayed) {
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
    }else {
        PSCSettingsController *settingsController = [PSCSettingsController new];
        settingsController.owningViewController = self;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsController];
        if (PSCIsIPad()) {
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:navController];
            [self.popoverController presentPopoverFromBarButtonItem:self.navigationItem.leftBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }else {
            [self presentModalViewControllerWithCloseButton:settingsController animated:YES];
        }
    }
}

// Calculates where the document view will be on screen.
- (CGRect)magazinePageCoordinatesWithDoublePageCurl:(BOOL)doublePageCurl {
    CGRect newFrame = self.view.frame;
    CGRect navBarFrame = self.navigationController.navigationBar.frame;

    // Compensate for transparent statusbar. Change this var if you're not using PSPDFStatusBarStyleLightContentHideOnIpad.
    PSC_IF_PRE_IOS7(newFrame.origin.y -= navBarFrame.size.height;
                    newFrame.size.height += navBarFrame.size.height;
                    BOOL iPadFadesOutStatusBar = YES;
                    if (!PSCIsIPad() || iPadFadesOutStatusBar) {
                        CGRect statusBarFrame = UIApplication.sharedApplication.statusBarFrame;
                        BOOL isPortrait = UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication.statusBarOrientation);
                        CGFloat statusBarHeight = isPortrait ? statusBarFrame.size.height : statusBarFrame.size.width;
                        newFrame.origin.y -= statusBarHeight;
                        newFrame.size.height += statusBarHeight;
                    })

    // Animation needs to be different if we are in pageCurl mode.
    if (doublePageCurl) {
        newFrame.size.width /= 2;
        newFrame.origin.x += newFrame.size.width;
    }
    return newFrame;
}

- (UIImage *)imageForMagazine:(PSCMagazine *)magazine {
    if (!magazine) return nil;

    NSUInteger lastPage = magazine.lastViewState.page;
    UIImage *coverImage = [PSPDFCache.sharedCache imageFromDocument:magazine page:lastPage size:UIScreen.mainScreen.bounds.size options:PSPDFCacheOptionDiskLoadSync|PSPDFCacheOptionRenderSync|PSPDFCacheOptionMemoryStoreAlways];
    return coverImage;
}

// Open magazine with a nice animation.
- (BOOL)openMagazine:(PSCMagazine *)magazine animated:(BOOL)animated cellIndex:(NSUInteger)cellIndex {
    self.lastOpenedMagazine = magazine;
    [self.searchBar resignFirstResponder];

    // Speed up displaying with parsing several things PSPDFViewController needs.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [magazine fillCache];
    });

    PSCKioskPDFViewController *pdfController = [[PSCKioskPDFViewController alloc] initWithDocument:magazine];

    // Try to get full-size image, if that fails try thumbnail.
    UIImage *coverImage = [self imageForMagazine:magazine];
    if (animated && coverImage && !magazine.isLocked) {
        PSCImageGridViewCell *cell = (PSCImageGridViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:cellIndex inSection:0]];
        cell.hidden = YES;
        CGRect cellCoords = [cell.imageView convertRect:cell.imageView.bounds toView:self.view];
        UIImageView *coverImageView = [[UIImageView alloc] initWithImage:coverImage];
        coverImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        coverImageView.frame = cellCoords;

        coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:coverImageView];
        self.magazineView = coverImageView;
        _animationCellIndex = cellIndex;

        // Add a smooth status bar transition on the iPhone
        if (!PSCIsIPad()) {
            PSC_IF_IOS7_OR_GREATER([UIApplication.sharedApplication setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];)
        }

        // If we have a different page, fade to that page.
        UIImageView *targetPageImageView = nil;
        if (pdfController.page != 0 && !pdfController.isDoublePageMode) {
            UIImage *targetPageImage = [PSPDFCache.sharedCache imageFromDocument:magazine page:pdfController.page size:UIScreen.mainScreen.bounds.size options:PSPDFCacheOptionDiskLoadSync|PSPDFCacheOptionRenderSkip|PSPDFCacheOptionMemoryStoreAlways];
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
            self.collectionView.transform = CGAffineTransformMakeScale(0.97f, 0.97f);

            _animationDoubleWithPageCurl = pdfController.pageTransition == PSPDFPageTransitionCurl && [pdfController isDoublePageMode];
            CGRect newFrame = [self magazinePageCoordinatesWithDoublePageCurl:_animationDoubleWithPageCurl];
            coverImageView.frame = newFrame;
            targetPageImageView.alpha = 1.f;

            self.collectionView.alpha = 0.0f;

        } completion:^(BOOL finished) {
            if (!PSCIsUIKitFlatMode()) [self.navigationController.navigationBar.layer addAnimation:PSCFadeTransition() forKey:kCATransition];
            [self.navigationController pushViewController:pdfController animated:NO];

            cell.hidden = NO;
        }];
    }else {
        if (animated) {
            // Add fake data so that we animate back.
            _animateViewWillAppearWithFade = YES;
            if (!PSCIsUIKitFlatMode()) [self.navigationController.view.layer addAnimation:PSCFadeTransition() forKey:kCATransition];
        }
        [self.navigationController pushViewController:pdfController animated:NO];
    }

    return YES;
}

- (void)diskDataLoaded {
    // Update indicator
    [self setProgressIndicatorVisible:PSCStoreManager.sharedStoreManager.isDiskDataLoaded animated:YES];

    // Not finished yet? return early.
    if (PSCStoreManager.sharedStoreManager.magazineFolders.count == 0) return;

    // If we're in plain mode, pre-set a folder.
    if (PSPDFStoreManagerPlain) self.magazineFolder = PSCStoreManager.sharedStoreManager.magazineFolders.lastObject;

    // Preload all magazines. (copy to prevent mutation errors)
    NSArray *magazines = [self.magazineFolder.magazines copy];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        for (PSCMagazine *magazine in magazines) {
            [PSPDFCache.sharedCache imageFromDocument:magazine page:0 size:kPSCLargeThumbnailSize options:PSPDFCacheOptionDiskLoadSkip|PSPDFCacheOptionRenderQueueBackground|PSPDFCacheOptionMemoryStoreNever];
        }
    });

    [self updateGrid];
}

- (BOOL)canEditCell:(PSCImageGridViewCell *)cell {
    BOOL editing = self.isEditing;
    if (editing) {
        if (cell.magazine) {
            editing =  cell.magazine.isDownloading || (cell.magazine.isAvailable && cell.magazine.isDeletable);
        }else {
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
    }else {
        _filteredData = PSCStoreManager.sharedStoreManager.magazineFolders;
    }

    NSString *searchString = _searchBar.text;
    if ([searchString length]) { // title CONTAINS[cd] '%@' ||
        NSString *predicate = [NSString stringWithFormat:@"fileURL.path CONTAINS[cd] '%@'", searchString];
        _filteredData = [_filteredData filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicate]];
    }else {
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
    }else {
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

    BOOL canDelete = YES;
    __unused NSString *message = nil;
    if (folder.magazines.count > 1 && !self.magazineFolder) {
        // Clang doesn't understand that we translate to strings with extra arguments.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wformat-extra-args"
        message = [NSString stringWithFormat:_(@"DeleteMagazineMultiple"), folder.title, folder.magazines.count];
    }else {
        message = [NSString stringWithFormat:_(@"DeleteMagazineSingle"), magazine.title];
#pragma clang diagnostic pop
        if (PSCShouldShowDeleteConfirmationDialog) {
            canDelete = magazine.isAvailable || magazine.isDownloading;
        }
    }

    dispatch_block_t deleteBlock = ^{
        if (self.magazineFolder) {
            if (magazine.isDownloading) {
                [PSCStoreManager.sharedStoreManager cancelDownloadForMagazine:magazine];
            }else {
                [PSCStoreManager.sharedStoreManager deleteMagazine:magazine];
            }
        }else {
            [PSCStoreManager.sharedStoreManager deleteMagazineFolder:folder];
        }
    };

    if (PSCShouldShowDeleteConfirmationDialog) {
        if (canDelete) {
            PSPDFActionSheet *deleteAction = [[PSPDFActionSheet alloc] initWithTitle:message];
            deleteAction.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [deleteAction setDestructiveButtonWithTitle:_(@"Delete") block:deleteBlock];
            [deleteAction setCancelButtonWithTitle:_(@"Cancel") block:nil];
            CGRect cellFrame = [cell convertRect:cell.imageView.frame toView:self.view];
            [deleteAction showFromRect:cellFrame inView:self.view animated:YES];
        }
    }else {
        deleteBlock();
    }
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
    }else {
        folder = (_filteredData)[indexPath.item];
        magazine = [folder firstMagazine];
    }

    PSCLog(@"Magazine selected: %tu %@", indexPath.item, magazine);

    if (folder.magazines.count == 1 || self.magazineFolder) {
        if (magazine.isDownloading) {
            [[[UIAlertView alloc] initWithTitle:PSPDFAppName()
                                        message:_(@"Item is currently downloading.")
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
    }else {
        PSCGridViewController *gridController = [[PSCGridViewController alloc] initWithMagazineFolder:folder];

        // A full-page-fade animation doesn't work very well on iPad. (under a ux aspect; technically it's fine)
        if (!PSCIsIPad()) {
            CATransition *transition = PSCFadeTransitionWithDuration(0.3f);
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
    if (self.isSearchModeActive) return; // don't animate if we're in search mode

    if (!self.magazineFolder) {
        NSUInteger cellIndex = [PSCStoreManager.sharedStoreManager.magazineFolders indexOfObject:magazineFolder];
        if (cellIndex != NSNotFound) {
            [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:cellIndex inSection:0]]];
        }else {
            PSCLog(@"index not found for %@", magazineFolder);
        }
    }
}

- (void)magazineStoreFolderAdded:(PSCMagazineFolder *)magazineFolder {
    if (self.isSearchModeActive) return; // don't animate if we're in search mode

    if (!self.magazineFolder) {
        NSUInteger cellIndex = [PSCStoreManager.sharedStoreManager.magazineFolders indexOfObject:magazineFolder];
        if (cellIndex != NSNotFound) {
            [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:cellIndex inSection:0]]];
        }else {
            PSCLog(@"index not found for %@", magazineFolder);
        }
    }
}

- (void)magazineStoreFolderModified:(PSCMagazineFolder *)magazineFolder {
    if (self.isSearchModeActive) return; // don't animate if we're in search mode

    if (!self.magazineFolder) {
        NSUInteger cellIndex = [PSCStoreManager.sharedStoreManager.magazineFolders indexOfObject:magazineFolder];
        if (cellIndex != NSNotFound) {
            [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:cellIndex inSection:0]]];
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
    if (self.isSearchModeActive) return; // don't animate if we're in search mode

    if (self.magazineFolder) {
        NSUInteger cellIndex = [self.magazineFolder.magazines indexOfObject:magazine];
        if (cellIndex != NSNotFound) {
            [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:cellIndex inSection:0]]];
        }else {
            PSCLog(@"index not found for %@", magazine);
        }
    }
}

- (void)magazineStoreMagazineAdded:(PSCMagazine *)magazine {
    if (self.isSearchModeActive) return; // don't animate if we're in search mode

    if (self.magazineFolder) {
        NSUInteger cellIndex = [self.magazineFolder.magazines indexOfObject:magazine];
        if (cellIndex != NSNotFound) {
            [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:cellIndex inSection:0]]];
        }else {
            PSCLog(@"index not found for %@", magazine);
        }
    }
}

- (void)magazineStoreMagazineModified:(PSCMagazine *)magazine {
    if (self.isSearchModeActive) return; // don't animate if we're in search mode

    if (self.magazineFolder) {
        NSUInteger cellIndex = [self.magazineFolder.magazines indexOfObject:magazine];
        if (cellIndex != NSNotFound) {
            [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:cellIndex inSection:0]]];
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
    if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_7_0) return; // stop if we're on iOS 6.

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
