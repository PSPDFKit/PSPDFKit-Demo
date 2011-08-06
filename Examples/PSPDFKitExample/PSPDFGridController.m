//
//  AMGridController.m
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/22/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFGridController.h"
#import "PSPDFImageGridViewCell.h"
#import "PSPDFMagazine.h"
#import "PSPDFMagazineFolder.h"
#import "PSPDFExampleViewController.h"
#import "PSPDFCacheSettingsController.h"
#import "PSPDFDownload.h"
#import "AppDelegate.h"

#import "PSPDFQuickLookViewController.h"

#define kPSPDFGridFadeAnimationDuration 0.3f

@implementation PSPDFGridController

@synthesize gridView = gridView_;
@synthesize magazineFolder = magazineFolder_;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private

- (void)closeModalView {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)presentModalViewControllerWithCloseButton:(UIViewController *)controller animated:(BOOL)animated {
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];
    controller.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(closeModalView)] autorelease];
    [self presentModalViewController:navController animated:animated];
}

- (void)shopButtonPressed {
    NSString *urlString = @"http://manuals.info.apple.com/en_US/ipad_2_user_guide.pdf";
    [[PSPDFDownload PDFDownloadWithURL:[NSURL URLWithString:urlString]] start];
}

- (void)optionsButtonPressed {
    if ([self.popoverController.contentViewController isKindOfClass:[PSPDFCacheSettingsController class]]) {
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
    }else {
        PSPDFCacheSettingsController *cacheSettingsController = [[[PSPDFCacheSettingsController alloc] init] autorelease];
        if (PSIsIpad()) {
            self.popoverController = [[[UIPopoverController alloc] initWithContentViewController:cacheSettingsController] autorelease];
            [self.popoverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }else {
            [self presentModalViewControllerWithCloseButton:cacheSettingsController animated:YES];
        }
    }
}

// open magazine with nice animation
- (BOOL)openMagazine:(PSPDFMagazine *)magazine animated:(BOOL)animated cellIndex:(NSUInteger)index {
#ifdef kPSPDFQuickLookEngineEnabled
    PSPDFQuickLookViewController *previewController = [[[PSPDFQuickLookViewController alloc] initWithDocument:magazine] autorelease];
    [self presentModalViewController:previewController animated:YES];
    return YES;
#endif
    
    // set global settings for magazine
    magazine.searchEnabled = [PSPDFCacheSettingsController search];
    magazine.annotationsEnabled = [PSPDFCacheSettingsController annotations];
    magazine.outlineEnabled = [PSPDFCacheSettingsController pdfoutline];
    
    PSPDFExampleViewController *pdfController = [[[PSPDFExampleViewController alloc] initWithDocument:magazine] autorelease];
    
    // set global settings from PSPDFCacheSettingsController
    pdfController.doublePageModeOnFirstPage = [PSPDFCacheSettingsController doublePageModeOnFirstPage];
    pdfController.pageMode = [PSPDFCacheSettingsController pageMode];
    pdfController.zoomingSmallDocumentsEnabled = [PSPDFCacheSettingsController zoomingSmallDocumentsEnabled];
    
    UINavigationController *pdfNavController = [[[UINavigationController alloc] initWithRootViewController:pdfController] autorelease];
    pdfNavController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    if (animated) {
        UIImage *coverImage = [[PSPDFCache sharedPSPDFCache] cachedImageForDocument:magazine page:0 size:PSPDFSizeThumbnail];
        AQGridViewCell *cell = [self.gridView cellForItemAtIndex:index];
        CGRect cellCoords = cell.frame;
        UIImageView *coverImageView = [[[UIImageView alloc] initWithImage:coverImage] autorelease];
        coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        coverImageView.frame = cellCoords;
        [self.view addSubview:coverImageView];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSThread sleepForTimeInterval:0.2];
            [self presentModalViewController:pdfNavController animated:YES];
        });
        
        [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
            CGRect newFrame = self.view.frame;
            newFrame.origin.y -= self.navigationController.navigationBar.height;
            newFrame.size.height += self.navigationController.navigationBar.height;
            coverImageView.frame = newFrame;
        } completion:^(BOOL finished) {
            [coverImageView removeFromSuperview];    
        }];  
    }else {
        [self presentModalViewController:pdfNavController animated:NO];
    }
    
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSObject

- (id)init {
    if ((self = [super init])) {
        self.title = @"PSPSFKit Example";   
        
        // custom back button for smaller wording
        self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Kiosk" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
    }
    return self;
}

- (id)initWithMagazineFolder:(PSPDFMagazineFolder *)aMagazineFolder {
    if ((self = [self init])) {
        self.title = aMagazineFolder.title;
        magazineFolder_ = [aMagazineFolder retain];
    }
    return self;
}


- (void)dealloc {
    [magazineFolder_ release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!self.magazineFolder) {
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Download PDF"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(shopButtonPressed)] autorelease];
        
    }
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Options"
                                                                               style:UIBarButtonItemStyleBordered
                                                                              target:self
                                                                              action:@selector(optionsButtonPressed)] autorelease];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"linen_texture_dark"]];
    self.gridView = [[[PSPDFGridView alloc] initWithFrame:CGRectZero] autorelease];
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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    if ([self.gridView indexOfSelectedItem] != NSNotFound) {
        [self.gridView deselectItemAtIndex:[self.gridView indexOfSelectedItem] animated:NO];
    }
    
    // ensure everything is up to date (we could change magazines in other controllers)
    [self.gridView reloadData];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)updateGrid; {
    [self.gridView reloadData];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark AQGridViewDataSource

- (CGFloat)thumbnailSizeReductionFactor {
    return PSIsIpad() ? 1.f : 0.588;
}

- (NSUInteger)numberOfItemsInGridView:(AQGridView *)gridView {
    if (self.magazineFolder) {
        return [self.magazineFolder.magazines count];
    }else {
        return [XAppDelegate.magazineFolders count];
    }
}

- (AQGridViewCell *)gridView:(AQGridView *)gridView cellForItemAtIndex:(NSUInteger)index {
    static NSString *MagazineCellIdentifier = @"PSPDFMagazineCellIdentifier";
    
    PSPDFImageGridViewCell * cell = (PSPDFImageGridViewCell *)[self.gridView dequeueReusableCellWithIdentifier:MagazineCellIdentifier];
    if (!cell) {
        CGFloat thumbnailSizeReductionFactor = [self thumbnailSizeReductionFactor];
        cell = [[[PSPDFImageGridViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, floorf(150.0*thumbnailSizeReductionFactor), floorf(200.0*thumbnailSizeReductionFactor)) reuseIdentifier:MagazineCellIdentifier] autorelease];
        cell.selectionGlowColor = [UIColor blueColor];
    }
    
    if (self.magazineFolder) {
        cell.magazine = [self.magazineFolder.magazines objectAtIndex:index];
    }else {
        cell.magazineFolder = [XAppDelegate.magazineFolders objectAtIndex:index];  
    }
    
    return cell;
}

- (CGSize)portraitGridCellSizeForGridView:(AQGridView *)aGridView {
    CGFloat thumbnailSizeReductionFactor = [self thumbnailSizeReductionFactor];
    return CGSizeMake(floorf(168.0*thumbnailSizeReductionFactor), floorf(224.0*thumbnailSizeReductionFactor));
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark AQGridViewDelegate

- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index {
    PSPDFMagazine *magazine;
    PSPDFMagazineFolder *folder;
    
    if (self.magazineFolder) {
        folder = self.magazineFolder;
        magazine = [self.magazineFolder.magazines objectAtIndex:index];
    }else {
        folder = [XAppDelegate.magazineFolders objectAtIndex:index];
        magazine = [folder firstMagazine];
    }
    
    PSELog(@"Magazine selected: %d %@", index, magazine);    
    
    if ([folder.magazines count] == 1 || self.magazineFolder
        ) {
        BOOL openSuccess = [self openMagazine:magazine animated:YES cellIndex:index];
        if (!openSuccess) {
            [self.gridView deselectItemAtIndex:index animated:NO];
        }
    }else {
        PSPDFGridController *gridController = [[[PSPDFGridController alloc] initWithMagazineFolder:folder] autorelease];
        
        // a full-page-fade animation doesn't work very well on iPad (under a ux aspect; technically it's fine)
        if (PSIsIpad()) {
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
#pragma mark -
#pragma mark AMStoreManagerDelegate

- (void)magazineStoreBeginUpdate {
    [self.gridView beginUpdates];
}
- (void)magazineStoreEndUpdate {
    [self.gridView endUpdates];
}

- (void)magazineStoreFolderDeleted:(PSPDFMagazineFolder *)magazineFolder {
    if (!self.magazineFolder) {
        NSUInteger index = [XAppDelegate.magazineFolders indexOfObject:magazineFolder];
        [self.gridView deleteItemsAtIndices:[NSIndexSet indexSetWithIndex:index] withAnimation:AQGridViewItemAnimationBottom];
    }
}

- (void)magazineStoreFolderAdded:(PSPDFMagazineFolder *)magazineFolder {
    if (!self.magazineFolder) {
        NSUInteger index = [XAppDelegate.magazineFolders indexOfObject:magazineFolder];
        [self.gridView insertItemsAtIndices:[NSIndexSet indexSetWithIndex:index] withAnimation:AQGridViewItemAnimationTop];
    }
}

- (void)magazineStoreFolderModified:(PSPDFMagazineFolder *)magazineFolder {
    if (!self.magazineFolder) {
        NSUInteger index = [XAppDelegate.magazineFolders indexOfObject:magazineFolder];
        [self.gridView reloadItemsAtIndices:[NSIndexSet indexSetWithIndex:index] withAnimation:AQGridViewItemAnimationFade];  
    }
}

- (void)openMagazine:(PSPDFMagazine *)magazine {
    NSUInteger index = [self.magazineFolder.magazines indexOfObject:magazine];
    [self openMagazine:magazine animated:YES cellIndex:index];
}

- (void)magazineStoreMagazineDeleted:(PSPDFMagazine *)magazine {
    if (self.magazineFolder) {
        NSUInteger index = [self.magazineFolder.magazines indexOfObject:magazine];
        [self.gridView deleteItemsAtIndices:[NSIndexSet indexSetWithIndex:index] withAnimation:AQGridViewItemAnimationFade];  
    }    
}

- (void)magazineStoreMagazineAdded:(PSPDFMagazine *)magazine {
    if (self.magazineFolder) {
        NSUInteger index = [self.magazineFolder.magazines indexOfObject:magazine];
        [self.gridView insertItemsAtIndices:[NSIndexSet indexSetWithIndex:index] withAnimation:AQGridViewItemAnimationFade];  
    }        
}

- (void)magazineStoreMagazineModified:(PSPDFMagazine *)magazine {
    if (self.magazineFolder) {
        NSUInteger index = [self.magazineFolder.magazines indexOfObject:magazine];
        [self.gridView reloadItemsAtIndices:[NSIndexSet indexSetWithIndex:index] withAnimation:AQGridViewItemAnimationFade];  
    }    
}

@end
