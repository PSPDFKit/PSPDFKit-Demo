//
//  PSCCustomSearchBarButtonImage.m
//  PSPDFKit
//
//  Copyright (c) 2012-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAssetLoader.h"
#import "PSCExample.h"

@interface PSCCustomSearchBarButtonImageExample : PSCExample @end

@implementation PSCCustomSearchBarButtonImageExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Change the search button image";
        self.contentDescription = @"Replaces the search button with a custom view that animates between red and blue.";
        self.category = PSCExampleCategoryBarButtons;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFHackerMagazineAsset];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];

    UIButton *customView = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 32.f, 32.f)];
    customView.showsTouchWhenHighlighted = YES;

    // Add custom animation
    CABasicAnimation *anAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    anAnimation.duration = 1.00;
    anAnimation.repeatCount = FLT_MAX;
    anAnimation.autoreverses = YES;
    anAnimation.fromValue = (id) UIColor.redColor.CGColor;
    anAnimation.toValue = (id) UIColor.blueColor.CGColor;
    [customView.layer addAnimation:anAnimation forKey:@"backgroundColor"];

    // Hook up target/action from the original search button item to our custom one.
    [customView addTarget:pdfController.searchButtonItem.target action:pdfController.searchButtonItem.action forControlEvents:UIControlEventTouchUpInside];

    // Create the custom bar button item.
    UIBarButtonItem *customSearchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];

    // Seat all button items as default except the search button item which we replace with our custom one.
    pdfController.rightBarButtonItems = @[pdfController.annotationButtonItem, customSearchButtonItem, pdfController.outlineButtonItem, pdfController.activityButtonItem, pdfController.viewModeButtonItem];

    return pdfController;
}

@end
