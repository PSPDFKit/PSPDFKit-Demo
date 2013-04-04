//
//  PSCustomTextSelectionMenuController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSCustomTextSelectionMenuController.h"

@interface PSCustomTextSelectionMenuController() <PSPDFViewControllerDelegate>
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

    // disable wikipedia
    // be sure to check for PSPDFMenuItem class; there might also be classic UIMenuItems in the array.
    // Note that for words that are in the iOS dictionary, instead of Wikipedia we show the "Define" menu item with the native dict.
    // There is also a simpler way to disable wikipedia (document.allowedMenuActions)
    NSMutableArray *newMenuItems = [menuItems mutableCopy];
    for (PSPDFMenuItem *menuItem in menuItems) {
        if ([menuItem isKindOfClass:[PSPDFMenuItem class]] && [menuItem.identifier isEqualToString:@"Wikipedia"]) {
            [newMenuItems removeObjectIdenticalTo:menuItem];
            break;
        }
    }

    // add option to google for it.
    PSPDFMenuItem *googleItem = [[PSPDFMenuItem alloc] initWithTitle:NSLocalizedString(@"Google", nil) block:^{

        // trim removes stuff like \n or 's.
        NSString *trimmedSearchText = PSPDFTrimString(selectedText);
        NSString *URLString = [NSString stringWithFormat:@"http://www.google.com/search?q=%@", [trimmedSearchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

        // create browser
        PSPDFWebViewController *browser = [[PSPDFWebViewController alloc] initWithURL:[NSURL URLWithString:URLString]];
        browser.delegate = pdfController;
        browser.contentSizeForViewInPopover = CGSizeMake(600, 500);

        [pdfController presentViewControllerModalOrPopover:browser embeddedInNavigationController:YES withCloseButton:YES animated:YES sender:nil options:@{PSPDFPresentOptionRect : BOXED(rect)}];

    } identifier:@"Google"];
    [newMenuItems addObject:googleItem];

    return newMenuItems;
}

@end
