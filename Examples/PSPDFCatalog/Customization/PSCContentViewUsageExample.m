//
//  PSCContentViewUsageExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCContentViewUsageExample.h"
#import "PSCAssetLoader.h"

@interface PSCCustomContentViewPDFController : PSPDFViewController
@property (nonatomic, strong) UIButton *alwaysVisibleButton;
@end

@implementation PSCContentViewUsageExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Use the 'contentView' to add always visible content.";
        self.category = PSCExampleCategoryViewCustomization;
    }
    return self;
}

- (UIViewController *)invoke {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    PSPDFViewController *pdfController = [[PSCCustomContentViewPDFController alloc] initWithDocument:document];
    return pdfController;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCCustomContentViewPDFController

@implementation PSCCustomContentViewPDFController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 'contentView' is first created in viewDidLoad.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Press Me" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    [button sizeToFit];
    [self.contentView addSubview:button];
    self.alwaysVisibleButton = button;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    // You can use AutoLayout as well...
    CGSize viewSize = self.view.bounds.size;
    CGSize buttonSize = self.alwaysVisibleButton.frame.size;
    self.alwaysVisibleButton.frame = CGRectIntegral(CGRectMake(viewSize.width-buttonSize.width, (viewSize.height-buttonSize.height)/2, buttonSize.width, buttonSize.height));
}

@end
