//
//  PSCCustomSearchBarButtonImage.m
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCCustomSearchBarButtonImageExample.h"
#import "PSCAssetLoader.h"

@interface PSCCustomSearchBarButtonItem : PSPDFSearchBarButtonItem
@end

@implementation PSCCustomSearchBarButtonImageExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Change the search button image";
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
        _customView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        [_customView addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        _customView.backgroundColor = UIColor.redColor;
        _customView.showsTouchWhenHighlighted = YES;
    }
    return _customView;
}

@end
