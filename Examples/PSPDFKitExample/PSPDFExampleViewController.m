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
#import "PSPDFSettingsBarButtonItem.h"

@interface PSPDFExampleViewController () {
    BOOL hasLoadedLastPage_;
}
@end

@implementation PSPDFExampleViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)optionsButtonPressed:(id)sender {
    if ([self.popoverController.contentViewController isKindOfClass:[PSPDFSettingsController class]]) {
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
        return;
    }
    
    PSPDFSettingsController *cacheSettingsController = [[PSPDFSettingsController alloc] init];
    if (PSIsIpad()) {
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:cacheSettingsController];
        self.popoverController.passthroughViews = @[self.navigationController.navigationBar];
        [self.popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else {
        [self presentModalViewController:cacheSettingsController embeddedInNavigationController:YES withCloseButton:YES animated:YES];
    }
}

// Helper for the option pane. You really shouldn't include that in your final app.
// This is just to show what PSPDFKit can do.
- (void)globalVarChanged {
    // set global settings for magazine
    self.magazine.annotationsEnabled = [PSPDFSettingsController annotations];
    self.magazine.aspectRatioEqual = [PSPDFSettingsController aspectRatioEqual];
    self.magazine.twoStepRenderingEnabled = [PSPDFSettingsController twoStepRendering];
    
    // set global settings from PSPDFCacheSettingsController
    self.doublePageModeOnFirstPage = [PSPDFSettingsController doublePageModeOnFirstPage];
    self.zoomingSmallDocumentsEnabled = [PSPDFSettingsController zoomingSmallDocumentsEnabled];
    self.scrobbleBarEnabled = [PSPDFSettingsController scrobbleBar];
    self.fitWidth = [PSPDFSettingsController fitWidth];
    self.pageCurlEnabled = [PSPDFSettingsController pageCurl];
    
    NSMutableArray *rightBarButtonItems = [NSMutableArray array];
    if ([PSPDFSettingsController pdfOutline]) {
        [rightBarButtonItems addObject:self.outlineButtonItem];
    }
    if ([PSPDFSettingsController search]) {
        [rightBarButtonItems addObject:self.searchButtonItem];
    }
    [rightBarButtonItems addObject:self.viewModeButtonItem];
    self.rightBarButtonItems = rightBarButtonItems;
    
    // define additional buttons with an action icon
    self.additionalRightBarButtonItems = @[self.printButtonItem, self.openInButtonItem, self.emailButtonItem];
    
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
        
        // 1.10 feature: replaces printEnabled, openInEnabled
        if (PSIsIpad()) {
            self.additionalRightBarButtonItems = @[self.openInButtonItem, self.printButtonItem, self.emailButtonItem];
        }else {
            self.rightBarButtonItems = @[self.searchButtonItem, self.viewModeButtonItem];
            self.additionalRightBarButtonItems = @[self.openInButtonItem, self.printButtonItem, self.emailButtonItem, self.outlineButtonItem];
        }
        
        // don't clip pages that have a high aspect ration variance. (for pageCurl, optional but useful check)
        CGFloat variance = [document aspectRatioVariance];
        self.clipToPageBoundaries = variance < 0.2f;

        // defaults to nil, this would show the back arrow (but we want a custom animation, thus our own button)
        NSString *closeTitle = PSIsIpad() ? NSLocalizedString(@"Documents", @"") : NSLocalizedString(@"Back", @"");
        UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:closeTitle style:UIBarButtonItemStyleBordered target:self action:@selector(close:)];
        PSPDFSettingsBarButtonItem *settingsButtomItem = [[PSPDFSettingsBarButtonItem alloc] initWithPDFViewController:self];

        self.leftBarButtonItems = @[closeButtonItem, settingsButtomItem];
        self.barButtonItemsAlwaysEnabled = @[closeButtonItem];

        // restore viewState
        if ([self.document isValid]) {
            NSData *viewStateData = [[NSUserDefaults standardUserDefaults] objectForKey:self.document.uid];
            @try {
                if (viewStateData) {
                    PSPDFViewState *viewState = [NSKeyedUnarchiver unarchiveObjectWithData:viewStateData];
                    [self restoreDocumentViewState:viewState animated:NO];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Failed to load saved viewState: %@", exception);
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.document.uid];
            }
        }

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
    // save current viewState
    if ([self.document isValid]) {
        NSData *viewStateData = [NSKeyedArchiver archivedDataWithRootObject:[self documentViewState]];
        [[NSUserDefaults standardUserDefaults] setObject:viewStateData forKey:self.document.uid];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (PSPDFMagazine *)magazine {
    return (PSPDFMagazine *)self.document;
}

- (void)close:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

    // Example to show how to only allow pageCurl in landscape mode.
    // Don't change this property in willAnimate* or bad things will happen.
    // self.pageCurlEnabled = UIInterfaceOrientationIsLandscape(self.interfaceOrientation);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

// time to adjust PSPDFViewController before a PSPDFDocument is displayed
- (void)pdfViewController:(PSPDFViewController *)pdfController willDisplayDocument:(PSPDFDocument *)document {
    pdfController.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"linen_texture_dark"]];

    // show pdf title and fileURL
    if (PSIsIpad() && ![document.title isEqualToString:[document.fileURL lastPathComponent]]) {
        self.title = [NSString stringWithFormat:@"%@ (%@)", document.title, [document.fileURL lastPathComponent]];
    }
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

- (void)pdfViewController:(PSPDFViewController *)pdfController willShowController:(id)viewController embeddedInController:(id)controller animated:(BOOL)animated {
    PSELog(@"willShowViewController: %@ embeddedIn:%@ animated: %d", viewController, controller, animated);
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didShowController:(id)viewController embeddedInController:(id)controller animated:(BOOL)animated {
    PSELog(@"didShowViewController: %@ embeddedIn:%@ animated: %d", viewController, controller, animated);
}

@end
