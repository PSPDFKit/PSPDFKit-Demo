//
//  PSCCustomColorPickerColorsExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"

@interface PSCCustomColorSelectionViewController : PSPDFColorSelectionViewController
@end

#define PSCColorPickerStyleCustom (PSPDFColorPickerStyleHSVPicker+1)

@interface PSCCustomColorPickerColorsExample : PSCExample @end
@implementation PSCCustomColorPickerColorsExample

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"Custom color picker";
        self.contentDescription = @"Defines a custom set of color patterns";
        self.category = PSCExampleCategoryViewCustomization;
        self.priority = 88;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kPSPDFQuickStart];
    
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document configuration:[PSPDFConfiguration configurationWithBuilder:^(PSPDFConfigurationBuilder *builder) {
        [builder overrideClass:PSPDFColorSelectionViewController.class withClass:PSCCustomColorSelectionViewController.class];
    }]];

    // Register the class overrides.
    [PSPDFColorSelectionViewController setDefaultColorPickerStyles:@[@(PSCColorPickerStyleCustom)]];
    return pdfController;
}

@end

@implementation PSCCustomColorSelectionViewController

+ (UIViewController *)colorPickerForType:(PSPDFColorPickerStyle)type {
    if (type == PSCColorPickerStyleCustom) {
        NSArray *colors = @[UIColor.redColor, UIColor.greenColor];
        PSPDFColorSelectionViewController *colorsViewController = [[self alloc] initWithColors:colors];
        colorsViewController.title = PSPDFLocalize(@"Custom");
        return colorsViewController;
    }else {
        return [super colorPickerForType:type];
    }
}

@end
