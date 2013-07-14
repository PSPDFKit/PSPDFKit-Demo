//
//  PSCVerticalAnnotationToolbar.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCVerticalAnnotationToolbar.h"

@interface PSCVerticalAnnotationToolbar() <PSPDFAnnotationToolbarDelegate>
@property (nonatomic, strong) UIButton *drawButton;
@property (nonatomic, strong) UIButton *freeTextButton;
@property (nonatomic, strong) PSPDFAnnotationToolbar *toolbar;
@end

@implementation PSCVerticalAnnotationToolbar

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithPDFController:(PSPDFViewController *)pdfController {
    if ((self = [super init])) {
        _pdfController = pdfController;

        self.toolbar = pdfController.annotationButtonItem.annotationToolbar;
        self.toolbar.annotationToolbarDelegate = self;
        self.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.8f];

        // draw button
        if ([pdfController.document.editableAnnotationTypes containsObject:PSPDFAnnotationStringInk]) {
            UIButton *drawButton = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *sketchImage = [UIImage imageNamed:@"PSPDFKit.bundle/sketch"];
            [drawButton setImage:sketchImage forState:UIControlStateNormal];
            [drawButton addTarget:self action:@selector(drawButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:drawButton];
            self.drawButton = drawButton;
        }

        // draw button
        if ([pdfController.document.editableAnnotationTypes containsObject:PSPDFAnnotationStringFreeText]) {
        UIButton *freetextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *freeTextImage = [UIImage imageNamed:@"PSPDFKit.bundle/freetext"];
        [freetextButton setImage:freeTextImage forState:UIControlStateNormal];
        [freetextButton addTarget:self action:@selector(freeTextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:freetextButton];
        self.freeTextButton = freetextButton;
        }

    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect rem = self.bounds, slice;
    CGRectDivide(rem, &slice, &rem, 44.f, CGRectMinYEdge);
    self.drawButton.frame = slice;
    self.freeTextButton.frame = rem;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Events

- (void)drawButtonPressed:(id)sender {
    PSPDFViewController *pdfController = self.pdfController;

    if (![self.toolbar.toolbarMode isEqualToString:PSPDFAnnotationStringInk]) {
        pdfController.HUDViewMode = PSPDFHUDViewAlways;
        if (!self.toolbar.window) {
            // match style
            self.toolbar.barStyle = pdfController.navigationBarStyle;
            self.toolbar.translucent = pdfController.isTransparentHUD;
            self.toolbar.tintColor = pdfController.tintColor;

            // add the toolbar to the view hierarchy for color picking etc
            if (pdfController.navigationController) {
                CGRect targetRect = pdfController.navigationController.navigationBar.frame;
                [pdfController.navigationController.view insertSubview:self.toolbar aboveSubview:pdfController.navigationController.navigationBar];
                [self.toolbar showToolbarInRect:targetRect animated:YES];
            }else {
                CGRect contentRect = pdfController.contentRect;
                CGRect targetRect = CGRectMake(contentRect.origin.x, contentRect.origin.y, pdfController.view.bounds.size.width, PSCToolbarHeightForOrientation(pdfController.interfaceOrientation));
                [pdfController.view addSubview:self.toolbar];
                [self.toolbar showToolbarInRect:targetRect animated:YES];
            }
        }

        // call draw mode of the toolbar
        [self.toolbar drawButtonPressed:sender];
    }else {
        pdfController.HUDViewMode = PSPDFHUDViewAutomatic;
        // remove toolbar
        [self.toolbar unlockPDFControllerAnimated:YES showControls:YES ensureToStayOnTop:NO];
        [self.toolbar finishDrawingAnimated:YES saveAnnotation:NO];
    }
}

- (void)freeTextButtonPressed:(id)sender {
    [self.toolbar freeTextButtonPressed:sender];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFAnnotationToolbarDelegate

// Called after a mode change is set (button pressed; drawing finished, etc)
- (void)annotationToolbar:(PSPDFAnnotationToolbar *)annotationToolbar didChangeMode:(NSString *)newMode {
    if (!newMode && annotationToolbar.window) {
        // don't show all toolbar features, hide instead.
        [annotationToolbar hideToolbarAnimated:YES completion:^{
            [annotationToolbar removeFromSuperview];
        }];
    }

    // update button selection status
    self.drawButton.backgroundColor = [newMode isEqualToString:PSPDFAnnotationStringInk] ? [UIColor whiteColor] : [UIColor clearColor];
    self.freeTextButton.backgroundColor = [newMode isEqualToString:PSPDFAnnotationStringFreeText] ? [UIColor whiteColor] : [UIColor clearColor];
}

@end
