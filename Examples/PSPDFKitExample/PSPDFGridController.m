//
//  PSPDFGridController.m
//  PSPDFKitExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PSPDFGridController.h"
#import "PSPDFImageGridViewCell.h"
#import "PSPDFMagazine.h"
#import "PSPDFMagazineFolder.h"
#import "PSPDFExampleViewController.h"
#import "PSPDFSettingsController.h"
#import "PSPDFDownload.h"
#import "AppDelegate.h"
#import "PSActionSheet.h"
#import "PSPDFImageGridViewCell.h"
#import "PSPDFQuickLookViewController.h"
#import "PSPDFShadowView.h"

#define kPSPDFGridFadeAnimationDuration 0.3f

// the delete button target is small enough that we don't need to ask for confirmation.
#define kPSPDFShouldShowDeleteConfirmationDialog NO

@interface PSPDFGridController()
@property(nonatomic, assign, getter=isEditMode) BOOL editMode;
@property(nonatomic, strong) UIView *magazineView;
@property(nonatomic, strong) PSPDFMagazineFolder *magazineFolder;
@property(nonatomic, strong) PSPDFShadowView *backgroundView;
@end

@implementation PSPDFGridController

@synthesize gridView = gridView_;
@synthesize magazineFolder = magazineFolder_;
@synthesize magazineView = magazineView_;
@synthesize editMode = editMode_;
@synthesize backgroundView = backgroudView_;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)closeModalView {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)presentModalViewControllerWithCloseButton:(UIViewController *)controller animated:(BOOL)animated {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:PSPDFLocalize(@"Close") style:UIBarButtonItemStyleBordered target:self action:@selector(closeModalView)];
    [self presentModalViewController:navController animated:animated];
}

- (void)optionsButtonPressed {
    if ([self.popoverController.contentViewController isKindOfClass:[PSPDFSettingsController class]]) {
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
    }else {
        PSPDFSettingsController *cacheSettingsController = [[PSPDFSettingsController alloc] init];
        if (PSIsIpad()) {
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:cacheSettingsController];
            [self.popoverController presentPopoverFromBarButtonItem:self.navigationItem.leftBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }else {
            [self presentModalViewControllerWithCloseButton:cacheSettingsController animated:YES];
        }
    }
}

// open magazine with nice animation
- (BOOL)openMagazine:(PSPDFMagazine *)magazine animated:(BOOL)animated cellIndex:(NSUInteger)cellIndex {
#ifdef kPSPDFQuickLookEngineEnabled
    PSPDFQuickLookViewController *previewController = [[[PSPDFQuickLookViewController alloc] initWithDocument:magazine] autorelease];
    [self presentModalViewController:previewController animated:YES];
    return YES;
#endif
    
    PSPDFExampleViewController *pdfController = [[PSPDFExampleViewController alloc] initWithDocument:magazine];
    UIImage *coverImage = [[PSPDFCache sharedPSPDFCache] cachedImageForDocument:magazine page:0 size:PSPDFSizeThumbnail];
    if (animated && coverImage) {
        PSPDFGridViewCell *cell = [self.gridView cellForItemAtIndex:cellIndex];
        cell.hidden = YES;
        CGRect cellCoords = [self.gridView convertRect:cell.frame toView:self.view];
        UIImageView *coverImageView = [[UIImageView alloc] initWithImage:coverImage];
        coverImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        coverImageView.frame = CGRectMake(0, 0, cellCoords.size.width, cellCoords.size.height);
        
        UIView *magazineView = [[UIView alloc] initWithFrame:cellCoords];
        [magazineView addSubview:coverImageView];
        
        coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:magazineView];
        self.magazineView = magazineView;
        baseGridPosition_ = cellCoords;
        
        // add a smooth status bar transition on the iPhone
        if (!PSIsIpad()) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
        }
        
        [UIView animateWithDuration:0.3f delay:0.f options:0 animations:^{
            self.navigationController.navigationBar.alpha = 0.f;
            backgroudView_.shadowEnabled = NO;
            self.gridView.transform = CGAffineTransformMakeScale(0.97, 0.97);
            
            CGRect newFrame = self.view.frame;
            newFrame.origin.y -= self.navigationController.navigationBar.frame.size.height;            
            newFrame.size.height += self.navigationController.navigationBar.frame.size.height;
            
            // compensate for transparent statusbar
            if (!PSIsIpad()) {
                CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
                CGFloat statusBarHeight = PSIsPortrait() ? statusBarFrame.size.height : statusBarFrame.size.width;
                newFrame.origin.y -= statusBarHeight;
                newFrame.size.height += statusBarHeight;
            }
            
            // animation needs to be different if we are in pageCurl mode
            if (pdfController.pageCurlEnabled && [pdfController isDualPageMode]) {
                newFrame.size.width /= 2;
                newFrame.origin.x += newFrame.size.width;
            }
            
            magazineView.frame = newFrame;
            self.gridView.alpha = 0.0f;
        } completion:^(BOOL finished) {            
            // fade for UINavigationBar
            CATransition* barTransition = [CATransition animation];
            barTransition.duration = 0.25f;
            barTransition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            barTransition.type = kCATransitionFade;
            barTransition.subtype = kCATransitionFromTop;
            [self.navigationController.navigationBar.layer addAnimation:barTransition forKey:kCATransition];
            [self.navigationController pushViewController:pdfController animated:NO];
            
            cell.hidden = NO;
        }];  
    }else {
        [self.navigationController pushViewController:pdfController animated:NO];
    }
    
    return YES;
}

- (void)diskDataLoaded {
    // not finished yet? return early.
    if ([[PSPDFStoreManager sharedPSPDFStoreManager].magazineFolders count] == 0) {
        return;
    }
    
    // if we're in plain mode, pre-set a folder
    if (kPSPDFStoreManagerPlain) {
        self.magazineFolder = [[PSPDFStoreManager sharedPSPDFStoreManager].magazineFolders lastObject];
    }
    
    [self.gridView reloadData];
}

- (void)editButtonPressed {
    if (self.isEditMode) {
        self.editMode = NO;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:PSPDFLocalize(@"Edit")
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(editButtonPressed)];    
        
    }else {
        self.editMode = YES;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:PSPDFLocalize(@"Done")
                                                                                  style:UIBarButtonItemStyleDone
                                                                                 target:self
                                                                                 action:@selector(editButtonPressed)];    
    }
}

- (void)setEditMode:(BOOL)editMode {
    editMode_ = editMode;    
    [self.gridView setEditing:editMode animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if ((self = [super init])) {
        self.title = @"PSPDFKit Kiosk Example";   
        
        // custom back button for smaller wording
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:PSPDFLocalize(@"Kiosk") style:UIBarButtonItemStylePlain target:nil action:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(diskDataLoaded) name:kPSPDFStoreDiskLoadFinishedNotification object:nil];
    }
    return self;
}

- (id)initWithMagazineFolder:(PSPDFMagazineFolder *)aMagazineFolder {
    if ((self = [self init])) {
        self.title = aMagazineFolder.title;
        magazineFolder_ = aMagazineFolder;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

- (void)updateGridForOrientation {
    gridView_.itemSpacing = UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ? 28 : 15;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.magazineFolder) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:PSPDFLocalize(@"Edit")
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(editButtonPressed)];
    }
    
    UIBarButtonItem *optionButton = [[UIBarButtonItem alloc] initWithTitle:PSPDFLocalize(@"Options")
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(optionsButtonPressed)];
    
    // only show the option button if we're at root (else we hide the back button)
    if ([self.navigationController.viewControllers objectAtIndex:0] == self) {
        self.navigationItem.leftBarButtonItem = optionButton;
    }else {
        // iOS5 supports easy additional buttons next to a native back button
        PSPDF_IF_IOS5_OR_GREATER(self.navigationItem.leftBarButtonItem = optionButton;
                                 self.navigationItem.leftItemsSupplementBackButton = YES;);
    }
    
    // use custom view to match background with PSPDFViewController
    CGFloat toolbarHeight = self.navigationController.navigationBar.frame.size.height;
    self.backgroundView = [[PSPDFShadowView alloc] initWithFrame:CGRectMake(0, -toolbarHeight, self.view.bounds.size.width, self.view.bounds.size.height + toolbarHeight)];
    backgroudView_.shadowOffset = toolbarHeight;
    backgroudView_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroudView_.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"linen_texture_dark"]];
    [self.view addSubview:backgroudView_];
    
    self.gridView = [[PSPDFGridView alloc] initWithFrame:CGRectZero];
    self.gridView.backgroundColor = [UIColor clearColor];
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.gridView.autoresizesSubviews = YES;
    self.gridView.actionDelegate = self;
    self.gridView.centerGrid = YES;
    self.gridView.layoutStrategy = [PSPDFGridViewLayoutStrategyFactory strategyFromType:PSPDFGridViewLayoutVertical];
    NSUInteger spacing = 20;
    self.gridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    [self.view addSubview:self.gridView];
    self.gridView.frame = self.view.bounds;
    [self updateGridForOrientation];
    self.gridView.dataSource = self; // auto-reloads
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.gridView.actionDelegate = nil;
    self.gridView.dataSource = nil;
    self.gridView = nil;
    self.backgroundView = nil;
}

// default style
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    // only one delegate at a time (only one grid is displayed at a time)
    [PSPDFStoreManager sharedPSPDFStoreManager].delegate = self;
    
    // call anyway - if store is done before we get initialized, don't fail
    [self diskDataLoaded];
    
    // ensure everything is up to date (we could change magazines in other controllers)
    [self.gridView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.magazineView) {
        [UIView animateWithDuration:0.3f delay:0.f options:0 animations:^{
            self.gridView.transform = CGAffineTransformIdentity;
            self.magazineView.frame = baseGridPosition_;
            self.gridView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [self.magazineView removeFromSuperview];
            self.magazineView = nil;
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [PSPDFStoreManager sharedPSPDFStoreManager].delegate = nil;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    PSPDF_IF_PRE_IOS5([self updateGridForOrientation];) // viewWillLayoutSubviews is iOS5 only
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self updateGridForOrientation];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)updateGrid {
    [self.gridView reloadData];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFGridViewDataSource

- (NSInteger)numberOfItemsInPSPDFGridView:(PSPDFGridView *)gridView {    
    NSUInteger count;
    if (self.magazineFolder) {
        count = [self.magazineFolder.magazines count];
    }else {
        count = [[PSPDFStoreManager sharedPSPDFStoreManager].magazineFolders count];
    }
    
    return count;
}

- (CGSize)PSPDFGridView:(PSPDFGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation {
    return PSIsIpad() ? CGSizeMake(170, 220) : CGSizeMake(82, 120);
}

- (PSPDFGridViewCell *)PSPDFGridView:(PSPDFGridView *)gridView cellForItemAtIndex:(NSInteger)cellIndex {
    CGSize size = [self PSPDFGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    PSPDFImageGridViewCell *cell = (PSPDFImageGridViewCell *)[self.gridView dequeueReusableCell];
    if (!cell) {
        cell = [[PSPDFImageGridViewCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    }
    
    if (self.magazineFolder) {
        cell.magazine = (PSPDFMagazine *)[self.magazineFolder.magazines objectAtIndex:cellIndex];
    }else {
        cell.magazineFolder = [[PSPDFStoreManager sharedPSPDFStoreManager].magazineFolders objectAtIndex:cellIndex];  
    }
    
    return cell;
}

- (BOOL)PSPDFGridView:(PSPDFGridView *)gridView canDeleteItemAtIndex:(NSInteger)index {
    BOOL canDelete;
    if (!self.magazineFolder) {
        NSArray *fixedMagazines = [self.magazineFolder.magazines filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isDeletable = NO || isAvailable = NO || isDownloading = YES"]];
        canDelete = [fixedMagazines count] == 0;
    }else {
        PSPDFMagazine *magazine = [self.magazineFolder.magazines objectAtIndex:index];
        canDelete = magazine.isAvailable && !magazine.isDownloading && magazine.isDeletable;
    }
    return canDelete;
}

- (void)PSPDFGridView:(PSPDFGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index {
    PSPDFMagazine *magazine;
    PSPDFMagazineFolder *folder;
    
    if (self.magazineFolder) {
        folder = self.magazineFolder;
        magazine = [self.magazineFolder.magazines objectAtIndex:index];
    }else {
        folder = [[PSPDFStoreManager sharedPSPDFStoreManager].magazineFolders objectAtIndex:index];
        magazine = [folder firstMagazine];
    }
    
    BOOL canDelete = YES;
    NSString *message = nil;
    if ([folder.magazines count] > 1 && !self.magazineFolder) {
        message = [NSString stringWithFormat:PSPDFLocalize(@"DeleteMagazineMultiple"), folder.title, [folder.magazines count]];
    }else {
        message = [NSString stringWithFormat:PSPDFLocalize(@"DeleteMagazineSingle"), magazine.title];
        if (kPSPDFShouldShowDeleteConfirmationDialog) {
            canDelete = magazine.isAvailable || magazine.isDownloading;
        }
    }
    
    PSPDFBasicBlock deleteBlock = ^{
        if (self.magazineFolder) {
            [[PSPDFStoreManager sharedPSPDFStoreManager] deleteMagazine:magazine];
        }else {
            [[PSPDFStoreManager sharedPSPDFStoreManager] deleteMagazineFolder:folder];
        }
    };
    
    if (kPSPDFShouldShowDeleteConfirmationDialog) {
        if (canDelete) {
            PSActionSheet *deleteAction = [PSActionSheet sheetWithTitle:message];
            deleteAction.sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [deleteAction setDestructiveButtonWithTitle:PSPDFLocalize(@"Delete") block:^{
                deleteBlock();
                // TODO should re-calculate index here.
                [self.gridView removeObjectAtIndex:index withAnimation:PSPDFGridViewItemAnimationFade];
            }];
            [deleteAction setCancelButtonWithTitle:PSPDFLocalize(@"Cancel") block:nil];
            PSPDFImageGridViewCell *cell = (PSPDFImageGridViewCell *)[gridView cellForItemAtIndex:index];
            CGRect cellFrame = [cell convertRect:cell.imageView.frame toView:self.view];
            [deleteAction showFromRect:cellFrame inView:self.view animated:YES];
        }
    }else {
        deleteBlock();
        if (magazine.url) {
            // magazines with URL can't really be deleted, just delete data & fade to gray.
            [self.gridView reloadObjectAtIndex:index withAnimation:PSPDFGridViewItemAnimationFade];
        }else {
            [self.gridView removeObjectAtIndex:index withAnimation:PSPDFGridViewItemAnimationFade];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFGridViewActionDelegate

- (void)PSPDFGridView:(PSPDFGridView *)gridView didTapOnItemAtIndex:(NSInteger)gridIndex {
    PSPDFMagazine *magazine;
    PSPDFMagazineFolder *folder;
    
    if (self.magazineFolder) {
        folder = self.magazineFolder;
        magazine = [self.magazineFolder.magazines objectAtIndex:gridIndex];
    }else {
        folder = [[PSPDFStoreManager sharedPSPDFStoreManager].magazineFolders objectAtIndex:gridIndex];
        magazine = [folder firstMagazine];
    }
    
    PSELog(@"Magazine selected: %d %@", gridIndex, magazine);    
    
    if ([folder.magazines count] == 1 || self.magazineFolder) {
        if (magazine.isDownloading) {
            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:PSPDFLocalize(@"Item is currently downloading.")]
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:PSPDFLocalize(@"OK")
                              otherButtonTitles:nil] show];
        } else if(!magazine.isAvailable && !magazine.isDownloading) {
            [[PSPDFStoreManager sharedPSPDFStoreManager] downloadMagazine:magazine];
        } else {
            if (magazine.isLocked) {
                PSPDF_IF_IOS5_OR_GREATER(
                // opening password protected pdf only works on iOS5 here, for convenience of the UIAlertView.alertViewStyle
                PSPDFAlertView *alertView = [PSPDFAlertView alertWithTitle:@"PDF Document Password"];
                alertView.alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
                [alertView setCancelButtonWithTitle:PSPDFLocalize(@"Cancel") block:nil];
                __ps_weak PSPDFAlertView *weakAlertView = alertView;
                [alertView addButtonWithTitle:PSPDFLocalize(@"Open") block:^{
                    NSString *password = [weakAlertView.alertView textFieldAtIndex:0].text;
                    BOOL success = [magazine unlockWithPassword:password];
                    
                    if (success) {
                        magazine.password = password;                    
                        [self openMagazine:magazine animated:YES cellIndex:gridIndex];
                    }else {
                        PSPDFAlertView *alert = [PSPDFAlertView alertWithTitle:@"Failed to unlock PDF"];
                        [alert show];
                    }
                }];
                [alertView show];
                )
                
                PSPDF_IF_PRE_IOS5([[[UIAlertView alloc] initWithTitle:@"" message:@"Opening password protected PDFs is not implemented on iOS4." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];)
            }
            else {
                [self openMagazine:magazine animated:YES cellIndex:gridIndex];
            }
        }
    }else {
        PSPDFGridController *gridController = [[PSPDFGridController alloc] initWithMagazineFolder:folder];
        
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

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFStoreManagerDelegate

- (void)magazineStoreBeginUpdate {}
- (void)magazineStoreEndUpdate {}

- (void)magazineStoreFolderDeleted:(PSPDFMagazineFolder *)magazineFolder {
    if (!self.magazineFolder) {
        NSUInteger cellIndex = [[PSPDFStoreManager sharedPSPDFStoreManager].magazineFolders indexOfObject:magazineFolder];
        if (cellIndex != NSNotFound) {
            [self.gridView removeObjectAtIndex:cellIndex withAnimation:PSPDFGridViewItemAnimationFade];
        }else {
            PSELog(@"index not found for %@", magazineFolder);
        }
    }
}

- (void)magazineStoreFolderAdded:(PSPDFMagazineFolder *)magazineFolder {
    if (!self.magazineFolder) {
        NSUInteger cellIndex = [[PSPDFStoreManager sharedPSPDFStoreManager].magazineFolders indexOfObject:magazineFolder];
        if (cellIndex != NSNotFound) {
            [self.gridView insertObjectAtIndex:cellIndex withAnimation:PSPDFGridViewItemAnimationFade];
        }else {
            PSELog(@"index not found for %@", magazineFolder);
        }
    }
}

- (void)magazineStoreFolderModified:(PSPDFMagazineFolder *)magazineFolder {
    if (!self.magazineFolder) {
        NSUInteger cellIndex = [[PSPDFStoreManager sharedPSPDFStoreManager].magazineFolders indexOfObject:magazineFolder];
        if (cellIndex != NSNotFound) {
            [self.gridView reloadObjectAtIndex:cellIndex withAnimation:PSPDFGridViewItemAnimationFade];
        }else {
            PSELog(@"index not found for %@", magazineFolder);
        }
    }
}

- (void)openMagazine:(PSPDFMagazine *)magazine {
    NSUInteger cellIndex = [self.magazineFolder.magazines indexOfObject:magazine];
    if (cellIndex != NSNotFound) {
        [self openMagazine:magazine animated:YES cellIndex:cellIndex];
    }else {
        PSELog(@"index not found for %@", magazine);
    }
}

- (void)magazineStoreMagazineDeleted:(PSPDFMagazine *)magazine {
    if (self.magazineFolder) {
        NSUInteger cellIndex = [self.magazineFolder.magazines indexOfObject:magazine];
        if (cellIndex != NSNotFound) {
            [self.gridView removeObjectAtIndex:cellIndex withAnimation:PSPDFGridViewItemAnimationFade];
        }else {
            PSELog(@"index not found for %@", magazine);
        }
    }    
}

- (void)magazineStoreMagazineAdded:(PSPDFMagazine *)magazine {
    [self.gridView reloadData];
    // TODO: PSPDFGridView has some problems with inserting elements; will be fixed soon.
    /*
     if (self.magazineFolder) {
     NSUInteger cellIndex = [self.magazineFolder.magazines indexOfObject:magazine];
     if (cellIndex != NSNotFound) {
     [self.gridView insertObjectAtIndex:cellIndex withAnimation:PSPDFGridViewItemAnimationFade];
     }else {
     PSELog(@"index not found for %@", magazine);
     }
     } */       
}

- (void)magazineStoreMagazineModified:(PSPDFMagazine *)magazine {
    if (self.magazineFolder) {
        NSUInteger cellIndex = [self.magazineFolder.magazines indexOfObject:magazine];
        if (cellIndex != NSNotFound) {
            [self.gridView reloadObjectAtIndex:cellIndex withAnimation:PSPDFGridViewItemAnimationFade];
        }else {
            PSELog(@"index not found for %@", magazine);
        }
    }    
}

@end
