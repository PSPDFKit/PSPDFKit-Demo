//
//  PSCatalogViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSCatalogViewController.h"
#import "PSCSectionDescriptor.h"
#import "PSCGridController.h"
#import "PSCTabbedExampleViewController.h"
#import "PSCDocumentSelectorController.h"
#import "PSCEmbeddedTestController.h"
#import "PSCustomToolbarController.h"
#import "PSCAnnotationTestController.h"
#import "PSCSplitDocumentSelectorController.h"
#import "PSCSplitPDFViewController.h"
#import "PSCBookmarkParser.h"
#import "PSCSettingsBarButtonItem.h"
#import "PSCKioskPDFViewController.h"
#import "PSCEmbeddedAnnotationTestViewController.h"
#import "PSCustomTextSelectionMenuController.h"
#import "PSCExampleAnnotationViewController.h"
#import "PSCCustomDrawingViewController.h"
#import "PSCBookViewController.h"
#import "PSCAutoScrollViewController.h"
#import "PSCPlayButtonItem.h"
#import "PSCGoToPageButtonItem.h"
#import "PSCCustomLinkAnnotationView.h"
#import "PSCChildViewController.h"
#import "PSCButtonPDFViewController.h"
#import "PSCCustomAnnotationProvider.h"
#import "PSCBottomToolbarViewController.h"
#import "PSCCustomBookmarkBarButtonItem.h"
#import "PSCTimingTestViewController.h"
#import "PSCRotatablePDFViewController.h"
#import "PSCSettingsController.h"
#import "PSCAppDelegate.h"
#import <objc/runtime.h>

#if !__has_feature(objc_arc)
#error "Compile this file with ARC"
#endif

// set to auto-choose a section; debugging aid.
//#define kPSPDFAutoSelectCellNumber [NSIndexPath indexPathForRow:0 inSection:0]
//#define kPSPDFAutoSelectCellNumber [NSIndexPath indexPathForRow:6 inSection:6]
//#define kDebugTextBlocks

@interface PSCatalogViewController () <PSPDFViewControllerDelegate, PSPDFDocumentDelegate, PSCDocumentSelectorControllerDelegate, UITextFieldDelegate> {
    BOOL _firstShown;
    BOOL _clearCacheNeeded;
    NSArray *_content;
}
@end

const char kPSCShowDocumentSelectorOpenInTabbedControllerKey;
const char kPSCAlertViewKey;

@implementation PSCatalogViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithStyle:style])) {
        self.title = PSPDFLocalize(@"PSPDFKit Catalog");
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Catalog" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self createTableContent];
    }
    return self;
}

- (void)createTableContent {
    // common paths
    NSURL *samplesURL = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"Samples"];
    NSURL *hackerMagURL = [samplesURL URLByAppendingPathComponent:kHackerMagazineExample];

    NSMutableArray *content = [NSMutableArray array];

    // Full Apps
    PSCSectionDescriptor *appSection = [[PSCSectionDescriptor alloc] initWithTitle:@"Full Example Apps" footer:@"Can be used as a template for your own apps."];

    [appSection addContent:[[PSContent alloc] initWithTitle:@"PSPDFViewController playground" block:^{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        //PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"About CLA.pdf"]];
        PSPDFViewController *controller = [[PSCKioskPDFViewController alloc] initWithDocument:document];
        controller.statusBarStyleSetting = PSPDFStatusBarDefault;
        return controller;
    }]];

    [appSection addContent:[[PSContent alloc] initWithTitle:@"PSPDFKit Kiosk" class:[PSCGridController class]]];

    [appSection addContent:[[PSContent alloc] initWithTitle:@"Tabbed Browser" block:^{
        if (PSIsIpad()) {
            return (UIViewController *)[PSCTabbedExampleViewController new];
        }else {
            // on iPhone, we do things a bit different, and push/pull the controller.
            PSCDocumentSelectorController *documentSelector = [[PSCDocumentSelectorController alloc] initWithDirectory:@"/Bundle/Samples" delegate:self];
            objc_setAssociatedObject(documentSelector, &kPSCShowDocumentSelectorOpenInTabbedControllerKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            return (UIViewController *)documentSelector;
        }
    }]];

    [appSection addContent:[[PSContent alloc] initWithTitle:@"Open In... Inbox" block:^{
        PSCDocumentSelectorController *documentSelector = [[PSCDocumentSelectorController alloc] initWithDirectory:@"Inbox" delegate:self];
        documentSelector.fullTextSearchEnabled = YES;
        return documentSelector;
    }]];

    PSPDFDocument *hackerMagDoc = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
    hackerMagDoc.UID = @"HACKERMAGDOC"; // set custom UID so it doesn't interfear with other examples

    /*
     // pre-cache whole document
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [[PSPDFCache sharedCache] cacheDocument:hackerMagDoc startAtPage:0 size:PSPDFSizeNative];
    });*/

    [appSection addContent:[[PSContent alloc] initWithTitle:@"Settings for a magazine" block:^{
        hackerMagDoc.title = @"HACKER MONTHLY Issue 12";
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:hackerMagDoc];
        controller.pageTransition = PSPDFPageCurlTransition;
        controller.pageMode = PSPDFPageModeAutomatic;
        
        // don't use thumbnails if the PDF is not rendered.
        // FullPageBlocking feels good when combined with pageCurl, less great with other scroll modes, especially PSPDFPageScrollContinuousTransition.
        controller.renderingMode = PSPDFPageRenderingModeFullPageBlocking;

        // setup toolbar
        controller.rightBarButtonItems = PSIsIpad() ? @[controller.brightnessButtonItem, controller.activityButtonItem, controller.searchButtonItem, controller.outlineButtonItem, controller.bookmarkButtonItem] : @[controller.activityButtonItem, controller.searchButtonItem, controller.outlineButtonItem, controller.bookmarkButtonItem];

        // show the thumbnail button on the HUD, but not on the toolbar (we're not adding viewModeButtonItem here)
        controller.documentLabel.labelStyle = PSPDFLabelStyleBordered;
        controller.pageLabel.labelStyle = PSPDFLabelStyleBordered;
        controller.pageLabel.showThumbnailGridButton = YES;
        return controller;
    }]];

    [appSection addContent:[[PSContent alloc] initWithTitle:@"Settings for a scientific paper" block:^{
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:[PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kPaperExampleFileName]]];
        // brighteness button is not yet optimized for iPhone
        controller.rightBarButtonItems = PSIsIpad() ? @[controller.annotationButtonItem, controller.brightnessButtonItem, controller.searchButtonItem, controller.viewModeButtonItem] : @[controller.annotationButtonItem, controller.searchButtonItem, controller.viewModeButtonItem];
        PSCGoToPageButtonItem *goToPageButton = [[PSCGoToPageButtonItem alloc] initWithPDFViewController:controller];
        controller.additionalBarButtonItems = @[controller.printButtonItem, controller.emailButtonItem, goToPageButton];
        controller.pageTransition = PSPDFPageScrollContinuousTransition;
        controller.scrollDirection = PSPDFScrollDirectionVertical;
        controller.fitToWidthEnabled = YES;
        controller.pagePadding = 5.f;
        controller.renderAnimationEnabled = NO;
        controller.statusBarStyleSetting = PSPDFStatusBarDefault;
        return controller;
    }]];

    [content addObject:appSection];
    ///////////////////////////////////////////////////////////////////////////////////////////


    // PSPDFDocument data provider test
    PSCSectionDescriptor *documentTests = [[PSCSectionDescriptor alloc] initWithTitle:@"PSPDFDocument data providers" footer:@"PSPDFDocument is highly flexible."];

    /// PSPDFDocument works with a NSURL
    [documentTests addContent:[[PSContent alloc] initWithTitle:@"NSURL" block:^{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        controller.rightBarButtonItems = @[controller.emailButtonItem, controller.searchButtonItem, controller.outlineButtonItem, controller.viewModeButtonItem];
        return controller;
    }]];

    /// A NSData (both memory-mapped and full)
    [documentTests addContent:[[PSContent alloc] initWithTitle:@"NSData" block:^{
        NSData *data = [NSData dataWithContentsOfMappedFile:[hackerMagURL path]];
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithData:data];
        document.title = @"NSData PDF";
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        controller.rightBarButtonItems = @[controller.emailButtonItem, controller.searchButtonItem, controller.outlineButtonItem, controller.viewModeButtonItem];
        return controller;
    }]];

    /// And even a CGDocumentProvider (can be used for encryption)
    [documentTests addContent:[[PSContent alloc] initWithTitle:@"CGDocumentProvider" block:^{
        NSData *data = [NSData dataWithContentsOfURL:hackerMagURL options:NSDataReadingMappedIfSafe error:NULL];
        CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)(data));
//        CGDataProviderRef dataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)([samplesURL URLByAppendingPathComponent:@"corrupted.pdf"]));
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithDataProvider:dataProvider];
        document.title = @"CGDataProviderRef PDF";
        CGDataProviderRelease(dataProvider);
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        controller.rightBarButtonItems = @[controller.emailButtonItem, controller.searchButtonItem, controller.outlineButtonItem, controller.viewModeButtonItem];
        return controller;
    }]];

    /// PSPDFDocument works with multiple NSURLs
    [documentTests addContent:[[PSContent alloc] initWithTitle:@"Multiple files" block:^{
        NSArray *files = @[@"A.pdf", @"B.pdf", @"C.pdf", @"D.pdf"];
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithBaseURL:samplesURL files:files];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        controller.rightBarButtonItems = @[controller.searchButtonItem, controller.viewModeButtonItem];
        controller.additionalBarButtonItems = @[controller.openInButtonItem, controller.emailButtonItem];
        return controller;
    }]];

    [documentTests addContent:[[PSContent alloc] initWithTitle:@"Multiple NSData objects (memory mapped)" block:^{
        static PSPDFDocument *document = nil;
        if (!document) {
            NSURL *file1 = [samplesURL URLByAppendingPathComponent:@"A.pdf"];
            NSURL *file2 = [samplesURL URLByAppendingPathComponent:@"B.pdf"];
            NSURL *file3 = [samplesURL URLByAppendingPathComponent:@"C.pdf"];
            NSData *data1 = [NSData dataWithContentsOfURL:file1 options:NSDataReadingMappedIfSafe error:NULL];
            NSData *data2 = [NSData dataWithContentsOfURL:file2 options:NSDataReadingMappedIfSafe error:NULL];
            NSData *data3 = [NSData dataWithContentsOfURL:file3 options:NSDataReadingMappedIfSafe error:NULL];
            document = [PSPDFDocument PDFDocumentWithDataArray:@[data1, data2, data3]];
        }else {
            // this is not needed, just an example how to use the changed dataArray (the data will be changed when annotations are written back)
            document = [PSPDFDocument PDFDocumentWithDataArray:document.dataArray];
        }

        // make sure your NSData objects are either small or memory mapped; else you're getting into memory troubles.
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        controller.rightBarButtonItems = @[controller.annotationButtonItem, controller.searchButtonItem, controller.viewModeButtonItem];
        controller.additionalBarButtonItems = @[controller.openInButtonItem, controller.emailButtonItem];
        return controller;
    }]];

    [documentTests addContent:[[PSContent alloc] initWithTitle:@"Multiple NSData objects" block:^{
        // make data document static in this example, so that the annotations will be saved (the NSData array will get changed)
        static PSPDFDocument *document = nil;
        if (!document) {
            NSURL *file1 = [samplesURL URLByAppendingPathComponent:@"A.pdf"];
            NSURL *file2 = [samplesURL URLByAppendingPathComponent:@"B.pdf"];
            NSURL *file3 = [samplesURL URLByAppendingPathComponent:@"C.pdf"];
            NSData *data1 = [NSData dataWithContentsOfURL:file1];
            NSData *data2 = [NSData dataWithContentsOfURL:file2];
            NSData *data3 = [NSData dataWithContentsOfURL:file3];
            document = [PSPDFDocument PDFDocumentWithDataArray:@[data1, data2, data3]];
        }

        // make sure your NSData objects are either small or memory mapped; else you're getting into memory troubles.
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        controller.rightBarButtonItems = @[controller.annotationButtonItem, controller.searchButtonItem, controller.viewModeButtonItem];
        controller.additionalBarButtonItems = @[controller.openInButtonItem, controller.emailButtonItem];
        return controller;
    }]];

    [documentTests addContent:[[PSContent alloc] initWithTitle:@"Multiple NSData objects (merged)" block:^{
            NSArray *fileNames = @[@"A.pdf", @"B.pdf", @"C.pdf"];
            //NSArray *fileNames = @[@"Test6.pdf", @"Test5.pdf", @"Test4.pdf", @"Test1.pdf", @"Test2.pdf", @"Test3.pdf", @"rotated-northern.pdf", @"A.pdf", @"rotated360degrees.pdf", @"Rotated PDF.pdf"];
            NSMutableArray *dataArray = [NSMutableArray array];
            for (NSString *fileName in fileNames) {
                NSURL *file = [samplesURL URLByAppendingPathComponent:fileName];
                NSData *data = [NSData dataWithContentsOfURL:file];
                [dataArray addObject:data];
            }
            PSPDFDocument *document = [PSPDFDocument PDFDocumentWithDataArray:dataArray];

        // Here we combine the NSData pieces in the PSPDFDocument into one piece of NSData (for sharing)
        NSDictionary * options = @{kPSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeNone & ~PSPDFAnnotationTypeLink)};
        NSData *consolidatedData = [[PSPDFProcessor defaultProcessor] generatePDFFromDocument:document pageRange:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [document pageCount])] options:options];
        PSPDFDocument *documentWithConsolidatedData = [PSPDFDocument PDFDocumentWithData:consolidatedData];

        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:documentWithConsolidatedData];
        controller.rightBarButtonItems = @[controller.annotationButtonItem, controller.searchButtonItem, controller.viewModeButtonItem];
        controller.additionalBarButtonItems = @[controller.openInButtonItem, controller.emailButtonItem];
        return controller;
    }]];

    /// Example how to decrypt a AES256 encrypted PDF on the fly.
    /// The crypto feature is only available in PSPDFKit Annotate.
    if ([PSPDFAESCryptoDataProvider isAESCryptoFeatureAvailable]) {
        [documentTests addContent:[[PSContent alloc] initWithTitle:@"Encrypted CGDocumentProvider" block:^{

            NSURL *encryptedPDF = [samplesURL URLByAppendingPathComponent:@"aes-encrypted.pdf.aes"];

            // Note: For shipping apps, you need to protect this string better, making it harder for hacker to simply disassemble and receive the key from the binary. Or add an internet service that fetches the key from an SSL-API. But then there's still the slight risk of memory dumping with an attached gdb. Or screenshots. Security is never 100% perfect; but using AES makes it way harder to get the PDF. You can even combine AES and a PDF password.
            NSString *passphrase = @"afghadöghdgdhfgöhapvuenröaoeruhföaeiruaerub";
            NSString *salt = @"ducrXn9WaRdpaBfMjDTJVjUf3FApA6gtim0e61LeSGWV9sTxB0r26mPs59Lbcexn";

            PSPDFAESCryptoDataProvider *cryptoWrapper = [[PSPDFAESCryptoDataProvider alloc] initWithURL:encryptedPDF passphrase:passphrase salt:salt];

            PSPDFDocument *document = [PSPDFDocument PDFDocumentWithDataProvider:cryptoWrapper.dataProvider];
            document.UID = [encryptedPDF lastPathComponent]; // manually set an UID for encrypted documents.

            // When PSPDFAESCryptoDataProvider is used, the cacheStrategy of PSPDFDocument is *automatically* set to PSPDFCacheNothing.
            // If you use your custom crypto solution, don't forget to set this to not leak out encrypted data as cached images.
            // document.cacheStrategy = PSPDFCacheNothing;

            return [[PSPDFViewController alloc] initWithDocument:document];
        }]];
    }

    [content addObject:documentTests];
    ///////////////////////////////////////////////////////////////////////////////////////////

    PSCSectionDescriptor *multimediaSection = [[PSCSectionDescriptor alloc] initWithTitle:@"Multimedia extensions" footer:@"You can integrate videos, audio, images and HTML5 content/websites as parts of a PDF page. See http://pspdfkit.com/documentation.html#multimedia for details."];

    [multimediaSection addContent:[[PSContent alloc] initWithTitle:@"Multimedia PDF example" block:^{
        PSPDFDocument *multimediaDoc = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"multimedia.pdf"]];
        return [[PSPDFViewController alloc] initWithDocument:multimediaDoc];
    }]];

    [multimediaSection addContent:[[PSContent alloc] initWithTitle:@"Dynamically added video example" block:^{
        PSPDFDocument *multimediaDoc = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];

        // dynamically add video box
        PSPDFLinkAnnotation *aVideo = [[PSPDFLinkAnnotation alloc] initWithSiteLinkTarget:@"pspdfkit://[autostart:false]localhost/Bundle/big_buck_bunny.mp4"];
        aVideo.boundingBox = [multimediaDoc pageInfoForPage:1].rotatedPageRect;
        [multimediaDoc addAnnotations:@[aVideo] forPage:1];

        return [[PSPDFViewController alloc] initWithDocument:multimediaDoc];
    }]];
    [content addObject:multimediaSection];

    PSCSectionDescriptor *annotationSection = [[PSCSectionDescriptor alloc] initWithTitle:@"Annotation Tests" footer:@"PSPDFKit supports all common PDF annotations, including Highlighing, Underscore, Strikeout, Comment and Ink."];

    [annotationSection addContent:[[PSContent alloc] initWithTitle:@"Test PDF annotation writing" block:^{
        //NSURL *annotationSavingURL = [samplesURL URLByAppendingPathComponent:@"weirdannots.pdf"];
        NSURL *annotationSavingURL = [samplesURL URLByAppendingPathComponent:kHackerMagazineExample];

        // copy file from the bundle to a location where we can write on it.
        NSString *docsFolder = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *newPath = [docsFolder stringByAppendingPathComponent:[annotationSavingURL lastPathComponent]];
        NSError *error;
        if(![[NSFileManager defaultManager] fileExistsAtPath:newPath] &&
           ![[NSFileManager defaultManager] copyItemAtPath:[annotationSavingURL path] toPath:newPath error:&error]) {
            NSLog(@"Error while copying %@: %@", [annotationSavingURL path], error);
        }
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[NSURL fileURLWithPath:newPath]];
        document.delegate = self;
        return [[PSCEmbeddedAnnotationTestViewController alloc] initWithDocument:document];
    }]];

    [annotationSection addContent:[[PSContent alloc] initWithTitle:@"Add custom image annotation" block:^{
        PSPDFDocument *hackerDocument = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        return [[PSCAnnotationTestController alloc] initWithDocument:hackerDocument];
    }]];

    [annotationSection addContent:[[PSContent alloc] initWithTitle:@"Custom annotations with multiple files" block:^{
        NSArray *files = @[@"A.pdf", @"B.pdf", @"C.pdf", @"D.pdf"];
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithBaseURL:samplesURL files:files];

        // We're lazy here. 2 = UIViewContentModeScaleAspectFill
        PSPDFLinkAnnotation *aVideo = [[PSPDFLinkAnnotation alloc] initWithSiteLinkTarget:@"pspdfkit://[contentMode=2]localhost/Bundle/big_buck_bunny.mp4"];
        aVideo.boundingBox = [document pageInfoForPage:5].rotatedPageRect;
        [document addAnnotations:@[aVideo ] forPage:5];

        PSPDFLinkAnnotation *anImage = [[PSPDFLinkAnnotation alloc] initWithSiteLinkTarget:@"pspdfkit://[contentMode=2]localhost/Bundle/exampleImage.jpg"];
        anImage.boundingBox = [document pageInfoForPage:2].rotatedPageRect;
        [document addAnnotations:@[anImage] forPage:2];

        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        return controller;
    }]];

    [annotationSection addContent:[[PSContent alloc] initWithTitle:@"Programmatically create annotations" block:^{
        // we use a NSData document here but it'll work even better with a file-based variant.
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithData:[NSData dataWithContentsOfURL:hackerMagURL options:NSDataReadingMappedIfSafe error:NULL]];
        document.title = @"Programmatically create annotations";

        NSMutableArray *annotations = [NSMutableArray array];
        CGFloat maxHeight = [document pageInfoForPage:0].rotatedPageRect.size.height;
        for (int i=0; i<5; i++) {
            PSPDFNoteAnnotation *noteAnnotation = [PSPDFNoteAnnotation new];
            // width/height will be ignored for note annotations.
            noteAnnotation.boundingBox = (CGRect){CGPointMake(100, 50 + i*maxHeight/5), kPSPDFNoteAnnotationViewFixedSize};
            noteAnnotation.contents = [NSString stringWithFormat:@"Note %d", 5-i]; // notes are added bottom-up
            [annotations addObject:noteAnnotation];
        }
        [document addAnnotations:annotations forPage:0];

        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        return controller;
    }]];

    [annotationSection addContent:[[PSContent alloc] initWithTitle:@"Annotation Links to external documents" block:^{
        PSPDFDocument *linkDocument = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"one.pdf"]];
        return [[PSPDFViewController alloc] initWithDocument:linkDocument];
    }]];

    [content addObject:annotationSection];
    ///////////////////////////////////////////////////////////////////////////////////////////

    
    PSCSectionDescriptor *storyboardSection = [[PSCSectionDescriptor alloc] initWithTitle:@"Storyboards" footer:@""];
    [storyboardSection addContent:[[PSContent alloc] initWithTitle:@"Init with Storyboard" block:^UIViewController *{
        UIViewController *controller = nil;
        @try {
            // will throw an exception if the file MainStoryboard.storyboard is missing
            controller = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateInitialViewController];
        }
        @catch (NSException *exception) {
            [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"You need to manually add the file MainStoryboard.storyboard." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
        return controller;
    }]];
    [content addObject:storyboardSection];
    ///////////////////////////////////////////////////////////////////////////////////////////

    PSCSectionDescriptor *textExtractionSection = [[PSCSectionDescriptor alloc] initWithTitle:@"Text Extraction / PDF creation" footer:@""];
    [textExtractionSection addContent:[[PSContent alloc] initWithTitle:@"Full-Text Search" block:^UIViewController *{
        PSCDocumentSelectorController *documentSelector = [[PSCDocumentSelectorController alloc] initWithDirectory:@"/Bundle/Samples" delegate:self];
        documentSelector.fullTextSearchEnabled = YES;
        return documentSelector;
    }]];

    [textExtractionSection addContent:[[PSContent alloc] initWithTitle:@"Convert markup string to PDF" block:^UIViewController *{

        PSPDFAlertView *websitePrompt = [[PSPDFAlertView alloc] initWithTitle:@"Markup String" message:@"Experimental feature. Basic HTML is allowed."];
        websitePrompt.alertViewStyle = UIAlertViewStylePlainTextInput;
        [[websitePrompt textFieldAtIndex:0] setText:@"<br><br><br><h1>This is a <i>test</i> in <span style='color:red'>color.</span></h1>"];

        [websitePrompt setCancelButtonWithTitle:@"Cancel" block:nil];
        [websitePrompt addButtonWithTitle:@"Convert" block:^{
            // get data
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
            NSString *html = [websitePrompt textFieldAtIndex:0].text ?: @"";
#pragma clang diagnostic pop
            NSURL *outputURL = PSPDFTempFileURLWithPathExtension(@"converted", @"pdf");

            // create pdf (blocking)
            [[PSPDFProcessor defaultProcessor] generatePDFFromHTMLString:html outputFileURL:outputURL options:@{kPSPDFProcessorNumberOfPages : @(1), kPSPDFProcessorDocumentTitle : @"Generated PDF"}];

            // generate document and show it
            PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:outputURL];
            PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
            [self.navigationController pushViewController:pdfController animated:YES];
        }];
        [websitePrompt show];
        return nil;
    }]];

    // Experimental feature
    [textExtractionSection addContent:[[PSContent alloc] initWithTitle:@"Convert Website/Files to PDF" block:^UIViewController *{

        PSPDFAlertView *websitePrompt = [[PSPDFAlertView alloc] initWithTitle:@"Website/File URL" message:@"Convert websites or files to PDF (Word, Pages, Keynote, ...)"];
        websitePrompt.alertViewStyle = UIAlertViewStylePlainTextInput;
        [[websitePrompt textFieldAtIndex:0] setText:@"http://apple.com/iphone"];

        [websitePrompt setCancelButtonWithTitle:@"Cancel" block:nil];
        [websitePrompt addButtonWithTitle:@"Convert" block:^{
            // get URL
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
            NSString *website = [websitePrompt textFieldAtIndex:0].text ?: @"";
#pragma clang diagnostic pop
            if (![website hasPrefix:@"http"]) website = [NSString stringWithFormat:@"http://%@", website];
            NSURL *URL = [NSURL URLWithString:website];
            NSURL *outputURL = PSPDFTempFileURLWithPathExtension(@"converted", @"pdf");
            //URL = [NSURL fileURLWithPath:PSPDFResolvePathNames(@"/Bundle/Samples/test2.key", nil)];

            // start the conversion
            [PSPDFProgressHUD showWithStatus:@"Converting..." maskType:PSPDFProgressHUDMaskTypeGradient];
            [[PSPDFProcessor defaultProcessor] generatePDFFromURL:URL outputFileURL:outputURL options:nil completionBlock:^(NSURL *fileURL, NSError *error) {
                if (error) {
                    [PSPDFProgressHUD dismiss];
                    [[[UIAlertView alloc] initWithTitle:@"Conversion failed" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                }else {
                    // generate document and show it
                    [PSPDFProgressHUD showSuccessWithStatus:@"Finished"];
                    PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:fileURL];
                    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
                    [self.navigationController pushViewController:pdfController animated:YES];
                }
            }];
        }];
        [[websitePrompt textFieldAtIndex:0] setDelegate:self]; // enable return key
        objc_setAssociatedObject([websitePrompt textFieldAtIndex:0], &kPSCAlertViewKey, websitePrompt, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [websitePrompt show];
        return nil;
    }]];
    [content addObject:textExtractionSection];
    ///////////////////////////////////////////////////////////////////////////////////////////

    // PSPDFViewController customization examples
    PSCSectionDescriptor *customizationSection = [[PSCSectionDescriptor alloc] initWithTitle:@"PSPDFViewController customization" footer:@""];

    [customizationSection addContent:[[PSContent alloc] initWithTitle:@"PageCurl example" block:^{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.pageMode = PSPDFPageModeSingle;
        pdfController.pageTransition = PSPDFPageCurlTransition;
        return pdfController;
    }]];

    [customizationSection addContent:[[PSContent alloc] initWithTitle:@"Using a NIB" block:^{
        return [[PSCEmbeddedTestController alloc] initWithNibName:@"EmbeddedNib" bundle:nil];
    }]];

    // one way to speed up PSPDFViewController display is calling fillCache on the document.
    /*
    PSPDFDocument *childDocument = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [childDocument fillCache];
    });
     */
    [customizationSection addContent:[[PSContent alloc] initWithTitle:@"Child View Controller containment" block:^{
        NSURL *testURL = [samplesURL URLByAppendingPathComponent:kHackerMagazineExample];
        PSPDFDocument *childDocument = [PSPDFDocument PDFDocumentWithURL:testURL];
        return [[PSCChildViewController alloc] initWithDocument:childDocument];
    }]];

    [customizationSection addContent:[[PSContent alloc] initWithTitle:@"Adding a simple UIButton" block:^{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        return [[PSCButtonPDFViewController alloc] initWithDocument:document];
    }]];

    // Other image replacements work similar.
    [customizationSection addContent:[[PSContent alloc] initWithTitle:@"Custom toolbar icon for bookmark item" block:^{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.title = @"Custom toolbar icon for bookmark item";
        pdfController.overrideClassNames = @{(id)[PSPDFBookmarkBarButtonItem class] : [PSCCustomBookmarkBarButtonItem class]};
        pdfController.bookmarkButtonItem.tapChangesBookmarkStatus = NO;
        pdfController.rightBarButtonItems = @[pdfController.bookmarkButtonItem, pdfController.viewModeButtonItem];
        return pdfController;
    }]];

    [customizationSection addContent:[[PSContent alloc] initWithTitle:@"Completely Custom Toolbar" block:^{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        return [[PSCustomToolbarController alloc] initWithDocument:document];
    }]];

    // this the default recommended way to customize the toolbar
    [customizationSection addContent:[[PSContent alloc] initWithTitle:@"Customized Toolbar" block:^{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.leftBarButtonItems = @[pdfController.closeButtonItem, pdfController.viewModeButtonItem];
        
        pdfController.rightBarButtonItems = @[pdfController.searchButtonItem];
        /*
        pdfController.rightBarButtonItems = @[pdfController.annotationButtonItem, pdfController.searchButtonItem];
        pdfController.additionalBarButtonItems = @[pdfController.emailButtonItem, pdfController.outlineButtonItem, pdfController.bookmarkButtonItem];
         */
        pdfController.tintColor = [UIColor orangeColor];
        pdfController.shouldTintPopovers = YES;
        return pdfController;
    }]];

    [customizationSection addContent:[[PSContent alloc] initWithTitle:@"Use a Bottom Toolbar" block:^{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        // simple subclass that shows/hides the navigationController bottom toolbar
        PSCBottomToolbarViewController *pdfController = [[PSCBottomToolbarViewController alloc] initWithDocument:document];
        pdfController.statusBarStyleSetting = PSPDFStatusBarDefault;
        pdfController.scrobbleBarEnabled = NO; // would look to crowded.
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
        pdfController.bookmarkButtonItem.tapChangesBookmarkStatus = NO;
        pdfController.toolbarItems = @[space, pdfController.bookmarkButtonItem, space, pdfController.annotationButtonItem, space, pdfController.searchButtonItem, space, pdfController.outlineButtonItem, space, pdfController.emailButtonItem, space, pdfController.printButtonItem, space, pdfController.openInButtonItem, space];
        return pdfController;
    }]];

    [customizationSection addContent:[[PSContent alloc] initWithTitle:@"Disable Toolbar" block:^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Will exit in 5 seconds." message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];

        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        self.navigationController.navigationBarHidden = YES;

        // pop back after 5 seconds.
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 5.f * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.navigationController popViewControllerAnimated:YES];
            [alertView dismissWithClickedButtonIndex:1 animated:YES];
        });

        // sample settings
        pdfController.pageTransition = PSPDFPageCurlTransition;
        pdfController.toolbarEnabled = NO;
        pdfController.fitToWidthEnabled = NO;

        return pdfController;
    }]];

    // Text selection feature is only available in PSPDFKit Annotate.
    if ([PSPDFTextSelectionView isTextSelectionFeatureAvailable]) {
        [customizationSection addContent:[[PSContent alloc] initWithTitle:@"Custom Text Selection Menu" block:^{
            PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
            return [[PSCustomTextSelectionMenuController alloc] initWithDocument:document];
        }]];
    }

    [customizationSection addContent:[[PSContent alloc] initWithTitle:@"Custom Background Color" block:^{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.backgroundColor = [UIColor brownColor];
        return pdfController;
    }]];

    [customizationSection addContent:[[PSContent alloc] initWithTitle:@"Night Mode" block:^{
        [[PSPDFCache sharedCache] clearCache];
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        document.renderOptions = @{kPSPDFInvertRendering : @YES};
        document.backgroundColor = [UIColor blackColor];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.backgroundColor = [UIColor blackColor];
        _clearCacheNeeded = YES;
        return pdfController;
    }]];

    // rotation example
    [customizationSection addContent:[[PSContent alloc] initWithTitle:@"Rotate PDF pages" block:^{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        PSPDFViewController *pdfController = [[PSCRotatablePDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [content addObject:customizationSection];
    ///////////////////////////////////////////////////////////////////////////////////////////

    PSCSectionDescriptor *encryptedSection = [[PSCSectionDescriptor alloc] initWithTitle:@"Passwords" footer:@"Password is test123"];

    // Bookmarks
    NSURL *protectedPDFURL = [samplesURL URLByAppendingPathComponent:@"protected.pdf"];

    [encryptedSection addContent:[[PSContent alloc] initWithTitle:@"Password preset" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:protectedPDFURL];
        [document unlockWithPassword:@"test123"];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        return controller;
    }]];

    [encryptedSection addContent:[[PSContent alloc] initWithTitle:@"Password not preset; dialog" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:protectedPDFURL];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        return controller;
    }]];

    [content addObject:encryptedSection];
    ///////////////////////////////////////////////////////////////////////////////////////////

    PSCSectionDescriptor *subclassingSection = [[PSCSectionDescriptor alloc] initWithTitle:@"Subclassing" footer:@"Examples how to subclass PSPDFKit"];

    // Bookmarks
    [subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Capture Bookmarks" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        document.overrideClassNames = @{(id)[PSPDFBookmarkParser class] : [PSCBookmarkParser class]};
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        controller.rightBarButtonItems = @[controller.bookmarkButtonItem, controller.searchButtonItem, controller.outlineButtonItem, controller.viewModeButtonItem];
        return controller;
    }]];

    [subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Change link background color to red" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        controller.overrideClassNames = @{(id)[PSPDFLinkAnnotationView class] : [PSCCustomLinkAnnotationView class]};
        return controller;
    }]];

    [subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Custom AnnotationProvider" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        [document setDidCreateDocumentProviderBlock:^(PSPDFDocumentProvider *documentProvider) {
            documentProvider.annotationParser.annotationProviders = @[[PSCCustomAnnotationProvider new], documentProvider.annotationParser.fileAnnotationProvider];
        }];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        return controller;
    }]];

    [subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Vertical always-visible annotation bar" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        PSPDFViewController *controller = [[PSCExampleAnnotationViewController alloc] initWithDocument:document];
        return controller;
    }]];

    // This example is actually the recommended way. Add this snipped to dynamically enable/disable fittingWidth on the iPhone.
    [subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Dynamic fittingWidth on iPhone" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        [controller setUpdateSettingsForRotationBlock:^(PSPDFViewController *pdfController, UIInterfaceOrientation toInterfaceOrientation) {
            if(!PSIsIpad()) pdfController.fitToWidthEnabled = UIInterfaceOrientationIsLandscape(toInterfaceOrientation);

            // example how to switch between pageTransitions
            //pdfController.pageTransition = UIInterfaceOrientationIsLandscape(toInterfaceOrientation) ? PSPDFPageCurlTransition : PSPDFPageScrollPerPageTransition;
        }];
        return controller;
    }]];

    [subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Book example" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        PSPDFViewController *controller = [[PSCBookViewController alloc] initWithDocument:document];
        return controller;
    }]];

    [subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Teleprompter example" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        PSPDFViewController *controller = [[PSCAutoScrollViewController alloc] initWithDocument:document];
        return controller;
    }]];

    [subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Auto paging example" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        PSCPlayButtonItem *playButton = [[PSCPlayButtonItem alloc] initWithPDFViewController:controller];
        playButton.autoplaying = YES;
        controller.rightBarButtonItems = @[playButton, controller.searchButtonItem, controller.outlineButtonItem, controller.viewModeButtonItem];
        controller.pageTransition = PSPDFPageCurlTransition;
        controller.pageMode = PSPDFPageModeAutomatic;
        return controller;
    }]];

    // Used for stability testing.
    [subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Timing tests" block:^UIViewController *{
        return [[PSCTimingTestViewController alloc] initWithNibName:nil bundle:nil];
    }]];

    [content addObject:subclassingSection];
    ///////////////////////////////////////////////////////////////////////////////////////////


    PSCSectionDescriptor *delegateSection = [[PSCSectionDescriptor alloc] initWithTitle:@"Delegate" footer:!PSIsIpad() ? PSPDFVersionString() : @""];
    [delegateSection addContent:[[PSContent alloc] initWithTitle:@"Custom drawing" block:^UIViewController *{

        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        document.title = @"Custom drawing";
        PSPDFViewController *controller = [[PSCCustomDrawingViewController alloc] initWithDocument:document];
        return controller;
    }]];
    [content addObject:delegateSection];
    ///////////////////////////////////////////////////////////////////////////////////////////


    // iPad only examples
    if (PSIsIpad()) {
        PSCSectionDescriptor *iPadTests = [[PSCSectionDescriptor alloc] initWithTitle:@"iPad only" footer:PSPDFVersionString()];
        [iPadTests addContent:[[PSContent alloc] initWithTitle:@"SplitView" block:^{
            UISplitViewController *splitVC = [[UISplitViewController alloc] init];
            splitVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Split" image:[UIImage imageNamed:@"shoebox"] tag:3];
            PSCSplitDocumentSelectorController *tableVC = [[PSCSplitDocumentSelectorController alloc] init];
            UINavigationController *tableNavVC = [[UINavigationController alloc] initWithRootViewController:tableVC];
            PSCSplitPDFViewController *hostVC = [[PSCSplitPDFViewController alloc] init];
            UINavigationController *hostNavVC = [[UINavigationController alloc] initWithRootViewController:hostVC];
            tableVC.masterVC = hostVC;
            splitVC.delegate = hostVC;
            splitVC.viewControllers = @[tableNavVC, hostNavVC];
            // Splitview controllers can't just be added to a UINavigationController
            self.view.window.rootViewController = splitVC;
            return (UIViewController *)nil;
        }]];
        [content addObject:iPadTests];
    }

    _content = content;

    // debug helper
#ifdef kDebugTextBlocks
    [PSCSettingsController settings][@"showTextBlocks"] = @YES;
#endif
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];

    // clear cache (for night mode)
    if (_clearCacheNeeded) {
        _clearCacheNeeded = NO;
        [[PSPDFCache sharedCache] clearCache];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

#ifdef kPSPDFAutoSelectCellNumber
    if (!_firstShown && kPSPDFAutoSelectCellNumber) {
        BOOL success = NO;
        NSUInteger numberOfSections = [self numberOfSectionsInTableView:self.tableView];
        NSUInteger numberOfRowsInSection = 0;
        if (kPSPDFAutoSelectCellNumber.section < numberOfSections) {
            numberOfRowsInSection = [self tableView:self.tableView numberOfRowsInSection:kPSPDFAutoSelectCellNumber.section];
            if (kPSPDFAutoSelectCellNumber.row < numberOfRowsInSection) {
                [self tableView:self.tableView didSelectRowAtIndexPath:kPSPDFAutoSelectCellNumber];
                success = YES;
            }
        }
        if (!success) {
            NSLog(@"Invalid row/section count: %@ (sections: %d, rows:%d)", kPSPDFAutoSelectCellNumber, numberOfSections, numberOfRowsInSection);
        }
    }
    _firstShown = YES;
#endif

    // cache the keyboard. (optional; makes search much more reactive)
    dispatch_async(dispatch_get_main_queue(), ^{PSPDFCacheKeyboard();});
}

// Support for iOS5. iOS6 does this differently and also correct by default.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return PSIsIpad() ? YES : toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_content count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_content[section] contentDescriptors] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_content[section] title];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [_content[section] footer];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PSCatalogCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    PSContent *contentDescriptor = [_content[indexPath.section] contentDescriptors][indexPath.row];
    cell.textLabel.text = contentDescriptor.title;
    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Invoking [NSIndexPath indexPathForRow:%d inSection:%d]", indexPath.row, indexPath.section);
    PSContent *contentDescriptor = [_content[indexPath.section] contentDescriptors][indexPath.row];
    UIViewController *controller;
    if (contentDescriptor.classToInvoke) {
        controller = [contentDescriptor.classToInvoke new];
    }else {
        controller = contentDescriptor.block();
    }
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
#pragma mark - PSPDFDocumentSelectorControllerDelegate

- (void)documentSelectorController:(PSCDocumentSelectorController *)controller didSelectDocument:(PSPDFDocument *)document {
    BOOL showInGrid = [objc_getAssociatedObject(controller, &kPSCShowDocumentSelectorOpenInTabbedControllerKey) boolValue];

    // add fade transition for navigationBar.
    [controller.navigationController.navigationBar.layer addAnimation:PSPDFFadeTransition() forKey:kCATransition];

    if (showInGrid) {
        // create controller and merge new documents with last saved state.
        PSPDFTabbedViewController *tabbedViewController = [PSCTabbedExampleViewController new];
        [tabbedViewController restoreStateAndMergeWithDocuments:@[document]];
        [controller.navigationController pushViewController:tabbedViewController animated:YES];
    }else {
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        [controller.navigationController pushViewController:pdfController animated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocumentDelegate

- (void)pdfDocument:(PSPDFDocument *)document didSaveAnnotations:(NSArray *)annotations {
    NSLog(@"\n\nSaving of %@ successful: %@", document, annotations);
}

- (void)pdfDocument:(PSPDFDocument *)document failedToSaveAnnotations:(NSArray *)annotations withError:(NSError *)error {
    NSLog(@"\n\n Warning: Saving of %@ failed: %@", document, error);
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITextFieldDelegate

// enable the return key on the alert view
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    UIAlertView *alertView = objc_getAssociatedObject(textField, &kPSCAlertViewKey);
    if (alertView) { [alertView dismissWithClickedButtonIndex:1 animated:YES]; return YES;
    }else return NO;
}

@end

// Fixes a behavior of UIModalPresentationFormSheet
// http://stackoverflow.com/questions/3372333/ipad-keyboard-will-not-dismiss-if-modal-view-controller-presentation-style-is-ui
@implementation UINavigationController (PSPDFKeyboardDismiss)
- (BOOL)disablesAutomaticKeyboardDismissal { return NO; }
@end
