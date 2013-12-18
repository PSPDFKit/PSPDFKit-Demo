//
//  PSCatalogViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCatalogViewController.h"
#import "PSCSectionDescriptor.h"
#import "PSCFileHelper.h"
#import "PSCGridViewController.h"
#import "PSCTabbedExampleViewController.h"
#import "PSCEmbeddedTestController.h"
#import "PSCCustomToolbarController.h"
#import "PSCAnnotationTestController.h"
#import "PSCSplitDocumentSelectorController.h"
#import "PSCSplitPDFViewController.h"
#import "PSCBookmarkParser.h"
#import "PSCKioskPDFViewController.h"
#import "PSCEmbeddedAnnotationTestViewController.h"
#import "PSCustomTextSelectionMenuController.h"
#import "PSCExampleAnnotationViewController.h"
#import "PSCCustomDrawingViewController.h"
#import "PSCAutoScrollViewController.h"
#import "PSCPlayBarButtonItem.h"
#import "PSCGoToPageButtonItem.h"
#import "PSCCustomLinkAnnotationView.h"
#import "PSCChildViewController.h"
#import "PSCButtonPDFViewController.h"
#import "PSCCustomAnnotationProvider.h"
#import "PSCBottomToolbarViewController.h"
#import "PSCCustomBookmarkBarButtonItem.h"
#import "PSCRotationLockBarButtonItem.h"
#import "PSCTimingTestViewController.h"
#import "PSCRotatablePDFViewController.h"
#import "PSCLinkEditorViewController.h"
#import "PSCTintablePDFViewController.h"
#import "PSCReaderPDFViewController.h"
#import "PSCCustomSubviewPDFViewController.h"
#import "PSCTwoFingerSwipeGestureViewController.h"
#import "PSCHeadlessSearchPDFViewController.h"
#import "PSCSaveAsPDFViewController.h"
#import "PSCCustomThumbnailsViewController.h"
#import "PSCHideHUDForThumbnailsViewController.h"
#import "PSCHideHUDDelayedDocumentViewController.h"
#import "PSCCustomDefaultZoomScaleViewController.h"
#import "PSCTextParserTest.h"
#import "PSCAppDelegate.h"
#import "PSCDropboxSplitViewController.h"
#import "PSCAnnotationTrailerCaptureDocument.h"
#import "PSCImageOverlayPDFViewController.h"
#import "PSCMultipleUsersPDFViewController.h"
#import "PSCAppearancePDFViewController.h"
#import "PSCShowHighlightNotesPDFController.h"
#import "PSCTopScrobbleBar.h"
#import "PSCExportPDFPagesViewController.h"
#import "PSCiBooksHighlightingViewController.h"
#import "PSCCoreDataAnnotationProvider.h"
#import "UIBarButtonItem+PSCBlockSupport.h"
#import "NSObject+PSCDeallocationBlock.h"
#import "PSCAssetLoader.h"
#import "PSCExampleManager.h"
#import "PSCViewHelper.h"
#import <objc/runtime.h>

// Crypto support
#import "RNEncryptor.h"
#import "RNDecryptor.h"

#if !__has_feature(objc_arc)
#error "Compile this file with ARC"
#endif

//#define kDebugTextBlocks

@interface PSCatalogViewController () <PSPDFViewControllerDelegate, PSPDFDocumentDelegate, PSPDFDocumentPickerControllerDelegate, PSPDFSignatureViewControllerDelegate, UITextFieldDelegate, UISearchDisplayDelegate, PSCExampleRunner> {
    UISearchDisplayController *_searchDisplayController;
    BOOL _firstShown;
    BOOL _clearCacheNeeded;
}
@property (nonatomic, strong) NSArray *content;
@property (nonatomic, strong) NSArray *filteredContent;
@property (nonatomic, strong) UISearchBar *searchBar;
@end

const char PSCShowDocumentSelectorOpenInTabbedControllerKey;
const char PSCAlertViewKey;
const char PSCSignatureCompletionBlock = 0;
static NSString *const PSCLastIndexPath = @"PSCLastIndexPath";

@implementation PSCatalogViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithStyle:style])) {
        self.title = PSPDFLocalize(@"PSPDFKit Catalog");
        if (PSCIsIPad()) {
            self.title = [PSPDFVersionString() stringByReplacingOccurrencesOfString:@"PSPDFKit" withString:PSPDFLocalize(@"PSPDFKit Catalog")];
        }
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Catalog" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self createTableContent];
        [self addDebugButtons];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Content Creation

- (void)createTableContent {
    // Common paths
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    NSURL *hackerMagURL = [samplesURL URLByAppendingPathComponent:kHackerMagazineExample];

    NSMutableOrderedSet *sections = [NSMutableOrderedSet orderedSet];

    // Full Apps
    PSCSectionDescriptor *appSection = [PSCSectionDescriptor sectionWithTitle:@"Example Applications" footer:nil];

    // Playground is convenient for testing.
    [appSection addContent:[PSContent contentWithTitle:@"PSPDFViewController playground" block:^{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        //PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_TouchDownButton.pdf"]];
        //PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_Wartungsformular_2.pdf"]];
        //PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"OoPdfFormExample.pdf"]];
        //PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_Form_Signature.pdf"]];
        //PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_Line_Crash.pdf"]];

        PSPDFViewController *controller = [[PSCKioskPDFViewController alloc] initWithDocument:document];
        controller.statusBarStyleSetting = PSPDFStatusBarStyleDefault;
        if (PSCIsUIKitFlatMode()) {
            controller.statusBarStyleSetting = PSPDFStatusBarStyleSmartBlack;
            controller.tintColor = UIColor.pspdfColor;      // navBarTintColor
        }
        //controller.shouldHideNavigationBarWithHUD = YES;
        //controller.shouldHideStatusBarWithHUD = YES;
        controller.imageSelectionEnabled = NO;
        //controller.page = 3;
        return controller;
    }]];

    [appSection addContent:[PSContent contentWithTitle:@"PSPDFKit Kiosk" block:^UIViewController *{
        return [PSCGridViewController new];
    }]];

    [appSection addContent:[PSContent contentWithTitle:@"Tabbed Browser" block:^{
        if (PSCIsIPad()) {
            return (UIViewController *)[PSCTabbedExampleViewController new];
        }else {
            // on iPhone, we do things a bit different, and push/pull the controller.
            PSPDFDocumentPickerController *documentSelector = [[PSPDFDocumentPickerController alloc] initWithDirectory:@"/Bundle/Samples" includeSubdirectories:YES library:PSPDFLibrary.defaultLibrary delegate:self];
            objc_setAssociatedObject(documentSelector, &PSCShowDocumentSelectorOpenInTabbedControllerKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            return (UIViewController *)documentSelector;
        }
    }]];

    [appSection addContent:[PSContent contentWithTitle:@"Open In... Inbox" block:^{
        // Add all documents in the Documents folder and subfolders (e.g. Inbox from Open In... feature)
        PSPDFDocumentPickerController *documentSelector = [[PSPDFDocumentPickerController alloc] initWithDirectory:nil includeSubdirectories:YES library:PSPDFLibrary.defaultLibrary delegate:self];
        documentSelector.fullTextSearchEnabled = YES;
        return documentSelector;
    }]];

    [appSection addContent:[PSContent contentWithTitle:@"Settings for a magazine" block:^{
        PSPDFDocument *hackerMagDoc = [PSPDFDocument documentWithURL:hackerMagURL];
        hackerMagDoc.UID = @"HACKERMAGDOC"; // set custom UID so it doesn't interfere with other examples
        hackerMagDoc.title = @"HACKER MONTHLY Issue 12"; // Override document title.
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:hackerMagDoc];
        controller.pageTransition = PSPDFPageTransitionCurl;
        controller.pageMode = PSPDFPageModeAutomatic;
        controller.HUDViewAnimation = PSPDFHUDViewAnimationSlide;
        controller.statusBarStyleSetting = PSPDFStatusBarStyleSmartBlackHideOnIpad;
        controller.thumbnailBarMode = PSPDFThumbnailBarModeScrollable;

        // Don't use thumbnails if the PDF is not rendered.
        // FullPageBlocking feels good when combined with pageCurl, less great with other scroll modes, especially PSPDFPageTransitionScrollContinuous.
        controller.renderingMode = PSPDFPageRenderingModeFullPageBlocking;

        // Setup toolbar
        controller.outlineButtonItem.availableControllerOptions = [NSOrderedSet orderedSetWithObject:@(PSPDFOutlineBarButtonItemOptionOutline)];
        controller.rightBarButtonItems = @[controller.activityButtonItem, controller.searchButtonItem, controller.outlineButtonItem, controller.bookmarkButtonItem];

        // Show the thumbnail button on the HUD, but not on the toolbar. (we're not adding viewModeButtonItem here)
        if (!PSCIsUIKitFlatMode()) {
            controller.documentLabel.labelStyle = PSPDFLabelStyleBordered;
            controller.pageLabel.labelStyle = PSPDFLabelStyleBordered;
        }
        controller.pageLabel.showThumbnailGridButton = YES;

        controller.activityButtonItem.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];

        // Hide thumbnail filter bar.
        controller.thumbnailController.filterOptions = [NSOrderedSet orderedSetWithArray:@[@(PSPDFThumbnailViewFilterShowAll), @(PSPDFThumbnailViewFilterBookmarks)]];

        return controller;
    }]];

    [appSection addContent:[PSContent contentWithTitle:@"Settings for a scientific paper" block:^{
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:[PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kPaperExampleFileName]]];

        // Starting with iOS7, we usually don't want to include an internal brightness control.
        // Since PSPDFKit optionally uses an additional software darkener, it can still be useful for certain places like a Pilot's Cockpit.
        BOOL includeBrightnessButton = YES;
        PSC_IF_IOS7_OR_GREATER(includeBrightnessButton = NO;)
        controller.rightBarButtonItems = includeBrightnessButton ? @[controller.annotationButtonItem, controller.brightnessButtonItem, controller.additionalActionsButtonItem, controller.searchButtonItem, controller.viewModeButtonItem] : @[controller.annotationButtonItem, controller.additionalActionsButtonItem, controller.searchButtonItem, controller.viewModeButtonItem];
        PSCGoToPageButtonItem *goToPageButton = [[PSCGoToPageButtonItem alloc] initWithPDFViewController:controller];
        controller.additionalBarButtonItems = @[controller.printButtonItem, controller.emailButtonItem, goToPageButton];
        controller.pageTransition = PSPDFPageTransitionScrollContinuous;
        controller.scrollDirection = PSPDFScrollDirectionVertical;
        controller.fitToWidthEnabled = YES;
        controller.pagePadding = 5.f;
        controller.renderAnimationEnabled = NO;
        controller.statusBarStyleSetting = PSCIsUIKitFlatMode() ? PSPDFStatusBarStyleBlackOpaque : PSPDFStatusBarStyleDefault;
        return controller;
    }]];

    [appSection addContent:[PSContent contentWithTitle:@"Dropbox-like interface" block:^{
        if (PSCIsIPad()) {
            PSCDropboxSplitViewController *splitViewController = [PSCDropboxSplitViewController new];
            [self.view.window.layer addAnimation:PSCFadeTransition() forKey:nil];
            self.view.window.rootViewController = splitViewController;
            PSC_IF_IOS7_OR_GREATER(splitViewController.view.tintColor = [UIColor blueColor];)
            return (UIViewController *)nil;
        }else {
            PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
            PSCDropboxPDFViewController *dropboxPDFController = [[PSCDropboxPDFViewController alloc] initWithDocument:document];
            return (UIViewController *)dropboxPDFController;
        }
    }]];

    [sections addObject:appSection];
    ///////////////////////////////////////////////////////////////////////////////////////////

    // Get all examples
    NSArray *examples = PSCExampleManager.defaultManager.allExamples;

    // Add examples and map categories to sections.
    PSCExampleCategory currentCategory = -1;
    PSCSectionDescriptor *currentSection = nil;
    __weak PSCatalogViewController *weakSelf = self;
    for (PSCExample *example in examples) {
        if (currentCategory != example.category) {
            currentCategory = example.category;
            currentSection = [PSCSectionDescriptor sectionWithTitle:PSPDFHeaderFromExampleCategory(currentCategory) footer:PSPDFFooterFromExampleCategory(currentCategory)];
            [sections addObject:currentSection];
        }

        [currentSection addContent:[PSContent contentWithTitle:example.title block:^UIViewController *{
            return [example invokeWithDelegate:weakSelf];
        }]];
    }


    ///////////////////////////////////////////////////////////////////////////////////////////

    // PSPDFViewController customization examples
    PSCSectionDescriptor *customizationSection = [PSCSectionDescriptor sectionWithTitle:@"PSPDFViewController customization" footer:@""];


    // this the default recommended way to customize the toolbar
    [customizationSection addContent:[PSContent contentWithTitle:@"UIAppearance examples" block:^{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        PSPDFViewController *pdfController = [[PSCAppearancePDFViewController alloc] initWithDocument:document];
        // Present modally to enable new appearance code.
        UINavigationController *navController = [[PSCAppearanceNavigationController alloc] initWithRootViewController:pdfController];
        [self presentViewController:navController animated:YES completion:NULL];
        return (PSPDFViewController *)nil;
    }]];

    [customizationSection addContent:[PSContent contentWithTitle:@"Use a Bottom Toolbar" block:^{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        // Simple subclass that shows/hides the navigationController bottom toolbar
        PSCBottomToolbarViewController *pdfController = [[PSCBottomToolbarViewController alloc] initWithDocument:document];
        pdfController.statusBarStyleSetting = PSPDFStatusBarStyleDefault;
        pdfController.thumbnailBarMode = PSPDFThumbnailBarModeNone;
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
        pdfController.bookmarkButtonItem.tapChangesBookmarkStatus = NO;
        pdfController.leftBarButtonItems = nil;
        pdfController.rightBarButtonItems = nil; // Important! BarButtonItems can only be displayed at one location.
        pdfController.toolbarItems = @[space, pdfController.bookmarkButtonItem, space, pdfController.annotationButtonItem, space, pdfController.searchButtonItem, space, pdfController.outlineButtonItem, space, pdfController.emailButtonItem, space, pdfController.printButtonItem, space, pdfController.openInButtonItem, space];

        // Since we show thetoolbar from the bottom, match the tint.
        PSC_IF_IOS7_OR_GREATER(pdfController.annotationButtonItem.annotationToolbar.barTintColor = self.navigationController.toolbar.barTintColor;)
        return pdfController;
    }]];

    [customizationSection addContent:[PSContent contentWithTitle:@"Disable Toolbar" block:^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Will exit in 5 seconds." message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];

        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        self.navigationController.navigationBarHidden = YES;

        // pop back after 5 seconds.
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.navigationController popViewControllerAnimated:YES];
            [alertView dismissWithClickedButtonIndex:1 animated:YES];
        });

        // sample settings
        pdfController.pageTransition = PSPDFPageTransitionCurl;
        pdfController.toolbarEnabled = NO;
        pdfController.fitToWidthEnabled = NO;

        return pdfController;
    }]];

    // Text selection feature is only available in PSPDFKit Complete.
    if ([PSPDFTextSelectionView isTextSelectionFeatureAvailable]) {
        [customizationSection addContent:[PSContent contentWithTitle:@"Custom Text Selection Menu" block:^{
            PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
            return [[PSCustomTextSelectionMenuController alloc] initWithDocument:document];
        }]];
    }

    if ([PSPDFTextSelectionView isTextSelectionFeatureAvailable]) {
        [customizationSection addContent:[PSContent contentWithTitle:@"Disable text copying" block:^{
            PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
            [document setDidCreateDocumentProviderBlock:^(PSPDFDocumentProvider *documentProvider) {
                documentProvider.allowsCopying = NO;
            }];
            return [[PSPDFViewController alloc] initWithDocument:document];
        }]];
    }

    [customizationSection addContent:[PSContent contentWithTitle:@"Custom Background Color" block:^{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.backgroundColor = [UIColor brownColor];
        return pdfController;
    }]];

    [customizationSection addContent:[PSContent contentWithTitle:@"Night Mode" block:^{
        [PSPDFCache.sharedCache clearCache];
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        document.renderOptions = @{PSPDFRenderInverted : @YES};
        document.backgroundColor = UIColor.blackColor;
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.backgroundColor = UIColor.blackColor;
        _clearCacheNeeded = YES;
        return pdfController;
    }]];

    // rotation example
    [customizationSection addContent:[PSContent contentWithTitle:@"Rotate PDF pages" block:^{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        PSPDFViewController *pdfController = [[PSCRotatablePDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [customizationSection addContent:[PSContent contentWithTitle:@"Customize thumbnail page label" block:^{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        PSPDFViewController *pdfController = [[PSCCustomThumbnailsViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [customizationSection addContent:[PSContent contentWithTitle:@"Hide HUD while showing thumbnails" block:^{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        PSPDFViewController *pdfController = [[PSCHideHUDForThumbnailsViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [customizationSection addContent:[PSContent contentWithTitle:@"Hide HUD with delayed document set" block:^UIViewController *{
        PSPDFDocument *hackerMagDoc = [PSPDFDocument documentWithURL:hackerMagURL];
        PSPDFViewController *pdfController = [[PSCHideHUDDelayedDocumentViewController alloc] init];

        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            pdfController.document = hackerMagDoc;
        });

        return pdfController;
    }]];

    [customizationSection addContent:[PSContent contentWithTitle:@"Set custom stamps" block:^UIViewController *{
        NSMutableArray *defaultStamps = [NSMutableArray array];
        for (NSString *stampSubject in @[@"Great!", @"Stamp", @"Like"]) {
            PSPDFStampAnnotation *stamp = [[PSPDFStampAnnotation alloc] initWithSubject:stampSubject];
            stamp.boundingBox = CGRectMake(0, 0, 200, 70);
            [defaultStamps addObject:stamp];
        }
        // Careful with memory - you don't wanna add large images here.
        PSPDFStampAnnotation *imageStamp = [[PSPDFStampAnnotation alloc] init];
        imageStamp.image = [UIImage imageNamed:@"exampleimage.jpg"];
        imageStamp.boundingBox = CGRectMake(0, 0, imageStamp.image.size.width, imageStamp.image.size.height);
        [defaultStamps addObject:imageStamp];
        [PSPDFStampViewController setDefaultStampAnnotations:defaultStamps];

        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.rightBarButtonItems = @[pdfController.annotationButtonItem];

        // Add cleanup block so other examples will use the default stamps.
        [pdfController psc_addDeallocBlock:^{
            [PSPDFStampViewController setDefaultStampAnnotations:nil];
        }];

        return pdfController;
    }]];

    [customizationSection addContent:[PSContent contentWithTitle:@"iBooks-like highlighting" block:^{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        PSPDFViewController *pdfController = [[PSCiBooksHighlightingViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [sections addObject:customizationSection];
    ///////////////////////////////////////////////////////////////////////////////////////////

    PSCSectionDescriptor *passwordSection = [PSCSectionDescriptor sectionWithTitle:@"Passwords/Security" footer:@"Password is test123"];

    // Bookmarks
    NSURL *protectedPDFURL = [samplesURL URLByAppendingPathComponent:@"protected.pdf"];

    [passwordSection addContent:[PSContent contentWithTitle:@"Password preset" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:protectedPDFURL];
        [document unlockWithPassword:@"test123"];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        return controller;
    }]];

    [passwordSection addContent:[PSContent contentWithTitle:@"Password not preset; dialog" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:protectedPDFURL];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        return controller;
    }]];

    [passwordSection addContent:[PSContent contentWithTitle:@"Create password protected PDF" block:^UIViewController *{
        // create new file that is protected
        NSString *password = @"test123";
        NSURL *tempURL = PSCTempFileURLWithPathExtension(@"protected", @"pdf");
        PSPDFDocument *hackerMagDoc = [PSPDFDocument documentWithURL:hackerMagURL];

        // With password protected pages, PSPDFProcessor can only add link annotations.
        [[PSPDFProcessor defaultProcessor] generatePDFFromDocument:hackerMagDoc pageRange:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, hackerMagDoc.pageCount)] outputFileURL:tempURL options:@{(id)kCGPDFContextUserPassword : password, (id)kCGPDFContextOwnerPassword : password, (id)kCGPDFContextEncryptionKeyLength : @128, PSPDFProcessorAnnotationAsDictionary : @YES, PSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeLink)} progressBlock:^(NSUInteger currentPage, NSUInteger numberOfProcessedPages, NSUInteger totalPages) {
            [PSPDFProgressHUD showProgress:numberOfProcessedPages/(float)totalPages status:PSPDFLocalize(@"Preparing...")];
        } error:NULL];

        [PSPDFProgressHUD dismiss];

        // show file
        PSPDFDocument *document = [PSPDFDocument documentWithURL:tempURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    /// Example how to decrypt a AES256 encrypted PDF on the fly.
    /// The crypto feature is only available in PSPDFKit Basic/Complete.
    if ([PSPDFAESCryptoDataProvider isAESCryptoFeatureAvailable]) {
        [passwordSection addContent:[PSContent contentWithTitle:@"Encrypted CGDocumentProvider" block:^{
            NSURL *encryptedPDF = [samplesURL URLByAppendingPathComponent:@"aes-encrypted.pdf.aes"];

            // Note: For shipping apps, you need to protect this string better, making it harder for hacker to simply disassemble and receive the key from the binary. Or add an internet service that fetches the key from an SSL-API. But then there's still the slight risk of memory dumping with an attached gdb. Or screenshots. Security is never 100% perfect; but using AES makes it way harder to get the PDF. You can even combine AES and a PDF password.
            NSString *passphrase = @"afghadöghdgdhfgöhapvuenröaoeruhföaeiruaerub";
            NSString *salt = @"ducrXn9WaRdpaBfMjDTJVjUf3FApA6gtim0e61LeSGWV9sTxB0r26mPs59Lbcexn";

            PSPDFAESCryptoDataProvider *cryptoWrapper = [[PSPDFAESCryptoDataProvider alloc] initWithURL:encryptedPDF passphrase:passphrase salt:salt rounds:PSPDFDefaultPBKDFNumberOfRounds];

            PSPDFDocument *document = [PSPDFDocument documentWithDataProvider:cryptoWrapper.dataProvider];
            document.UID = [encryptedPDF lastPathComponent]; // manually set an UID for encrypted documents.

            // When PSPDFAESCryptoDataProvider is used, the diskCacheStrategy of PSPDFDocument is *automatically* set to PSPDFDiskCacheStrategyNothing.
            // If you use your custom crypto solution, don't forget to set this to not leak out encrypted data as cached images.
            // document.diskCacheStrategy = PSPDFDiskCacheStrategyNothing;
            return [[PSPDFViewController alloc] initWithDocument:document];
        }]];
    }

    // Encrypting the images will be a 5-10% slowdown, nothing substantial at all.
    [passwordSection addContent:[PSContent contentWithTitle:@"Enable PSPDFCache encryption" block:^UIViewController *{
        PSPDFCache *cache = PSPDFCache.sharedCache;
        // Clear existing cache
        [cache clearCache];

        // Set new cache directory so this example doesn't interfere with the other examples
        cache.cacheDirectory = @"PSPDFKit_encrypted";

        // Set up cache encryption handlers
        NSString *password = @"unsafe-testpassword";
        [cache setEncryptDataBlock:^(PSPDFDocument *document, NSMutableData *data) {
            NSError *error = nil;
            NSData *encryptedData = [RNEncryptor encryptData:data
                                                withSettings:kRNCryptorAES256Settings
                                                    password:password
                                                       error:&error];
            if (!encryptedData) {
                NSLog(@"Failed to encrypt: %@", error.localizedDescription);
                [data setData:[NSData data]]; // clear data - better save nothing than unencrypted!
            }else {
                [data setData:encryptedData];
            }
        }];
        [cache setDecryptFromPathBlock:^NSData *(PSPDFDocument *document, NSString *path) {
            NSError *error = nil;
            NSData *encryptedData = [NSData dataWithContentsOfFile:path];
            if (!encryptedData) return nil; // no file, return early.

            NSData *decryptedData = [RNDecryptor decryptData:encryptedData
                                                withPassword:password
                                                       error:&error];
            if (!decryptedData) {
                NSLog(@"Failed to decrypt: %@", error.localizedDescription);
            }
            return decryptedData;
        }];

        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        return controller;
    }]];

    [sections addObject:passwordSection];
    ///////////////////////////////////////////////////////////////////////////////////////////

    PSCSectionDescriptor *subclassingSection = [PSCSectionDescriptor sectionWithTitle:@"Subclassing" footer:@"Examples how to subclass PSPDFKit."];

    [subclassingSection addContent:[PSContent contentWithTitle:@"Annotation Link Editor" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        document.editableAnnotationTypes = [NSOrderedSet orderedSetWithObjects:
                                            PSPDFAnnotationStringLink, // important!
                                            PSPDFAnnotationStringHighlight,
                                            PSPDFAnnotationStringUnderline,
                                            PSPDFAnnotationStringSquiggly,
                                            PSPDFAnnotationStringStrikeOut,
                                            PSPDFAnnotationStringNote,
                                            PSPDFAnnotationStringFreeText,
                                            PSPDFAnnotationStringInk,
                                            PSPDFAnnotationStringSquare,
                                            PSPDFAnnotationStringCircle,
                                            PSPDFAnnotationStringStamp,
                                            nil];

        PSPDFViewController *controller = [[PSCLinkEditorViewController alloc] initWithDocument:document];
        return controller;
    }]];

    // Bookmarks
    [subclassingSection addContent:[PSContent contentWithTitle:@"Capture Bookmarks" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        [document overrideClass:[PSPDFBookmarkParser class] withClass:[PSCBookmarkParser class]];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        controller.rightBarButtonItems = @[controller.bookmarkButtonItem, controller.searchButtonItem, controller.outlineButtonItem, controller.viewModeButtonItem];
        return controller;
    }]];

    [subclassingSection addContent:[PSContent contentWithTitle:@"Change link background color to red" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        // Note: You can also globally change the color using:
        // We don't use this in the example here since it would change the color globally for all examples.
        //[PSPDFLinkAnnotationView setGlobalBorderColor:[UIColor greenColor]];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        [controller overrideClass:PSPDFLinkAnnotationView.class withClass:PSCCustomLinkAnnotationView.class];
        return controller;
    }]];

    [subclassingSection addContent:[PSContent contentWithTitle:@"Custom AnnotationProvider" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        [document setDidCreateDocumentProviderBlock:^(PSPDFDocumentProvider *documentProvider) {
            documentProvider.annotationManager.annotationProviders = @[[PSCCustomAnnotationProvider new], documentProvider.annotationManager.fileAnnotationProvider];
        }];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        return controller;
    }]];

    // As a second test, this example disables text selection, test that the shape still can be resized.
    [subclassingSection addContent:[PSContent contentWithTitle:@"Programmatically add a shape annotation" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled; // don't confuse other examples
        // add shape annotation if there isn't one already.
        NSUInteger targetPage = 0;
        if ([document annotationsForPage:targetPage type:PSPDFAnnotationTypeSquare].count == 0) {
            PSPDFSquareAnnotation *annotation = [[PSPDFSquareAnnotation alloc] init];
            annotation.boundingBox = CGRectInset([document pageInfoForPage:targetPage].rotatedPageRect, 100, 100);
            annotation.color = [UIColor colorWithRed:0.f green:100.f/255.f blue:0.f alpha:1.f];
            annotation.fillColor = annotation.color;
            annotation.alpha = 0.5f;
            annotation.page = targetPage;
            [document addAnnotations:@[annotation]];
        }

        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        controller.textSelectionEnabled = NO;
        controller.rightBarButtonItems = @[controller.searchButtonItem, controller.openInButtonItem, controller.viewModeButtonItem];
        return controller;
    }]];

    // As a second test, this example disables text selection, test that the shape still can be resized.
    [subclassingSection addContent:[PSContent contentWithTitle:@"Programmatically add a PolyLine annotation" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled; // don't confuse other examples
        // add shape annotation if there isn't one already.
        NSUInteger targetPage = 0;
        if ([document annotationsForPage:targetPage type:PSPDFAnnotationTypePolyLine].count == 0) {
            PSPDFPolyLineAnnotation *polyline = [PSPDFPolyLineAnnotation new];
            polyline.points = @[[NSValue valueWithCGPoint:CGPointMake(52, 633)], [NSValue valueWithCGPoint:CGPointMake(67, 672)], [NSValue valueWithCGPoint:CGPointMake(131, 685)], [NSValue valueWithCGPoint:CGPointMake(178, 654)], [NSValue valueWithCGPoint:CGPointMake(115, 622)]];
            polyline.color = [UIColor colorWithRed:0.0 green:1.f blue:0.f alpha:1.f];
            polyline.fillColor = UIColor.yellowColor;
            polyline.lineEnd2 = PSPDFLineEndTypeClosedArrow;
            polyline.lineWidth = 5.f;
            polyline.page = targetPage;
            [document addAnnotations:@[polyline]];
        }

        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        controller.textSelectionEnabled = NO;
        controller.rightBarButtonItems = @[controller.searchButtonItem, controller.openInButtonItem, controller.viewModeButtonItem];
        return controller;
    }]];

    [subclassingSection addContent:[PSContent contentWithTitle:@"Programmatically add a highlight annotation" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled; // don't confuse other examples.

        // Let's create a highlight for all occurences of BATMAN on the first 10 pages, in Orange.
        NSUInteger annotationCounter = 0;
        for (NSUInteger pageIndex = 0; pageIndex < 10; pageIndex++) {
            for (PSPDFWord *word in [document textParserForPage:pageIndex].words) {
                if ([word.stringValue isEqualToString:@"Batman"]) {
                    CGRect boundingBox;
                    NSArray *highlighedRects = PSPDFRectsFromGlyphs(word.glyphs, [document pageInfoForPage:pageIndex].pageRotationTransform, &boundingBox);
                    PSPDFHighlightAnnotation *annotation = [PSPDFHighlightAnnotation new];
                    annotation.color = [UIColor orangeColor];
                    annotation.boundingBox = boundingBox;
                    annotation.rects = highlighedRects;
                    annotation.contents = [NSString stringWithFormat:@"This is automatically created highlight #%lu", (unsigned long)annotationCounter];
                    annotation.page = pageIndex;
                    [document addAnnotations:@[annotation]];
                    annotationCounter++;
                }
            }
        }
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        controller.page = 8;
        return controller;
    }]];

    [subclassingSection addContent:[PSContent contentWithTitle:@"Programmatically add an ink annotation" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled; // don't confuse other examples

        // add shape annotation if there isn't one already.
        NSUInteger targetPage = 0;
        if ([document annotationsForPage:targetPage type:PSPDFAnnotationTypeInk].count == 0) {

            // Check the header for more helper methods; PSPDFBezierPathGetPoints() might be useful depending on your use case.
            PSPDFInkAnnotation *annotation = [PSPDFInkAnnotation new];

            // example how to create a line rect. Boxed is just shorthand for [NSValue valueWithCGRect:]
            NSArray *lines = @[@[BOXED(CGPointMake(100,100)), BOXED(CGPointMake(100,200)), BOXED(CGPointMake(150,300))], // first line
                               @[BOXED(CGPointMake(200,100)), BOXED(CGPointMake(200,200)), BOXED(CGPointMake(250,300))]  // second line
                               ];

            // convert view line points into PDF line points.
            PSPDFPageInfo *pageInfo = [document pageInfoForPage:targetPage];
            CGRect viewRect = [UIScreen mainScreen].bounds; // this is your drawing view rect - we don't have one yet, so lets just assume the whole screen for this example. You can also directly write the points in PDF coordinate space, then you don't need to convert, but usually your user draws and you need to convert the points afterwards.
            annotation.lineWidth = 5;
            annotation.lines = PSPDFConvertViewLinesToPDFLines(lines, pageInfo.pageRect, pageInfo.pageRotation, viewRect);

            annotation.color = [UIColor colorWithRed:0.667f green:0.279f blue:0.748f alpha:1.f];
            annotation.page = targetPage;
            [document addAnnotations:@[annotation]];
        }

        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        return controller;
    }]];

    // This example is actually the recommended way. Add this snipped to dynamically enable/disable fittingWidth on the iPhone.
    [subclassingSection addContent:[PSContent contentWithTitle:@"Capture the annotation trailer" block:^UIViewController *{
        NSURL *newURL = PSCCopyFileURLToDocumentFolderAndOverride(hackerMagURL, YES);
        PSCAnnotationTrailerCaptureDocument *document = [PSCAnnotationTrailerCaptureDocument documentWithURL:newURL];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        controller.annotationButtonItem.annotationToolbar.saveAfterToolbarHiding = YES;
        controller.rightBarButtonItems = @[controller.annotationButtonItem, controller.viewModeButtonItem];
        return controller;
    }]];

    // Allows multiple annotation sets (e.g. different users)
    [subclassingSection addContent:[PSContent contentWithTitle:@"Multiple annotation sets / user switch" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        PSPDFViewController *controller = [[PSCMultipleUsersPDFViewController alloc] initWithDocument:document];
        return controller;
    }]];

    // This example is actually the recommended way. Add this snipped to dynamically enable/disable fittingWidth on the iPhone.
    [subclassingSection addContent:[PSContent contentWithTitle:@"Dynamic fittingWidth on iPhone" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        [controller setUpdateSettingsForRotationBlock:^(PSPDFViewController *pdfController, UIInterfaceOrientation toInterfaceOrientation) {
            if (!PSCIsIPad()) pdfController.fitToWidthEnabled = UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
        }];
        return controller;
    }]];

    [subclassingSection addContent:[PSContent contentWithTitle:@"Dynamic pageCurl/scrolling" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        [controller setUpdateSettingsForRotationBlock:^(PSPDFViewController *pdfController, UIInterfaceOrientation toInterfaceOrientation) {
            if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
                pdfController.pageTransition = PSPDFPageTransitionScrollPerPage;
            }  else {
                pdfController.pageTransition = PSPDFPageTransitionCurl;
            }
        }];
        return controller;
    }]];

    [subclassingSection addContent:[PSContent contentWithTitle:@"Teleprompter example" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        PSPDFViewController *controller = [[PSCAutoScrollViewController alloc] initWithDocument:document];
        return controller;
    }]];

    [subclassingSection addContent:[PSContent contentWithTitle:@"Auto paging example" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        PSCPlayBarButtonItem *playButton = [[PSCPlayBarButtonItem alloc] initWithPDFViewController:controller];
        playButton.autoplaying = YES;
        controller.rightBarButtonItems = @[playButton, controller.searchButtonItem, controller.outlineButtonItem, controller.viewModeButtonItem];
        controller.pageTransition = PSPDFPageTransitionCurl;
        controller.pageMode = PSPDFPageModeAutomatic;
        return controller;
    }]];

    [subclassingSection addContent:[PSContent contentWithTitle:@"Screen Reader" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        PSPDFViewController *controller = [[PSCReaderPDFViewController alloc] initWithDocument:document];
        controller.page = 3;
        return controller;
    }]];

    // Helps in case you want to add custom subviews but still have drawings on top of everything
    [subclassingSection addContent:[PSContent contentWithTitle:@"Draw all annotations as overlay" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        PSPDFViewController *controller = [[PSCCustomSubviewPDFViewController alloc] initWithDocument:document];
        return controller;
    }]];

    [subclassingSection addContent:[PSContent contentWithTitle:@"Directly show note controller for highlight annotations" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;

        // Create some highlights
        NSUInteger page = 5;
        for (NSUInteger idx = 0; idx < 6; idx++) {
            PSPDFWord *word = ([document textParserForPage:page].words)[idx];
            PSPDFHighlightAnnotation *annotation = [PSPDFHighlightAnnotation new];
            CGRect boundingBox;
            annotation.rects = PSPDFRectsFromGlyphs(word.glyphs, [document pageInfoForPage:0].pageRotationTransform, &boundingBox);
            annotation.boundingBox = boundingBox;
            annotation.page = page;
            [document addAnnotations:@[annotation]];
        }

        PSPDFViewController *controller = [[PSCShowHighlightNotesPDFController alloc] initWithDocument:document];
        controller.page = page;
        return controller;
    }]];

    [subclassingSection addContent:[PSContent contentWithTitle:@"Add a two finger swipe gesture" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        PSPDFViewController *controller = [[PSCTwoFingerSwipeGestureViewController  alloc] initWithDocument:document];
        controller.page = 3;
        return controller;
    }]];

    [subclassingSection addContent:[PSContent contentWithTitle:@"Search for Batman, without controller" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSCHeadlessSearchPDFViewController *pdfController = [[PSCHeadlessSearchPDFViewController alloc] initWithDocument:document];
        pdfController.highlightedSearchText = @"Batman";
        return pdfController;
    }]];

    [subclassingSection addContent:[PSContent contentWithTitle:@"Remove Ink from the annotation toolbar" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.rightBarButtonItems = @[pdfController.annotationButtonItem];
        NSMutableOrderedSet *editableTypes = [document.editableAnnotationTypes mutableCopy];
        [editableTypes removeObject:PSPDFAnnotationStringInk];
        pdfController.annotationButtonItem.annotationToolbar.editableAnnotationTypes = editableTypes;
        return pdfController;
    }]];

    [subclassingSection addContent:[PSContent contentWithTitle:@"Customize email sending (add body text)" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.emailButtonItem.mailComposeViewControllerCustomizationBlock = ^(MFMailComposeViewController *mailController) {
            [mailController setMessageBody:@"<h1 style='color:blue'>Custom message body.</h1>" isHTML:YES];
        };
        pdfController.rightBarButtonItems = @[pdfController.emailButtonItem];
        return pdfController;
    }]];

    [subclassingSection addContent:[PSContent contentWithTitle:@"Set custom default zoom level" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Marketing.pdf"]];
        PSPDFViewController *pdfController = [[PSCCustomDefaultZoomScaleViewController alloc] initWithDocument:document];
        [self presentViewController:pdfController animated:YES completion:NULL];
        return nil;
    }]];

    [subclassingSection addContent:[PSContent contentWithTitle:@"Change font of the note controller" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        [PSPDFNoteAnnotationViewController setTextViewCustomizationBlock:^(PSPDFNoteAnnotationViewController *noteController) {
            noteController.textView.font = [UIFont fontWithName:@"Helvetica" size:20];
        }];
        return pdfController;
    }]];

    [subclassingSection addContent:[PSContent contentWithTitle:@"Change scrobble bar position" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];

        // Register our subclass.
        [pdfController overrideClass:PSPDFScrobbleBar.class withClass:PSCTopScrobbleBar.class];


        pdfController.pageLabelDistance = 0.f;
        return pdfController;
    }]];

    [subclassingSection addContent:[PSContent contentWithTitle:@"Open and immediately request signing" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];

        // Delay the presentation of the controller until after the present animation is finished.
        double delayInSeconds = 0.3f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            PSPDFPageView *pageView = pdfController.visiblePageViews.count > 0 ? pdfController.visiblePageViews[0] : nil;
            [pageView showSignatureControllerAtRect:CGRectNull withTitle:PSPDFLocalize(@"Add Signature") shouldSaveSignature:YES animated:YES];
        });

        return pdfController;
    }]];

    [subclassingSection addContent:[PSContent contentWithTitle:@"Sign all pages" block:^UIViewController *{
        UIColor *penBlueColor = [UIColor colorWithRed:0.000f green:0.030f blue:0.516f alpha:1.000f];

        // Show the signature controller
        PSPDFSignatureViewController *signatureController = [[PSPDFSignatureViewController alloc] init];
        signatureController.drawView.strokeColor = penBlueColor;
        signatureController.drawView.lineWidth = 3.f;
        signatureController.delegate = self;
        UINavigationController *signatureContainer = [[UINavigationController alloc] initWithRootViewController:signatureController];
        signatureContainer.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:signatureContainer animated:YES completion:NULL];

        // To make the example more concise, we're using a callback block here.
        void(^signatureCompletionBlock)(PSPDFSignatureViewController *theSignatureController) = ^(PSPDFSignatureViewController *theSignatureController) {
            // Create the document.
            PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
            document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled; // Don't pollute other examples.

            // We want to add signture at the bottom of the page.
            for (NSUInteger pageIndex = 0; pageIndex < document.pageCount; pageIndex++) {

                // Check if we're already signed and ignore.
                BOOL alreadySigned = NO;
                NSArray *annotationsForPage = [document annotationsForPage:pageIndex type:PSPDFAnnotationTypeInk];
                for (PSPDFInkAnnotation *ann in annotationsForPage) {
                    if ([ann.name isEqualToString:@"Signature"]) {
                        alreadySigned = YES; break;
                    }
                }

                // Not yet signed -> create new Ink annotation.
                if (!alreadySigned) {
                    const CGFloat margin = 10.f;
                    const CGSize maxSize = CGSizeMake(150, 75);

                    // Prepare the lines and convert them from view space to PDF space. (PDF space is mirrored!)
                    PSPDFPageInfo *pageInfo = [document pageInfoForPage:pageIndex];
                    NSArray *lines = PSPDFConvertViewLinesToPDFLines(signatureController.lines, pageInfo.pageRect, pageInfo.pageRotation, pageInfo.pageRect);

                    // Calculate the size, aspect ratio correct.
                    CGSize annotationSize = PSPDFBoundingBoxFromLines(lines, 2).size;
                    CGFloat scale = PSCScaleForSizeWithinSize(annotationSize, maxSize);
                    annotationSize = CGSizeMake(lround(annotationSize.width * scale), lround(annotationSize.height * scale));

                    // Create the annotation.
                    PSPDFInkAnnotation *annotation = [PSPDFInkAnnotation new];
                    annotation.name = @"Signature"; // Arbitrary string, will be persisted in the PDF.
                    annotation.lines = lines;
                    annotation.lineWidth = 3.f;
                    // Add lines to bottom right. (PDF zero is bottom left)
                    annotation.boundingBox = CGRectMake(pageInfo.pageRect.size.width-annotationSize.width-margin, margin, annotationSize.width, annotationSize.height);
                    annotation.color = penBlueColor;
                    annotation.contents = [NSString stringWithFormat:@"Signed on %@ by test user.", [NSDateFormatter localizedStringFromDate:NSDate.date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle]];
                    annotation.page = pageIndex;

                    // Add annotation.
                    [document addAnnotations:@[annotation]];
                }
            }

            // Now we could flatten the PDF so that the signature is "burned in".
            PSPDFAlertView *flattenAlert = [[PSPDFAlertView alloc] initWithTitle:@"Flatten Annotations" message:@"Flattening will merge the annotations with the page content"];
            [flattenAlert addButtonWithTitle:@"Flatten" block:^{
                NSURL *tempURL = PSCTempFileURLWithPathExtension(@"flattened_signaturetest", @"pdf");
                // Perform in background to allow progress showing.
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    [[PSPDFProcessor defaultProcessor] generatePDFFromDocument:document pageRange:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)] outputFileURL:tempURL options:@{PSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeAll)} progressBlock:^(NSUInteger currentPage, NSUInteger numberOfProcessedPages, NSUInteger totalPages) {
                        // Access UI only from main thread.
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [PSPDFProgressHUD showProgress:(numberOfProcessedPages+1)/(float)totalPages status:PSPDFLocalize(@"Preparing...")];
                        });
                    } error:NULL];

                    // completion
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [PSPDFProgressHUD dismiss];
                        PSPDFDocument *flattenedDocument = [PSPDFDocument documentWithURL:tempURL];
                        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:flattenedDocument];
                        [self.navigationController pushViewController:pdfController animated:YES];
                    });
                });
            }];
            [flattenAlert addButtonWithTitle:@"Allow Editing" block:^{
                PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
                [self.navigationController pushViewController:pdfController animated:YES];
            }];
            [flattenAlert show];
        };

        objc_setAssociatedObject(signatureController, &PSCSignatureCompletionBlock, signatureCompletionBlock, OBJC_ASSOCIATION_COPY);

        return (UIViewController *)nil;
    }]];

    [subclassingSection addContent:[PSContent contentWithTitle:@"Allow to select and export pages in thumbnail mode" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSCExportPDFPagesViewController *pdfController = [[PSCExportPDFPagesViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [sections addObject:subclassingSection];

    [subclassingSection addContent:[PSContent contentWithTitle:@"Core Data Annotation Provider" block:^UIViewController *{
        // Create document.
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"A.pdf"]];
        // The Core Data Annotation Provider doesn't support undo/redo.
        document.undoEnabled = NO;
        // Set annotation provider block.
        [document setDidCreateDocumentProviderBlock:^(PSPDFDocumentProvider *documentProvider) {
            PSCCoreDataAnnotationProvider *provider = [[PSCCoreDataAnnotationProvider alloc] initWithDocumentProvider:documentProvider databasePath:nil];
            documentProvider.annotationManager.annotationProviders = @[provider];
        }];
        // Create controller.
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [sections addObject:subclassingSection];


    ///
    /// TEST SECTION
    ///
    PSCSectionDescriptor *testSection = [PSCSectionDescriptor sectionWithTitle:@"Tests" footer:@""];

    // Used for stability testing.
    [testSection addContent:[PSContent contentWithTitle:@"Timing tests" block:^UIViewController *{
        return [[PSCTimingTestViewController alloc] initWithNibName:nil bundle:nil];
    }]];

    // Modal controller - check that we don't get dismissed at some point.
    [testSection addContent:[PSContent contentWithTitle:@"Modal test" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"multimedia.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.rightBarButtonItems = @[pdfController.printButtonItem, pdfController.emailButtonItem, pdfController.openInButtonItem, pdfController.viewModeButtonItem];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:pdfController];
        [self presentViewController:navController animated:YES completion:NULL];
        return nil; // don't push anything
    }]];

    // Check that a new tab will be opened
    [testSection addContent:[PSContent contentWithTitle:@"Tabbed Controller + External references test" block:^UIViewController *{
        PSPDFTabbedViewController *tabbedController = [[PSPDFTabbedViewController alloc] init];
        PSPDFDocument *multimediaDoc = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"multimedia.pdf"]];

        // Create a custom outline for testing.
        PSPDFOutlineElement *openExternalAction = [[PSPDFOutlineElement alloc] initWithTitle:@"Open External" action:[[PSPDFRemoteGoToAction alloc] initWithRemotePath:@"A.pdf" pageIndex:0] children:nil level:1];
        PSPDFOutlineElement *rootOutline = [[PSPDFOutlineElement alloc] initWithTitle:@"Root" action:nil children:@[openExternalAction] level:0];
        multimediaDoc.outlineParser.outline = rootOutline;

        tabbedController.documents = @[multimediaDoc,
                                       [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]]];
        return tabbedController;
    }]];

    // Check that the current tab title changes.
    [testSection addContent:[PSContent contentWithTitle:@"Tabbed Controller + Update tab within" block:^UIViewController *{
        PSPDFTabbedViewController *tabbedController = [[PSPDFTabbedViewController alloc] init];
        tabbedController.openDocumentActionInNewTab = NO;
        PSPDFDocument *multimediaDoc = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"multimedia.pdf"]];

        // Create a custom outline for testing.
        PSPDFOutlineElement *openExternalAction = [[PSPDFOutlineElement alloc] initWithTitle:@"Open External" action:[[PSPDFRemoteGoToAction alloc] initWithRemotePath:@"A.pdf" pageIndex:0] children:nil level:1];
        PSPDFOutlineElement *rootOutline = [[PSPDFOutlineElement alloc] initWithTitle:@"Root" action:nil children:@[openExternalAction] level:0];
        multimediaDoc.outlineParser.outline = rootOutline;

        tabbedController.documents = @[multimediaDoc,
                                       [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]]];
        return tabbedController;
    }]];

    // Tests if we're correctly reloading the controller.
    // Check if scrolling works after the document is set delayed.
    [testSection addContent:[PSContent contentWithTitle:@"Delayed document set" block:^UIViewController *{
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] init];
        PSPDFDocument *hackerMagDoc = [PSPDFDocument documentWithURL:hackerMagURL];

        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            pdfController.document = hackerMagDoc;
        });

        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"UITabBarController/UINavigationController embedding" block:^UIViewController *{
        NSURL *file1 = [samplesURL URLByAppendingPathComponent:@"A.pdf"];
        NSURL *file2 = [samplesURL URLByAppendingPathComponent:@"B.pdf"];
        NSURL *file3 = [samplesURL URLByAppendingPathComponent:@"C.pdf"];
        NSURL *file4 = [samplesURL URLByAppendingPathComponent:@"D.pdf"];
        PSPDFViewController *pdfController1 = [[PSPDFViewController alloc] initWithDocument:[PSPDFDocument documentWithURL:file1]];
        PSPDFViewController *pdfController2 = [[PSPDFViewController alloc] initWithDocument:[PSPDFDocument documentWithURL:file2]];
        PSPDFViewController *pdfController3 = [[PSPDFViewController alloc] initWithDocument:[PSPDFDocument documentWithURL:file3]];
        PSPDFViewController *pdfController4 = [[PSPDFViewController alloc] initWithDocument:[PSPDFDocument documentWithURL:file4]];

        pdfController1.HUDViewMode      = pdfController2.HUDViewMode      = pdfController3.HUDViewMode      = pdfController4.HUDViewMode      = PSPDFHUDViewModeAutomaticNoFirstLastPage;
        pdfController1.HUDViewAnimation = pdfController2.HUDViewAnimation = pdfController3.HUDViewAnimation = pdfController4.HUDViewAnimation = PSPDFHUDViewAnimationNone;
        pdfController1.HUDVisible       = pdfController2.HUDVisible       = pdfController3.HUDVisible       = pdfController4.HUDVisible       = NO;
        pdfController1.pageMode = pdfController2.pageMode = pdfController3.pageMode = pdfController4.pageMode = PSPDFPageModeSingle;
        pdfController1.viewMode = pdfController2.viewMode = pdfController3.viewMode = pdfController4.viewMode = PSPDFViewModeThumbnails;

        void (^configureVC)(PSPDFViewController *pdfController) = ^void(PSPDFViewController *pdfController) {
            pdfController1.leftBarButtonItems  = @[pdfController1.annotationButtonItem];
            pdfController1.rightBarButtonItems = @[pdfController1.viewModeButtonItem];
            pdfController1.shouldHideStatusBarWithHUD = NO;
        };

        configureVC(pdfController1);
        pdfController1.useParentNavigationBar = YES;
        pdfController1.useBorderedToolbarStyle = YES;
        configureVC(pdfController2);
        pdfController2.useParentNavigationBar = YES;
        pdfController2.useBorderedToolbarStyle = NO;
        configureVC(pdfController3);
        pdfController3.useParentNavigationBar = NO;
        pdfController3.useBorderedToolbarStyle = YES;
        configureVC(pdfController4);
        pdfController4.useParentNavigationBar = NO;
        pdfController4.useBorderedToolbarStyle = NO;

        UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:pdfController1];
        UINavigationController *navigationController2 = [[UINavigationController alloc] initWithRootViewController:pdfController2];
        UINavigationController *navigationController3 = [[UINavigationController alloc] initWithRootViewController:pdfController3];
        UINavigationController *navigationController4 = [[UINavigationController alloc] initWithRootViewController:pdfController4];
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        tabBarController.viewControllers = @[navigationController1, navigationController2, navigationController3, navigationController4];
        PSC_IF_IOS7_OR_GREATER(tabBarController.tabBar.translucent = NO;)
        return tabBarController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Multi-document UITabBarController/UINavigationController embedding" block:^UIViewController *{
        NSURL *file1 = [samplesURL URLByAppendingPathComponent:@"A.pdf"];
        NSURL *file2 = [samplesURL URLByAppendingPathComponent:@"B.pdf"];
        NSURL *file3 = [samplesURL URLByAppendingPathComponent:@"C.pdf"];
        NSURL *file4 = [samplesURL URLByAppendingPathComponent:@"D.pdf"];
        PSPDFViewController *pdfController1 = [[PSPDFViewController alloc] initWithDocument:[PSPDFDocument documentWithURL:file1]];
        PSPDFViewController *pdfController2 = [[PSPDFViewController alloc] initWithDocument:[PSPDFDocument documentWithURL:file2]];
        PSPDFViewController *pdfController3 = [[PSPDFViewController alloc] initWithDocument:[PSPDFDocument documentWithURL:file3]];
        PSPDFViewController *pdfController4 = [[PSPDFViewController alloc] initWithDocument:[PSPDFDocument documentWithURL:file4]];
        PSPDFMultiDocumentViewController *pdfMultiDocController1 = [[PSPDFMultiDocumentViewController alloc] initWithPDFViewController:pdfController1];
        PSPDFMultiDocumentViewController *pdfMultiDocController2 = [[PSPDFMultiDocumentViewController alloc] initWithPDFViewController:pdfController2];
        PSPDFMultiDocumentViewController *pdfMultiDocController3 = [[PSPDFMultiDocumentViewController alloc] initWithPDFViewController:pdfController3];
        PSPDFMultiDocumentViewController *pdfMultiDocController4 = [[PSPDFMultiDocumentViewController alloc] initWithPDFViewController:pdfController4];

        pdfController1.HUDViewMode      = pdfController2.HUDViewMode      = pdfController3.HUDViewMode      = pdfController4.HUDViewMode      = PSPDFHUDViewModeAutomaticNoFirstLastPage;
        pdfController1.HUDViewAnimation = pdfController2.HUDViewAnimation = pdfController3.HUDViewAnimation = pdfController4.HUDViewAnimation = PSPDFHUDViewAnimationNone;
        pdfController1.HUDVisible       = pdfController2.HUDVisible       = pdfController3.HUDVisible       = pdfController4.HUDVisible       = NO;
        pdfController1.pageMode = pdfController2.pageMode = pdfController3.pageMode = pdfController4.pageMode = PSPDFPageModeSingle;
        pdfController1.viewMode = pdfController2.viewMode = pdfController3.viewMode = pdfController4.viewMode = PSPDFViewModeThumbnails;

        pdfController1.leftBarButtonItems  = @[pdfController1.annotationButtonItem];
        pdfController1.rightBarButtonItems = @[pdfController1.viewModeButtonItem];
        pdfController1.useParentNavigationBar = YES;
        pdfController1.useBorderedToolbarStyle = YES;
        pdfController2.leftBarButtonItems  = @[pdfController2.annotationButtonItem];
        pdfController2.rightBarButtonItems = @[pdfController2.viewModeButtonItem];
        pdfController2.useParentNavigationBar = YES;
        pdfController2.useBorderedToolbarStyle = NO;
        pdfController3.leftBarButtonItems  = @[pdfController3.annotationButtonItem];
        pdfController3.rightBarButtonItems = @[pdfController3.viewModeButtonItem];
        pdfController3.useParentNavigationBar = NO;
        pdfController3.useBorderedToolbarStyle = YES;
        pdfController4.leftBarButtonItems  = @[pdfController4.annotationButtonItem];
        pdfController4.rightBarButtonItems = @[pdfController4.viewModeButtonItem];
        pdfController4.useParentNavigationBar = NO;
        pdfController4.useBorderedToolbarStyle = NO;

        UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:pdfMultiDocController1];
        UINavigationController *navigationController2 = [[UINavigationController alloc] initWithRootViewController:pdfMultiDocController2];
        UINavigationController *navigationController3 = [[UINavigationController alloc] initWithRootViewController:pdfMultiDocController3];
        UINavigationController *navigationController4 = [[UINavigationController alloc] initWithRootViewController:pdfMultiDocController4];
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        tabBarController.viewControllers = @[navigationController1, navigationController2, navigationController3, navigationController4];
        return tabBarController;
    }]];

    // Tests if the placement of the search controller is correct, even for zoomed documents.
    [testSection addContent:[PSContent contentWithTitle:@"Inline search test" block:^UIViewController *{
        PSPDFDocument *hackerMagDoc = [PSPDFDocument documentWithURL:hackerMagURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:hackerMagDoc];
        pdfController.fitToWidthEnabled = YES;
        pdfController.rightBarButtonItems = @[pdfController.viewModeButtonItem];
        return pdfController;
    }]];

    // Test that we don't get in a state where the toolbar disappeared completely.
    [testSection addContent:[PSContent contentWithTitle:@"Drawing invoked with menu while toolbar is visible" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"stamps2.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.statusBarStyleSetting = PSPDFStatusBarStyleSmartBlackHideOnIpad;
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [pdfController.annotationButtonItem action:pdfController.annotationButtonItem];
            [[[UIAlertView alloc] initWithTitle:@"Testcase" message:@"Now long-press on the page, invoke draw action, check that toolbar changes, press done or cancel, verify that the annotation toolbar is still there. Press done on the bar and verify that the main toolbar is still visible." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        });
        return pdfController;
    }]];

    // additional test cases, just for developing and testing PSPDFKit.
    // Referenced PDF files are proprietary and not released with the downloadable package.
#ifdef PSPDF_USE_SOURCE
    
    // Test rotated PDF (90, 180, 270, 0 deg).
    [testSection addContent:[PSContent contentWithTitle:@"Rotated PDF pages" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_RotatedPages.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Test immensely large PDF.
    [testSection addContent:[PSContent contentWithTitle:@"Test huge sized PDF" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_HugelyOversizedMap.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Zoom out UIKit freeze bug" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"About CLA.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // test search highlighting matching, also tests that we indeed are on logical page 3.
    [testSection addContent:[PSContent contentWithTitle:@"Search for Drammen" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"doc-1205.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 2; // pages start at 0.

        int64_t delayInSeconds = 1.f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [pdfController searchForString:@"Drammen" options:nil animated:YES];
        });

        return pdfController;
    }]];

    // Check that 'ipsum' can be found.
    [testSection addContent:[PSContent contentWithTitle:@"Search for ipsum" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"testcase_Search ipsum fails.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        int64_t delayInSeconds = 1.f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [pdfController searchForString:@"lorem" options:nil animated:YES];
        });

        return pdfController;
    }]];

    // Check that words can be selected
    [testSection addContent:[PSContent contentWithTitle:@"Test word block separation" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_word_separation_ascii2.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 1;
        return pdfController;
    }]];

    // Test that the Type... menu item is NOT visible (since Underscore/StrikeOut are disabled)
    [testSection addContent:[PSContent contentWithTitle:@"Limited annotation features (only Highlight/Ink)" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        document.editableAnnotationTypes = [NSOrderedSet orderedSetWithArray:@[PSPDFAnnotationStringHighlight, PSPDFAnnotationStringInk]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.rightBarButtonItems = @[pdfController.annotationButtonItem, pdfController.viewModeButtonItem];
        return pdfController;
    }]];

    // Show grid initially, test that page is correctly zoomed at.
    [testSection addContent:[PSContent contentWithTitle:@"Show grid initially" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"PDFReference17.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 15;
        pdfController.viewMode = PSPDFViewModeThumbnails;
        return pdfController;
    }]];

    // check that annotations work well with pageCurl (e.g. that you can't curl while adding a annotation)
    [testSection addContent:[PSContent contentWithTitle:@"Annotations + pageCurl" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.rightBarButtonItems = @[pdfController.annotationButtonItem, pdfController.viewModeButtonItem];
        pdfController.pageTransition = PSPDFPageTransitionCurl;
        return pdfController;
    }]];

    // check that the brightness works on iPhone as well.
    [testSection addContent:[PSContent contentWithTitle:@"Brightness on iPhone" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.rightBarButtonItems = @[pdfController.brightnessButtonItem, pdfController.viewModeButtonItem];
        return pdfController;
    }]];

    // check that non-uniform pages are correctly handled.
    [testSection addContent:[PSContent contentWithTitle:@"Centered dual-page mode" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"pepsico-slow2.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 1;
        return pdfController;
    }]];

    // check that external links are correctly recognized and the alert is shown.
    [testSection addContent:[PSContent contentWithTitle:@"External links test" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"one.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 1;
        return pdfController;
    }]];

    // Check that even multiple different pageLabel enumerations work properly, compare with Acrobat.
    [testSection addContent:[PSContent contentWithTitle:@"PageLabels test" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"pagelabels-test.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.viewMode = PSPDFViewModeThumbnails;
        return pdfController;
    }]];

    // Check that we don't get weird page labels like 11 for 1.
    [testSection addContent:[PSContent contentWithTitle:@"PageLabels test (numbered, needs to be ignored)" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"broken pagelabels.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.viewMode = PSPDFViewModeThumbnails;
        return pdfController;
    }]];

    // Check that page labels work correctly, even if we use the pageRange feature.
    [testSection addContent:[PSContent contentWithTitle:@"PageLabels test + pageRange" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"pagelabels-test.pdf"]];
        [PSPDFCache.sharedCache removeCacheForDocument:document deleteDocument:NO error:NULL];
        _clearCacheNeeded = YES;
        document.pageRange = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(5, 15)];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.viewMode = PSPDFViewModeThumbnails;
        return pdfController;
    }]];

    // Check that there's no transparent border around images.
    [testSection addContent:[PSContent contentWithTitle:@"Thumbnails Aspect Ratio Test" block:^UIViewController *{
        [PSPDFCache.sharedCache clearCache];
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_aspectratio.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.viewMode = PSPDFViewModeThumbnails;
        return pdfController;
    }]];

    // Test HSV color picker
    [testSection addContent:[PSContent contentWithTitle:@"Color picker test" block:^UIViewController *{
        PSPDFHSVColorPickerController *picker = [PSPDFHSVColorPickerController new];
        picker.selectionColor = [UIColor yellowColor];
        return picker;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Internal WebBrowser test" block:^UIViewController *{
        PSPDFWebViewController *browser = [[PSPDFWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://pspdfkit.com"]];
        return browser;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Test that § can be found" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Entwurf AIFM-UmsG.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 5;

        int64_t delayInSeconds = 1.f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [pdfController searchForString:@"§ " options:nil animated:YES];
        });

        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Test that 'In Vitro Amplification' can be found" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"In Vitro Amplification - search.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];

        int64_t delayInSeconds = 1.f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [pdfController searchForString:@"In Vitro Amplification" options:nil animated:YES];
        });
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Search performance test" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"PDFReference16.pdf"]];
        document.diskCacheStrategy = PSPDFDiskCacheStrategyNothing; // we want to focus on search alone.
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        int64_t delayInSeconds = 5.f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [pdfController searchForString:@"pdfo" options:nil animated:YES];
        });
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"TextParser test" block:^UIViewController *{
        [PSCTextParserTest runWithDocumentAtPath:[samplesURL URLByAppendingPathComponent:@"protected.pdf"].path];
        return nil;
    }]];

    // Test if all words are complete.
    // Output: Preocupa la violencia contra
    [testSection addContent:[PSContent contentWithTitle:@"TextParser test missing glypgs" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_MissingGlyphs_focussed.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        NSLog(@"Text: %@", [[document textParserForPage:0] text]);
        NSLog(@"Glyphs: %@", [[document textParserForPage:0] glyphs]);
        NSLog(@"Words: %@", [[document textParserForPage:0] words]);
        return pdfController;
    }]];

    // Creating press-ready artwork
    [testSection addContent:[PSContent contentWithTitle:@"TextParser test word spaces" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_wordspace.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        NSLog(@"Text: %@", [[document textParserForPage:0] text]);
        NSLog(@"Glyphs: %@", [[document textParserForPage:0] glyphs]);
        NSLog(@"Words: %@", [[document textParserForPage:0] words]);
        return pdfController;
    }]];

    // Page 26 of hackernews-12 has a very complex XObject setup with nested objects that reference objects that have a parent with the same name. If parsed from top to bottom with the wrong XObjects this will take 100^4 calls, thus clocks up the iPad for a very long time.
    [testSection addContent:[PSContent contentWithTitle:@"Test for cyclic XObject references" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 26;

        [[document textParserForPage:26] words];
        return pdfController;
    }]];

    // Check that the free text annotation has a 5px red border around it.
    [testSection addContent:[PSContent contentWithTitle:@"Freetext annotation with border" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"textbox.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Freetext annotation on rotated PDF" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_Rotated PDF.pdf"]];
        document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;
        PSPDFFreeTextAnnotation *freeText = [PSPDFFreeTextAnnotation new];
        freeText.contents = @"This is a test.\n1\n2\n3\n4\n5";
        freeText.boundingBox = CGRectMake(100, 100, 400, 200);
        freeText.fillColor = UIColor.yellowColor;
        freeText.fontSize = 40;
        [document addAnnotations:@[freeText]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Freetext annotation on 90g rotated PDF" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_rotated-northern.pdf"]];
        document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;
        PSPDFFreeTextAnnotation *freeText = [PSPDFFreeTextAnnotation new];
        freeText.contents = @"This is a test.\n1\n2\n3\n4\n5";
        freeText.boundingBox = CGRectMake(100, 100, 400, 200);
        freeText.fillColor = UIColor.yellowColor;
        freeText.fontSize = 30;
        [document addAnnotations:@[freeText]];
        PSPDFAnnotation *secondAnnotation = [freeText copy];
        secondAnnotation.page = 1;
        [document addAnnotations:@[secondAnnotation]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Check that free text annotation doesn't has a fillColor set.
    [testSection addContent:[PSContent contentWithTitle:@"Freetext annotation with border, no fill color" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_FreeText_no_background.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Check that "Griffin" is correctly parsed and only one word. (fi ligature)
    [testSection addContent:[PSContent contentWithTitle:@"Test fi ligature parsing 1" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 1;

        NSArray *glyphs = [[document textParserForPage:1] glyphs];
        NSLog(@"glyphs: %@", glyphs);

        return pdfController;
    }]];

    // Check that "rather than fight" is correctly parsed and 3 words without stray spaces. (fi ligature)
    [testSection addContent:[PSContent contentWithTitle:@"Test fi ligature parsing 2" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_rather_than_fight.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];

        NSArray *glyphs = [[document textParserForPage:0] glyphs];
        NSLog(@"glyphs: %@", glyphs);

        return pdfController;
    }]];


    // There's a ffi ligature on the first page.
    [testSection addContent:[PSContent contentWithTitle:@"Test ffi ligature parsing" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_ffi-glyph-manyongeAMS89-92-2012.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];

        NSArray *glyphs = [[document textParserForPage:0] glyphs];
        NSLog(@"glyphs: %@", glyphs);

        BOOL foundWord = NO;
        NSArray *words = [document textParserForPage:0].words;
        for (PSPDFWord *word in words) {
            if ([word.stringValue isEqualToString:@"Coefficient"]) {
                foundWord = YES;
                break;
            }
        }

        // One day this will be a real testcase. For now, that'll have to do.
        NSAssert(foundWord, @"Test failed!");

        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Test bfrange-Cmaps with array syntax" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"HT-newspaper-textextraction.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];

        NSString *text = [document textParserForPage:0].text;
        NSLog(@"text: %@", text);

        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Test bfrange-Cmaps with ligatures" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"chinese0.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];

        NSString *text = [document textParserForPage:0].text;
        NSLog(@"text: %@", text);

        return pdfController;
    }]];


    [testSection addContent:[PSContent contentWithTitle:@"Test glyph count = text length" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_GlyphCount.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];

        [[document textParserForPage:0] glyphs];

        PSPDFTextParser *textParser = [document textParserForPage:27];
        __unused NSString *text = textParser.text;
        NSAssert(text.length == textParser.glyphs.count, @"Text length needs to equal glyph count");

        return pdfController;
    }]];

    // PSPDFKit had some problem swith the font included in this file and calculated the height as too small.
    [testSection addContent:[PSContent contentWithTitle:@"Test text frame size" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_negative-descent.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        double delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [[pdfController pageViewForPage:0].selectionView showTextFlowData:YES animated:NO];
        });
        return pdfController;
    }]];

    // Test that file actually opens.
    // CoreGraphics is picky about AES-128 and will fail if the document is parsed before we enter a password with a "failed to create default crypt filter."
    [testSection addContent:[PSContent contentWithTitle:@"Test AES-128 password protected file" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"cryptfilter-password-abc.pdf"]];
        [document pageCount]; // trigger calculation to test that pageCount is reset afterwards
        document.password = @"abc";
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Ensure that there is a red ink annotations in the document. Password is test123
    [testSection addContent:[PSContent contentWithTitle:@"Test password protected file + annotations" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase-password ink.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Test PDF annotation writing with nil color" block:^{
        NSURL *annotationSavingURL = [samplesURL URLByAppendingPathComponent:@"annotation-missing-colors.pdf"];

        // copy file from the bundle to a location where we can write on it.
        NSURL *newURL = PSCCopyFileURLToDocumentFolderAndOverride(annotationSavingURL, YES);
        PSPDFDocument *document = [PSPDFDocument documentWithURL:newURL];
        return [[PSCEmbeddedAnnotationTestViewController alloc] initWithDocument:document];
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Test that Fullscren Audio doesn't flicker" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Lifescribe.pdf"]];
        return [[PSPDFViewController alloc] initWithDocument:document];
    }]];

    // Check that this doesn't auto-play.
    [testSection addContent:[PSContent contentWithTitle:@"Test Video No-Autoplay" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"multimedia-autostart-ios5.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Test video covers
    [testSection addContent:[PSContent contentWithTitle:@"Test multiple Video Covers" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"covertest/imrevi.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Ensure that videos do display.
    [testSection addContent:[PSContent contentWithTitle:@"Test large video extraction code" block:^UIViewController *{
        // clear temp directory to force video extraction.
        [[NSFileManager defaultManager] removeItemAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"PSPDFKit"] error:NULL];
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Embedded-video-large.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 11;
        return pdfController;
    }]];

    // Check that multiple videos work fine and all annotations are parsed.
    // Also check that dashed border is parsed correctly and displayed as dash.
    [testSection addContent:[PSContent contentWithTitle:@"Advanced annotation usage test" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"stamps2.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 8;
        return pdfController;
    }]];

    // Test that PSPDFProcessor doesn't flatten when you add annotations programmatically.
    [testSection addContent:[PSContent contentWithTitle:@"Ink annotation + PSPDFProcessor" block:^UIViewController *{

        NSURL *URL = PSCCopyFileURLToDocumentFolderAndOverride(hackerMagURL, YES);
        PSPDFDocument *document = [PSPDFDocument documentWithURL:URL];
        document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled; // don't confuse other examples

        // add shape annotation if there isn't one already.
        NSUInteger targetPage = 0;
        if ([document annotationsForPage:targetPage type:PSPDFAnnotationTypeInk].count == 0) {

            // Check the header for more helper methods; PSPDFBezierPathGetPoints() might be useful depending on your use case.
            PSPDFInkAnnotation *annotation = [PSPDFInkAnnotation new];

            // example how to create a line rect. Boxed is just shorthand for [NSValue valueWithCGRect:]
            NSArray *lines = @[@[BOXED(CGPointMake(100,100)), BOXED(CGPointMake(100,200)), BOXED(CGPointMake(150,300))], // first line
                               @[BOXED(CGPointMake(200,100)), BOXED(CGPointMake(200,200)), BOXED(CGPointMake(250,300))]  // second line
                               ];

            // convert view line points into PDF line points.
            PSPDFPageInfo *pageInfo = [document pageInfoForPage:targetPage];
            CGRect viewRect = [UIScreen mainScreen].bounds; // this is your drawing view rect - we don't have one yet, so lets just assume the whole screen for this example. You can also directly write the points in PDF coordinate space, then you don't need to convert, but usually your user draws and you need to convert the points afterwards.
            annotation.lineWidth = 5;
            annotation.lines = PSPDFConvertViewLinesToPDFLines(lines, pageInfo.pageRect, pageInfo.pageRotation, viewRect);

            annotation.color = [UIColor colorWithRed:0.667f green:0.279f blue:0.748f alpha:1.f];
            annotation.page = targetPage;
            [document addAnnotations:@[annotation]];
        }

        //Here we should figure out which pages have annotations
        NSDictionary *annotationsDictionary = [document allAnnotationsOfType:PSPDFAnnotationTypeInk];
        NSArray *annotatedPages = annotationsDictionary.allKeys;
        NSIndexSet *pageNumbers = PSPDFIndexSetFromArray(annotatedPages);
        NSDictionary *processorOptions = @{PSPDFProcessorAnnotationAsDictionary : @YES, PSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeAll)};

        NSURL *outputFileURL = document.fileURL;
        [[PSPDFProcessor defaultProcessor] generatePDFFromDocument:document pageRange:pageNumbers outputFileURL:outputFileURL options:processorOptions progressBlock:NULL error:NULL];

        [document clearCache];

        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        return controller;
    }]];

    // Test that stamps are correctly displayed and movable.
    [testSection addContent:[PSContent contentWithTitle:@"Stamp annotation test" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"stamps2.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 1;
        return pdfController;
    }]];

    // Test that polylines are correctly displayed.
    [testSection addContent:[PSContent contentWithTitle:@"Polyline annotation test" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"stamps2.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 9;
        return pdfController;
    }]];

    // Test that buttons are correctly displayed.
    [testSection addContent:[PSContent contentWithTitle:@"Widget annotation test" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_WidgetAnnotations.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 4;
        return pdfController;
    }]];

    // Test that Sound is playable
    [testSection addContent:[PSContent contentWithTitle:@"Sound annotation test" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"SoundAnnotation.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.rightBarButtonItems = @[pdfController.outlineButtonItem, pdfController.openInButtonItem];
        return pdfController;
    }]];

    // Test that Sound is playable
    [testSection addContent:[PSContent contentWithTitle:@"Sound annotation test 2" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"SoundAnnotation2.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.rightBarButtonItems = @[pdfController.outlineButtonItem, pdfController.openInButtonItem];
        return pdfController;
    }]];

    // Test that the files can be opened.
    [testSection addContent:[PSContent contentWithTitle:@"FileAttachment annotation test" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"FileAttachments.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.rightBarButtonItems = @[pdfController.outlineButtonItem, pdfController.openInButtonItem];
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Caret annotations" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_Annotation_Caret.PDF"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Stamp annotation test, only allow stamp editing" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"stamps2.pdf"]];
        document.editableAnnotationTypes = [NSOrderedSet orderedSetWithObject:PSPDFAnnotationStringStamp];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 1;
        return pdfController;
    }]];

    // Line annotations generic, display, endings.
    [testSection addContent:[PSContent contentWithTitle:@"Line annotation test" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"stamps2.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 7;
        return pdfController;
    }]];

    // Test that the green shape is properly displayed in Adobe Acrobat for iOS.
    [testSection addContent:[PSContent contentWithTitle:@"Shape annotation AP test" block:^UIViewController *{
        // Copy file from the bundle to a location where we can write on it.
        NSURL *newURL = PSCCopyFileURLToDocumentFolderAndOverride([samplesURL URLByAppendingPathComponent:kHackerMagazineExample], NO);
        PSPDFDocument *document = [PSPDFDocument documentWithURL:newURL];
        // Add the annotation
        PSPDFSquareAnnotation *annotation = [PSPDFSquareAnnotation new];
        annotation.boundingBox = CGRectInset([document pageInfoForPage:0].rotatedPageRect, 100.f, 100.f);
        annotation.color = [UIColor colorWithRed:0.f green:100.f/255.f blue:0.f alpha:1.f];
        annotation.fillColor = annotation.color;
        annotation.alpha = 0.5f;
        [document addAnnotations:@[annotation]];
        // Save it
        NSError *error = nil;
        if (![document saveAnnotationsWithError:&error]) {
            NSLog(@"Failed to save: %@", error.localizedDescription);
        }

        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.rightBarButtonItems = @[pdfController.openInButtonItem];
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Stamps test with appearance streams" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"stamptest.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"FreeText annotation" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"stamps2.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 2;
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Test image extraction with CMYK images" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"CMYK-image-mokafive.pdf"]];

        NSDictionary *images = [document objectsAtPDFRect:[document pageInfoForPage:0].rotatedPageRect page:0 options:@{PSPDFObjectsImages : @YES}];
        NSLog(@"Detected images: %@", images);

        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Test image extraction - top left" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"image-topleft.pdf"]];

        NSDictionary *images = [document objectsAtPDFRect:[document pageInfoForPage:0].rotatedPageRect page:0 options:@{PSPDFObjectsImages : @YES}];
        NSLog(@"Detected images: %@", images);

        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Test image extraction - not inverted" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"inverted-image.pdf"]];

        NSDictionary *images = [document objectsAtPDFRect:[document pageInfoForPage:0].rotatedPageRect page:0 options:@{PSPDFObjectsImages : @YES}];
        NSLog(@"Detected images: %@", images);

        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // test that even many links don't create any performance problem on saving.
    [testSection addContent:[PSContent contentWithTitle:@"Performance with many links" block:^UIViewController *{

        NSURL *documentURL = [samplesURL URLByAppendingPathComponent:@"PDFReference17.pdf"];
        NSURL *newURL = PSCCopyFileURLToDocumentFolderAndOverride(documentURL, YES);

        PSPDFDocument *document = [PSPDFDocument documentWithURL:newURL];
        document.annotationSaveMode = PSPDFAnnotationSaveModeEmbedded;
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 2;
        return pdfController;
    }]];

    // Check that the link annotation on page one actually works, even if it's encoded in a weird way.
    [testSection addContent:[PSContent contentWithTitle:@"Test invalid URI encodings" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"weird-link-annotation-siteLinkTargetIsRaw.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Check that the link on page one opens the internal web view both on the simulator and device.
    // There was a bug that prevented opening local html pages on the device until PSPDFKit 2.7.
    // Also check that the inline web view shows a nice error message + image as html.
    [testSection addContent:[PSContent contentWithTitle:@"Test link on page 1" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"weblink-page1.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Test that those links are properly visible and NOT covered by a webview (white box).
    [testSection addContent:[PSContent contentWithTitle:@"Test localhost links" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_WhiteBox.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Check that telephone numbers are dynamically converted to annotations.
    [testSection addContent:[PSContent contentWithTitle:@"Detect Telephone Numbers and Links" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"detect-telephone-numbers.pdf"]];

        // Detect URLs in the document and create annotations
        NSIndexSet *allPagesIndex = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)];
        NSDictionary *annotationsPerPage = [document annotationsFromDetectingLinkTypes:PSPDFTextCheckingTypeAll pagesInRange:allPagesIndex progress:^(NSArray *annotations, NSUInteger page, BOOL *stop) {
            NSLog(@"Detected %@ on %lu", annotations, (unsigned long)page);
        } error:NULL];

        // Add those annotations to the page.
        [annotationsPerPage enumerateKeysAndObjectsUsingBlock:^(NSNumber *pageNumber, NSArray *annotations, BOOL *stop) {
            [document addAnnotations:annotations];
        }];

        NSDictionary *annotationsPerPage2 = [document annotationsFromDetectingLinkTypes:PSPDFTextCheckingTypeAll pagesInRange:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)] progress:NULL error:NULL];
        __unused NSUInteger annotationCount = [[annotationsPerPage2.allValues valueForKeyPath:@"@max.type.@count"] unsignedIntegerValue];
        NSAssert(annotationCount == 0, @"A second run should not create new annotations");
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Check that those links actually work.
    [testSection addContent:[PSContent contentWithTitle:@"Test latex generated PDF links" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"pdf_pagelinks_latex.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Check that font caching works correctly and doesn't corrupt future search runs.
    // Also check search support to ignore no-break-space
    [testSection addContent:[PSContent contentWithTitle:@"Test Font Caching" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"fontcaching-bug.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 12;
        //[PSPDFFontCacheTest runWithDocumentAtPath:[document.fileURL path]];

        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [pdfController searchForString:@"control points" options:nil animated:YES];
        });

        NSLog(@"%@", [[document textParserForPage:12] glyphs]);

        return pdfController;
    }]];

    // This document has a font XObject recursion depth of > 4. Test if it's parsed correctly and doesn't crash PSPDFKit.
    // Simply opening will crash if this isn't handled correctly.
    [testSection addContent:[PSContent contentWithTitle:@"Test font XObject recursion depth" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"font-xobject-recursion-depth-crashtest.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Test that document opens without crashing.
    [testSection addContent:[PSContent contentWithTitle:@"Test document parsing" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_crash_missing_object_reference.pdf"]];
        PSPDFHighlightAnnotation *test = [PSPDFHighlightAnnotation new];
        [document addAnnotations:@[test]];
        [document saveAnnotationsWithError:NULL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Check that blocks are recognized and that it is fast (not 10 seconds!)
    [testSection addContent:[PSContent contentWithTitle:@"Test block detection" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"block-detection-test.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        // Debug: Visualizes glyphs and text blocks.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for (PSPDFPageView *pageView in pdfController.visiblePageViews)
                [pageView.selectionView showTextFlowData:YES animated:NO];

            NSLog(@"%@", [document textParserForPage:0].glyphs);
        });
        return pdfController;
    }]];

    // Check that text can be properly selected
    [testSection addContent:[PSContent contentWithTitle:@"Test text selection" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_text_selection_not_working.pdf"]];
        NSLog(@"Page size: %@", [document pageInfoForPage:0]);
        NSLog(@"glyphs: %@", [document textParserForPage:0].glyphs);
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Check that text can be properly selected
    [testSection addContent:[PSContent contentWithTitle:@"Test bookmark + pageRange" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        [document.bookmarkParser addBookmarkForPage:0];
        [document.bookmarkParser addBookmarkForPage:1];
        [document.bookmarkParser addBookmarkForPage:2];
        [document.bookmarkParser addBookmarkForPage:3];
        [document.bookmarkParser addBookmarkForPage:4];
        [document.bookmarkParser addBookmarkForPage:5];
        NSMutableIndexSet *pageRange = [[NSMutableIndexSet alloc] initWithIndex:1];
        [pageRange addIndex:3];
        [pageRange addIndex:5];
        document.pageRange = pageRange;
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Test that showing all annotations doesn't kill the app due to memory pressure.
    [testSection addContent:[PSContent contentWithTitle:@"Test 5500 pages with annotations" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_5500_pages.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [pdfController.outlineButtonItem action:pdfController.outlineButtonItem];
        });
        return pdfController;
    }]];

    // Test that showing all annotations doesn't kill the app due to memory pressure.
    [testSection addContent:[PSContent contentWithTitle:@"Test 22000 pages with annotations" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_22000_pages.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Check that showing this won't crash the iPad1.
    [testSection addContent:[PSContent contentWithTitle:@"Test memory intensive document" block:^UIViewController *{
        [PSPDFCache.sharedCache clearCache];
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Dictionary of American Idioms and Phrasal Verbs.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];


    // Check that GIFs are animated.
    [testSection addContent:[PSContent contentWithTitle:@"Test animated GIFs + Links" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"animatedgif.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Test that we preserve the scrollEnabled setting.
    // Check that scroll is still blocked after drawing.
    [testSection addContent:[PSContent contentWithTitle:@"Test scroll blocking" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        // Finds the right timing to set properties.
        [pdfController setUpdateSettingsForRotationBlock:^(PSPDFViewController *aPDFController, UIInterfaceOrientation toInterfaceOrientation) {
            aPDFController.pagingScrollView.scrollEnabled = NO;
        }];
        return pdfController;
    }]];

    // Add note annotation via toolbar, close toolbar, ensure that the PDF was saved correctly, then test if the annotation still can be moved. If annotations haven't been correctly reloaded after saving the move will fail.
    [testSection addContent:[PSContent contentWithTitle:@"Test annotation updating after a save" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.imageSelectionEnabled = NO;
        pdfController.annotationButtonItem.annotationToolbar.saveAfterToolbarHiding = YES;
        pdfController.rightBarButtonItems = @[pdfController.annotationButtonItem];
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Parse weird outline format" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"weird-outline.pdf"]];
        [document.outlineParser outline]; // PARSE!
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Test outline parsing" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"LearningFlex4-outline.pdf"]];
        [document.outlineParser outline]; // PARSE!
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.rightBarButtonItems = @[pdfController.outlineButtonItem];
        return pdfController;
    }]];

    // should only take a few seconds, not 120.
    [testSection addContent:[PSContent contentWithTitle:@"Test outline parsing speed" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"5000pages-slow-outline.pdf"]];
        [document.outlineParser outline]; // PARSE!
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.rightBarButtonItems = @[pdfController.outlineButtonItem];
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Test audio" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"pdf_mp3/650_v2.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 36;
        pdfController.doublePageModeOnFirstPage = YES;
        return pdfController;
    }]];

    // Check that even extremely long pages are correctly rendered.
    [testSection addContent:[PSContent contentWithTitle:@"Test extremely long pages" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"pepsico-slow.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Test that all links on page 92 do work as expected.
    [testSection addContent:[PSContent contentWithTitle:@"Test JavaScript actions" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"US-GardeningMain2013-US.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 91;
        return pdfController;
    }]];

    // Test audio controls on the top left.
    [testSection addContent:[PSContent contentWithTitle:@"Test Rendition actions" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_Rendition-action.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Test RichMediaExecute actions" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_RichMediaExecute.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Test GoBack/GoForward named actions" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_GoBack-GoForward.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        //pdfController.page = 91;
        return pdfController;
    }]];

    // Check that there's a link inside that document.
    [testSection addContent:[PSContent contentWithTitle:@"Test URL parsing" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_URL-broken.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Test that the link correctly opens a new document.
    // Correct if it doesn't crash and then shows "PROCEDURES" as document.
    [testSection addContent:[PSContent contentWithTitle:@"Test GoToR actions" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_GotoR-FCOM.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.outlineButtonItem.availableControllerOptions = [NSOrderedSet orderedSetWithObject:@(PSPDFOutlineBarButtonItemOptionOutline)];

        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [pdfController.outlineButtonItem action:pdfController.outlineButtonItem];

            // Tap on PRO Procedures
            PSPDFOutlineViewController *outlineController = (PSPDFOutlineViewController *)([(UINavigationController *)(pdfController.popoverController.contentViewController) topViewController]);
            [outlineController tableView:outlineController.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
        });

        return pdfController;
    }]];

    // Check that external URLs are displayed in the inline browser (http and Http should be handled equally)
    [testSection addContent:[PSContent contentWithTitle:@"Test links with Http:// uppercase protocol" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"testcase_Http_tdn130209_1.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 13;
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"View state restoration for continuous scrolling" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 10;
        pdfController.pageTransition = PSPDFPageTransitionScrollContinuous;
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Test annotation saving + NSData" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithData:[NSData dataWithContentsOfURL:[samplesURL URLByAppendingPathComponent:@"annotations_nsdata.pdf"]]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Test image drawing" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"imagestest.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Test freetext annotation" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"freetext-test.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Test rotated documents" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_rotated-northern.pdf"]];
        [document appendFile:@"test1.pdf"];
        [document appendFile:@"test2.pdf"];
        [document appendFile:@"test3.pdf"];
        [document appendFile:@"test4.pdf"];
        [document appendFile:@"test5.pdf"];
        [document appendFile:@"Testcase_AllPageRotations.pdf"];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // There was a bug where free text annotations with a too small boundingBox were not drawn.
    [testSection addContent:[PSContent contentWithTitle:@"Test small freetext annotation" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"SmallTextAnnotationTest.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Ensure that a word is highlighted.
    [testSection addContent:[PSContent contentWithTitle:@"Test annotation writing with invalid page object" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_invalid_first_page_object.pdf"]];

        for (NSUInteger idx = 0; idx < 6; idx++) {
            PSPDFWord *word = ([document textParserForPage:0].words)[idx];
            PSPDFHighlightAnnotation *annotation = [PSPDFHighlightAnnotation new];
            CGRect boundingBox;
            annotation.rects = PSPDFRectsFromGlyphs(word.glyphs, [document pageInfoForPage:0].pageRotationTransform, &boundingBox);
            annotation.boundingBox = boundingBox;
            [document addAnnotations:@[annotation]];
            [document saveAnnotationsWithError:NULL];
        }
        // NSLog(@"annots: %@", [document allAnnotationsOfType:PSPDFAnnotationTypeHighlight]);

        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Ensure that a word is highlighted and that the we don't crash in saveChangedAnnotationsWithError
    [testSection addContent:[PSContent contentWithTitle:@"Test annotation writing with invalid page object 2" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_corrupt_stream_add_annotations.pdf"]];

        for (NSUInteger idx = 0; idx < 6; idx++) {
            PSPDFWord *word = ([document textParserForPage:0].words)[idx];
            PSPDFHighlightAnnotation *annotation = [PSPDFHighlightAnnotation new];
            CGRect boundingBox;
            annotation.rects = PSPDFRectsFromGlyphs(word.glyphs, [document pageInfoForPage:0].pageRotationTransform, &boundingBox);
            annotation.boundingBox = boundingBox;
            [document addAnnotations:@[annotation]];
            [document saveAnnotationsWithError:NULL];
        }
        // NSLog(@"annots: %@", [document allAnnotationsOfType:PSPDFAnnotationTypeHighlight]);

        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    /*
     [testSection addContent:[PSContent contentWithTitle:@"Tests thumbnail extraction" block:^UIViewController *{
     NSURL *URL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"] URLByAppendingPathComponent:@"landscapetest.pdf"];
     PSPDFDocument *doc = [PSPDFDocument documentWithURL:URL];
     NSError *error = nil;
     UIImage *thumbnail = [doc imageForPage:0 size:CGSizeMake(300, 300) clippedToRect:CGRectZero annotations:nil options:nil receipt:NULL error:&error];
     if (!thumbnail) {
     NSLog(@"Failed to generate thumbnail: %@", error.localizedDescription);
     }
     NSData *thumbnailMedium = UIImagePNGRepresentation([thumbnail pspdf_resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(150, 150) honorScaleFactor:YES interpolationQuality:kCGInterpolationHigh]);
     NSData *thumbnailSmall = UIImagePNGRepresentation([thumbnail pspdf_resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(80, 80) honorScaleFactor:YES interpolationQuality:kCGInterpolationHigh]);
     NSString *filePathMedium = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"medium.png"];
     NSString *filePathSmall = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"small.png"];
     NSLog(@"Writing %@", filePathMedium);
     [thumbnailMedium writeToFile:filePathMedium atomically:YES];
     NSLog(@"Writing %@", filePathSmall);
     [thumbnailSmall writeToFile:filePathSmall atomically:YES];
     NSString *filePathFull = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"full.png"];
     [UIImagePNGRepresentation(thumbnail) writeToFile:filePathFull atomically:YES];
     return nil;
     }]];*/

    // Check that there's a red note annotation in landscape mode or when you zoom out.
    [testSection addContent:[PSContent contentWithTitle:@"Test annotation outside of page" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"noteannotation-outside.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Test flattening, especially for notes.
    [testSection addContent:[PSContent contentWithTitle:@"Test annotation flattening" block:^UIViewController *{
        NSURL *tempURL = PSCTempFileURLWithPathExtension(@"annotationtest", @"pdf");
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"stamps2.pdf"]];
        [[PSPDFProcessor defaultProcessor] generatePDFFromDocument:document pageRange:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)] outputFileURL:tempURL options:@{PSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeAll)} progressBlock:NULL error:NULL];

        // show file
        PSPDFDocument *newDocument = [PSPDFDocument documentWithURL:tempURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:newDocument];
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"Test annotation flattening 2" block:^UIViewController *{
        NSURL *tempURL = PSCTempFileURLWithPathExtension(@"annotationtest2", @"pdf");
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;
        PSPDFNoteAnnotation *noteAnnotation = [PSPDFNoteAnnotation new];
        noteAnnotation.boundingBox = CGRectMake(100, 100, 50, 50);
        noteAnnotation.contents = @"This is a test for the note annotation flattening. This is a test for the note annotation flattening. This is a test for the note annotation flattening. This is a test for the note annotation flattening.";
        [document addAnnotations:@[noteAnnotation]];
        [[PSPDFProcessor defaultProcessor] generatePDFFromDocument:document pageRange:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)] outputFileURL:tempURL options:@{PSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeAll)} progressBlock:NULL error:NULL];

        // show file
        PSPDFDocument *newDocument = [PSPDFDocument documentWithURL:tempURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:newDocument];
        return pdfController;
    }]];

    // Check that annotations are there, links work.
    [testSection addContent:[PSContent contentWithTitle:@"Test PDF generation + annotation adding 1" block:^UIViewController *{
        NSURL *tempURL = PSCTempFileURLWithPathExtension(@"annotationtest", @"pdf");
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        [[PSPDFProcessor defaultProcessor] generatePDFFromDocument:document pageRange:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)] outputFileURL:tempURL options:@{PSPDFProcessorAnnotationAsDictionary : @YES, PSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeAll)} progressBlock:NULL error:NULL];

        // show file
        PSPDFDocument *newDocument = [PSPDFDocument documentWithURL:tempURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:newDocument];
        return pdfController;
    }]];

    // Check that annotations are there.
    [testSection addContent:[PSContent contentWithTitle:@"Test PDF generation + annotation adding 2" block:^UIViewController *{
        NSURL *tempURL = PSCTempFileURLWithPathExtension(@"annotationtest", @"pdf");
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"stamps2.pdf"]];
        [[PSPDFProcessor defaultProcessor] generatePDFFromDocument:document pageRange:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)] outputFileURL:tempURL options:@{PSPDFProcessorAnnotationAsDictionary : @YES, PSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeAll)} progressBlock:NULL error:NULL];

        // show file
        PSPDFDocument *newDocument = [PSPDFDocument documentWithURL:tempURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:newDocument];
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"PSPDFProcessor PPTX (Microsoft Office) conversion" block:^UIViewController *{
        NSURL *URL = [NSURL fileURLWithPath:@"/Users/steipete/Documents/Projects/PSPDFKit_meta/converts/Neu_03_VZ3_Introduction.pptx"];
        NSURL *outputURL = PSCTempFileURLWithPathExtension(@"converted", @"pdf");
        [PSPDFProgressHUD showWithStatus:@"Converting..." maskType:PSPDFProgressHUDMaskTypeGradient];
        [[PSPDFProcessor defaultProcessor] generatePDFFromURL:URL outputFileURL:outputURL options:nil completionBlock:^(NSURL *fileURL, NSError *error) {
            if (error) {
                [PSPDFProgressHUD dismiss];
                [[[UIAlertView alloc] initWithTitle:@"Conversion failed" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            }else {
                // generate document and show it
                [PSPDFProgressHUD showSuccessWithStatus:@"Finished"];
                PSPDFDocument *document = [PSPDFDocument documentWithURL:fileURL];
                PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
                [self.navigationController pushViewController:pdfController animated:YES];
            }
        }];
        return nil;
    }]];

    // Test that merging both document (first page each) correctly preserves the aspect ratio.
    [testSection addContent:[PSContent contentWithTitle:@"Merge landscape with portrait page" block:^{
        PSPDFDocument *document = [PSPDFDocument documentWithBaseURL:samplesURL files:@[@"Testcase_consolidate_A.pdf", @"Testcase_consolidate_B.pdf"]];
        NSMutableIndexSet *pageRange = [NSMutableIndexSet indexSetWithIndex:0];
        [pageRange addIndex:5];
        document.pageRange = pageRange;

        // Merge pages into new document.
        NSURL *tempURL = PSCTempFileURLWithPathExtension(@"temp-merged", @"pdf");
        [[PSPDFProcessor defaultProcessor] generatePDFFromDocument:document pageRange:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)] outputFileURL:tempURL options:nil progressBlock:NULL error:NULL];
        PSPDFDocument *mergedDocument = [PSPDFDocument documentWithURL:tempURL];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:mergedDocument];
        return controller;
    }]];

    // Form support
    [testSection addContent:[PSContent contentWithTitle:@"Test PDF Forms" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_forms.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.rightBarButtonItems = @[pdfController.annotationButtonItem, pdfController.openInButtonItem, pdfController.emailButtonItem, pdfController.outlineButtonItem, pdfController.viewModeButtonItem];
        return pdfController;
    }]];

    // Form support
    [testSection addContent:[PSContent contentWithTitle:@"Test PDF Forms 2" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_Forms_Tool.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.rightBarButtonItems = @[pdfController.annotationButtonItem, pdfController.openInButtonItem, pdfController.searchButtonItem, pdfController.outlineButtonItem, pdfController.viewModeButtonItem];
        return pdfController;
    }]];

    // Form support
    [testSection addContent:[PSContent contentWithTitle:@"Test PDF Button Show/Hide" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_TouchDownButton.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.rightBarButtonItems = @[pdfController.annotationButtonItem, pdfController.openInButtonItem, pdfController.searchButtonItem, pdfController.outlineButtonItem, pdfController.viewModeButtonItem];
        return pdfController;
    }]];

#endif

    [sections addObject:testSection];
    ///////////////////////////////////////////////////////////////////////////////////////////

    PSCSectionDescriptor *delegateSection = [PSCSectionDescriptor sectionWithTitle:@"Delegate" footer:!PSCIsIPad() ? PSPDFVersionString() : @""];
    [delegateSection addContent:[PSContent contentWithTitle:@"Custom drawing" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        document.title = @"Custom drawing";
        PSPDFViewController *pdfController = [[PSCCustomDrawingViewController alloc] initWithDocument:document];
        return pdfController;
    }]];
    [sections addObject:delegateSection];
    ///////////////////////////////////////////////////////////////////////////////////////////


    // iPad only examples
    if (PSCIsIPad()) {
        PSCSectionDescriptor *iPadTests = [PSCSectionDescriptor sectionWithTitle:@"iPad only" footer:PSPDFVersionString()];
        [iPadTests addContent:[PSContent contentWithTitle:@"SplitView" block:^{
            UISplitViewController *splitVC = [[UISplitViewController alloc] init];
            splitVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Split" image:[UIImage imageNamed:@"shoebox"] tag:3];
            PSCSplitDocumentSelectorController *tableVC = [[PSCSplitDocumentSelectorController alloc] init];
            UINavigationController *tableNavVC = [[UINavigationController alloc] initWithRootViewController:tableVC];
            PSCSplitPDFViewController *hostVC = [[PSCSplitPDFViewController alloc] init];
            UINavigationController *hostNavVC = [[UINavigationController alloc] initWithRootViewController:hostVC];
            tableVC.masterVC = hostVC;
            splitVC.delegate = hostVC;
            splitVC.viewControllers = @[tableNavVC, hostNavVC];
            // Split view controllers can't just be added to a UINavigationController
            self.view.window.rootViewController = splitVC;
            return (UIViewController *)nil;
        }]];
        [sections addObject:iPadTests];
    }

    _content = sections.array;

    // debug helper
#ifdef kDebugTextBlocks
    [PSCSettingsController settings][@"showTextBlocks"] = @YES;
#endif
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.bounds.size.width, 44.f)];
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.tableView.tableHeaderView = _searchBar;

    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDisplayController.delegate = self;
    _searchDisplayController.searchResultsDataSource = self;
    _searchDisplayController.searchResultsDelegate = self;

    // Private API to improve search result style - don't ship this in App Store builds.
    if (!PSCIsUIKitFlatMode()) {
        [_searchDisplayController setValue:@(UITableViewStyleGrouped) forKey:[NSString stringWithFormat:@"%@TableViewStyle", @"searchResults"]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Restore state as it was before.
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if (PSCIsUIKitFlatMode()) {
        PSC_IF_IOS7_OR_GREATER([UIApplication.sharedApplication setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
                               self.navigationController.navigationBar.barTintColor = UIColor.pspdfColor;
                               self.navigationController.toolbar.tintColor = UIColor.blackColor;
                               self.navigationController.view.tintColor = UIColor.whiteColor;
                               // By default the system would show a white cursor.
                               [[UITextField appearance] setTintColor:UIColor.pspdfColor];
                               [[UITextView  appearance] setTintColor:UIColor.pspdfColor];
                               [[UISearchBar appearance] setTintColor:UIColor.pspdfColor];)
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor : UIColor.whiteColor};
    }else {
        [UIApplication.sharedApplication setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
    }
    [UIApplication.sharedApplication setStatusBarHidden:NO withAnimation:animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone];
    PSCFixNavigationBarForNavigationControllerAnimated(self.navigationController, NO);
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController setToolbarHidden:YES animated:animated];

    // clear cache (for night mode)
    if (_clearCacheNeeded) {
        _clearCacheNeeded = NO;
        [PSPDFCache.sharedCache clearCache];
    }
}

#define PSCResetKey @"psc_reset"

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    PSCFixNavigationBarForNavigationControllerAnimated(self.navigationController, animated);

    // Support reset from settings.
    if ([[NSUserDefaults standardUserDefaults] boolForKey:PSCResetKey]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:PSCResetKey];
        _firstShown = YES;
    }

    // Load last state
    if (!_firstShown) {
        NSData *indexData = [[NSUserDefaults standardUserDefaults] objectForKey:PSCLastIndexPath];
        if (indexData) {
            NSIndexPath *indexPath = nil;
            @try { indexPath = [NSKeyedUnarchiver unarchiveObjectWithData:indexData]; }
            @catch (NSException *exception) {}
            if ([self isValidIndexPath:indexPath]) {
                [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
            }
        }
        _firstShown = YES;
    }else {
        // Second display, remove user default.
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:PSCLastIndexPath];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (BOOL)isValidIndexPath:(NSIndexPath *)indexPath {
    BOOL isValid = NO;
    if (indexPath) {
        NSUInteger numberOfSections = [self numberOfSectionsInTableView:self.tableView];
        NSUInteger numberOfRowsInSection = 0;
        if (indexPath.section < numberOfSections) {
            numberOfRowsInSection = [self tableView:self.tableView numberOfRowsInSection:indexPath.section];
            if (indexPath.row < numberOfRowsInSection) {
                isValid = YES;
            }
        }
    }
    return isValid;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return tableView == self.tableView ? self.content.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView == self.tableView ? [_content[section] contentDescriptors].count : self.filteredContent.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return tableView == self.tableView ? [_content[section] title] : nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return tableView == self.tableView ? [_content[section] footer] : nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *PSCCellIdentifier = @"PSCatalogCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PSCCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PSCCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    // Get correct content descriptor
    PSContent *contentDescriptor;
    if (tableView == self.tableView) {
        contentDescriptor = [_content[indexPath.section] contentDescriptors][indexPath.row];
    }else {
        contentDescriptor = self.filteredContent[indexPath.row];
    }

    cell.textLabel.text = contentDescriptor.title;
    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Invoking [NSIndexPath indexPathForRow:%ld inSection:%ld]", (long)indexPath.row, (long)indexPath.section);

    __block NSIndexPath *unfilteredIndexPath;
    PSContent *contentDescriptor;
    if (tableView == self.tableView) {
        contentDescriptor = [_content[indexPath.section] contentDescriptors][indexPath.row];
        unfilteredIndexPath = indexPath;
    }else {
        contentDescriptor = self.filteredContent[indexPath.row];
        // Find original index path so we can persist.
        [self.content enumerateObjectsUsingBlock:^(PSCSectionDescriptor *section, NSUInteger sectionIndex, BOOL *stop) {
            [section.contentDescriptors enumerateObjectsUsingBlock:^(PSContent *content, NSUInteger contentIndex, BOOL *stop2) {
                if (content == contentDescriptor) {
                    unfilteredIndexPath = [NSIndexPath indexPathForRow:contentIndex inSection:sectionIndex];
                    *stop = YES, *stop2 = YES;
                }
            }];
        }];
    }

    // Persist state
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:unfilteredIndexPath] forKey:PSCLastIndexPath];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _firstShown = YES; // don't re-show after saving it first.

    UIViewController *controller = contentDescriptor.block();
    if (controller) {
        if ([controller isKindOfClass:[UINavigationController class]]) {
            controller = [((UINavigationController *)controller) topViewController];
        }
        [self.navigationController pushViewController:controller animated:YES];
    }else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocumentPickerControllerDelegate

- (void)documentPickerController:(PSPDFDocumentPickerController *)controller didSelectDocument:(PSPDFDocument *)document page:(NSUInteger)pageIndex searchString:(NSString *)searchString {
    BOOL showInGrid = [objc_getAssociatedObject(controller, &PSCShowDocumentSelectorOpenInTabbedControllerKey) boolValue];

    // add fade transition for navigationBar.
    [controller.navigationController.navigationBar.layer addAnimation:PSCFadeTransition() forKey:kCATransition];

    if (showInGrid) {
        // create controller and merge new documents with last saved state.
        PSPDFTabbedViewController *tabbedViewController = [PSCTabbedExampleViewController new];
        [tabbedViewController restoreStateAndMergeWithDocuments:@[document]];
        tabbedViewController.pdfController.page = pageIndex;
        [controller.navigationController pushViewController:tabbedViewController animated:YES];
    }else {
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = pageIndex;
        pdfController.rightBarButtonItems = @[pdfController.searchButtonItem, pdfController.outlineButtonItem, pdfController.annotationButtonItem, pdfController.viewModeButtonItem];
        pdfController.additionalBarButtonItems = @[pdfController.openInButtonItem, pdfController.bookmarkButtonItem, pdfController.brightnessButtonItem, pdfController.printButtonItem, pdfController.emailButtonItem];
        [controller.navigationController pushViewController:pdfController animated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocumentDelegate

- (void)pdfDocument:(PSPDFDocument *)document didSaveAnnotations:(NSArray *)annotations {
    PSCLog(@"\n\nSaving of %@ successful: %@", document, annotations);
}

- (void)pdfDocument:(PSPDFDocument *)document failedToSaveAnnotations:(NSArray *)annotations error:(NSError *)error {
    PSCLog(@"\n\n Warning: Saving of %@ failed: %@", document, error);
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITextFieldDelegate

// enable the return key on the alert view
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    UIAlertView *alertView = objc_getAssociatedObject(textField, &PSCAlertViewKey);
    if (alertView) { [alertView dismissWithClickedButtonIndex:1 animated:YES]; return YES;
    }else return NO;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UISearchDisplayController and content filtering

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:
     [self.searchDisplayController.searchBar scopeButtonTitles][[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];

    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    // HACK: Tapping twice on the search bar on iOS 7 will make it disappear. This is a workaround for this UIKit bug.
    [self.view addSubview:controller.searchBar];
}

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    NSMutableArray *filteredContent = [NSMutableArray array];

    if (searchText.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.title CONTAINS[cd] %@", searchText];
        for (PSCSectionDescriptor *section in self.content) {
            [filteredContent addObjectsFromArray:[section.contentDescriptors filteredArrayUsingPredicate:predicate]];
        }
    }
    self.filteredContent = filteredContent;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFSignatureViewControllerDelegate

// Sign all pages example
- (void)signatureViewControllerDidSave:(PSPDFSignatureViewController *)signatureController {
    void(^signatureCompletionBlock)(PSPDFSignatureViewController *signatureController) = objc_getAssociatedObject(signatureController, &PSCSignatureCompletionBlock);
    if (signatureCompletionBlock) signatureCompletionBlock(signatureController);
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Debug Helper

- (void)addDebugButtons {
#ifdef PSPDF_USE_SOURCE
    UIBarButtonItem *memoryButton = [[UIBarButtonItem alloc] initWithTitle:@"Memory" style:UIBarButtonItemStyleBordered target:self action:@selector(debugCreateLowMemoryWarning)];
    self.navigationItem.leftBarButtonItem = memoryButton;
    
    UIBarButtonItem *cacheButton = [[UIBarButtonItem alloc] initWithTitle:@"Cache" style:UIBarButtonItemStyleBordered target:self action:@selector(debugClearCache)];
    self.navigationItem.rightBarButtonItem = cacheButton;
#endif
}

// Only for debugging - this will get you rejected on the App Store!
- (void)debugCreateLowMemoryWarning {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [UIApplication.sharedApplication performSelector:NSSelectorFromString([NSString stringWithFormat:@"_%@Warning", @"performMemory"])];
#pragma clang diagnostic pop
    
    // Clear any reference of items that would retain controllers/pages.
    [[UIMenuController sharedMenuController] setMenuItems:nil];
}

- (void)debugClearCache {
    [PSPDFRenderQueue.sharedRenderQueue cancelAllJobs];
    [PSPDFCache.sharedCache clearCache];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExampleRunner

- (UIViewController *)currentViewController {
    return self;
}

@end
