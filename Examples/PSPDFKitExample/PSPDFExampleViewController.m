//
//  PSPDFExampleViewController.m
//  PSPDFKitExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFExampleViewController.h"
#import "AppDelegate.h"
#import "PSPDFMagazine.h"
#import "PSPDFSettingsController.h"
#import "PSPDFGridController.h"

@interface PSPDFExampleViewController () {
    BOOL hasLoadedLastPage_;
}
@end

@implementation PSPDFExampleViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)closeModalView {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)optionsButtonPressed:(id)sender {
    if(![self checkAndDismissPopoverForViewControllerClass:[PSPDFSettingsController class] animated:YES]) {
        [self checkAndDismissPopoverForViewControllerClass:nil animated:NO]; // close print/open in
        PSPDFSettingsController *cacheSettingsController = [[PSPDFSettingsController alloc] init];
        if (PSIsIpad()) {
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:cacheSettingsController];
            self.popoverController.passthroughViews = [NSArray arrayWithObject:self.navigationController.navigationBar];
            [self.popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }else {
            [self presentModalViewController:cacheSettingsController withCloseButton:YES animated:YES];
        }
    }
}

// Helper for the option pane. You really shouldn't include that in your final app.
// This is just to show what PSPDFKit can do.
- (void)globalVarChanged {
    // set global settings for magazine
    self.magazine.searchEnabled = [PSPDFSettingsController search];
    self.magazine.annotationsEnabled = [PSPDFSettingsController annotations];
    self.magazine.outlineEnabled = [PSPDFSettingsController pdfOutline];
    self.magazine.aspectRatioEqual = [PSPDFSettingsController aspectRatioEqual];
    self.magazine.twoStepRenderingEnabled = [PSPDFSettingsController twoStepRendering];
    
    // set global settings from PSPDFCacheSettingsController
    self.doublePageModeOnFirstPage = [PSPDFSettingsController doublePageModeOnFirstPage];
    self.zoomingSmallDocumentsEnabled = [PSPDFSettingsController zoomingSmallDocumentsEnabled];
    self.scrobbleBarEnabled = [PSPDFSettingsController scrobbleBar];
    self.fitWidth = [PSPDFSettingsController fitWidth];
    self.pageCurlEnabled = [PSPDFSettingsController pageCurl];
    
    NSUInteger page = [self landscapePage:self.page];
    self.pageMode = [PSPDFSettingsController pageMode];
    self.pageScrolling = [PSPDFSettingsController pageScrolling];
    
    // reload scrollview
    [self reloadDataAndScrollToPage:page];
    
    // update toolbar
    if ([self isViewLoaded]) {
        [self createToolbar];        
        [self updateToolbars];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithDocument:document])) {
        self.delegate = self;
        
        // initally update vars
        [self globalVarChanged];
        
        // register for global var change notifications from PSPDFCacheSettingsController
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(globalVarChanged) name:kGlobalVarChangeNotification object:nil];
        
        // use inline browser for pdf links
        self.linkAction = PSPDFLinkActionInlineBrowser;
        
        // 1.9.10 feature
        self.printEnabled = YES;
        self.openInEnabled = YES;
        
        // 1.9.16 feature
        self.sendViaEmailEnabled = YES;
        
        // don't clip pages that have a high aspect ration variance. (for pageCurl, optional but useful check)
        CGFloat variance = [document aspectRatioVariance];
        self.clipToPageBoundaries = variance < 0.2f;
        
        // 1.9 feature
        //self.tintColor = [UIColor colorWithRed:60.f/255.f green:100.f/255.f blue:160.f/255.f alpha:1.f];
        //self.statusBarStyleSetting = PSPDFStatusBarDefaultWhite;
        
        // change statusbar setting to your preferred style
        //self.statusBarStyleSetting = PSPDFStatusBarDisable;
        //self.statusBarStyleSetting = self.statusBarStyleSetting | PSPDFStatusBarIgnore;
    }    
    return self;
}

- (void)dealloc {
    [[NSUserDefaults standardUserDefaults] setInteger:self.realPage forKey:self.document.uid]; // remember last page
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (PSPDFMagazine *)magazine {
    return (PSPDFMagazine *)self.document;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // try to restore the last page
    if (!hasLoadedLastPage_) {
        hasLoadedLastPage_ = YES;
        NSInteger lastPage = [[NSUserDefaults standardUserDefaults] integerForKey:self.document.uid];
        if (lastPage >= 0 && lastPage < self.document.pageCount) {
            // animation with pageCurl form first page looks weird, so don't animated here.
            BOOL shouldAnimate = !self.pageCurlEnabled;
            [self scrollToPage:lastPage animated:shouldAnimate];
        }
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    /*
     // Example how to customize the double page mode switching. 
     if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation) && !PSIsIpad()) {
     self.pageMode = PSPDFPageModeDouble;
     }else {
     self.pageMode = PSPDFPageModeAutomatic;
     }*/
    
    // toolbar will be recreated, so release popover after rotation (else CoreAnimation crashes on us)
    [self.popoverController dismissPopoverAnimated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (NSArray *)additionalLeftToolbarButtons {
    UIBarButtonItem *button;
    
    // on iOS5, we can finally set the landscapeImagePhone
    if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iPhoneOS_5_0) {
        button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"]      
                                                  style:UIBarButtonItemStylePlain
                                                 target:self
                                                 action:@selector(optionsButtonPressed:)];
    }else {
        button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"]
                                    landscapeImagePhone:[UIImage imageNamed:@"settings_landscape"]
                                                  style:UIBarButtonItemStylePlain
                                                 target:self
                                                 action:@selector(optionsButtonPressed:)];
    }
    
    return [NSArray arrayWithObject:button];
}

- (void)documentButtonPressed {
    [self.navigationController popViewControllerAnimated:NO];
}

- (UIBarButtonItem *)toolbarBackButton {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:PSIsIpad() ? PSPDFLocalize(@"Documents") : PSPDFLocalize(@"Back")
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(documentButtonPressed)];
    return backButton;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

// time to adjust PSPDFViewController before a PSPDFDocument is displayed
- (void)pdfViewController:(PSPDFViewController *)pdfController willDisplayDocument:(PSPDFDocument *)document {
    pdfController.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"linen_texture_dark"]];
}

// if user tapped within page bounds, this will notify you.
// return YES if this touch was processed by you and need no further checking by PSPDFKit.
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnPageView:(PSPDFPageView *)pageView info:(PSPDFPageInfo *)pageInfo coordinates:(PSPDFPageCoordinates *)pageCoordinates {
    PSELog(@"Page %d tapped at %@.", pageView.page, pageCoordinates);
    
    // touch not used
    return NO;
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didShowPageView:(PSPDFPageView *)pageView {
    PSELog(@"page %d displayed. (document: %@)", pageView.page, pageView.document.title);    
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didRenderPageView:(PSPDFPageView *)pageView {
    PSELog(@"page %d rendered. (document: %@)", pageView.page, pageView.document.title);
}

- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnAnnotation:(PSPDFAnnotation *)annotation page:(NSUInteger)page info:(PSPDFPageInfo *)pageInfo coordinates:(PSPDFPageCoordinates *)pageCoordinates {
    BOOL handled = NO;
    return handled;
}

@end
