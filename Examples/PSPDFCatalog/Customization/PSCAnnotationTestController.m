//
//  PSPDFAnnotationTestController.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAnnotationTestController.h"
#import "PSCPlayBarButtonItem.h"
#import "PSCSelectionZoomBarButtonItem.h"
#import "PSCAvailability.h"
#import <MapKit/MapKit.h>

@implementation PSCAnnotationTestController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (id)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithDocument:document])) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Annotations" image:[UIImage imageNamed:@"movie"] tag:4];
        self.delegate = self; // set PSPDFViewControllerDelegate to self
        document.delegate = self;
        self.pageTransition = PSPDFPageTransitionCurl;
        self.renderingMode = PSPDFPageRenderingModeFullPageBlocking;
        self.linkAction = PSPDFLinkActionInlineBrowser;
        self.statusBarStyleSetting = PSPDFStatusBarStyleLightContentHideOnIpad;
        self.tintColor = [UIColor orangeColor];
        self.maximumZoomScale = 100; // as we have the selection zoom-in tool

        PSPDFBarButtonItem *playButtonItem = [[PSCPlayBarButtonItem alloc] initWithPDFViewController:self];
        PSCSelectionZoomBarButtonItem *selectionZoomButtonItem = [[PSCSelectionZoomBarButtonItem alloc] initWithPDFViewController:self];

        if (PSCIsIPad()) {
            self.rightBarButtonItems = @[playButtonItem, selectionZoomButtonItem, self.bookmarkButtonItem, self.openInButtonItem, self.printButtonItem, self.searchButtonItem, self.outlineButtonItem, self.viewModeButtonItem];
        }else {
            // not enough space on the iPhone; move some features to additonalRightBarButtonItems
            self.rightBarButtonItems = @[playButtonItem, self.bookmarkButtonItem, self.viewModeButtonItem];
            self.additionalBarButtonItems = @[selectionZoomButtonItem, self.openInButtonItem, self.printButtonItem, self.searchButtonItem, self.outlineButtonItem];
        }

        // example how to add custom image annotation
        NSArray *linkAnnotations = [[self.document annotationManagerForPage:0] annotationsForPage:0 type:PSPDFAnnotationTypeLink];
        if (linkAnnotations.count <= 2) {
            PSPDFLinkAnnotation *annotation = [[PSPDFLinkAnnotation alloc] initWithLinkAnnotationType:PSPDFLinkAnnotationImage];

            // with setting the path, you can use two different ways:

            // either set the siteLinkTarget, which needs the pspdfkit syntax and invokes parseAnnotationLinkTarget in PSPDFAnnotationManager to parse the type, options and the path.
            // Note that we need to explicitly set the bundlePath here. As a default, PSPDFKit will set the path where the PDF file is; but in this example the PDF file is in a folder called "Samples" and the image is in the root bundle folder, this we can't use the auto-path mode.
            // Also note how we set a custom contentMode (this will get parsed and added to the options dict of PSPDFLinkAnnotation and later parsed in PSPDFImageAnnotationView)
            // Using siteLinkTarget the value you're initially setting the link annotation type to (here: PSPDFLinkAnnotation) will be overridden.
            annotation.URL = [NSURL URLWithString:[NSString stringWithFormat:@"pspdfkit://[contentMode=%ld]localhost/TokenTest/exampleimage.jpg", (long)UIViewContentModeScaleAspectFill]];

            // Variant two is directly setting the URL. Here PSPDFKit will not further parse the annotation, so the path must be correct (can't use relative path's here.)
            // Also note that while we are accepting a URL, annotations will only work with file-based URL's (unless it's invoking a UIWebView). Loading a remote image here is not (yet) supported.
            //annotation.URL = [NSURL fileURLWithPath:NSBundle.mainBundle.bundlePath stringByAppendingPathComponent:@"exampleimage.jpg"]];

            // annotation frame is in PDF coordinate space. Use pageRect for the full page.
            annotation.boundingBox = [self.document pageInfoForPage:0].rotatedPageRect;
            annotation.page = 0;

            // annotation.page/document is auto detecting set.
            [self.document addAnnotations:@[annotation]];
        }
    }
    return self;
}

/*
 // example that shows how to dynamically switch between pageCurl and scrolling;
 don't change the property within willRotateToInterfaceOrientation.
 - (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
 [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

 self.pageCurlEnabled = UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation);
 }*/

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (BOOL)pdfViewController:(PSPDFViewController *)pdfController shouldChangeDocument:(PSPDFDocument *)document {
    NSLog(@"shouldChangeDocument: %@", document);
    return YES;
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didChangeDocument:(PSPDFDocument *)document {
    NSLog(@"didDisplayDocument: %@", document);
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didShowPageView:(PSPDFPageView *)pageView {
    NSLog(@"didShowPageView: page:%tu", pageView.page);
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didRenderPageView:(PSPDFPageView *)pageView {
    NSLog(@"didRenderPageView: page:%tu", pageView.page);
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didChangeViewMode:(PSPDFViewMode)viewMode {
    NSLog(@"didChangeViewMode: %tu", viewMode);
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didLoadPageView:(PSPDFPageView *)pageView {
    NSLog(@"didLoadPageView: page:%tu", pageView.page);
}

- (void)pdfViewController:(PSPDFViewController *)pdfController willUnloadPageView:(PSPDFPageView *)pageView {
    NSLog(@"willUnloadPageView: page:%tu", pageView.page);
}

- (UIView <PSPDFAnnotationViewProtocol> *)pdfViewController:(PSPDFViewController *)pdfController annotationView:(UIView <PSPDFAnnotationViewProtocol> *)annotationView forAnnotation:(PSPDFAnnotation *)annotation onPageView:(PSPDFPageView *)pageView {

    if ([annotation isKindOfClass:[PSPDFLinkAnnotation class]]) {
        PSPDFLinkAnnotation *linkAnnotation = (PSPDFLinkAnnotation *)annotation;
        // example how to add a MapView with the url protocol map://lat,long,latspan,longspan
        if (linkAnnotation.linkType == PSPDFLinkAnnotationCustom && [linkAnnotation.URL.absoluteString hasPrefix:@"map://"]) {
            // parse annotation data
            NSString *mapData = [linkAnnotation.URL.absoluteString stringByReplacingOccurrencesOfString:@"map://" withString:@""];
            NSArray *token = [mapData componentsSeparatedByString:@","];

            // ensure we have token count of 4 (latitude, longitude, span la, span lo)
            if (token.count == 4) {
                CLLocationCoordinate2D location = CLLocationCoordinate2DMake([token[0] doubleValue],
                                                                             [token[1] doubleValue]);

                MKCoordinateSpan span = MKCoordinateSpanMake([token[2] doubleValue],
                                                             [token[3] doubleValue]);

                // frame is set in PSPDFViewController, but MKMapView needs the position before setting the region.
                CGRect frame = [annotation boundingBoxForPageRect:pageView.bounds];

                MKMapView *mapView = [[MKMapView alloc] initWithFrame:frame];
                [mapView setRegion:MKCoordinateRegionMake(location, span) animated:NO];
                return (UIView <PSPDFAnnotationViewProtocol> *)mapView;
            }
        }
    }
    return annotationView;
}

/// Invoked prior to the presentation of the annotation view: use this to configure actions etc
- (void)pdfViewController:(PSPDFViewController *)pdfController willShowAnnotationView:(UIView <PSPDFAnnotationViewProtocol> *)annotationView onPageView:(PSPDFPageView *)pageView {
    NSLog(@"willShowAnnotationView: %@ page:%tu", annotationView, pageView.page);
}

/// Invoked after animation used to present the annotation view
- (void)pdfViewController:(PSPDFViewController *)pdfController didShowAnnotationView:(UIView <PSPDFAnnotationViewProtocol> *)annotationView onPageView:(PSPDFPageView *)pageView {
    NSLog(@"didShowAnnotationView: %@ page:%tu", annotationView, pageView.page);
}

- (BOOL)pdfViewController:(PSPDFViewController *)pdfController shouldShowController:(id)viewController embeddedInController:(id)controller options:(NSDictionary *)options animated:(BOOL)animated {
    NSLog(@"willShowViewController: %@ embeddedIn:%@ animated: %d", viewController, controller, animated);

    // example how to intercept PSPDFSearchViewController and change the barStyle to black
    if ([viewController isKindOfClass:[PSPDFSearchViewController class]]) {
        PSPDFSearchViewController *searchController = (PSPDFSearchViewController *)viewController;
        searchController.searchBar.barStyle = UIBarStyleBlack;
        searchController.searchBar.tintColor = UIColor.blackColor;
    }
    return YES;
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didShowController:(id<PSPDFPresentableViewController>)controller embeddedInController:(id<PSPDFHostableViewController>)hostController options:(NSDictionary *)options animated:(BOOL)animated {
    NSLog(@"didShowViewController: %@ embeddedIn:%@ animated: %d", controller, hostController, animated);
}

/// HUD was displayed (called after the animation finishes)
- (void)pdfViewController:(PSPDFViewController *)pdfController didShowHUD:(BOOL)animated {
    NSLog(@"didShowHUDAnimated: %@", animated ? @"YES" : @"NO");
}

/// HUD was hidden (called after the animation finishes)
- (void)pdfViewController:(PSPDFViewController *)pdfController didHideHUD:(BOOL)animated {
    NSLog(@"didHideHUDAnimated: %@", animated ? @"YES" : @"NO");
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocumentDelegate

/// Allow resolving custom path tokens (Documents, Bundle are automatically resolved; you can add e.g. Book and resolve this here). Will only get called for unknown tokens.
- (NSString *)pdfDocument:(PSPDFDocument *)document resolveCustomAnnotationPathToken:(NSString *)pathToken {
    NSString *resolvedPath = nil;
    if ([pathToken isEqualToString:@"TokenTest"]) {
        resolvedPath = NSBundle.mainBundle.bundlePath;
    }else {
        PSCLog(@"Token not recognized: %@", pathToken);
    }
    return resolvedPath;
}

@end
