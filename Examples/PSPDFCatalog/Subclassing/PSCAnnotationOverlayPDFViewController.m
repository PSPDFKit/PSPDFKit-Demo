//
//  PSCAnnotationOverlayPDFViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAnnotationOverlayPDFViewController.h"

@interface PSCOverlayFileAnnotationProvider : PSPDFFileAnnotationProvider @end

// This is an example how to modify all annotations to render as overlay.
// Note that this is a corner case and isn't as greatly tested.
@implementation PSCAnnotationOverlayPDFViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document configuration:(PSPDFConfiguration *)configuration {
    [super commonInitWithDocument:document configuration:configuration];
    self.delegate = self;
    self.rightBarButtonItems = @[self.annotationButtonItem, self.viewModeButtonItem];

    // register our custom annotation provider as subclass.
    [document overrideClass:PSPDFFileAnnotationProvider.class withClass:PSCOverlayFileAnnotationProvider.class];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (void)pdfViewController:(PSPDFViewController *)pdfController didLoadPageView:(PSPDFPageView *)pageView {
    // adds a custom view above every page, to demonstrate that the annotations will render ABOVE that view.
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(100.f, 100.f, 300.f, 300.f)];
    customView.backgroundColor = [UIColor colorWithRed:1.f green:0.846f blue:0.088f alpha:0.9f];
    customView.layer.cornerRadius = 10.f;
    customView.layer.borderColor = [UIColor colorWithRed:1.f green:0.846f blue:0.088f alpha:1.f].CGColor;
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
        if (!(annotation.type & PSPDFAnnotationTypeTextMarkup) == 0) {
            annotation.overlay = YES;
        }
    }
    return annotations;
}

// Set annotations to render as overlay right after they are inserted.
- (NSArray *)addAnnotations:(NSArray *)annotations options:(NSDictionary *)options {
    for (PSPDFAnnotation *annotation in annotations) {
        if (![annotation isKindOfClass:[PSPDFHighlightAnnotation class]]) {
            annotation.overlay = YES;
        }
    }
    return [super addAnnotations:annotations options:options];
}

@end

