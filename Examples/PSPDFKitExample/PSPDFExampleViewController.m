//
//  PSPDFExampleViewController.m
//  PSPDFKitExample
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFExampleViewController.h"
#import "AppDelegate.h"
#import "PSPDFMagazine.h"
#import "PSPDFSettingsController.h"
#import "PSPDFGridController.h"

@implementation PSPDFExampleViewController

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

- (void)optionsButtonPressed:(id)sender {
    if ([self.popoverController.contentViewController isKindOfClass:[PSPDFSettingsController class]]) {
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
    }else {
        PSPDFSettingsController *cacheSettingsController = [[PSPDFSettingsController alloc] init];
        if (PSIsIpad()) {
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:cacheSettingsController];
            [self.popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }else {
            [self presentModalViewControllerWithCloseButton:cacheSettingsController animated:YES];
        }
    }
}

- (void)globalVarChanged {
    
    // set global settings for magazine
    self.magazine.searchEnabled = [PSPDFSettingsController search];
    self.magazine.annotationsEnabled = [PSPDFSettingsController annotations];
    self.magazine.outlineEnabled = [PSPDFSettingsController pdfoutline];
    self.magazine.aspectRatioEqual = [PSPDFSettingsController aspectRatioEqual];

    // set global settings from PSPDFCacheSettingsController
    self.doublePageModeOnFirstPage = [PSPDFSettingsController doublePageModeOnFirstPage];
    self.zoomingSmallDocumentsEnabled = [PSPDFSettingsController zoomingSmallDocumentsEnabled];
    self.scrobbleBarEnabled = [PSPDFSettingsController scrobbleBar];
    self.fitWidth = [PSPDFSettingsController fitWidth];
    //self.pagingEnabled = [PSPDFSettingsController pagingEnabled];
    
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

- (id)initWithDocument:(PSPDFDocument *)magazine {
    if ((self = [super initWithDocument:magazine])) {
        self.delegate = self;
        
        // initally update vars
        [self globalVarChanged];
        
        // register for global var change notifications from PSPDFCacheSettingsController
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(globalVarChanged) name:kGlobalVarChangeNotification object:nil];
        
        //self.pageTurnEnabled = YES;
        
        // change statusbar setting to your preferred style
        //statusBarStyleSetting_ = PSPDFStatusBarDisable;
        
        
        // how to extract text
        // NSString *pageText = [magazine.documentSearcher textForPage:0];
        // NSLog(@"text of page 0: %@", pageText);
    }    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (PSPDFMagazine *)magazine {
    return (PSPDFMagazine *)self.document;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    // toolbar will be recreated, so release popover after rotation (else CoreAnimation crashes on us)
    [self.popoverController dismissPopoverAnimated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (NSArray *)additionalLeftToolbarButtons {
    
    // button width is too high
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:PSIsIpad() ? @"Options" : @"O"
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(optionsButtonPressed:)];
    return [NSArray arrayWithObject:button];
}

- (void)documentButtonPressed {
    [self.navigationController popViewControllerAnimated:NO];
}

- (UIBarButtonItem *)toolbarBackButton; {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:PSIsIpad() ? @"Documents" : @"Back"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(documentButtonPressed)];
    return backButton;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

// time to adjust PSPDFViewController before a PSPDFDocument is displayed
- (void)pdfViewController:(PSPDFViewController *)pdfController willDisplayDocument:(PSPDFDocument *)document; {
    pdfController.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"linen_texture_dark"]];
}

- (void)pdfViewController:(PSPDFViewController *)pdfController willShowPage:(NSUInteger)page {
    //PSELog(@"showing page %d", page);
    
    // update title!
    if (PSIsIpad()) {
        NSString *title = [NSString stringWithFormat:@"%@ %d/%d", self.magazine.title, page, [self.magazine pageCount]];
        pdfController.title = title;
    }
}

// if user tapped within page bounds, this will notify you.
// return YES if this touch was processed by you and need no further checking by PSPDFKit.
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnPage:(NSUInteger)page atPoint:(CGPoint)point pageSize:(CGSize)pageSize; {
    PSELog(@"Page %@ tapped at %@.", NSStringFromCGSize(pageSize), NSStringFromCGPoint(point));
    
    // touch not used
    return NO;
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didRenderPage:(NSUInteger)page {
    PSELog(@"page %d rendered.", page);
}

@end
