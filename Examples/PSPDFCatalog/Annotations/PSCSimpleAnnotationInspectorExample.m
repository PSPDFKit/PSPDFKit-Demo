//
//  PSCSimpleAnnotationInspectorExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAssetLoader.h"
#import "PSCExample.h"

@interface PSCSimpleAnnotationStyleViewController : PSPDFAnnotationStyleViewController @end

@interface PSCSimpleAnnotationInspectorExample : PSCExample <PSPDFViewControllerDelegate> @end
@implementation PSCSimpleAnnotationInspectorExample

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"Simple Annotation Inspector";
        self.contentDescription = @"Shows how to customize the annotation inspector to hide certain properties, making it simpler.";
        self.category = PSCExampleCategoryViewCustomization;
        self.priority = 30;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document configuration:[PSPDFConfiguration configurationWithBuilder:^(PSPDFConfigurationBuilder *builder) {
        // This property can be used as well to customize what options are offered in the text menu.
        // We customize this again later in the callback, but here's your chance to e.g. enable Wikipedia.
        builder.allowedMenuActions = PSPDFTextSelectionMenuActionSearch|PSPDFTextSelectionMenuActionDefine;

        // Overrides the inspector with our own subclass to dynamically modify what properties we want to show.
        [builder overrideClass:PSPDFAnnotationStyleViewController.class withClass:PSCSimpleAnnotationStyleViewController.class];
    }]];

    // We use the delegate to customize the menu items.
    pdfController.delegate = self;

    return pdfController;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

// Limit menu options for highlight annotations (they don't use the annotation inspector)
- (NSArray *)pdfViewController:(PSPDFViewController *)pdfController shouldShowMenuItems:(NSArray *)menuItems atSuggestedTargetRect:(CGRect)rect forAnnotations:(NSArray *)annotations inRect:(CGRect)annotationRect onPageView:(PSPDFPageView *)pageView {
    return [menuItems filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(PSPDFMenuItem *menuItem, NSDictionary *bindings) {
        // Make sure to also enable individual colors, as this callback will be also called for sub-menus.
        return [@[PSPDFAnnotationMenuRemove, PSPDFAnnotationMenuColor, PSPDFAnnotationMenuOpacity, PSPDFAnnotationMenuColorWhite, PSPDFAnnotationMenuColorYellow, PSPDFAnnotationMenuColorGreen, PSPDFAnnotationMenuColorBlue] containsObject:menuItem.identifier];
    }]];
}

// Limit the menu options when text is selected.
- (NSArray *)pdfViewController:(PSPDFViewController *)pdfController shouldShowMenuItems:(NSArray *)menuItems atSuggestedTargetRect:(CGRect)rect forSelectedText:(NSString *)selectedText inRect:(CGRect)textRect onPageView:(PSPDFPageView *)pageView {
    return [menuItems filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(PSPDFMenuItem *menuItem, NSDictionary *bindings) {
        return [@[PSPDFTextMenuCopy, PSPDFTextMenuDefine, PSPDFAnnotationMenuHighlight] containsObject:menuItem.identifier];
    }]];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCSimpleAnnotationStyleViewController

@implementation PSCSimpleAnnotationStyleViewController

- (NSArray *)propertiesForAnnotations:(NSArray *)annotations {
    NSArray *sections = [super propertiesForAnnotations:annotations];

    // Allow only a smaller list of known properties in the inspector popover.
    NSMutableArray *newSections = [NSMutableArray array];
    for (NSArray *properties in sections) {
        [newSections addObject:[properties filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString *property, NSDictionary *bindings2) {
            return [@[PROPERTY(color), PROPERTY(alpha), PROPERTY(lineWidth), PROPERTY(fontSize)] containsObject:property];
        }]]];
    }
    return newSections;
}

@end
