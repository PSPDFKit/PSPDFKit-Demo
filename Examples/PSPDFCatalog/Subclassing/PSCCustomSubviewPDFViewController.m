//
//  PSCCustomSubviewPDFViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSCCustomSubviewPDFViewController.h"

@interface PSCOverlayFileAnnotationProvider : PSPDFFileAnnotationProvider @end

// This is an example how to modify all annotations to render as overlay.
// Note that this is a corner case and isn't as greatly tested.
@implementation PSCCustomSubviewPDFViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document {
    [super commonInitWithDocument:document];
    self.delegate = self;
    self.rightBarButtonItems = @[self.annotationButtonItem, self.viewModeButtonItem];

    // register our custom annotation provider as subclass.
    document.overrideClassNames = @{(id)[PSPDFFileAnnotationProvider class] : [PSCOverlayFileAnnotationProvider class]};
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (void)pdfViewController:(PSPDFViewController *)pdfController didLoadPageView:(PSPDFPageView *)pageView {
    // adds a custom view above every page, to demonstrate that the annotations will render ABOVE that view.
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 300, 300)];
    customView.backgroundColor = [UIColor colorWithRed:1.000 green:0.846 blue:0.088 alpha:0.900];
    customView.layer.cornerRadius = 10.f;
    customView.layer.borderColor = [UIColor colorWithRed:1.000 green:0.846 blue:0.088 alpha:1.000].CGColor;
    customView.layer.borderWidth = 2.f;
    [pageView insertSubview:customView belowSubview:pageView.annotationContainerView];
}

@end

@implementation PSCOverlayFileAnnotationProvider

- (NSArray *)annotationsForPage:(NSUInteger)page pageRef:(CGPDFPageRef)pageRef {
    NSArray *annotations = [super annotationsForPage:page pageRef:pageRef];

    // make all annotations overlay annotations (they will be rendered in their own views instead of within the page image)
    for (PSPDFAnnotation *annotation in annotations) {
        // Making highlights as overlay really really doesn't look good. (since they are multiplied into the page content, this is not possible with regular UIView composition, so you'd completely overlap the text, unless you make them semi-transparent)
        if (![annotation isKindOfClass:[PSPDFHighlightAnnotation class]]) {
            annotation.overlay = YES;
        }
    }
    return annotations;
}

// Set annotations to render as overlay right after they are inserted.
- (BOOL)addAnnotations:(NSArray *)annotations forPage:(NSUInteger)page {
    for (PSPDFAnnotation *annotation in annotations) {
        if (![annotation isKindOfClass:[PSPDFHighlightAnnotation class]]) {
            annotation.overlay = YES;
        }
    }
    return [super addAnnotations:annotations forPage:page];
}

@end

