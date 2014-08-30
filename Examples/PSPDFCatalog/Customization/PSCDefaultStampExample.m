//
//  PSCDefaultStampExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAssetLoader.h"
#import "PSCExample.h"
#import <tgmath.h>

@interface PSCCustomStampAnnotationToolbar : PSPDFFlexibleAnnotationToolbar @end
@interface PSCInvisibleResizableView : PSPDFResizableView @end
@interface PSCCustomTouchScrollView : PSPDFScrollView @end
@interface PSCFastStampAnnotation : PSPDFStampAnnotation @end

@interface PSCDefaultStampExample : PSCExample @end
@interface PSCDefaultStampExample () <PSPDFViewControllerDelegate> @end

@implementation PSCDefaultStampExample

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"Custom Stamp Mode";
        self.contentDescription = @"Shows how much the stamp feature can be customized.";
        self.category = PSCExampleCategoryViewCustomization;
        self.priority = 1000;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    // Set up the document.
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    [document overrideClass:PSPDFStampAnnotation.class withClass:PSCFastStampAnnotation.class];

    // And also the controller.
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document configuration:[PSPDFConfiguration configurationWithBuilder:^(PSPDFConfigurationBuilder *builder) {
        builder.createAnnotationMenuEnabled = NO;
        [builder overrideClass:PSPDFFlexibleAnnotationToolbar.class withClass:PSCCustomStampAnnotationToolbar.class];
        [builder overrideClass:PSPDFResizableView.class withClass:PSCInvisibleResizableView.class];
        [builder overrideClass:PSPDFScrollView.class withClass:PSCCustomTouchScrollView.class];
    }]];
    pdfController.delegate =  self;
    return pdfController;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Helper

static BOOL PSCRemoveStampAnnotationsAtPage(PSPDFPageView *pageView, CGPoint viewPoint) {
    NSCParameterAssert(pageView);
    NSArray *stampAnnotations = PSCStampAnnotationsAtPoint(pageView, viewPoint);
    if (stampAnnotations.count > 0) {
        return [pageView.document removeAnnotations:@[stampAnnotations[0]]];
    }
    return NO;
}

static NSArray *PSCStampAnnotationsAtPoint(PSPDFPageView *pageView, CGPoint viewPoint) {
    NSCParameterAssert(pageView);
    NSMutableArray *stampAnnotations = [NSMutableArray array];
    for (PSPDFAnnotation *annotation in [pageView tappableAnnotationsAtPoint:viewPoint]) {
        if (annotation.type == PSPDFAnnotationTypeStamp) {
            [stampAnnotations addObject:annotation];
        }
    }
    return stampAnnotations;
}

static BOOL PSCIsStampModeEnabledForPDFController(PSPDFViewController *pdfController) {
    return [pdfController.annotationStateManager.state isEqualToString:PSPDFAnnotationStringStamp];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnPageView:(PSPDFPageView *)pageView atPoint:(CGPoint)viewPoint {
    // Process taps - if we are in stamp mode, add or remove stamps on touch.
    if (PSCIsStampModeEnabledForPDFController(pdfController)) {
        if (!PSCRemoveStampAnnotationsAtPage(pageView, viewPoint)) {
            PSPDFStampAnnotation *stampAnnotation = [[pdfController.document classForClass:PSPDFStampAnnotation.class] new];
            stampAnnotation.subject = @"Accepted"; // PDF spec special case; will render as checkmark.
            stampAnnotation.boundingBox = CGRectMake(0, 0, 100, 100);
            stampAnnotation.absolutePage = pageView.page;

            // Center and add annotation.
            [pageView centerAnnotation:stampAnnotation aroundViewPoint:viewPoint];
            [pdfController.document addAnnotations:@[stampAnnotation] options:@{PSPDFAnnotationOptionUserCreatedKey: @YES}];
        }
        return YES;
    }
    return NO;
}

- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didLongPressOnPageView:(PSPDFPageView *)pageView atPoint:(CGPoint)viewPoint gestureRecognizer:(UILongPressGestureRecognizer *)gestureRecognizer {
    // After we're done with dragging, make sure annotations are deselected again.
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        pageView.selectedAnnotations = nil;
    }
    return NO;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCCustomStampAnnotationToolbar

@implementation PSCCustomStampAnnotationToolbar

// By default, this mode would show the stamp view controller.
// We want to preselect a stamp and enter a special stamp creation/deletion mode.
- (void)stampButtonPressed:(id)sender {
    if (![self.annotationStateManager.state isEqualToString:PSPDFAnnotationStringStamp]) {
        // Make sure we deselect any selected annotation.
        [self.annotationStateManager.pdfController.visiblePageViews makeObjectsPerformSelector:@selector(setSelectedAnnotations:) withObject:nil];
        self.annotationStateManager.state = PSPDFAnnotationStringStamp;
    }else {
        self.annotationStateManager.state = nil;
    }
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCInvisibleResizableView

@implementation PSCInvisibleResizableView

- (void)layoutSubviews {
    [super layoutSubviews];
    // Always hide view - don't show any selection state.
    self.alpha = 0.f;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCCustomTouchScrollView

@implementation PSCCustomTouchScrollView {
    CGPoint _startPoint;
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer {
    [super longPress:recognizer];

    // Remember start point and handle it as a tap if move distance is below a certain treshold.
    PSPDFViewController *pdfController = self.configurationDataSource.pdfController;
    if (PSCIsStampModeEnabledForPDFController(pdfController)) {
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            _startPoint = [recognizer locationInView:self];
        }
        else if (recognizer.state == UIGestureRecognizerStateEnded) {
            // Calculate distance from starting point.
            CGPoint endPoint = [recognizer locationInView:self];
            CGFloat distance = (CGFloat)fmax(fabs(_startPoint.x - endPoint.x), fabs(_startPoint.y - endPoint.y));
            if (distance < 5) {
                for (PSPDFPageView *pageView in pdfController.visiblePageViews) {
                    if (PSCRemoveStampAnnotationsAtPage(pageView, [recognizer locationInView:pageView])) break;
                }
            }
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    BOOL shouldBegin = [super gestureRecognizerShouldBegin:gestureRecognizer];

    // If not enabled yet, check if we're in our special stamp mode and allow long press there.
    // (Usually, long press is blocked when the annotation toolbar is active)
    if (!shouldBegin && PSCIsStampModeEnabledForPDFController(self.configurationDataSource.pdfController) &&
        [gestureRecognizer isKindOfClass:UILongPressGestureRecognizer.class]) {
        shouldBegin = YES;
    }
    return shouldBegin;
}

- (BOOL)pressRecognizerShouldHandlePressImmediately:(PSPDFLongPressGestureRecognizer *)recognizer {
    // Select a stamp annotation as soon as we start touching it, making dragging instant.
    id <PSPDFConfigurationDataSource> configDataSource = self.configurationDataSource;
    if (PSCIsStampModeEnabledForPDFController(configDataSource.pdfController)) {
        for (PSPDFPageView *pageView in configDataSource.visiblePageViews) {
            NSArray *stampAnnotations = PSCStampAnnotationsAtPoint(pageView, [recognizer locationInView:pageView]);
            if (stampAnnotations.count > 0) {
                pageView.selectedAnnotations = @[stampAnnotations[0]];
                break;
            }
        }
    }
    return [super pressRecognizerShouldHandlePressImmediately:recognizer];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCFastStampAnnotation

@implementation PSCFastStampAnnotation

// We don't want to allow resizing here.
- (BOOL)isResizable {
    return NO;
}

// Enable overlay mode for stamps. This will disable rendering them into the page image,
// and thus allow updates faster. Downside: Doesn't render into the thumbnails.
- (BOOL)isOverlay {
    return YES;
}

@end
