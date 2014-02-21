//
//  PSCHighlightAnnotationToolbarButtonExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAssetLoader.h"
#import "UIImage+Tinting.h"
#import <objc/message.h>
#import "PSCExample.h"

@interface PSCHighlightAnnotationBarButtonItem : UIBarButtonItem @end

@interface PSCHighlightAnnotationToolbarButtonExample : PSCExample
@property (nonatomic, weak) PSPDFViewController *pdfController;
@end

@implementation PSCHighlightAnnotationToolbarButtonExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Highlight Toolbar Button";
        self.contentDescription = @"Add the highlight button into the main toolbar.";
        self.category = PSCExampleCategoryAnnotations;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];

    // Create highlight button and set it.
    UIBarButtonItem *highlightButton = [PSCHighlightAnnotationBarButtonItem new];
    highlightButton.target = self;
    highlightButton.action = @selector(highlightButtonPressed:);
    pdfController.rightBarButtonItems = @[highlightButton, pdfController.outlineButtonItem, pdfController.viewModeButtonItem];

    self.pdfController = pdfController;
    return pdfController;
}

// Toggle highlight mode.
- (void)highlightButtonPressed:(id)sender {
    [self.pdfController.annotationStateManager toggleState:PSPDFAnnotationStringHighlight];
}

@end

@implementation PSCHighlightAnnotationBarButtonItem {
    UIButton *_highlightButton;
}

- (id)init {
    if (self = [super init]) {
        // Create custom view since we need to show the state.
        _highlightButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 32.f, 32.f)];
        [_highlightButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_highlightButton setImage:[PSPDFBundleImage(@"highlight") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_highlightButton setImage:[PSPDFBundleImage(@"highlight") psc_imageTintedWithColor:UIColor.yellowColor fraction:0.f] forState:UIControlStateSelected];
        self.customView = _highlightButton;
    }
    return self;
}

- (void)buttonClicked:(id)sender {
    _highlightButton.selected = !_highlightButton.isSelected;
    objc_msgSend(self.target, self.action, sender); // forward action.
}

@end
