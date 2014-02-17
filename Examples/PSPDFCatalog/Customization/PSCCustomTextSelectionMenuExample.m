//
//  PSCCustomTextSelectionMenuExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCCustomTextSelectionMenuExample.h"
#import "PSCAssetLoader.h"

@interface PSCustomTextSelectionMenuController : PSPDFViewController <PSPDFViewControllerDelegate>
@end

@implementation PSCCustomTextSelectionMenuExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Custom Text Selection Menu";
        self.contentDescription = @"Add option to google for selected text via the PSPDFViewControllerDelegate.";
        self.category = PSCExampleCategoryPSPDFViewControllerCustomization;
        self.priority = 100;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    return [[PSCustomTextSelectionMenuController alloc] initWithDocument:document];
}

@end

@implementation PSCustomTextSelectionMenuController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (id)initWithDocument:(PSPDFDocument *)document {
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
        // Trim removes stuff like \n or 's.
        NSString *trimmedSearchText = PSPDFTrimString(selectedText);
        NSString *URLString = [NSString stringWithFormat:@"http://www.google.com/search?q=%@", [trimmedSearchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

        // Create browser
        PSPDFWebViewController *browser = [[PSPDFWebViewController alloc] initWithURL:[NSURL URLWithString:URLString]];
        browser.delegate = pdfController;
        browser.contentSizeForViewInPopover = CGSizeMake(600.f, 500.f);
        [pdfController presentModalOrInPopover:browser embeddedInNavigationController:YES withCloseButton:YES animated:YES sender:nil options:@{PSPDFPresentOptionRect : BOXED(rect)}];

    } identifier:@"Google"];
    [newMenuItems addObject:googleItem];
    
    return newMenuItems;
}

@end
