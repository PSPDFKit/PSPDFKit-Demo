//
//  PSCCustomDefaultZoomScaleViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSCCustomDefaultZoomScaleViewController.h"

@interface PSCCustomDocumentProvider : PSPDFDocumentProvider @end

@interface PSCCustomDefaultZoomScaleViewController ()
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation PSCCustomDefaultZoomScaleViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document {
    [super commonInitWithDocument:document];
    document.overrideClassNames = @{(id<NSCopying>)PSPDFDocumentProvider.class : PSCCustomDocumentProvider.class};

    self.delegate = self;
    self.toolbarEnabled = NO;
    self.statusBarStyleSetting = PSPDFStatusBarDisable;
    self.HUDViewMode = PSPDFHUDViewNever;
    self.pageTransition = PSPDFPageCurlTransition;
    self.renderingMode = PSPDFPageRenderingModeFullPageBlocking;
    self.smartZoomEnabled = NO;
    self.zoomingSmallDocumentsEnabled = YES;
    self.createAnnotationMenuEnabled = NO;
    self.documentLabelEnabled = NO;
    self.textSelectionEnabled = NO;
    self.shadowEnabled = NO;
    self.backgroundColor = [UIColor blackColor];
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

- (void)pdfViewController:(PSPDFViewController *)pdfController willShowAnnotationView:(UIView<PSPDFAnnotationViewProtocol> *)annotationView onPageView:(PSPDFPageView *)pageView {
    if ([annotationView isKindOfClass:[PSPDFVideoAnnotationView class]]) {
        PSPDFVideoAnnotationView *videoView = (PSPDFVideoAnnotationView *)annotationView;
        videoView.autoplayEnabled = YES;

        MPMoviePlayerController *player = videoView.player;
        player.controlStyle = MPMovieControlStyleNone;
        player.scalingMode = MPMovieScalingModeAspectFill;
    }
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didLoadPageView:(PSPDFPageView *)pageView {
    pageView.scrollView.scrollEnabled = NO;
    pageView.scrollView.zoomingEnabled = NO;
}

- (void)pdfViewController:(PSPDFViewController *)pdfController
    didShowAnnotationView:(UIView<PSPDFAnnotationViewProtocol> *)annotationView
               onPageView:(PSPDFPageView *)pageView {
    if([annotationView isKindOfClass:[PSPDFVideoAnnotationView class]]) {
        PSPDFVideoAnnotationView *videoView = (PSPDFVideoAnnotationView *)annotationView;
        MPMoviePlayerController *player = videoView.player;
        player.scalingMode = MPMovieScalingModeAspectFill;
        player.view.userInteractionEnabled = NO;
    }
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
    }else {
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
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
    CGFloat pageRatio = pageInfo.rotatedPageRect.size.width/pageInfo.rotatedPageRect.size.height;
    CGFloat screenRatio = UIScreen.mainScreen.bounds.size.height/UIScreen.mainScreen.bounds.size.width; // landscape
    CGFloat diff = pageRatio - screenRatio;

    if (diff > 0.1) {
        pageInfo = [pageInfo copy];
        CGFloat cutX = pageInfo.pageRect.size.width * diff/2;
        pageInfo.pageRect = CGRectIntegral(CGRectMake(cutX/2, 0, pageInfo.pageRect.size.width-cutX, pageInfo.pageRect.size.height));
    }
    
    return pageInfo;
}

@end
