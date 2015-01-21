//
//  PSCOutlineSidebarExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAssetLoader.h"
#import "UIBarButtonItem+PSCBlockSupport.h"
#import "PSCExample.h"

@interface PSPDFSidebarViewController : UIViewController <PSPDFDocumentPickerControllerDelegate, UISplitViewControllerDelegate>
- (instancetype)initWithDocument:(PSPDFDocument *)document NS_DESIGNATED_INITIALIZER;
@property (nonatomic, strong) PSPDFDocument *document;
@property (nonatomic, strong) PSPDFViewController *pdfController;
@property (nonatomic, strong) PSPDFContainerViewController *sidebarController;
@property (nonatomic, strong) UIBarButtonItem *pickerButtonItem;
@end

@interface PSCOutlineSidebarExample : PSCExample @end
@implementation PSCOutlineSidebarExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Always-Visible Sidebar";
        self.contentDescription = @"Uses a split view controller to show the outline/annotation/bookmark/search view controller in an always-visible sidebar for landscape mode.";
        self.category = PSCExampleCategoryViewCustomization;
        self.priority = 1;
        // Split view is iPad only.
        self.targetDevice = PSCExampleTargetDeviceMaskPad;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFHackerMagazineAsset];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;

    PSPDFSidebarViewController *sidebarController = [[PSPDFSidebarViewController alloc] initWithDocument:document];
    [delegate.currentViewController presentViewController:sidebarController animated:YES completion:NULL];
    return nil;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFSidebarViewController

@implementation PSPDFSidebarViewController

- (instancetype)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super init])) {
        // Set up the PDF controller
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document configuration:[PSPDFConfiguration configurationWithBuilder:^(PSPDFConfigurationBuilder *builder) {
            builder.pageMode = PSPDFPageModeSingle;
            builder.fitToWidthEnabled = YES;
        }]];

        // Set up the document picker button
        PSPDFDocumentPickerController *documentPicker = [[PSPDFDocumentPickerController alloc] initWithDirectory:@"/Bundle/Samples" includeSubdirectories:YES library:PSPDFKit.sharedInstance.library delegate:self];
        __weak PSPDFViewController *weakPDFController = pdfController;
        UIBarButtonItem *pickerButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Document" style:UIBarButtonItemStyleBordered block:^(id sender) {
            [weakPDFController presentViewController:documentPicker options:@{PSPDFPresentationInNavigationControllerKey: @YES} animated:YES sender:sender error:NULL completion:NULL];
        }];
        self.pickerButtonItem = pickerButtonItem;

        pdfController.leftBarButtonItems = @[pdfController.closeButtonItem, pickerButtonItem];
        pdfController.barButtonItemsAlwaysEnabled = @[pickerButtonItem];
        pdfController.rightBarButtonItems = @[pdfController.annotationButtonItem, pdfController.brightnessButtonItem, pdfController.bookmarkButtonItem, pdfController.activityButtonItem, pdfController.viewModeButtonItem];
        self.pdfController = pdfController;
        UINavigationController *navPDFController = [[UINavigationController alloc] initWithRootViewController:pdfController];

        // Set up the controller for annotations/outline/bookmarks/search.
        PSPDFOutlineViewController *outlineController = [[PSPDFOutlineViewController alloc] initWithDocument:document];
        outlineController.delegate = pdfController;
        PSPDFBookmarkViewController *bookmarkController = [[PSPDFBookmarkViewController alloc] initWithDocument:document];
        bookmarkController.delegate = pdfController;
        PSPDFAnnotationTableViewController *annotationController = [[PSPDFAnnotationTableViewController alloc] initWithDocument:document];
        annotationController.delegate = pdfController;
        PSPDFSearchViewController *searchController = [[PSPDFSearchViewController alloc] initWithDocument:document];
        searchController.delegate = pdfController;
        searchController.pinSearchBarToHeader = YES;

        // Create the container controller.
        PSPDFContainerViewController *containerController = [[PSPDFContainerViewController alloc] initWithControllers:@[outlineController, annotationController, bookmarkController, searchController] titles:nil delegate:nil];
        containerController.shouldAnimateChanges = NO;
        self.sidebarController = containerController;
        UINavigationController *navContainer = [[UINavigationController alloc] initWithRootViewController:containerController];

        // Create the split view controller
        UISplitViewController *splitController = [UISplitViewController new];
        splitController.delegate = self;
        splitController.viewControllers = @[navContainer, navPDFController];

        // Use a dummy to present, as the split controller doesn't like to be presented modally.
        [self addChildViewController:splitController];
        [self.view addSubview:splitController.view];
        [splitController didMoveToParentViewController:self];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Properties

- (PSPDFDocument *)document {
    return self.pdfController.document;
}

// Update document everywhere.
- (void)setDocument:(PSPDFDocument *)document {
    self.pdfController.document = document;
    // All controllers allow updating the document. If you add other controllers, customize this part to check for the selector.
    [self.sidebarController.viewControllers setValue:document forKey:@"document"];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocumentPickerControllerDelegate

- (void)documentPickerController:(PSPDFDocumentPickerController *)documentPickerController didSelectDocument:(PSPDFDocument *)document page:(NSUInteger)pageIndex searchString:(NSString *)searchString {

    // Set new document and dismiss.
    self.document = document;
    [self.pdfController dismissPopoverAnimated:YES class:documentPickerController.class completion:NULL];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UISplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc {
    barButtonItem.title = @"Sidebar";
    self.pdfController.leftBarButtonItems = @[self.pdfController.closeButtonItem, self.pickerButtonItem, barButtonItem];
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    self.pdfController.leftBarButtonItems = @[self.pdfController.closeButtonItem, self.pickerButtonItem];
}

- (void)splitViewController:(UISplitViewController *)svc popoverController:(UIPopoverController *)pc willPresentViewController:(UIViewController *)aViewController {
    // Dismiss any other popovers.
    [self.pdfController dismissPopoverAnimated:YES class:Nil completion:NULL];
}

@end
