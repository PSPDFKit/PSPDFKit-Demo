//
//  PSCDefaultZoomScaleViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCDefaultZoomScaleViewController.h"

@interface PSCCustomDocumentProvider : PSPDFDocumentProvider @end

@interface PSCDefaultZoomScaleViewController ()
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation PSCDefaultZoomScaleViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document configuration:(PSPDFConfiguration *)configuration {
    [super commonInitWithDocument:document configuration:[configuration configurationUpdatedWithBuilder:^(PSPDFConfigurationBuilder *builder) {
        builder.toolbarEnabled = NO;
        builder.HUDViewMode = PSPDFHUDViewModeNever;
        builder.pageTransition = PSPDFPageTransitionCurl;
        builder.renderingMode = PSPDFPageRenderingModeFullPageBlocking;
        builder.smartZoomEnabled = NO;
        builder.zoomingSmallDocumentsEnabled = YES;
        builder.createAnnotationMenuEnabled = NO;
        builder.documentLabelEnabled = NO;
        builder.textSelectionEnabled = NO;
        builder.shadowEnabled = NO;
        builder.backgroundColor = UIColor.blackColor;
    }]];
    [document overrideClass:PSPDFDocumentProvider.class withClass:PSCCustomDocumentProvider.class];

    self.delegate = self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Add close button
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setImage:[UIImage imageNamed:@"closebox"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton sizeToFit];
    [self.view addSubview:self.closeButton];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnPageView:(PSPDFPageView *)pageView atPoint:(CGPoint)viewPoint {
    [self toggleCloseButton];
    return YES;
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didShowPageView:(PSPDFPageView *)pageView {
    if (self.isLastPage) {
        [self performSelector:@selector(showCloseButton) withObject:nil afterDelay:1.f];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showCloseButton) object:nil];
        [self setCloseButtonHidden:YES animated:YES];
    }
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didLoadPageView:(PSPDFPageView *)pageView {
    pageView.scrollView.scrollEnabled = NO;
    pageView.scrollView.zoomingEnabled = NO;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)setCloseButtonHidden:(BOOL)hidden animated:(BOOL)animated {
    if (animated) {
        if (!hidden) {
            [self.view addSubview:self.closeButton];
            self.closeButton.alpha = 0.f;
        }
        [UIView animateWithDuration:0.25f delay:0.f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction animations:^{
            self.closeButton.alpha = hidden ? 0.f : 1.f;
        } completion:^(BOOL finished) {
            if (hidden) [self.closeButton removeFromSuperview];
        }];
    } else {
        if (hidden) [self.closeButton removeFromSuperview];
        else [self.view addSubview:self.closeButton];
    }
}

- (void)showCloseButton {
    [self setCloseButtonHidden:NO animated:YES];
}

- (void)toggleCloseButton {
    [self setCloseButtonHidden:self.closeButton.superview != nil animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Rotation

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCCustomDocumentProvider

@implementation PSCCustomDocumentProvider

- (PSPDFPageInfo *)pageInfoForPage:(NSUInteger)page pageRef:(CGPDFPageRef)pageRef {
    PSPDFPageInfo *pageInfo = [super pageInfoForPage:page pageRef:pageRef];

    // Adapt the PDF so that it is always full screen, cutting away some content if it doesn't fit.
    CGFloat pageRatio = pageInfo.rotatedRect.size.width/pageInfo.rotatedRect.size.height;
    CGFloat screenRatio = UIScreen.mainScreen.bounds.size.height/UIScreen.mainScreen.bounds.size.width; // landscape
    CGFloat diff = pageRatio - screenRatio;

    if (diff > 0.1) {
        CGFloat cutX = pageInfo.rect.size.width * diff/2;
        pageInfo = [[PSPDFPageInfo alloc] initWithPage:pageInfo.page rect:CGRectIntegral(CGRectMake(cutX / 2, 0, pageInfo.rect.size.width - cutX, pageInfo.rect.size.height)) rotation:pageInfo.rotation documentProvider:pageInfo.documentProvider];
    }

    return pageInfo;
}

@end
