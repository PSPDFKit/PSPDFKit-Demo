//
//  PSCCustomSearchBarButtonImage.m
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAssetLoader.h"
#import "PSCExample.h"

@interface PSCCustomSearchBarButtonImageExample : PSCExample @end
@interface PSCCustomSearchBarButtonItem : PSPDFSearchBarButtonItem @end

@implementation PSCCustomSearchBarButtonImageExample

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"Change the search button image";
        self.contentDescription = @"Replaces the search button with a custom view that animates between red and blue.";
        self.category = PSCExampleCategoryBarButtons;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    [pdfController overrideClass:PSPDFSearchBarButtonItem.class withClass:PSCCustomSearchBarButtonItem.class];
    return pdfController;
}

@end

@implementation PSCCustomSearchBarButtonItem {
    UIButton *_customView;
}

- (UIBarButtonSystemItem)systemItem {
    return (UIBarButtonSystemItem)-1;
}

- (UIImage *)image {
    return nil;
}

- (UIView *)customView {
    if (!_customView) {
        _customView = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 32.f, 32.f)];
        [_customView addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        _customView.showsTouchWhenHighlighted = YES;

        // Add custom animation
        CABasicAnimation *anAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        anAnimation.duration = 1.00;
        anAnimation.repeatCount = FLT_MAX;
        anAnimation.autoreverses = YES;
        anAnimation.fromValue = (id) UIColor.redColor.CGColor;
        anAnimation.toValue = (id) UIColor.blueColor.CGColor;
        [_customView.layer addAnimation:anAnimation forKey:@"backgroundColor"];
    }
    return _customView;
}

@end
