//
//  PSCSidebarExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCSidebarExample.h"
#import "PSCAssetLoader.h"
#import "UIBarButtonItem+PSCBlockSupport.h"

@interface PSPDFSidebarViewController : UIViewController <PSPDFDocumentPickerControllerDelegate, UISplitViewControllerDelegate>
- (id)initWithDocument:(PSPDFDocument *)document;
@property (nonatomic, strong) PSPDFDocument *document;
@property (nonatomic, strong) PSPDFViewController *pdfController;
@property (nonatomic, strong) PSPDFContainerViewController *sidebarController;
@property (nonatomic, strong) UIBarButtonItem *pickerButtonItem;
@end

@implementation PSCSidebarExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Sidebar Example";
        self.category = PSCExampleCategoryViewCustomization;
        self.priority = 1;
        self.targetDevice = PSCExampleTargetDeviceMaskPad; // Split view is iPad only.
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;

    PSPDFSidebarViewController *sidebarController = [[PSPDFSidebarViewController alloc] initWithDocument:document];
    [delegate.currentViewController presentViewController:sidebarController animated:YES completion:NULL];
    return nil;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFSidebarViewController

@implementation PSPDFSidebarViewController

- (id)initWithDocument:(PSPDFDocument *)document {
    if (self = [super init]) {
        // Set up the PDF controller
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.pageMode = PSPDFPageModeSingle;
        pdfController.fitToWidthEnabled = YES;

        // Set up the document picker button
        PSPDFDocumentPickerController *documentPicker = [[PSPDFDocumentPickerController alloc] initWithDirectory:@"/Bundle/Samples" includeSubdirectories:YES library:PSPDFLibrary.defaultLibrary delegate:self];
        __weak PSPDFViewController *weakPDFController = pdfController;
        UIBarButtonItem *pickerButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Document" style:UIBarButtonItemStyleBordered block:^(id sender) {
            [weakPDFController presentModalOrInPopover:documentPicker embeddedInNavigationController:YES withCloseButton:NO animated:YES sender:sender options:nil];
        }];
        self.pickerButtonItem = pickerButtonItem;

        pdfController.leftBarButtonItems = @[pdfController.closeButtonItem, pickerButtonItem];
        pdfController.barButtonItemsAlwaysEnabled = @[pickerButtonItem];
        pdfController.rightBarButtonItems = @[pdfController.annotationButtonItem, pdfController.searchButtonItem, pdfController.activityButtonItem, pdfController.viewModeButtonItem];
        self.pdfController = pdfController;
        UINavigationController *navPDFController = [[UINavigationController alloc] initWithRootViewController:pdfController];

        // Set up the container for annotations/outline/bookmarks/search.
        PSPDFOutlineViewController *outlineController = [[PSPDFOutlineViewController alloc] initWithDocument:document delegate:pdfController];
        PSPDFBookmarkViewController *bookmarkController = [[PSPDFBookmarkViewController alloc] initWithDocument:document delegate:pdfController];
        PSPDFAnnotationTableViewController *annotationController = [[PSPDFAnnotationTableViewController alloc] initWithDocument:document delegate:pdfController];
        PSPDFSearchViewController *searchController = [[PSPDFSearchViewController alloc] initWithDocument:document delegate:pdfController];
        searchController.pinSearchBarToHeader = YES;
        PSPDFContainerViewController *containerController = [[PSPDFContainerViewController alloc] initWithControllers:@[outlineController, annotationController, bookmarkController, searchController] titles:nil delegate:nil];
        containerController.shouldShowCloseButton = NO;
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

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.pdfController.splitViewController.view.frame = self.view.bounds;
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
