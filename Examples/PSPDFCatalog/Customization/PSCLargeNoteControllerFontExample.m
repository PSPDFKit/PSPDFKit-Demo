//
//  PSCLargeNoteControllerFontExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"

@interface PSCLargeFontNoteAnnotationViewController : PSPDFNoteAnnotationViewController @end
@interface PSCLargeNoteControllerFontExample : PSCExample @end
@implementation PSCLargeNoteControllerFontExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Customized PSPDFNoteAnnotationViewController font";
        self.category = PSCExampleCategoryViewCustomization;
        self.priority = 89;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFQuickStartAsset];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document configuration:[PSPDFConfiguration configurationWithBuilder:^(PSPDFConfigurationBuilder *builder) {
        [builder overrideClass:PSPDFNoteAnnotationViewController.class withClass:PSCLargeFontNoteAnnotationViewController.class];
    }]];

    // We create appearance rule on the custom subclass
    // so that this example doesn't change all note controllers within the example
    [[UITextView appearanceWhenContainedIn:PSCLargeFontNoteAnnotationViewController.class, nil] setFont:[UIFont fontWithName:@"Helvetica" size:20.f]];
    [[UITextView appearanceWhenContainedIn:PSCLargeFontNoteAnnotationViewController.class, nil] setTextColor:UIColor.greenColor];
    return pdfController;
}

@end

@implementation PSCLargeFontNoteAnnotationViewController

- (void)updateTextView {
    [super updateTextView];

    // Possible to set the color here, but it's even cleaner to use UIAppearance rules (see above).
    //self.textView.font = [UIFont fontWithName:@"Helvetica" size:20.f];
    //self.textView.textColor = UIColor.brownColor;
}

@end
