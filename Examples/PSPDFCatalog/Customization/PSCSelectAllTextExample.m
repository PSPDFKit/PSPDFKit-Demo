//
//  PSCSelectAllTextExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCSelectAllTextExample.h"
#import "PSCAssetLoader.h"

@interface PSCSelectAllTextExample () <PSPDFViewControllerDelegate>
@end

@implementation PSCSelectAllTextExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Add \"Select All\" to text menu";
        self.category = PSCExampleCategoryViewCustomization;
    }
    return self;
}

- (UIViewController *)invoke {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    pdfController.delegate = self;
    return pdfController;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (PSPDFMenuItem *)selectAllTextItemForPageView:(PSPDFPageView *)pageView {
    PSPDFMenuItem *selectAllMenu = nil;

    // Make sure we haven't selected everything already.
    NSArray *allGlyphs = [pageView.document textParserForPage:pageView.page].glyphs;
    if (pageView.selectionView.selectedGlyphs.count != allGlyphs.count) {
        selectAllMenu = [[PSPDFMenuItem alloc] initWithTitle:@"Select All" block:^{
            // We need to manually sort glyphs.
            pageView.selectionView.selectedGlyphs = [pageView.selectionView sortedGlyphs:allGlyphs];
        } identifier:@"Select All"];
    }
    return selectAllMenu;
}

- (NSArray *)pdfViewController:(PSPDFViewController *)pdfController shouldShowMenuItems:(NSArray *)menuItems atSuggestedTargetRect:(CGRect)rect forSelectedText:(NSString *)selectedText inRect:(CGRect)textRect onPageView:(PSPDFPageView *)pageView {
    NSMutableArray *mutableMenuItems = [NSMutableArray arrayWithArray:menuItems];
    PSPDFMenuItem *selectAllMenu = [self selectAllTextItemForPageView:pageView];
    if (selectAllMenu) {
        [mutableMenuItems insertObject:selectAllMenu atIndex:0];
    }

    return mutableMenuItems;
}

- (NSArray *)pdfViewController:(PSPDFViewController *)pdfController shouldShowMenuItems:(NSArray *)menuItems atSuggestedTargetRect:(CGRect)rect forAnnotations:(NSArray *)annotations inRect:(CGRect)annotationRect onPageView:(PSPDFPageView *)pageView {

    NSMutableArray *mutableMenuItems = [NSMutableArray arrayWithArray:menuItems];

    // Show only in new annotation menu
    if (annotations.count == 0) {
        PSPDFMenuItem *selectAllMenu = [self selectAllTextItemForPageView:pageView];
        if (selectAllMenu) {
            [mutableMenuItems insertObject:selectAllMenu atIndex:0];
        }
    }

    return mutableMenuItems;
}

@end
