//
//  PSCCustomSelectionKnobsExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"

@interface PSCResizableView : PSPDFResizableView @end
@implementation PSCResizableView

- (id)initWithTrackedView:(UIView *)trackedView {
    if (self = [super initWithTrackedView:trackedView]) {

        // Remove all knobs but the bottom right one.
        for (PSPDFResizableViewOuterKnob knobType = PSPDFResizableViewOuterKnobTopLeft; knobType < PSPDFResizableViewOuterKnobBottomRight; knobType++) {
            [[self outerKnobOfType:knobType] removeFromSuperview];
        }

        // Draw a custom knob in code.
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(60.f, 60.f), NO, 0.0);
        UIColor* color = [UIColor colorWithRed: 1 green: 0.622 blue: 0 alpha: 1];

        //// Oval Drawing
        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(2, 2, 56, 56)];
        [color setFill];
        [ovalPath fill];
        [UIColor.redColor setStroke];
        ovalPath.lineWidth = 1;
        [ovalPath stroke];

        //// Bezier Drawing
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(12.5, 26.5)];
        [bezierPath addCurveToPoint: CGPointMake(22.57, 18.24) controlPoint1: CGPointMake(16.72, 23.12) controlPoint2: CGPointMake(20.01, 20.41)];
        [bezierPath addCurveToPoint: CGPointMake(31.5, 9.5) controlPoint1: CGPointMake(32.12, 10.12) controlPoint2: CGPointMake(31.5, 9.5)];
        [UIColor.blackColor setStroke];
        bezierPath.lineWidth = 3.5;
        [bezierPath stroke];

        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
        [bezier2Path moveToPoint: CGPointMake(22.5, 18.5)];
        [bezier2Path addCurveToPoint: CGPointMake(39.5, 41.5) controlPoint1: CGPointMake(39.5, 41.5) controlPoint2: CGPointMake(39.5, 41.5)];
        [bezier2Path addLineToPoint: CGPointMake(49.5, 31.5)];
        [bezier2Path addLineToPoint: CGPointMake(31.5, 49.5)];
        [UIColor.blackColor setStroke];
        bezier2Path.lineWidth = 3.5;
        [bezier2Path stroke];
        UIImage *knobImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        UIImageView *bottomRightKnob = [self outerKnobOfType:PSPDFResizableViewOuterKnobBottomRight];
        bottomRightKnob.image = knobImage;
        [bottomRightKnob sizeToFit];

        self.selectionBorderColor = color;
    }
    return self;
}

- (CGPoint)centerPointForOuterKnob:(PSPDFResizableViewOuterKnob)knob {
    CGPoint point = [super centerPointForOuterKnob:knob];
    if (knob == PSPDFResizableViewOuterKnobBottomRight) {
        point.x += 10.f;
        point.y += 10.f;
    }
    return point;
}

@end

@interface PSCCustomSelectionKnobsExample : PSCExample <PSPDFViewControllerDelegate> @end
@implementation PSCCustomSelectionKnobsExample

//////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Custom Selection Knobs Example";
        self.category = PSCExampleCategoryViewCustomization;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];

    // Add free text.
    PSPDFFreeTextAnnotation *freeText = [PSPDFFreeTextAnnotation new];
    freeText.fontSize = 30.f;
    freeText.contents = @"I am example text. Drag me!";
    freeText.boundingBox = CGRectMake(50.f, 50.f, 300.f, 300.f);
    [freeText sizeToFit];
    freeText.color = UIColor.blueColor;
    freeText.absolutePage = 0;
    [document addAnnotations:@[freeText]];

    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    [pdfController overrideClass:PSPDFResizableView.class withClass:PSCResizableView.class];
    pdfController.delegate = self;

    [[PSCResizableView appearance] setSelectionBorderWidth:3.f];
    [[PSCResizableView appearance] setCornerRadius:6.f];

    return pdfController;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (void)pdfViewController:(PSPDFViewController *)pdfController didLoadPageView:(PSPDFPageView *)pageView {
    // Automatically select
    if (pageView.page == 0) {
        pageView.selectedAnnotations = [pdfController.document annotationsForPage:0 type:PSPDFAnnotationTypeFreeText];
    }
}

@end
