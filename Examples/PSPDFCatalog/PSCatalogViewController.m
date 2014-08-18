//
//  PSCatalogViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import <QuickLook/QuickLook.h>
#import "PSCatalogViewController.h"
#import "PSCSectionDescriptor.h"
#import "PSCFileHelper.h"
#import "PSCGridViewController.h"
#import "PSCTabbedExampleViewController.h"
#import "PSCBookmarkParser.h"
#import "PSCKioskPDFViewController.h"
#import "PSCEmbeddedAnnotationTestViewController.h"
#import "PSCCustomDrawingViewController.h"
#import "PSCAutoScrollViewController.h"
#import "PSCPlayBarButtonItem.h"
#import "PSCCustomLinkAnnotationView.h"
#import "PSCCustomAnnotationProvider.h"
#import "PSCTimingTestViewController.h"
#import "PSCCustomSubviewPDFViewController.h"
#import "PSCTwoFingerSwipeGestureViewController.h"
#import "PSCHeadlessSearchPDFViewController.h"
#import "PSCCustomThumbnailsViewController.h"
#import "PSCHideHUDForThumbnailsViewController.h"
#import "PSCCustomDefaultZoomScaleViewController.h"
#import "PSCDropboxSplitViewController.h"
#import "PSCAnnotationTrailerCaptureDocument.h"
#import "PSCMultipleUsersPDFViewController.h"
#import "PSCShowHighlightNotesPDFController.h"
#import "PSCExportPDFPagesViewController.h"
#import "PSCiBooksHighlightingViewController.h"
#import "PSCAssetLoader.h"
#import "PSCExampleManager.h"
#import "PSCAvailability.h"
#import "PSCViewHelper.h"
#import "UIColor+PSPDFCatalog.h"
#import "NSArray+PSCHelper.h"

#ifdef PSPDF_USE_SOURCE
#import "PSCPopoverTestViewController.h"
#endif

#import <objc/runtime.h>

// Crypto support
#import "RNEncryptor.h"
#import "RNDecryptor.h"

//#define kDebugTextBlocks

@interface PSCatalogViewController () <PSPDFViewControllerDelegate, PSPDFDocumentDelegate, PSPDFDocumentPickerControllerDelegate, PSPDFSignatureViewControllerDelegate, UITextFieldDelegate, UISearchDisplayDelegate, PSCExampleRunnerDelegate> {
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
static NSString *const PSCLastIndexPath = @"PSCLastIndexPath";

@implementation PSCatalogViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithStyle:style])) {
        self.title = PSPDFLocalize(@"PSPDFKit Catalog");
        if (PSCIsIPad()) {
            self.title = [PSPDFKit.sharedInstance.version stringByReplacingOccurrencesOfString:@"PSPDFKit" withString:PSPDFLocalize(@"PSPDFKit Catalog")];
        }
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Catalog" style:UIBarButtonItemStylePlain target:nil action:nil];
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
    [appSection addContent:[PSContent contentWithTitle:@"PSPDFViewController playground" contentDescription:@"Simple Test-Bed for the PSPDFViewController" block:^{
        PSPDFDocument *document;
        document = [PSCAssetLoader sampleDocumentWithName:kPSPDFQuickStart];

        //document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Test-relative-links.pdf"]];
        PSPDFViewController *controller = [[PSCKioskPDFViewController alloc] initWithDocument:document];
        return controller;
    }]];

    [appSection addContent:[PSContent contentWithTitle:@"Case Study from Box" contentDescription:@"Incudes a RichMedia inline video that works in Acrobat and PSPDFKit." block:^{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kCaseStudyBox]];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        controller.thumbnailBarMode = PSPDFThumbnailBarModeNone;
        controller.shouldShowHUDOnViewWillAppear = NO;
        controller.pageLabelEnabled = NO;
        controller.activityButtonItem.applicationActivities = @[PSPDFActivityTypeOpenIn];
        controller.rightBarButtonItems = @[controller.annotationButtonItem, controller.searchButtonItem, controller.activityButtonItem];
        return controller;
    }]];

    [appSection addContent:[PSContent contentWithTitle:@"Kiosk Grid Example" contentDescription:@"Dispays all documents in the Sample directory" block:^UIViewController *{
        return [PSCGridViewController new];
    }]];

    [appSection addContent:[PSContent contentWithTitle:@"Tabbed Browser" contentDescription:@"Allows to open multiple documents via a tabbed interface." block:^{
        if (PSCIsIPad()) {
            return (UIViewController *)[PSCTabbedExampleViewController new];
        }else {
            // on iPhone, we do things a bit different, and push/pull the controller.
            PSPDFDocumentPickerController *documentSelector = [[PSPDFDocumentPickerController alloc] initWithDirectory:@"/Bundle/Samples" includeSubdirectories:YES library:PSPDFLibrary.defaultLibrary delegate:self];
            objc_setAssociatedObject(documentSelector, &PSCShowDocumentSelectorOpenInTabbedControllerKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            return (UIViewController *)documentSelector;
        }
    }]];

    [appSection addContent:[PSContent contentWithTitle:@"Open In... Inbox" contentDescription:@"Displays all files in the Inbox directory via the PSPDFDocumentPickerController." block:^{
        // Add all documents in the Documents folder and subfolders (e.g. Inbox from Open In... feature)
        PSPDFDocumentPickerController *documentSelector = [[PSPDFDocumentPickerController alloc] initWithDirectory:nil includeSubdirectories:YES library:PSPDFLibrary.defaultLibrary delegate:self];
        documentSelector.fullTextSearchEnabled = YES;
        return documentSelector;
    }]];

    [appSection addContent:[PSContent contentWithTitle:@"Settings for a magazine" contentDescription:@"Large thumbnails, page curl, sliding HUD." block:^{
        PSPDFDocument *hackerMagDoc = [PSPDFDocument documentWithURL:hackerMagURL];
        hackerMagDoc.UID = @"HACKERMAGDOC"; // set custom UID so it doesn't interfere with other examples
        hackerMagDoc.title = @"HACKER MONTHLY Issue 12"; // Override document title.
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:hackerMagDoc];
        controller.pageTransition = PSPDFPageTransitionCurl;
        controller.pageMode = PSPDFPageModeAutomatic;
        controller.HUDViewAnimation = PSPDFHUDViewAnimationSlide;
        controller.thumbnailBarMode = PSPDFThumbnailBarModeScrollable;

        // Don't use thumbnails if the PDF is not rendered.
        // FullPageBlocking feels good when combined with pageCurl, less great with other scroll modes, especially PSPDFPageTransitionScrollContinuous.
        controller.renderingMode = PSPDFPageRenderingModeFullPageBlocking;

        // Setup toolbar
        controller.outlineButtonItem.availableControllerOptions = [NSOrderedSet orderedSetWithObject:@(PSPDFOutlineBarButtonItemOptionOutline)];
        controller.rightBarButtonItems = @[controller.activityButtonItem, controller.searchButtonItem, controller.outlineButtonItem, controller.bookmarkButtonItem];

        controller.HUDView.pageLabel.showThumbnailGridButton = YES;
        controller.activityButtonItem.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];

        // Hide thumbnail filter bar.
        controller.thumbnailController.filterOptions = [NSOrderedSet orderedSetWithArray:@[@(PSPDFThumbnailViewFilterShowAll), @(PSPDFThumbnailViewFilterBookmarks)]];

        return controller;
    }]];

    [appSection addContent:[PSContent contentWithTitle:@"Settings for a scientific paper" contentDescription:@"Automatic text link detection, continuous scrolling, default style." block:^{
        // Initialize document and enable link autodetection.
        PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kPaperExampleFileName];
        document.autodetectTextLinkTypes = PSPDFTextCheckingTypeAll;
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];

        // Starting with iOS7, we usually don't want to include an internal brightness control.
        // Since PSPDFKit optionally uses an additional software darkener, it can still be useful for certain places like a Pilot's Cockpit.
        controller.rightBarButtonItems = @[controller.annotationButtonItem, controller.activityButtonItem, controller.outlineButtonItem, controller.searchButtonItem, controller.viewModeButtonItem];
        controller.activityButtonItem.applicationActivities = @[PSPDFActivityTypeOpenIn, PSPDFActivityTypeGoToPage];
        controller.pageTransition = PSPDFPageTransitionScrollContinuous;
        controller.scrollDirection = PSPDFScrollDirectionVertical;
        controller.fitToWidthEnabled = YES;
        controller.pagePadding = 5.f;
        controller.renderAnimationEnabled = NO;
		controller.shouldHideNavigationBarWithHUD = NO;
		controller.shouldHideStatusBarWithHUD = NO;

        // Present modally, so we can more easily configure it to have a different style.
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
		navController.navigationBar.translucent = NO;
        [self.navigationController presentViewController:navController animated:YES completion:NULL];
        return (UIViewController *)nil;
    }]];

    [appSection addContent:[PSContent contentWithTitle:@"Dropbox-like interface" contentDescription:@"Replicates the floating toolbar interface of the Dropbox app, which also uses PSPDFKit." block:^{
        if (PSCIsIPad()) {
            PSCDropboxSplitViewController *splitViewController = [PSCDropboxSplitViewController new];
            UIViewController *containerController = [[UIViewController alloc] init];
            [containerController addChildViewController:splitViewController];
            [containerController.view addSubview:splitViewController.view];
            [splitViewController didMoveToParentViewController:containerController];
            [self presentViewController:containerController animated:YES completion:NULL];
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
        [currentSection addContent:[PSContent contentWithTitle:example.title contentDescription:example.contentDescription block:^UIViewController *{
            return [example invokeWithDelegate:weakSelf];
        }]];
    }

    ///////////////////////////////////////////////////////////////////////////////////////////

    // PSPDFViewController customization examples
    PSCSectionDescriptor *customizationSection = [PSCSectionDescriptor sectionWithTitle:@"PSPDFViewController customization" footer:@""];

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

    [customizationSection addContent:[PSContent contentWithTitle:@"iBooks-like highlighting" block:^{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        PSPDFViewController *pdfController = [[PSCiBooksHighlightingViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [sections addObject:customizationSection];
    ///////////////////////////////////////////////////////////////////////////////////////////

    PSCSectionDescriptor *passwordSection = [PSCSectionDescriptor sectionWithTitle:@"Passwords / Security" footer:@"Password is test123"];

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

        PSPDFStatusHUDItem *status = [PSPDFStatusHUDItem progressWithText:[PSPDFLocalize(@"Preparing") stringByAppendingString:@"…"]];
        [status pushAnimated:YES];

        // With password protected pages, PSPDFProcessor can only add link annotations.
        [PSPDFProcessor.defaultProcessor generatePDFFromDocument:hackerMagDoc pageRanges:@[[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, hackerMagDoc.pageCount)]] outputFileURL:tempURL options:@{(id)kCGPDFContextUserPassword : password, (id)kCGPDFContextOwnerPassword : password, (id)kCGPDFContextEncryptionKeyLength : @128, PSPDFProcessorAnnotationAsDictionary : @YES, PSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeLink)} progressBlock:^(NSUInteger currentPage, NSUInteger numberOfProcessedPages, NSUInteger totalPages) {
            status.progress = numberOfProcessedPages/(float)totalPages;
        } error:NULL];

        [status popAnimated:YES];

        // show file
        PSPDFDocument *document = [PSPDFDocument documentWithURL:tempURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    /// Example how to decrypt a AES256 encrypted PDF on the fly.
    /// The crypto feature requires the `PSPDFFeatureMaskStrongEncryption` feature flag.
    if (PSPDFAESCryptoDataProvider.isAESCryptoFeatureAvailable) {
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

        PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        return controller;
    }]];

    [sections addObject:passwordSection];
    ///////////////////////////////////////////////////////////////////////////////////////////

    PSCSectionDescriptor *subclassingSection = [PSCSectionDescriptor sectionWithTitle:@"Subclassing" footer:@"Examples how to subclass PSPDFKit."];

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
            annotation.boundingBox = CGRectInset([document pageInfoForPage:targetPage].rotatedRect, 100, 100);
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
                    NSArray *highlighedRects = PSPDFRectsFromGlyphs(word.glyphs, [document pageInfoForPage:pageIndex].rotationTransform, &boundingBox);
                    PSPDFHighlightAnnotation *annotation = [PSPDFHighlightAnnotation new];
                    annotation.color = [UIColor orangeColor];
                    annotation.boundingBox = boundingBox;
                    annotation.rects = highlighedRects;
                    annotation.contents = [NSString stringWithFormat:@"This is automatically created highlight #%tu", annotationCounter];
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
            annotation.lines = PSPDFConvertViewLinesToPDFLines(lines, pageInfo.rect, pageInfo.rotation, viewRect);

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
		controller.annotationButtonItem.flexibleAnnotationToolbar.saveAfterToolbarHiding = YES;
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
            annotation.rects = PSPDFRectsFromGlyphs(word.glyphs, [document pageInfoForPage:0].rotationTransform, &boundingBox);
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
        PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
        PSCHeadlessSearchPDFViewController *pdfController = [[PSCHeadlessSearchPDFViewController alloc] initWithDocument:document];
        pdfController.highlightedSearchText = @"Batman";
        return pdfController;
    }]];

    [subclassingSection addContent:[PSContent contentWithTitle:@"Remove Ink from the annotation toolbar" block:^UIViewController *{
        PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.rightBarButtonItems = @[pdfController.annotationButtonItem];
        NSMutableOrderedSet *editableTypes = [document.editableAnnotationTypes mutableCopy];
        [editableTypes removeObject:PSPDFAnnotationStringInk];
		pdfController.annotationButtonItem.flexibleAnnotationToolbar.editableAnnotationTypes = editableTypes;
        return pdfController;
    }]];

    [subclassingSection addContent:[PSContent contentWithTitle:@"Set custom default zoom level" block:^UIViewController *{
        PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
        PSPDFViewController *pdfController = [[PSCCustomDefaultZoomScaleViewController alloc] initWithDocument:document];
        [self presentViewController:pdfController animated:YES completion:NULL];
        return nil;
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

    [subclassingSection addContent:[PSContent contentWithTitle:@"Allow to select and export pages in thumbnail mode" block:^UIViewController *{
        PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
        PSCExportPDFPagesViewController *pdfController = [[PSCExportPDFPagesViewController alloc] initWithDocument:document];
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

    // Check that a new tab will be opened
    [testSection addContent:[PSContent contentWithTitle:@"Tabbed Controller + External references test" block:^UIViewController *{
        PSPDFTabbedViewController *tabbedController = [[PSPDFTabbedViewController alloc] init];
        PSPDFDocument *multimediaDoc = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"multimedia.pdf"]];

        // Create a custom outline for testing.
        PSPDFOutlineElement *openExternalAction = [[PSPDFOutlineElement alloc] initWithTitle:@"Open External" color:nil fontTraits:0 action:[[PSPDFRemoteGoToAction alloc] initWithRemotePath:@"A.pdf" pageIndex:0] children:nil level:1];
        PSPDFOutlineElement *rootOutline = [[PSPDFOutlineElement alloc] initWithTitle:@"Root"  color:nil fontTraits:0 action:nil children:@[openExternalAction] level:0];
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
        PSPDFOutlineElement *openExternalAction = [[PSPDFOutlineElement alloc] initWithTitle:@"Open External"  color:nil fontTraits:0 action:[[PSPDFRemoteGoToAction alloc] initWithRemotePath:@"A.pdf" pageIndex:0] children:nil level:1];
        PSPDFOutlineElement *rootOutline = [[PSPDFOutlineElement alloc] initWithTitle:@"Root"  color:nil fontTraits:0 action:nil children:@[openExternalAction] level:0];
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

        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            pdfController.document = hackerMagDoc;
        });

        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"PSPDFMultiDocumentViewController" block:^UIViewController *{
        PSPDFDocument *doc1 = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"A.pdf"]];
        PSPDFDocument *doc2 = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"B.pdf"]];
        PSPDFDocument *doc3 = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"C.pdf"]];
        PSPDFDocument *doc4 = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"D.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:nil];
        pdfController.useParentNavigationBar = YES;
        PSPDFMultiDocumentViewController *pdfMultiDocController = [[PSPDFMultiDocumentViewController alloc] initWithPDFViewController:pdfController];
        pdfMultiDocController.documents = @[doc1, doc2, doc3, doc4];
        pdfMultiDocController.visibleDocument = doc1;
        return [[UINavigationController alloc] initWithRootViewController:pdfMultiDocController];
    }]];

    // additional test cases, just for developing and testing PSPDFKit.
    // Referenced PDF files are proprietary and not released with the downloadable package.
#ifdef PSPDF_USE_SOURCE

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

    // check that the brightness works on iPhone as well.
    [testSection addContent:[PSContent contentWithTitle:@"Brightness on iPhone" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.rightBarButtonItems = @[pdfController.brightnessButtonItem, pdfController.viewModeButtonItem];
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

#ifdef PSPDF_USE_SOURCE
    [testSection addContent:[PSContent contentWithTitle:@"Popover test" block:^UIViewController *{
        PSCPopoverTestViewController *popover = [PSCPopoverTestViewController new];
        return popover;
    }]];
#endif

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

    // Ensure that videos do display.
    [testSection addContent:[PSContent contentWithTitle:@"Test large video extraction code" block:^UIViewController *{
        // clear temp directory to force video extraction.
        [NSFileManager.defaultManager removeItemAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"PSPDFKit"] error:NULL];
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
            NSArray *lines = @[@[BOXED(CGPointMake(100, 100)), BOXED(CGPointMake(100, 200)), BOXED(CGPointMake(150, 300))], // first line
                               @[BOXED(CGPointMake(200, 100)), BOXED(CGPointMake(200, 200)), BOXED(CGPointMake(250, 300))]  // second line
                               ];

            // convert view line points into PDF line points.
            PSPDFPageInfo *pageInfo = [document pageInfoForPage:targetPage];
            CGRect viewRect = [UIScreen mainScreen].bounds; // this is your drawing view rect - we don't have one yet, so lets just assume the whole screen for this example. You can also directly write the points in PDF coordinate space, then you don't need to convert, but usually your user draws and you need to convert the points afterwards.
            annotation.lineWidth = 5;
            annotation.lines = PSPDFConvertViewLinesToPDFLines(lines, pageInfo.rect, pageInfo.rotation, viewRect);

            annotation.color = [UIColor colorWithRed:0.667f green:0.279f blue:0.748f alpha:1.f];
            annotation.page = targetPage;
            [document addAnnotations:@[annotation]];
        }

        //Here we should figure out which pages have annotations
        NSDictionary *annotationsDictionary = [document allAnnotationsOfType:PSPDFAnnotationTypeInk];
        NSArray *annotatedPages = annotationsDictionary.allKeys;
        NSIndexSet *pageNumbers = annotatedPages.psc_indexSet;
        NSDictionary *processorOptions = @{PSPDFProcessorAnnotationAsDictionary : @YES, PSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeAll)};

        NSURL *outputFileURL = document.fileURL;
        [PSPDFProcessor.defaultProcessor generatePDFFromDocument:document pageRanges:@[pageNumbers] outputFileURL:outputFileURL options:processorOptions progressBlock:NULL error:NULL];

        [document clearCache];

        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        return controller;
    }]];

    // Test that buttons are correctly displayed.
    [testSection addContent:[PSContent contentWithTitle:@"Widget annotation test" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Testcase_WidgetAnnotations.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 4;
        return pdfController;
    }]];

    // Test that the green shape is properly displayed in Adobe Acrobat for iOS.
    [testSection addContent:[PSContent contentWithTitle:@"Shape annotation AP test" block:^UIViewController *{
        // Copy file from the bundle to a location where we can write on it.
        NSURL *newURL = PSCCopyFileURLToDocumentFolderAndOverride([samplesURL URLByAppendingPathComponent:kHackerMagazineExample], NO);
        PSPDFDocument *document = [PSPDFDocument documentWithURL:newURL];
        // Add the annotation
        PSPDFSquareAnnotation *annotation = [PSPDFSquareAnnotation new];
        annotation.boundingBox = CGRectInset([document pageInfoForPage:0].rotatedRect, 100.f, 100.f);
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

    // Check that GIFs are animated.
    [testSection addContent:[PSContent contentWithTitle:@"Test animated GIFs + Links" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"animatedgif.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Add note annotation via toolbar, close toolbar, ensure that the PDF was saved correctly, then test if the annotation still can be moved. If annotations haven't been correctly reloaded after saving the move will fail.
    [testSection addContent:[PSContent contentWithTitle:@"Test annotation updating after a save" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
		pdfController.annotationButtonItem.flexibleAnnotationToolbar.saveAfterToolbarHiding = YES;
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

    [testSection addContent:[PSContent contentWithTitle:@"Test rotated documents" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithBaseURL:samplesURL files:@[@"Testcase_rotated-northern.pdf", @"test1.pdf", @"test2.pdf", @"test3.pdf", @"test4.pdf", @"test5.pdf", @"Testcase_AllPageRotations.pdf"]];
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
            annotation.rects = PSPDFRectsFromGlyphs(word.glyphs, [document pageInfoForPage:0].rotationTransform, &boundingBox);
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
            annotation.rects = PSPDFRectsFromGlyphs(word.glyphs, [document pageInfoForPage:0].rotationTransform, &boundingBox);
            annotation.boundingBox = boundingBox;
            [document addAnnotations:@[annotation]];
            [document saveAnnotationsWithError:NULL];
        }
        // NSLog(@"annots: %@", [document allAnnotationsOfType:PSPDFAnnotationTypeHighlight]);

        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

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
        [PSPDFProcessor.defaultProcessor generatePDFFromDocument:document pageRanges:@[[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)]] outputFileURL:tempURL options:@{PSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeAll)} progressBlock:NULL error:NULL];

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
        [PSPDFProcessor.defaultProcessor generatePDFFromDocument:document pageRanges:@[[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)]] outputFileURL:tempURL options:@{PSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeAll)} progressBlock:NULL error:NULL];

        // show file
        PSPDFDocument *newDocument = [PSPDFDocument documentWithURL:tempURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:newDocument];
        return pdfController;
    }]];

    // Check that annotations are there, links work.
    [testSection addContent:[PSContent contentWithTitle:@"Test PDF generation + annotation adding 1" block:^UIViewController *{
        NSURL *tempURL = PSCTempFileURLWithPathExtension(@"annotationtest", @"pdf");
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        [PSPDFProcessor.defaultProcessor generatePDFFromDocument:document pageRanges:@[[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)]] outputFileURL:tempURL options:@{PSPDFProcessorAnnotationAsDictionary : @YES, PSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeAll)} progressBlock:NULL error:NULL];

        // show file
        PSPDFDocument *newDocument = [PSPDFDocument documentWithURL:tempURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:newDocument];
        return pdfController;
    }]];

    // Check that annotations are there.
    [testSection addContent:[PSContent contentWithTitle:@"Test PDF generation + annotation adding 2" block:^UIViewController *{
        NSURL *tempURL = PSCTempFileURLWithPathExtension(@"annotationtest", @"pdf");
        PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"stamps2.pdf"]];
        [PSPDFProcessor.defaultProcessor generatePDFFromDocument:document pageRanges:@[[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)]] outputFileURL:tempURL options:@{PSPDFProcessorAnnotationAsDictionary : @YES, PSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeAll)} progressBlock:NULL error:NULL];

        // show file
        PSPDFDocument *newDocument = [PSPDFDocument documentWithURL:tempURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:newDocument];
        return pdfController;
    }]];

    [testSection addContent:[PSContent contentWithTitle:@"PSPDFProcessor PPTX (Microsoft Office) conversion" block:^UIViewController *{
        NSURL *URL = [NSURL fileURLWithPath:@"/Users/steipete/Documents/Projects/PSPDFKit_meta/converts/Neu_03_VZ3_Introduction.pptx"];
        NSURL *outputURL = PSCTempFileURLWithPathExtension(@"converted", @"pdf");

        PSPDFStatusHUDItem *status = [PSPDFStatusHUDItem indeterminateProgressWithText:@"Converting..."];
        [status setHUDStyle:PSPDFStatusHUDStyleGradient];
        [status pushAnimated:YES];

        [PSPDFProcessor.defaultProcessor generatePDFFromURL:URL outputFileURL:outputURL options:nil completionBlock:^(NSURL *fileURL, NSError *error) {
            if (error) {
                [status popAnimated:YES];
                [[[UIAlertView alloc] initWithTitle:@"Conversion failed" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            }else {
                PSPDFStatusHUDItem *statusDone = [PSPDFStatusHUDItem successWithText:@"Done"];
                [statusDone setHUDStyle:PSPDFStatusHUDStyleGradient];
                [statusDone pushAndPopWithDelay:2.0f animated:YES];

                // generate document and show it
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
        [PSPDFProcessor.defaultProcessor generatePDFFromDocument:document pageRanges:@[[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)]] outputFileURL:tempURL options:nil progressBlock:NULL error:NULL];
        PSPDFDocument *mergedDocument = [PSPDFDocument documentWithURL:tempURL];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:mergedDocument];
        return controller;
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

    PSCSectionDescriptor *delegateSection = [PSCSectionDescriptor sectionWithTitle:@"Delegate" footer:!PSCIsIPad() ? PSPDFKit.sharedInstance.version : @""];
    [delegateSection addContent:[PSContent contentWithTitle:@"Custom drawing" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
        document.title = @"Custom drawing";
        PSPDFViewController *pdfController = [[PSCCustomDrawingViewController alloc] initWithDocument:document];
        return pdfController;
    }]];
    [sections addObject:delegateSection];
    ///////////////////////////////////////////////////////////////////////////////////////////

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

    [self createTableContent];
    [self addDebugButtons];

    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.bounds.size.width, 44.f)];
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.tableView.tableHeaderView = _searchBar;

    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDisplayController.delegate = self;
    _searchDisplayController.searchResultsDataSource = self;
    _searchDisplayController.searchResultsDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Restore state as it was before.
	if (!self.searchDisplayController.active) {
		// If returning from a modal view controller while the search controller is active, this would cause
		// the navigation bar to completely obscure the search bar.
		[self.navigationController setNavigationBarHidden:NO animated:animated];
	}
    self.navigationController.navigationBar.barTintColor = UIColor.pspdfColor;
    self.navigationController.toolbar.barTintColor = UIColor.pspdfColor;
    self.navigationController.view.tintColor = UIColor.whiteColor;
    // By default the system would show a white cursor.
    [[UITextField appearance] setTintColor:UIColor.pspdfColor];
    [[UITextView  appearance] setTintColor:UIColor.pspdfColor];
    [[UISearchBar appearance] setTintColor:UIColor.pspdfColor];
    [[UINavigationBar appearanceWhenContainedIn:QLPreviewController.class, nil] setTintColor:UIColor.pspdfColor];
	// We need to style the section index, otherwise we can end up with white text on a white-ish background.
	[[UITableView appearance] setSectionIndexColor:UIColor.pspdfColor];
	[[UITableView appearance] setSectionIndexBackgroundColor:UIColor.clearColor];

    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : UIColor.whiteColor};

    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PSCCellIdentifier];
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
    cell.detailTextLabel.text = contentDescriptor.contentDescription;
    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Invoking [NSIndexPath indexPathForRow:%tu inSection:%tu]", indexPath.row, indexPath.section);

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

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    // HACK: Using UISearchBarStyleMinimal produces a black bar on iPhone.
    self.searchBar.searchBarStyle = UISearchBarStyleDefault;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
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
