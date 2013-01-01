//
//  PSCVerticalAnnotationToolbar.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSCVerticalAnnotationToolbar.h"

@interface PSCVerticalAnnotationToolbar() <PSPDFAnnotationToolbarDelegate>
@property (nonatomic, strong) UIButton *drawButton;
@property (nonatomic, strong) PSPDFAnnotationToolbar *toolbar;
@end

@implementation PSCVerticalAnnotationToolbar

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithPDFController:(PSPDFViewController *)pdfController {
    if ((self = [super init])) {
        _pdfController = pdfController;

        self.toolbar = [[PSPDFAnnotationToolbar alloc] initWithPDFController:pdfController];
        self.toolbar.delegate = self;
        self.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.8f];

        // simple example, just one button.
        UIButton *drawButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *sketchImage = [UIImage imageNamed:@"PSPDFKit.bundle/sketch"];
        [drawButton setImage:sketchImage forState:UIControlStateNormal];
        [drawButton addTarget:self action:@selector(drawButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:drawButton];
        self.drawButton = drawButton;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.drawButton.frame = self.bounds;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Events

- (void)drawButtonPressed:(id)sender {
    if (self.toolbar.toolbarMode == PSPDFAnnotationToolbarNone) {

        // add the toolbar to the view hierarchy for color picking etc
        if (self.pdfController.navigationController) {
            CGRect targetRect = self.pdfController.navigationController.navigationBar.frame;
            [self.pdfController.navigationController.view insertSubview:self.toolbar aboveSubview:self.pdfController.navigationController.navigationBar];
            [self.toolbar showToolbarInRect:targetRect animated:YES];
        }else {
            CGRect targetRect = CGRectMake(0, 0, self.pdfController.view.bounds.size.width, PSPDFToolbarHeightForOrientation(self.pdfController.interfaceOrientation));
            [self.toolbar showToolbarInRect:targetRect animated:YES];
        }

        // call draw mode of the toolbar
        [self.toolbar drawButtonPressed:sender];
    }else {
        // remove toolbar
        [self.toolbar unlockPDFControllerAndEnsureToStayOnTop:NO];
        [self.toolbar finishDrawingAnimated:YES andSaveAnnotation:NO];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFAnnotationToolbarDelegate

// Called after a mode change is set (button pressed; drawing finished, etc)
- (void)annotationToolbar:(PSPDFAnnotationToolbar *)annotationToolbar didChangeMode:(PSPDFAnnotationToolbarMode)newMode {
    if (newMode == PSPDFAnnotationToolbarNone) {
        // don't show all toolbar features, hide instead.
        [self.toolbar hideToolbarAnimated:YES completion:^{
            [self.toolbar removeFromSuperview];
        }];
    }

    // update button selection status
    self.drawButton.backgroundColor = newMode == PSPDFAnnotationToolbarDraw ? [UIColor whiteColor] : [UIColor clearColor];
}

@end
