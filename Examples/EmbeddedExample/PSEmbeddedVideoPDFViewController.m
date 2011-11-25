//
//  PSEmbeddedVideoPDFViewController.m
//  EmbeddedExample
//
//  Created by Peter Steinberger on 9/11/11.
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

#import "PSEmbeddedVideoPDFViewController.h"
#import <MapKit/MapKit.h>

@implementation PSEmbeddedVideoPDFViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithDocument:document])) {
        self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"VideoEx" image:[UIImage imageNamed:@"45-movie-1"] tag:4] autorelease];
        self.delegate = self; // set PSPDFViewControllerDelegate to self        
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

// disable back button
- (UIBarButtonItem *)toolbarBackButton {
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

/// called after pdf page has been loaded and added to the pagingScrollView.
- (void)pdfViewController:(PSPDFViewController *)pdfController didLoadPageView:(PSPDFPageView *)pageView; {
    NSLog(@"didLoadPageView: page:%d", pageView.page);
}

/// called before a pdf page will be unloaded and removed from the pagingScrollView.
- (void)pdfViewController:(PSPDFViewController *)pdfController willUnloadPageView:(PSPDFPageView *)pageView; {
    NSLog(@"willUnloadPageView: page:%d", pageView.page);
}

- (UIView *)pdfViewController:(PSPDFViewController *)pdfController viewForAnnotation:(PSPDFAnnotation *)annotation onPageView:(PSPDFPageView *)pageView {
    
    // example how to add a MapView with the url protocol map://lat,long,latspan,longspan
    if (annotation.type == PSPDFAnnotationTypeCustom && [annotation.siteLinkTarget hasPrefix:@"map://"]) {
        // parse annotation data
        NSString *mapData = [annotation.siteLinkTarget stringByReplacingOccurrencesOfString:@"map://" withString:@""];
        NSArray *token = [mapData componentsSeparatedByString:@","];

        // ensure we have token count of 4 (latitude, longitude, span la, span lo)
        if ([token count] == 4) {
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake([[token objectAtIndex:0] doubleValue],
                                                                         [[token objectAtIndex:1] doubleValue]);
            
            MKCoordinateSpan span = MKCoordinateSpanMake([[token objectAtIndex:2] doubleValue],
                                                         [[token objectAtIndex:3] doubleValue]);
            
            // frame is set in PSPDFViewController, but MKMapView needs the position before setting the region.
            CGRect frame = [annotation rectForPageRect:pageView.bounds];
            
            MKMapView *mapView = [[[MKMapView alloc] initWithFrame:frame] autorelease];
            [mapView setRegion:MKCoordinateRegionMake(location, span) animated:NO];
            return mapView;
        }
    }
    return nil;
}

@end
