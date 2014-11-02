//
//  PSCMapWidgetExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"
#import <MapKit/MapKit.h>

@interface PSCMapWidgetExample : PSCExample <PSPDFViewControllerDelegate> @end

@implementation PSCMapWidgetExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Page with Apple Maps Widget";
        self.category = PSCExampleCategoryViewCustomization;
        self.priority = 50;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFHackerMagazineAsset];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;

    // This annotation could be already in the document - we just add it programmatically for this example.
    PSPDFLinkAnnotation *linkAnnotation = [[PSPDFLinkAnnotation alloc] initWithURL:[NSURL URLWithString:@"map://37.7998377,-122.400478,0.005,0.005"]];
    linkAnnotation.linkType = PSPDFLinkAnnotationBrowser;
    linkAnnotation.boundingBox = CGRectMake(100.f, 100.f, 300.f, 300.f);
    linkAnnotation.page = 0;
    [document addAnnotations:@[linkAnnotation]];

    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document configuration:[PSPDFConfiguration configurationWithBuilder:^(PSPDFConfigurationBuilder *builder) {
        builder.thumbnailBarMode = PSPDFThumbnailBarModeNone;
    }]];
    pdfController.delegate = self;
    return pdfController;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (UIView <PSPDFAnnotationViewProtocol> *)pdfViewController:(PSPDFViewController *)pdfController annotationView:(UIView <PSPDFAnnotationViewProtocol> *)annotationView forAnnotation:(PSPDFAnnotation *)annotation onPageView:(PSPDFPageView *)pageView {

    if ([annotation isKindOfClass:[PSPDFLinkAnnotation class]]) {
        PSPDFLinkAnnotation *linkAnnotation = (PSPDFLinkAnnotation *)annotation;
        // example how to add a MapView with the url protocol map://lat,long,latspan,longspan
        if (linkAnnotation.linkType == PSPDFLinkAnnotationBrowser && [linkAnnotation.URL.absoluteString hasPrefix:@"map://"]) {
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


@end
