//
//  PSPDFGridController.m
//  PSPDFKitExample
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFGridController.h"
#import "PSPDFImageGridViewCell.h"
#import "PSPDFMagazine.h"
#import "PSPDFMagazineFolder.h"
#import "PSPDFExampleViewController.h"
#import "PSPDFSettingsController.h"
#import "PSPDFDownload.h"
#import "AppDelegate.h"
#import "PSActionSheet.h"

#import "PSPDFQuickLookViewController.h"

#define kPSPDFGridFadeAnimationDuration 0.3f

@interface PSPDFGridController()
@property(nonatomic, assign, getter=isEditMode) BOOL editMode;
@property(nonatomic, strong) UIView *magazineView;
@property(nonatomic, strong) PSPDFMagazineFolder *magazineFolder;
@end

@implementation PSPDFGridController

@synthesize gridView = gridView_;
@synthesize magazineFolder = magazineFolder_;
@synthesize magazineView = magazineView_;
@synthesize editMode = editMode_;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)closeModalView {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)presentModalViewControllerWithCloseButton:(UIViewController *)controller animated:(BOOL)animated; {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(closeModalView)];
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

/*
 - (CGPathRef)renderPaperCurl:(UIView*)imgView {
 CGSize size = imgView.bounds.size;
 CGFloat curlFactor = 15.0f;
 CGFloat shadowDepth = 5.0f;
 
 UIBezierPath *path = [UIBezierPath bezierPath];
 [path moveToPoint:CGPointMake(0.0f, 0.0f)];
 [path addLineToPoint:CGPointMake(size.width, 0.0f)];
 [path addLineToPoint:CGPointMake(size.width, size.height + shadowDepth)];
 [path addCurveToPoint:CGPointMake(0.0f, size.height + shadowDepth)
 controlPoint1:CGPointMake(size.width - curlFactor, size.height + shadowDepth - curlFactor)
 controlPoint2:CGPointMake(curlFactor, size.height + shadowDepth - curlFactor)];
 
 return path.CGPath;
 }*/

// open magazine with nice animation
- (BOOL)openMagazine:(PSPDFMagazine *)magazine animated:(BOOL)animated cellIndex:(NSUInteger)cellIndex {
#ifdef kPSPDFQuickLookEngineEnabled
    PSPDFQuickLookViewController *previewController = [[[PSPDFQuickLookViewController alloc] initWithDocument:magazine] autorelease];
    [self presentModalViewController:previewController animated:YES];
    return YES;
#endif
    
    PSPDFExampleViewController *pdfController = [[PSPDFExampleViewController alloc] initWithDocument:magazine];
    //UINavigationController *pdfNavController = [[UINavigationController alloc] initWithRootViewController:pdfController];
    //pdfNavController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    if (animated) {
        UIImage *coverImage = [[PSPDFCache sharedPSPDFCache] cachedImageForDocument:magazine page:0 size:PSPDFSizeThumbnail];
        AQGridViewCell *cell = [self.gridView cellForItemAtIndex:cellIndex];
        CGRect cellCoords = [self.gridView convertRect:cell.frame toView:self.view];
        UIImageView *coverImageView = [[UIImageView alloc] initWithImage:coverImage];
        coverImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        coverImageView.frame = CGRectMake(0, 0, cellCoords.size.width, cellCoords.size.height);
        
        UIView *magazineView = [[UIView alloc] initWithFrame:cellCoords];
        [magazineView addSubview:coverImageView];
        
        /*
         CALayer *shadowLayer = magazineView.layer;
         shadowLayer.shadowColor = [UIColor blackColor].CGColor;
         shadowLayer.shadowOpacity = 0.7f;
         shadowLayer.shadowOffset = PSIsIpad() ? CGSizeMake(10.0f, 10.0f) : CGSizeMake(8.0f, 8.0f); 
         shadowLayer.shadowRadius = 4.0f;
         shadowLayer.masksToBounds = NO;
         shadowLayer.shadowPath = [self renderPaperCurl:magazineView];
         */
        
        coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:magazineView];
        self.magazineView = magazineView;
        baseGridPosition_ = cellCoords;
        
        [UIView animateWithDuration:0.3f delay:0.f options:0 animations:^{
            CGRect newFrame = self.view.frame;
            newFrame.origin.y -= self.navigationController.navigationBar.height;
            newFrame.size.height += self.navigationController.navigationBar.height;
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

            // fade for content
            /*
            CATransition* transition = [CATransition animation];
            transition.duration = 0.1f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionFade;
            transition.subtype = kCATransitionFromTop;
            [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
             */
            
            [self.navigationController pushViewController:pdfController animated:NO];
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
    
    // if lastNumbersOfItemsInGridView_ is > 0, grid is already loaded!
    if(lastNumbersOfItemsInGridView_ == 0) {
        // check if we are flattened (no folders) or not
        NSMutableIndexSet *indexSet;
        if (kPSPDFStoreManagerPlain) {
            self.magazineFolder = [[PSPDFStoreManager sharedPSPDFStoreManager].magazineFolders lastObject];
            indexSet = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.magazineFolder.magazines count])];
        }else {
            indexSet = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [[PSPDFStoreManager sharedPSPDFStoreManager].magazineFolders count])]; 
        }
        // if we're in init, this is nil and just ignored.
        if ([indexSet count]) {
            [self.gridView insertItemsAtIndices:indexSet withAnimation:AQGridViewItemAnimationFade];
            [self.gridView scrollToItemAtIndex:0 atScrollPosition:AQGridViewScrollPositionTop animated:NO];
        }
    }
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
    editMode_ = editMode;
    
    NSArray *visibleCells = [self.gridView visibleCells];
    for (PSPDFImageGridViewCell *cell in visibleCells) {
        if ([cell isKindOfClass:[PSPDFImageGridViewCell class]]) {
            cell.showDeleteImage = editMode;
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if ((self = [super init])) {
        self.title = @"PSPDFKit Example";   
        
        // custom back button for smaller wording
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Kiosk", @"") style:UIBarButtonItemStylePlain target:nil action:nil];
        
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.magazineFolder) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", @"")
                                                                                   style:UIBarButtonItemStyleBordered
                                                                                  target:self
                                                                                  action:@selector(editButtonPressed)];
    }
    
    UIBarButtonItem *optionButton = [[UIBarButtonItem alloc] initWithTitle:@"Options"
                                                                               style:UIBarButtonItemStyleBordered
                                                                              target:self
                                                                              action:@selector(optionsButtonPressed)];
    
    // only show the option button if we're at root (else we hide the back button)
    if ([self.navigationController.viewControllers objectAtIndex:0] == self) {
        self.navigationItem.leftBarButtonItem = optionButton;
    }else {
        // iOS5 supports easy additional buttons next to a native back button
        PSPDF_IF_IOS5_OR_GREATER(
                                 self.navigationItem.leftBarButtonItem = optionButton;
                                 self.navigationItem.leftItemsSupplementBackButton = YES;
        );
    }
    
    // use custom view to match background with PSPDFViewController
    CGFloat toolbarHeight = self.navigationController.navigationBar.frame.size.height;
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -toolbarHeight, self.view.bounds.size.width, self.view.bounds.size.height + toolbarHeight)];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"linen_texture_dark"]];
    backgroundView.opaque = YES;
    [self.view addSubview:backgroundView];
    
    self.gridView = [[PSPDFGridView alloc] initWithFrame:CGRectZero];
    self.gridView.backgroundColor = [UIColor clearColor];
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.gridView.autoresizesSubviews = YES;
    self.gridView.delegate = self;
    self.gridView.dataSource = self;  
    self.gridView.layoutDirection = AQGridViewLayoutDirectionVertical;
    self.gridView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [self.view addSubview:self.gridView];
    self.gridView.frame = self.view.bounds;
    [self.gridView reloadData];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.gridView.delegate = nil;
    self.gridView.dataSource = nil;
    self.gridView = nil;
}

// default style
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    if ([self.gridView indexOfSelectedItem] != NSNotFound) {
        [self.gridView deselectItemAtIndex:[self.gridView indexOfSelectedItem] animated:NO];
    }
    
    // only one delegate at a time (only one grid is displayed at a time)
    [PSPDFStoreManager sharedPSPDFStoreManager].delegate = self;
    
    // call anyway - if store is done before we get initialized, don't fail
    [self diskDataLoaded];
    
    // ensure everything is up to date (we could change magazines in other controllers)
    [self.gridView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    PSPDFLog(@"Grid appeared.");
    
    if (self.magazineView) {
        [UIView animateWithDuration:0.3f delay:0.f options:0 animations:^{
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

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)updateGrid; {
    [self.gridView reloadData];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - AQGridViewDataSource

- (CGFloat)thumbnailSizeReductionFactor {
    return PSIsIpad() ? 1.f : 0.588f;
}

- (NSUInteger)numberOfItemsInGridView:(AQGridView *)gridView {
    NSUInteger count;
    if (self.magazineFolder) {
        count = [self.magazineFolder.magazines count];
    }else {
        count = [[PSPDFStoreManager sharedPSPDFStoreManager].magazineFolders count];
    }
    
    lastNumbersOfItemsInGridView_ = count;
    return count;
}

- (AQGridViewCell *)gridView:(AQGridView *)gridView cellForItemAtIndex:(NSUInteger)cellIndex {
    static NSString *MagazineCellIdentifier = @"PSPDFMagazineCellIdentifier";
    
    PSPDFImageGridViewCell * cell = (PSPDFImageGridViewCell *)[self.gridView dequeueReusableCellWithIdentifier:MagazineCellIdentifier];
    if (!cell) {
        CGFloat thumbnailSizeReductionFactor = [self thumbnailSizeReductionFactor];
        cell = [[PSPDFImageGridViewCell alloc] initWithFrame:CGRectMake(0.f, 0.f, roundf(154.f*thumbnailSizeReductionFactor), roundf(208.f*thumbnailSizeReductionFactor)) reuseIdentifier:MagazineCellIdentifier];
        cell.selectionGlowColor = [UIColor blueColor];
    }
    
    if (self.magazineFolder) {
        cell.magazine = (PSPDFMagazine *)[self.magazineFolder.magazines objectAtIndex:cellIndex];
    }else {
        cell.magazineFolder = [[PSPDFStoreManager sharedPSPDFStoreManager].magazineFolders objectAtIndex:cellIndex];  
    }
    
    // set edit mode
    cell.showDeleteImage = self.isEditMode;

    return cell;
}

- (CGSize)portraitGridCellSizeForGridView:(AQGridView *)aGridView {
    CGFloat thumbnailSizeReductionFactor = [self thumbnailSizeReductionFactor];
    return CGSizeMake(roundf(168.f*thumbnailSizeReductionFactor), roundf(224.f*thumbnailSizeReductionFactor));
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - AQGridViewDelegate

- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)gridIndex {
    PSPDFMagazine *magazine;
    PSPDFMagazineFolder *folder;
    
    if (self.magazineFolder) {
        folder = self.magazineFolder;
        magazine = [self.magazineFolder.magazines objectAtIndex:gridIndex];
    }else {
        folder = [[PSPDFStoreManager sharedPSPDFStoreManager].magazineFolders objectAtIndex:gridIndex];
        magazine = [folder firstMagazine];
    }
    
    AQGridViewCell *cell = [gridView cellForItemAtIndex:gridIndex];
    PSELog(@"Magazine selected: %d %@", gridIndex, magazine);    

    if (self.isEditMode) {
        // unless we have multiselect...
        BOOL canDelete = YES;
        NSString *message = nil;
        if ([folder.magazines count] > 1 && !self.magazineFolder) {
            message = [NSString stringWithFormat:NSLocalizedString(@"DeleteMagazineMultiple", @""), folder.title, [folder.magazines count]];
        }else {
            message = [NSString stringWithFormat:NSLocalizedString(@"DeleteMagazineSingle", @""), magazine.title];
            canDelete = magazine.isAvailable || magazine.isDownloading;
        }
        if (canDelete) {
            PSActionSheet *deleteAction = [PSActionSheet sheetWithTitle:message];
            deleteAction.sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [deleteAction setDestructiveButtonWithTitle:NSLocalizedString(@"Delete", @"") block:^{
                if (self.magazineFolder) {
                    [[PSPDFStoreManager sharedPSPDFStoreManager] deleteMagazine:magazine];
                }else {
                    [[PSPDFStoreManager sharedPSPDFStoreManager] deleteMagazineFolder:folder];
                }
            }];
            [deleteAction setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
            [deleteAction showFromRect:cell.frame inView:self.view animated:YES];
        }        
    }
    else if ([folder.magazines count] == 1 || self.magazineFolder) {
        if (magazine.isDownloading) {
            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Item is currently downloading."]
                                         message:nil
                                        delegate:nil
                               cancelButtonTitle:NSLocalizedString(@"OK", @"")
                               otherButtonTitles:nil] show];
        } else if(!magazine.isAvailable && !magazine.isDownloading) {
            [[PSPDFStoreManager sharedPSPDFStoreManager] downloadMagazine:magazine];
        } else {
            BOOL openSuccess = [self openMagazine:magazine animated:YES cellIndex:gridIndex];
            if (!openSuccess) {
                [self.gridView deselectItemAtIndex:gridIndex animated:NO];
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
    
    // remove selection
    [self.gridView deselectItemAtIndex:gridIndex animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFStoreManagerDelegate

- (void)magazineStoreBeginUpdate {
    [self.gridView beginUpdates];
}
- (void)magazineStoreEndUpdate {
    [self.gridView endUpdates];
}

- (void)magazineStoreFolderDeleted:(PSPDFMagazineFolder *)magazineFolder {
    if (!self.magazineFolder) {
        NSUInteger cellIndex = [[PSPDFStoreManager sharedPSPDFStoreManager].magazineFolders indexOfObject:magazineFolder];
        [self.gridView deleteItemsAtIndices:[NSIndexSet indexSetWithIndex:cellIndex] withAnimation:AQGridViewItemAnimationBottom];
    }
}

- (void)magazineStoreFolderAdded:(PSPDFMagazineFolder *)magazineFolder {
    if (!self.magazineFolder) {
        NSUInteger cellIndex = [[PSPDFStoreManager sharedPSPDFStoreManager].magazineFolders indexOfObject:magazineFolder];
        [self.gridView insertItemsAtIndices:[NSIndexSet indexSetWithIndex:cellIndex] withAnimation:AQGridViewItemAnimationTop];
    }
}

- (void)magazineStoreFolderModified:(PSPDFMagazineFolder *)magazineFolder {
    if (!self.magazineFolder) {
        NSUInteger cellIndex = [[PSPDFStoreManager sharedPSPDFStoreManager].magazineFolders indexOfObject:magazineFolder];
        [self.gridView reloadItemsAtIndices:[NSIndexSet indexSetWithIndex:cellIndex] withAnimation:AQGridViewItemAnimationFade];  
    }
}

- (void)openMagazine:(PSPDFMagazine *)magazine {
    NSUInteger cellIndex = [self.magazineFolder.magazines indexOfObject:magazine];
    [self openMagazine:magazine animated:YES cellIndex:cellIndex];
}

- (void)magazineStoreMagazineDeleted:(PSPDFMagazine *)magazine {
    if (self.magazineFolder) {
        NSUInteger cellIndex = [self.magazineFolder.magazines indexOfObject:magazine];
        [self.gridView deleteItemsAtIndices:[NSIndexSet indexSetWithIndex:cellIndex] withAnimation:AQGridViewItemAnimationFade];  
    }    
}

- (void)magazineStoreMagazineAdded:(PSPDFMagazine *)magazine {
    if (self.magazineFolder) {
        NSUInteger cellIndex = [self.magazineFolder.magazines indexOfObject:magazine];
        [self.gridView insertItemsAtIndices:[NSIndexSet indexSetWithIndex:cellIndex] withAnimation:AQGridViewItemAnimationFade];  
    }        
}

- (void)magazineStoreMagazineModified:(PSPDFMagazine *)magazine {
    if (self.magazineFolder) {
        NSUInteger cellIndex = [self.magazineFolder.magazines indexOfObject:magazine];
        [self.gridView reloadItemsAtIndices:[NSIndexSet indexSetWithIndex:cellIndex] withAnimation:AQGridViewItemAnimationFade];  
    }    
}

@end
