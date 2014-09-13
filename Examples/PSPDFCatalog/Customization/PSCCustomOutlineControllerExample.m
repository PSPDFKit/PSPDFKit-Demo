//
//  PSCCustomOutlineController.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"

@interface PSCCustomOutlineBarButtonItem : PSPDFOutlineBarButtonItem @end
@interface PSCCustomOutlineViewController : UIViewController @end

@interface PSCCustomOutlineControllerExample : PSCExample @end
@implementation PSCCustomOutlineControllerExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Custom Outline Controller";
        self.category = PSCExampleCategoryViewCustomization;
        self.priority = 100;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document configuration:[PSPDFConfiguration configurationWithBuilder:^(PSPDFConfigurationBuilder *builder) {
        [builder overrideClass:PSPDFOutlineBarButtonItem.class withClass:PSCCustomOutlineBarButtonItem.class];
    }]];
    return pdfController;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCCustomOutlineBarButtonItem

@implementation PSCCustomOutlineBarButtonItem

- (NSString*)titleForOption:(PSPDFOutlineBarButtonItemOption)option {
    return (option == PSPDFOutlineBarButtonItemOptionOutline) ? @"Custom Outline" : [super titleForOption:option];
}

- (UIViewController *)controllerForOption:(PSPDFOutlineBarButtonItemOption)option {
    UIViewController *viewController = nil;

    if (option == PSPDFOutlineBarButtonItemOptionOutline) {
        viewController = [[PSCCustomOutlineViewController alloc] init];
    }else {
        viewController = [super controllerForOption:option];
    }
    return viewController;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCCustomOutlineViewController

@implementation PSCCustomOutlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];

    UILabel *customLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    customLabel.text = @"I am a custom outline controller";
    customLabel.textAlignment = NSTextAlignmentCenter;
    [customLabel sizeToFit];
    [self.view addSubview:customLabel];
}

@end
