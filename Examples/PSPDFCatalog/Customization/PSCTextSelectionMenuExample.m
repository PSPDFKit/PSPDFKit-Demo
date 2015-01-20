//
//  PSCTextSelectionMenuExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAssetLoader.h"
#import "PSCExample.h"

@interface PSCTextSelectionMenuExample : PSCExample @end

@interface PSCustomTextSelectionMenuController : PSPDFViewController <PSPDFViewControllerDelegate>
@end

@implementation PSCTextSelectionMenuExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Custom Text Selection Menu";
        self.contentDescription = @"Add option to google for selected text via the PSPDFViewControllerDelegate.";
        self.category = PSCExampleCategoryControllerCustomization;
        self.priority = 100;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFHackerMagazineAsset];
    return [[PSCustomTextSelectionMenuController alloc] initWithDocument:document];
}

@end

@implementation PSCustomTextSelectionMenuController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (instancetype)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithDocument:document])) {
        self.delegate = self;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (NSArray *)pdfViewController:(PSPDFViewController *)pdfController shouldShowMenuItems:(NSArray *)menuItems atSuggestedTargetRect:(CGRect)rect forSelectedText:(NSString *)selectedText inRect:(CGRect)textRect onPageView:(PSPDFPageView *)pageView {

    // Disable Wikipedia
    // Be sure to check for PSPDFMenuItem class; there might also be classic UIMenuItems in the array.
    // Note that for words that are in the iOS dictionary, instead of Wikipedia we show the "Define" menu item with the native dict.
    // There is also a simpler way to disable wikipedia (See PSPDFTextSelectionMenuAction)
    NSMutableArray *newMenuItems = [menuItems mutableCopy];
    for (PSPDFMenuItem *menuItem in menuItems) {
        if ([menuItem isKindOfClass:[PSPDFMenuItem class]] && [menuItem.identifier isEqualToString:@"Wikipedia"]) {
            [newMenuItems removeObjectIdenticalTo:menuItem];
            break;
        }
    }

    // Add option to Google for it.
    PSPDFMenuItem *googleItem = [[PSPDFMenuItem alloc] initWithTitle:NSLocalizedString(@"Google", nil) block:^{
        NSString *URLString = [NSString stringWithFormat:@"http://www.google.com/search?q=%@", [selectedText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

        // Create browser
        PSPDFWebViewController *browser = [[PSPDFWebViewController alloc] initWithURL:[NSURL URLWithString:URLString]];
        browser.delegate = pdfController;
        browser.preferredContentSize = CGSizeMake(600.f, 500.f);
        [pdfController presentViewController:browser options:@{PSPDFPresentationRectKey: BOXED(rect),
                                                               PSPDFPresentationInNavigationControllerKey: @YES,
                                                               PSPDFPresentationCloseButtonKey: @YES}
                                      animated:YES sender:nil error:NULL completion:NULL];

    } identifier:@"Google"];
    [newMenuItems addObject:googleItem];

    return newMenuItems;
}

@end
