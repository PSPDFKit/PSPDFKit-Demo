//
//  PSPDFAnnotationTestController.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSCAnnotationTestController.h"
#import "PSCPlayButtonItem.h"
#import "PSCSelectionZoomBarButtonItem.h"
#import <MapKit/MapKit.h>
#import <MediaPlayer/MediaPlayer.h>

@implementation PSCAnnotationTestController

// sample implementaton how to automatically advance to the next page
- (void)advanceToNextPage {
    if ([self isLastPage]) {
        [self setPage:0 animated:YES];
    }else {
        [self scrollToNextPageAnimated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (id)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithDocument:document])) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Annotations" image:[UIImage imageNamed:@"movie"] tag:4];
        self.delegate = self; // set PSPDFViewControllerDelegate to self
        self.pageTransition = PSPDFPageCurlTransition;
        self.renderingMode = PSPDFPageRenderingModeFullPageBlocking;
        self.linkAction = PSPDFLinkActionInlineBrowser;
        self.statusBarStyleSetting = PSPDFStatusBarSmartBlack;
        self.tintColor = [UIColor orangeColor];
        self.maximumZoomScale = 100; // as we have the selection zoom-in tool
        
        PSPDFBarButtonItem *playButtonItem = [[PSCPlayButtonItem alloc] initWithPDFViewController:self];
        PSCSelectionZoomBarButtonItem *selectionZoomButtonItem = [[PSCSelectionZoomBarButtonItem alloc] initWithPDFViewController:self];

        if (PSIsIpad()) {
            self.rightBarButtonItems = @[playButtonItem, selectionZoomButtonItem, self.bookmarkButtonItem, self.openInButtonItem, self.printButtonItem, self.searchButtonItem, self.outlineButtonItem, self.viewModeButtonItem];
        }else {
            // not enough space on the iPhone; move some features to additonalRightBarButtonItems
            self.rightBarButtonItems = @[playButtonItem, self.bookmarkButtonItem, self.viewModeButtonItem];
            self.additionalRightBarButtonItems = @[selectionZoomButtonItem, self.openInButtonItem, self.printButtonItem, self.searchButtonItem, self.outlineButtonItem];
        }

        // example how to add custom image annotation
        PSPDFLinkAnnotation *annotation = [[PSPDFLinkAnnotation alloc] initWithLinkAnnotationType:PSPDFLinkAnnotationImage];

        // with setting the path, you can use two different ways:

        // either set the siteLinkTarget, which needs the pspdfkit syntax and invokes parseAnnotationLinkTarget in PSPDFAnnotationParser to parse the type, options and the path.
        // Note that we need to expliitely set the bundlePath here. As a default, PSPDFKit will set the path where the PDF file is; but in this example the PDF file is in a folder called "Samples" and the image is in the root bundle folter, this we can't use the auto-path mode.
        // Also note how we set a custom contentMode (this will get parsed and added to the options dict of PSPDFLinkAnnotation and later parsed in PSPDFImageAnnoationView)
        // Using siteLinkTarget the value you're initially setting the link annotation type to (here: PSPDFLinkAnnotation) will be overridden.
        annotation.siteLinkTarget = [NSString stringWithFormat:@"pspdfkit://[contentMode=%d]localhost/%@/exampleimage.jpg", UIViewContentModeScaleAspectFill, [[NSBundle mainBundle] bundlePath]];

        // Variant two is directly setting the URL. Here PSPDFKit will not further parse the annotation, so the path must be correct (can't use relative path's here.)
        // Also note that while we are accepting a URL, annotations will only work with file-based URL's (unless it's invoking a UIWebView). Loading a remote image here is not (yet) supported.
        //annotation.URL = [NSURL fileURLWithPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"exampleimage.jpg"]];

        // annotation frame is in PDF coordinate space. Use pageRect for the full page.
        annotation.boundingBox = [self.document pageInfoForPage:0].pageRect;
        // annotation.page/document is auomatically set.
        [self.document.annotationParser addAnnotations:@[annotation] forPage:0];
    }
    return self;
}

/*
 // example that shows how to dynamically switch between pageCurl and scrolling;
 don't change the property within willRotateToInterfaceOrientation.
 - (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
 [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
 
 self.pageCurlEnabled = UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
 }*/

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

/// time to adjust PSPDFViewController before a PSPDFDocument is displayed
- (void)pdfViewController:(PSPDFViewController *)pdfController willDisplayDocument:(PSPDFDocument *)document {
    NSLog(@"willDisplayDocument: %@", document);    
}

/// delegate to be notified when pdfController finished loading
- (void)pdfViewController:(PSPDFViewController *)pdfController didDisplayDocument:(PSPDFDocument *)document {
    NSLog(@"didDisplayDocument: %@", document);
}

/// controller did show/scrolled to a new page (at least 51% of it is visible)
- (void)pdfViewController:(PSPDFViewController *)pdfController didShowPageView:(PSPDFPageView *)pageView {
    NSLog(@"didShowPageView: page:%d", pageView.page);
}

/// page was fully rendered at zoomlevel = 1
- (void)pdfViewController:(PSPDFViewController *)pdfController didRenderPageView:(PSPDFPageView *)pageView {
    NSLog(@"didRenderPageView: page:%d", pageView.page);    
}

/// will be called when viewMode changes
- (void)pdfViewController:(PSPDFViewController *)pdfController didChangeViewMode:(PSPDFViewMode)viewMode {
    NSLog(@"didChangeViewMode: %d", viewMode);        
}

/// called after pdf page has been loaded and added to the pagingScrollView.
- (void)pdfViewController:(PSPDFViewController *)pdfController didLoadPageView:(PSPDFPageView *)pageView; {
    NSLog(@"didLoadPageView: page:%d", pageView.page);
}

/// called before a pdf page will be unloaded and removed from the pagingScrollView.
- (void)pdfViewController:(PSPDFViewController *)pdfController willUnloadPageView:(PSPDFPageView *)pageView; {
    NSLog(@"willUnloadPageView: page:%d", pageView.page);
}

/// if user tapped within page bounds, this will notify you.
/// return YES if this touch was processed by you and need no further checking by PSPDFKit.
/// Note that PSPDFPageInfo may has only page=1 if the optimization isAspectRatioEqual is enabled.
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnPageView:(PSPDFPageView *)pageView info:(PSPDFPageInfo *)pageInfo coordinates:(PSPDFPageCoordinates *)pageCoordinates {
    NSLog(@"didTapOnPageView: page:%d", pageView.page);
    return NO;
}

- (UIView *)pdfViewController:(PSPDFViewController *)pdfController viewForAnnotation:(PSPDFAnnotation *)annotation onPageView:(PSPDFPageView *)pageView {
    
    if ([annotation isKindOfClass:[PSPDFLinkAnnotation class]]) {
        PSPDFLinkAnnotation *linkAnnotation = (PSPDFLinkAnnotation *)annotation;
        // example how to add a MapView with the url protocol map://lat,long,latspan,longspan
        if (linkAnnotation.linkType == PSPDFLinkAnnotationCustom && [linkAnnotation.siteLinkTarget hasPrefix:@"map://"]) {
            // parse annotation data
            NSString *mapData = [linkAnnotation.siteLinkTarget stringByReplacingOccurrencesOfString:@"map://" withString:@""];
            NSArray *token = [mapData componentsSeparatedByString:@","];
            
            // ensure we have token count of 4 (latitude, longitude, span la, span lo)
            if ([token count] == 4) {
                CLLocationCoordinate2D location = CLLocationCoordinate2DMake([[token objectAtIndex:0] doubleValue],
                                                                             [[token objectAtIndex:1] doubleValue]);
                
                MKCoordinateSpan span = MKCoordinateSpanMake([[token objectAtIndex:2] doubleValue],
                                                             [[token objectAtIndex:3] doubleValue]);
                
                // frame is set in PSPDFViewController, but MKMapView needs the position before setting the region.
                CGRect frame = [annotation rectForPageRect:pageView.bounds];
                
                MKMapView *mapView = [[MKMapView alloc] initWithFrame:frame];
                [mapView setRegion:MKCoordinateRegionMake(location, span) animated:NO];
                return mapView;
            }
        }
    }
    return nil;
}

/// Invoked prior to the presentation of the annotation view: use this to configure actions etc
- (void)pdfViewController:(PSPDFViewController *)pdfController willShowAnnotationView:(UIView <PSPDFAnnotationView> *)annotationView onPageView:(PSPDFPageView *)pageView {
    NSLog(@"willShowAnnotationView: %@ page:%d", annotationView, pageView.page);
}

/// Invoked after animation used to present the annotation view
- (void)pdfViewController:(PSPDFViewController *)pdfController didShowAnnotationView:(UIView <PSPDFAnnotationView> *)annotationView onPageView:(PSPDFPageView *)pageView {
    NSLog(@"didShowAnnotationView: %@ page:%d", annotationView, pageView.page);    
}

/// Allow resolving custom path tokens (Documents, Bundle are automatically resolved; you can add e.g. Book and resolve this here). Will only get called for unknown tokens.
- (NSString *)pdfViewController:(PSPDFViewController *)pdfController resolveCustomAnnotationPathToken:(NSString *)pathToken {
    NSString *resolvedPath = nil;
    if ([pathToken isEqualToString:@"Books"]) {
        resolvedPath = [[NSBundle mainBundle] bundlePath];
    }
    return resolvedPath;
}

- (void)pdfViewController:(PSPDFViewController *)pdfController willShowController:(id)viewController embeddedInController:(id)controller animated:(BOOL)animated {
    NSLog(@"willShowViewController: %@ embeddedIn:%@ animated: %d", viewController, controller, animated);
    
    // example how to intercept PSPDFSearchViewController and change the barStyle to black
    if ([viewController isKindOfClass:[PSPDFSearchViewController class]]) {
        PSPDFSearchViewController *searchController = (PSPDFSearchViewController *)viewController;
        searchController.searchBar.barStyle = UIBarStyleBlack;
        searchController.searchBar.tintColor = [UIColor blackColor];
    }
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didShowController:(id)viewController embeddedInController:(id)controller animated:(BOOL)animated {
    NSLog(@"didShowViewController: %@ embeddedIn:%@ animated: %d", viewController, controller, animated);
}

/// HUD will be displayed.
- (void)pdfViewController:(PSPDFViewController *)pdfController willShowHUD:(BOOL)animated {
    NSLog(@"willShowHUDAnimated: %@", animated ? @"YES" : @"NO");
}

/// HUD was displayed (called after the animation finishes)
- (void)pdfViewController:(PSPDFViewController *)pdfController didShowHUD:(BOOL)animated {
    NSLog(@"didShowHUDAnimated: %@", animated ? @"YES" : @"NO");
}

/// HUD will be hidden.
- (void)pdfViewController:(PSPDFViewController *)pdfController willHideHUD:(BOOL)animated {
    NSLog(@"willHideHudAnimated: %@", animated ? @"YES" : @"NO");
}

/// HUD was hidden (called after the animation finishes)
- (void)pdfViewController:(PSPDFViewController *)pdfController didHideHUD:(BOOL)animated {
    NSLog(@"didHideHUDAnimated: %@", animated ? @"YES" : @"NO");
}

@end
