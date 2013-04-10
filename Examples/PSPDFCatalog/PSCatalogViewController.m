//
//  PSCatalogViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSCatalogViewController.h"
#import "PSCSectionDescriptor.h"
#import "PSCGridController.h"
#import "PSCTabbedExampleViewController.h"
#import "PSCDocumentSelectorController.h"
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
#import "PSCBookViewController.h"
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
#import "PSCColoredHighlightAnnotation.h"
#import <objc/runtime.h>

// Dropbox support
#import <DropboxSDK/DropboxSDK.h>
#import "GSDropboxActivity.h"
#import "GSDropboxUploader.h"

// Crypto support
#import "RNEncryptor.h"
#import "RNDecryptor.h"

#if !__has_feature(objc_arc)
#error "Compile this file with ARC"
#endif

// set to auto-choose a section; debugging aid.
//#define kPSPDFAutoSelectCellNumber [NSIndexPath indexPathForRow:0 inSection:0]
//#define kDebugTextBlocks

@interface PSCatalogViewController () <PSPDFViewControllerDelegate, PSPDFDocumentDelegate, PSCDocumentSelectorControllerDelegate, UITextFieldDelegate, UISearchDisplayDelegate> {
    UISearchDisplayController *_searchDisplayController;
    BOOL _firstShown;
    BOOL _clearCacheNeeded;
}
@property (nonatomic, strong) NSArray *content;
@property (nonatomic, strong) NSArray *filteredContent;
@property (nonatomic, strong) UISearchBar *searchBar;
@end

const char kPSCShowDocumentSelectorOpenInTabbedControllerKey;
const char kPSCAlertViewKey;
#define kPSPDFLastIndexPath @"kPSPDFLastIndexPath"

@implementation PSCatalogViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithStyle:style])) {
        self.title = PSPDFLocalize(@"PSPDFKit Catalog");
        if (PSIsIpad()) {
            self.title = [PSPDFVersionString() stringByReplacingOccurrencesOfString:@"PSPDFKit" withString:PSPDFLocalize(@"PSPDFKit Catalog")];
        }else {
#ifdef PSPDF_USE_SOURCE
            self.title = [PSPDFVersionString() stringByReplacingOccurrencesOfString:@"PSPDFKit" withString:PSPDFLocalize(@"")];
#endif
        }
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Catalog" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self createTableContent];
        [self addDebugButtons];
    }
    return self;
}

- (void)createTableContent {
    // common paths
    NSURL *samplesURL = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"Samples"];
    NSURL *hackerMagURL = [samplesURL URLByAppendingPathComponent:kHackerMagazineExample];

    NSMutableOrderedSet *content = [NSMutableOrderedSet orderedSet];

    // Full Apps
    PSCSectionDescriptor *appSection = [[PSCSectionDescriptor alloc] initWithTitle:@"Full Example Apps" footer:@"Can be used as a template for your own apps."];

    [appSection addContent:[[PSContent alloc] initWithTitle:@"PSPDFViewController playground" block:^{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
//        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"Annotation Test.pdf"]];

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
    hackerMagDoc.UID = @"HACKERMAGDOC"; // set custom UID so it doesn't interfere with other examples

    [appSection addContent:[[PSContent alloc] initWithTitle:@"Settings for a magazine" block:^{
        hackerMagDoc.title = @"HACKER MONTHLY Issue 12";
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:hackerMagDoc];
        controller.pageTransition = PSPDFPageCurlTransition;
        controller.pageMode = PSPDFPageModeAutomatic;
        controller.statusBarStyleSetting = PSPDFStatusBarSmartBlackHideOnIpad;

        // don't use thumbnails if the PDF is not rendered.
        // FullPageBlocking feels good when combined with pageCurl, less great with other scroll modes, especially PSPDFPageScrollContinuousTransition.
        controller.renderingMode = PSPDFPageRenderingModeFullPageBlocking;

        PSCRotationLockBarButtonItem *rotationLock = [[PSCRotationLockBarButtonItem alloc] initWithPDFViewController:controller];

        // setup toolbar
        controller.rightBarButtonItems = PSIsIpad() ? @[rotationLock, controller.brightnessButtonItem, controller.activityButtonItem, controller.searchButtonItem, controller.outlineButtonItem, controller.bookmarkButtonItem] : @[controller.activityButtonItem, controller.searchButtonItem, controller.outlineButtonItem, controller.bookmarkButtonItem];

        // show the thumbnail button on the HUD, but not on the toolbar (we're not adding viewModeButtonItem here)
        controller.documentLabel.labelStyle = PSPDFLabelStyleBordered;
        controller.pageLabel.labelStyle = PSPDFLabelStyleBordered;
        controller.pageLabel.showThumbnailGridButton = YES;

        // Hide thumbnail filter bar.
        controller.thumbnailController.filterOptions = [NSOrderedSet orderedSetWithArray:@[@(PSPDFThumbnailViewFilterShowAll), @(PSPDFThumbnailViewFilterBookmarks)]];

        return controller;
    }]];

    [appSection addContent:[[PSContent alloc] initWithTitle:@"Settings for a scientific paper" block:^{
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:[PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kPaperExampleFileName]]];
        // brightness button is not yet optimized for iPhone
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

    [appSection addContent:[[PSContent alloc] initWithTitle:@"Dropbox-like interface" block:^{
        if (PSIsIpad()) {
            PSCDropboxSplitViewController *splitViewController = [PSCDropboxSplitViewController new];
            [self.view.window.layer addAnimation:PSPDFFadeTransition() forKey:nil];
            self.view.window.rootViewController = splitViewController;
            return (UIViewController *)nil;
        }else {
            PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
            PSCDropboxPDFViewController *dropboxPDFController = [[PSCDropboxPDFViewController alloc] initWithDocument:document];
            return (UIViewController *)dropboxPDFController;
        }
    }]];

    [content addObject:appSection];
    ///////////////////////////////////////////////////////////////////////////////////////////

    // PSPDFDocument data provider test
    PSCSectionDescriptor *documentTests = [[PSCSectionDescriptor alloc] initWithTitle:@"PSPDFDocument data providers" footer:@"PSPDFDocument is highly flexible and allows you to merge multiple file sources to one logical one."];

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
        controller.rightBarButtonItems = @[controller.searchButtonItem, controller.printButtonItem, controller.annotationButtonItem, controller.viewModeButtonItem];
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
        NSDictionary *options = @{kPSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeNone & ~PSPDFAnnotationTypeLink)};
        NSData *consolidatedData = [[PSPDFProcessor defaultProcessor] generatePDFFromDocument:document pageRange:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)] options:options progressBlock:NULL error:NULL];
        PSPDFDocument *documentWithConsolidatedData = [PSPDFDocument PDFDocumentWithData:consolidatedData];

        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:documentWithConsolidatedData];
        controller.rightBarButtonItems = @[controller.annotationButtonItem, controller.searchButtonItem, controller.viewModeButtonItem];
        controller.additionalBarButtonItems = @[controller.openInButtonItem, controller.emailButtonItem];
        return controller;
    }]];

    [documentTests addContent:[[PSContent alloc] initWithTitle:@"Extract single pages with PSPDFProcessor" block:^{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];

        // Here we combine the NSData pieces in the PSPDFDocument into one piece of NSData (for sharing)
        NSMutableIndexSet *pageIndexes = [[NSMutableIndexSet alloc] initWithIndex:1];
        [pageIndexes addIndex:3];
        [pageIndexes addIndex:5];

        // Extract pages into new document
        NSData *newDocumentData = [[PSPDFProcessor defaultProcessor] generatePDFFromDocument:document pageRange:pageIndexes options:nil progressBlock:NULL error:NULL];

        // add a page from a second document
        PSPDFDocument *landscapeDocument = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kPSPDFCatalog]];
        NSData *newLandscapeDocumentData = [[PSPDFProcessor defaultProcessor] generatePDFFromDocument:landscapeDocument pageRange:[NSIndexSet indexSetWithIndex:0] options:nil progressBlock:NULL error:NULL];

        // merge into new PDF
        PSPDFDocument *twoPartDocument = [PSPDFDocument PDFDocumentWithDataArray:@[newDocumentData, newLandscapeDocumentData]];
        NSData *mergedDocumentData = [[PSPDFProcessor defaultProcessor] generatePDFFromDocument:twoPartDocument pageRange:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, twoPartDocument.pageCount)] options:nil progressBlock:NULL error:NULL];
        PSPDFDocument *mergedDocument = [PSPDFDocument PDFDocumentWithData:mergedDocumentData];

        // Note: PSPDFDocument supports having multiple data sources right from the start, this is just to demonstrate how to generate a new, single PDF from PSPDFDocument sources.

        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:mergedDocument];
        return controller;
    }]];

    [documentTests addContent:[[PSContent alloc] initWithTitle:@"Extract single pages with PSPDFProcessor, the fast way" block:^{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];

        // Here we use the pageRange feature to skip the intermediate NSDate objects we had to create in the last example.
        NSMutableIndexSet *pageIndexes = [[NSMutableIndexSet alloc] initWithIndex:1];
        [pageIndexes addIndex:3];
        [pageIndexes addIndex:5];
        [pageIndexes addIndex:document.pageCount + 3]; // next document!

        [document appendFile:kPSPDFCatalog]; // Append second file
        document.pageRange = pageIndexes;    // Define new page range.

        // Merge pages into new document.
        NSURL *tempURL = PSPDFTempFileURLWithPathExtension(@"temp", @"pdf");
        [[PSPDFProcessor defaultProcessor] generatePDFFromDocument:document pageRange:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)] outputFileURL:tempURL options:nil progressBlock:NULL error:NULL];
        PSPDFDocument *mergedDocument = [PSPDFDocument PDFDocumentWithURL:tempURL];

        // Note: PSPDFDocument supports having multiple data sources right from the start, this is just to demonstrate how to generate a new, single PDF from PSPDFDocument sources.
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:mergedDocument];
        return controller;
    }]];

    [documentTests addContent:[[PSContent alloc] initWithTitle:@"Limit pages to 5-10 via pageRange" block:^{
        // cache needs to be cleared since pages will change.
        [[PSPDFCache sharedCache] clearCache];
        _clearCacheNeeded = YES;

        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        document.pageRange = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(4, 5)];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        controller.rightBarButtonItems = @[controller.annotationButtonItem, controller.viewModeButtonItem];
        return controller;
    }]];

    [content addObject:documentTests];
    ///////////////////////////////////////////////////////////////////////////////////////////

    PSCSectionDescriptor *multimediaSection = [[PSCSectionDescriptor alloc] initWithTitle:@"Multimedia examples" footer:@"You can integrate videos, audio, images and HTML5 content/websites as parts of a PDF page. See http://pspdfkit.com/documentation.html#multimedia for details."];

    [multimediaSection addContent:[[PSContent alloc] initWithTitle:@"Multimedia PDF example" block:^{
        PSPDFDocument *multimediaDoc = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"multimedia.pdf"]];
        return [[PSPDFViewController alloc] initWithDocument:multimediaDoc];
    }]];

    [multimediaSection addContent:[[PSContent alloc] initWithTitle:@"Dynamically added video example" block:^{
        PSPDFDocument *multimediaDoc = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        multimediaDoc.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;

        // dynamically add video box
        PSPDFLinkAnnotation *aVideo = [[PSPDFLinkAnnotation alloc] initWithURLString:@"pspdfkit://[autostart:false]localhost/Bundle/big_buck_bunny.mp4"];
        aVideo.boundingBox = CGRectInset([multimediaDoc pageInfoForPage:0].rotatedPageRect, 100, 100);
        [multimediaDoc addAnnotations:@[aVideo] forPage:0];

        return [[PSPDFViewController alloc] initWithDocument:multimediaDoc];
    }]];

    [multimediaSection addContent:[[PSContent alloc] initWithTitle:@"Dynamically added video with cover" block:^{
        PSPDFDocument *multimediaDoc = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        multimediaDoc.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;

        // dynamically add video box
        PSPDFLinkAnnotation *aVideo = [[PSPDFLinkAnnotation alloc] initWithURLString:@"pspdfkit://[autostart:false, cover:true]localhost/Bundle/big_buck_bunny.mp4"];
        aVideo.boundingBox = CGRectInset([multimediaDoc pageInfoForPage:0].rotatedPageRect, 100, 100);
        [multimediaDoc addAnnotations:@[aVideo] forPage:0];

        return [[PSPDFViewController alloc] initWithDocument:multimediaDoc];
    }]];
    [content addObject:multimediaSection];

    PSCSectionDescriptor *annotationSection = [[PSCSectionDescriptor alloc] initWithTitle:@"Annotation Tests" footer:@"PSPDFKit supports all common PDF annotations, including Highlighing, Underscore, Strikeout, Comment and Ink."];

    [annotationSection addContent:[[PSContent alloc] initWithTitle:@"PDF annotation writing" block:^{
        NSURL *annotationSavingURL = [samplesURL URLByAppendingPathComponent:@"Annotation Test.pdf"];
        //NSURL *annotationSavingURL = [samplesURL URLByAppendingPathComponent:kHackerMagazineExample];

        // Copy file from the bundle to a location where we can write on it.
        NSURL *newURL = [self copyFileURLToDocumentFolder:annotationSavingURL overrideFile:NO];
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:newURL];

        document.editableAnnotationTypes = [NSOrderedSet orderedSetWithObjects:
                                            PSPDFAnnotationTypeStringLink, // not added by default.
                                            PSPDFAnnotationTypeStringHighlight,
                                            PSPDFAnnotationTypeStringUnderline,
                                            PSPDFAnnotationTypeStringStrikeout,
                                            PSPDFAnnotationTypeStringNote,
                                            PSPDFAnnotationTypeStringFreeText,
                                            PSPDFAnnotationTypeStringInk,
                                            PSPDFAnnotationTypeStringLine,
                                            PSPDFAnnotationTypeStringSquare,
                                            PSPDFAnnotationTypeStringCircle,
                                            PSPDFAnnotationTypeStringSignature,
                                            PSPDFAnnotationTypeStringStamp,
                                            PSPDFAnnotationTypeStringImage,
                                            nil];
        document.delegate = self;
        return [[PSCEmbeddedAnnotationTestViewController alloc] initWithDocument:document];
    }]];

    [annotationSection addContent:[[PSContent alloc] initWithTitle:@"PDF annotation writing with NSData" block:^{
        NSData *PDFData = [NSData dataWithContentsOfURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithData:PDFData];
        return [[PSCEmbeddedAnnotationTestViewController alloc] initWithDocument:document];
    }]];

    [annotationSection addContent:[[PSContent alloc] initWithTitle:@"Add image annotation and a MapView" block:^{
        NSURL *pspdfURL = [samplesURL URLByAppendingPathComponent:kPSPDFCatalog];
        PSPDFDocument *hackerDocument = [PSPDFDocument PDFDocumentWithURL:pspdfURL];
        return [[PSCAnnotationTestController alloc] initWithDocument:hackerDocument];
    }]];

    [annotationSection addContent:[[PSContent alloc] initWithTitle:@"Custom annotations with multiple files" block:^{
        NSArray *files = @[@"A.pdf", @"B.pdf", @"C.pdf", @"D.pdf"];
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithBaseURL:samplesURL files:files];

        // We're lazy here. 2 = UIViewContentModeScaleAspectFill
        PSPDFLinkAnnotation *aVideo = [[PSPDFLinkAnnotation alloc] initWithURLString:@"pspdfkit://[contentMode=2]localhost/Bundle/big_buck_bunny.mp4"];
        aVideo.boundingBox = [document pageInfoForPage:5].rotatedPageRect;
        [document addAnnotations:@[aVideo ] forPage:5];

        PSPDFLinkAnnotation *anImage = [[PSPDFLinkAnnotation alloc] initWithURLString:@"pspdfkit://[contentMode=2]localhost/Bundle/exampleImage.jpg"];
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

    [annotationSection addContent:[[PSContent alloc] initWithTitle:@"Save as... for annotation editing" block:^{
        NSURL *documentURL = [samplesURL URLByAppendingPathComponent:kHackerMagazineExample];
        NSURL *writableDocumentURL = [self copyFileURLToDocumentFolder:documentURL overrideFile:YES];
        PSPDFDocument *linkDocument = [PSPDFDocument PDFDocumentWithURL:writableDocumentURL];
        return [[PSCSaveAsPDFViewController alloc] initWithDocument:linkDocument];
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

    [customizationSection addContent:[[PSContent alloc] initWithTitle:@"Adding multiple UIButtons" block:^{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        return [[PSCImageOverlayPDFViewController alloc] initWithDocument:document];
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
        return [[PSCCustomToolbarController alloc] initWithDocument:document];
    }]];

    // this the default recommended way to customize the toolbar
    [customizationSection addContent:[[PSContent alloc] initWithTitle:@"Tinted Toolbar, Popovers, AlertView" block:^{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        PSPDFViewController *pdfController = [[PSCTintablePDFViewController alloc] initWithDocument:document];
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

    if ([PSPDFTextSelectionView isTextSelectionFeatureAvailable]) {
        [customizationSection addContent:[[PSContent alloc] initWithTitle:@"Disable text copying" block:^{
            PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
            [document setDidCreateDocumentProviderBlock:^(PSPDFDocumentProvider *documentProvider) {
                documentProvider.allowsCopying = NO;
            }];
            return [[PSPDFViewController alloc] initWithDocument:document];
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

    [customizationSection addContent:[[PSContent alloc] initWithTitle:@"Customize thumbnail page label" block:^{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        PSPDFViewController *pdfController = [[PSCCustomThumbnailsViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [customizationSection addContent:[[PSContent alloc] initWithTitle:@"Hide HUD while showing thumbnails" block:^{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        PSPDFViewController *pdfController = [[PSCHideHUDForThumbnailsViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [customizationSection addContent:[[PSContent alloc] initWithTitle:@"Hide HUD with delayed document set" block:^UIViewController *{
        PSPDFViewController *pdfController = [[PSCHideHUDDelayedDocumentViewController alloc] init];

        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            pdfController.document = hackerMagDoc;
        });

        return pdfController;
    }]];

    [content addObject:customizationSection];
    ///////////////////////////////////////////////////////////////////////////////////////////

    PSCSectionDescriptor *passwordSection = [[PSCSectionDescriptor alloc] initWithTitle:@"Passwords/Security" footer:@"Password is test123"];

    // Bookmarks
    NSURL *protectedPDFURL = [samplesURL URLByAppendingPathComponent:@"protected.pdf"];

    [passwordSection addContent:[[PSContent alloc] initWithTitle:@"Password preset" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:protectedPDFURL];
        [document unlockWithPassword:@"test123"];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        return controller;
    }]];

    [passwordSection addContent:[[PSContent alloc] initWithTitle:@"Password not preset; dialog" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:protectedPDFURL];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        return controller;
    }]];

    [passwordSection addContent:[[PSContent alloc] initWithTitle:@"Create password protected PDF." block:^UIViewController *{
        // create new file that is protected
        NSString *password = @"test123";
        NSURL *tempURL = PSPDFTempFileURLWithPathExtension(@"protected", @"pdf");

        // With password protected pages, PSPDFProcessor can only add link annotations.
        [[PSPDFProcessor defaultProcessor] generatePDFFromDocument:hackerMagDoc pageRange:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, hackerMagDoc.pageCount)] outputFileURL:tempURL options:@{(id)kCGPDFContextUserPassword : password, (id)kCGPDFContextOwnerPassword : password, (id)kCGPDFContextEncryptionKeyLength : @(128), kPSPDFProcessorAnnotationAsDictionary : @YES, kPSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeLink)} progressBlock:^(NSUInteger currentPage, NSUInteger numberOfProcessedPages, NSUInteger totalPages) {
            [PSPDFProgressHUD showProgress:numberOfProcessedPages/(float)totalPages status:PSPDFLocalize(@"Preparing...")];
        } error:NULL];
        [PSPDFProgressHUD dismiss];

        // show file
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:tempURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    /// Example how to decrypt a AES256 encrypted PDF on the fly.
    /// The crypto feature is only available in PSPDFKit Annotate.
    if ([PSPDFAESCryptoDataProvider isAESCryptoFeatureAvailable]) {
        [passwordSection addContent:[[PSContent alloc] initWithTitle:@"Encrypted CGDocumentProvider" block:^{

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

    // Encrypting the images will be a 5-10% slowdown, nothing substantial at all.
    // TODO: Update RNCryptor as soon as file format v2 has been released: http://robnapier.net/blog/rncryptor-hmac-vulnerability-827
    [passwordSection addContent:[[PSContent alloc] initWithTitle:@"Enable PSPDFCache encryption" block:^UIViewController *{
        PSPDFCache *cache = [PSPDFCache sharedCache];
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
                PSPDFLogWarning(@"Failed to encrypt: %@", [error localizedDescription]);
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
                PSPDFLogWarning(@"Failed to decrypt: %@", [error localizedDescription]);
            }
            return decryptedData;
        }];

        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        return controller;
    }]];

    [content addObject:passwordSection];
    ///////////////////////////////////////////////////////////////////////////////////////////

    PSCSectionDescriptor *subclassingSection = [[PSCSectionDescriptor alloc] initWithTitle:@"Subclassing" footer:@"Examples how to subclass PSPDFKit."];

    [subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Annotation Link Editor" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        document.editableAnnotationTypes = [NSOrderedSet orderedSetWithObjects:
                                            PSPDFAnnotationTypeStringLink, // important!
                                            PSPDFAnnotationTypeStringHighlight,
                                            PSPDFAnnotationTypeStringUnderline,
                                            PSPDFAnnotationTypeStringStrikeout,
                                            PSPDFAnnotationTypeStringNote,
                                            PSPDFAnnotationTypeStringFreeText,
                                            PSPDFAnnotationTypeStringInk,
                                            PSPDFAnnotationTypeStringSquare,
                                            PSPDFAnnotationTypeStringCircle,
                                            PSPDFAnnotationTypeStringStamp,
                                            nil];

        PSPDFViewController *controller = [[PSCLinkEditorViewController alloc] initWithDocument:document];
        return controller;
    }]];

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

    // As a second test, this example disables text selection, test that the shape still can be resized.
    [subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Programmatically add a shape annotation" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled; // don't confuse other examples
        // add shape annotation if there isn't one already.
        NSUInteger targetPage = 0;
        if ([[document annotationsForPage:targetPage type:PSPDFAnnotationTypeShape] count] == 0) {
            PSPDFShapeAnnotation *annotation = [[PSPDFShapeAnnotation alloc] initWithShapeType:PSPDFShapeAnnotationSquare];
            annotation.boundingBox = CGRectInset([document pageInfoForPage:targetPage].rotatedPageRect, 100, 100);
            annotation.color = [UIColor colorWithRed:0.0 green:100.0/255.f blue:0.f alpha:1.f];
            annotation.fillColor = annotation.color;
            annotation.alpha = 0.5f;
            [document addAnnotations:@[annotation] forPage:targetPage];
        }

        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        controller.textSelectionEnabled = NO;
        controller.rightBarButtonItems = @[controller.searchButtonItem, controller.openInButtonItem, controller.viewModeButtonItem];
        return controller;
    }]];

    [subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Programmatically add a highlight annotation" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled; // don't confuse other examples.

        // Let's create a highlight for all occurences of BATMAN on the first 10 pages, in Orange.
        NSUInteger annotationCounter = 0;
        for (NSUInteger pageIndex = 0; pageIndex < 10; pageIndex++) {
            for (PSPDFWord *word in [document textParserForPage:pageIndex].words) {
                if ([word.stringValue isEqualToString:@"Batman"]) {
                    CGRect boundingBox;
                    NSArray *highlighedRects = PSPDFRectsFromGlyphs(word.glyphs, [document pageInfoForPage:pageIndex].pageRotationTransform, &boundingBox);
                    PSPDFHighlightAnnotation *annotation = [[PSPDFHighlightAnnotation alloc] initWithHighlightType:PSPDFHighlightAnnotationHighlight];
                    annotation.color = [UIColor orangeColor];
                    annotation.boundingBox = boundingBox;
                    annotation.rects = highlighedRects;
                    annotation.contents = [NSString stringWithFormat:@"This is automatically created highlight #%d", annotationCounter];
                    [document addAnnotations:@[annotation] forPage:pageIndex];
                    annotationCounter++;
                }
            }
        }
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        controller.page = 8;
        return controller;
    }]];

    [subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Change default highlight annotation color" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        [document overrideClass:PSPDFHighlightAnnotation.class withClass:PSCColoredHighlightAnnotation.class];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        return controller;
    }]];

    [subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Programmatically add an ink annotation" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled; // don't confuse other examples

        // add shape annotation if there isn't one already.
        NSUInteger targetPage = 0;
        if ([[document annotationsForPage:targetPage type:PSPDFAnnotationTypeInk] count] == 0) {

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

            annotation.color = [UIColor colorWithRed:0.667 green:0.279 blue:0.748 alpha:1.000];
            [document addAnnotations:@[annotation] forPage:targetPage];
        }

        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        return controller;
    }]];

    // This example is actually the recommended way. Add this snipped to dynamically enable/disable fittingWidth on the iPhone.
    [subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Capture the annotation trailer" block:^UIViewController *{
        NSURL *newURL = [self copyFileURLToDocumentFolder:hackerMagURL overrideFile:YES];
        PSCAnnotationTrailerCaptureDocument *document = [PSCAnnotationTrailerCaptureDocument PDFDocumentWithURL:newURL];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        controller.annotationButtonItem.annotationToolbar.saveAfterToolbarHiding = YES;
        controller.rightBarButtonItems = @[controller.annotationButtonItem, controller.viewModeButtonItem];
        return controller;
    }]];

    // This example is actually the recommended way. Add this snipped to dynamically enable/disable fittingWidth on the iPhone.
    [subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Dynamic fittingWidth on iPhone" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        [controller setUpdateSettingsForRotationBlock:^(PSPDFViewController *pdfController, UIInterfaceOrientation toInterfaceOrientation) {
            if (!PSIsIpad()) pdfController.fitToWidthEnabled = UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
        }];
        return controller;
    }]];

    [subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Dynamic pageCurl/scrolling" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        [controller setUpdateSettingsForRotationBlock:^(PSPDFViewController *pdfController, UIInterfaceOrientation toInterfaceOrientation) {
            if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
                pdfController.pageTransition = PSPDFPageScrollPerPageTransition;
            }  else {
                pdfController.pageTransition = PSPDFPageCurlTransition;
            }
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
        PSCPlayBarButtonItem *playButton = [[PSCPlayBarButtonItem alloc] initWithPDFViewController:controller];
        playButton.autoplaying = YES;
        controller.rightBarButtonItems = @[playButton, controller.searchButtonItem, controller.outlineButtonItem, controller.viewModeButtonItem];
        controller.pageTransition = PSPDFPageCurlTransition;
        controller.pageMode = PSPDFPageModeAutomatic;
        return controller;
    }]];

    [subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Screen Reader" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        PSPDFViewController *controller = [[PSCReaderPDFViewController alloc] initWithDocument:document];
        controller.page = 3;
        return controller;
    }]];

    // Helps in case you want to add custom subviews but still have drawings on top of everything
    [subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Draw all annotations as overlay" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        PSPDFViewController *controller = [[PSCCustomSubviewPDFViewController alloc] initWithDocument:document];
        return controller;
    }]];

    [subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Add a two finger swipe gesture" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        PSPDFViewController *controller = [[PSCTwoFingerSwipeGestureViewController  alloc] initWithDocument:document];
        controller.page = 3;
        return controller;
    }]];

    PSPDF_IF_IOS6_OR_GREATER([subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Dropbox Activity (iOS6 only)" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
        controller.rightBarButtonItems = @[controller.activityButtonItem, controller.searchButtonItem, controller.outlineButtonItem, controller.viewModeButtonItem];

        // To use this in your own app, replace the key/secret with your own API.
        // and update the Info.plist with the new URL scheme.
        // See https://www.dropbox.com/developers/start/authentication#ios for details.
        DBSession *dbSession = [[DBSession alloc] initWithAppKey:@"tlgd0ci9254huta"
                                                       appSecret:@"jbel7nqasuc63wt"
                                                            root:kDBRootAppFolder];
        [DBSession setSharedSession:dbSession];
        controller.activityButtonItem.applicationActivities = @[[GSDropboxActivity new]];

        // Very simple approach to show upload status.
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [[NSNotificationCenter defaultCenter] addObserverForName:GSDropboxUploaderDidGetProgressUpdateNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
                [PSPDFProgressHUD showProgress:[note.userInfo[GSDropboxUploaderProgressKey] floatValue] status:@"Uploading..."];
            }];

            [[NSNotificationCenter defaultCenter] addObserverForName:GSDropboxUploaderDidFinishUploadingFileNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
                [PSPDFProgressHUD showSuccessWithStatus:@"Upload Finished."];
            }];

            [[NSNotificationCenter defaultCenter] addObserverForName:GSDropboxUploaderDidFailNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
                [PSPDFProgressHUD showErrorWithStatus:@"Upload failed."];
            }];
        });

        return controller;
    }]];)

    [subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Search for Batman, without controller" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSCHeadlessSearchPDFViewController *pdfController = [[PSCHeadlessSearchPDFViewController alloc] initWithDocument:document];
        pdfController.highlightedSearchText = @"Batman";
        return pdfController;
    }]];

    [subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Remove Ink from the annotation toolbar" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.rightBarButtonItems = @[pdfController.annotationButtonItem];
        NSMutableOrderedSet *editableTypes = [document.editableAnnotationTypes mutableCopy];
        [editableTypes removeObject:PSPDFAnnotationTypeStringInk];
        pdfController.annotationButtonItem.annotationToolbar.editableAnnotationTypes = editableTypes;
        return pdfController;
    }]];

    [subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Customize email sending (add body text)" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.emailButtonItem.mailComposeViewControllerCustomizationBlock = ^(MFMailComposeViewController *mailController) {
            [mailController setMessageBody:@"<h1 style='color:blue'>Custom message body.</h1>" isHTML:YES];
        };
        pdfController.rightBarButtonItems = @[pdfController.emailButtonItem];
        return pdfController;
    }]];

    [subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Set custom default zoom level" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"Marketing.pdf"]];
        PSPDFViewController *pdfController = [[PSCCustomDefaultZoomScaleViewController alloc] initWithDocument:document];
        [self presentViewController:pdfController animated:YES completion:NULL];
        return nil;
    }]];

    [subclassingSection addContent:[[PSContent alloc] initWithTitle:@"Change font of the note controller" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        [PSPDFNoteAnnotationController setTextViewCustomizationBlock:^(PSPDFNoteAnnotationController *noteController) {
            noteController.textView.font = [UIFont fontWithName:@"Helvetica" size:20];
        }];
        return pdfController;
    }]];

    [content addObject:subclassingSection];



    PSCSectionDescriptor *testSection = [[PSCSectionDescriptor alloc] initWithTitle:@"Tests" footer:@""];

    // Used for stability testing.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Timing tests" block:^UIViewController *{
        return [[PSCTimingTestViewController alloc] initWithNibName:nil bundle:nil];
    }]];

    // Modal controller - check that we don't get dismissed at some point.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Modal test" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"multimedia.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.rightBarButtonItems = @[pdfController.printButtonItem, pdfController.emailButtonItem, pdfController.openInButtonItem, pdfController.viewModeButtonItem];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:pdfController];
        [self presentViewController:navController animated:YES completion:NULL];
        return nil; // don't push anything
    }]];

    // Tests if we're correctly reloading the controller.
    // Check if scrolling works after the document is set delayed.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Delayed document set" block:^UIViewController *{
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] init];

        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            pdfController.document = hackerMagDoc;
        });

        return pdfController;
    }]];

    // Tests if the placement of the search controller is correct, even for zoomed documents.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Inline search test" block:^UIViewController *{
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:hackerMagDoc];
        pdfController.fitToWidthEnabled = YES;
        pdfController.rightBarButtonItems = @[pdfController.viewModeButtonItem];
        return pdfController;
    }]];

    // additional test cases, just for developing and testing PSPDFKit.
    // Referenced PDF files are proprietary and not released with the downloadable package.
#ifdef PSPDF_USE_SOURCE
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Zoom out UIKit freeze bug" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"About CLA.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // test search highlighting matching, also tests that we indeed are on logical page 3.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Search for Drammen" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"doc-1205.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 2; // pages start at 0.

        int64_t delayInSeconds = 1.f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [pdfController searchForString:@"Drammen" animated:YES];
        });

        return pdfController;
    }]];

    // Test that the Type... menu item is NOT visible (since Underscore/StrikeOut are disabled)
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Limited annotation features (only Highlight/Ink)" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        document.editableAnnotationTypes = [NSOrderedSet orderedSetWithArray:@[PSPDFAnnotationTypeStringHighlight, PSPDFAnnotationTypeStringInk]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.rightBarButtonItems = @[pdfController.annotationButtonItem, pdfController.viewModeButtonItem];
        return pdfController;
    }]];

    // Show grid initially, test that page is correctly zoomed at.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Show grid initially" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"PDFReference17.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 15;
        pdfController.viewMode = PSPDFViewModeThumbnails;
        return pdfController;
    }]];

    // check that annotations work well with pageCurl (e.g. that you can't curl while adding a annotation)
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Annotations + pageCurl" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.rightBarButtonItems = @[pdfController.annotationButtonItem, pdfController.viewModeButtonItem];
        pdfController.pageTransition = PSPDFPageCurlTransition;
        return pdfController;
    }]];

    // check that the brightness works on iPhone as well.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Brightness on iPhone" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.rightBarButtonItems = @[pdfController.brightnessButtonItem, pdfController.viewModeButtonItem];
        return pdfController;
    }]];

    // check that non-uniform pages are correctly handled.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Centered dual-page mode" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"pepsico-slow2.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 1;
        return pdfController;
    }]];

    // check that external links are correctly recognized and the alert is shown.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"External links test" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"one.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 1;
        return pdfController;
    }]];

    // Check that even multiple different pageLabel enumerations work properly, compare with Acrobat.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"PageLabels test" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"pagelabels-test.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.viewMode = PSPDFViewModeThumbnails;
        return pdfController;
    }]];

    // Check that we don't get weird page labels like 11 for 1.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"PageLabels test (numbered, needs to be ignored)" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"broken pagelabels.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.viewMode = PSPDFViewModeThumbnails;
        return pdfController;
    }]];

    // Check that page labels work correctly, even if we use the pageRange feature.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"PageLabels test + pageRange" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"pagelabels-test.pdf"]];
        [[PSPDFCache sharedCache] removeCacheForDocument:document deleteDocument:NO error:NULL];
        _clearCacheNeeded = YES;
        document.pageRange = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(5, 15)];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.viewMode = PSPDFViewModeThumbnails;
        return pdfController;
    }]];

    // Test HSV color picker
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Color picker test" block:^UIViewController *{
        PSPDFHSVColorPickerController *picker = [PSPDFHSVColorPickerController new];
        picker.selectionColor = [UIColor yellowColor];
        return picker;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test that § can be found." block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"Entwurf AIFM-UmsG.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 5;

        int64_t delayInSeconds = 1.f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [pdfController searchForString:@"§ " animated:YES];
        });

        return pdfController;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test that 'In Vitro Amplification' can be found." block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"In Vitro Amplification - search.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];

        int64_t delayInSeconds = 1.f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [pdfController searchForString:@"In Vitro Amplification" animated:YES];
        });
        return pdfController;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"Search performance test" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"PDFReference16.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        int64_t delayInSeconds = 1.f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [pdfController searchForString:@"pdfo" animated:YES];
        });
        return pdfController;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"TextParser test" block:^UIViewController *{
        [PSCTextParserTest runWithDocumentAtPath:[samplesURL URLByAppendingPathComponent:@"protected.pdf"].path];
        return nil;
    }]];

    // Page 26 of hackernews-12 has a very complex XObject setup with nested objects that reference objects that have a parent with the same name. If parsed from top to bottom with the wrong XObjects this will take 100^4 calls, thus clocks up the iPad for a very long time.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test for cyclic XObject references." block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 26;

        [[document textParserForPage:26] words];
        return pdfController;
    }]];

    // Check that the free text annotation has a 5px red border around it.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Freetext annotation with border" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"textbox.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Check that "Griffin" is correctly parsed and only one word.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test ligature parsing" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 1;

        NSArray *glyphs = [[document textParserForPage:1] glyphs];
        NSLog(@"glyphs: %@", glyphs);

        return pdfController;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test bfrange-Cmaps with array syntax" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"HT-newspaper-textextraction.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];

        NSString *text = [document textParserForPage:0].text;
        NSLog(@"text: %@", text);

        return pdfController;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test bfrange-Cmaps with ligatures" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"chinese0.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];

        NSString *text = [document textParserForPage:0].text;
        NSLog(@"text: %@", text);

        return pdfController;
    }]];

    // Test that file actually opens.
    // CoreGraphics is picky about AES-128 and will fail if the document is parsed before we enter a password with a "failed to create default crypt filter."
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test AES-128 password protected file" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"cryptfilter-password-abc.pdf"]];
        [document pageCount]; // trigger calculation to test that pageCount is reset afterwards
        document.password = @"abc";
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test PDF annotation writing with nil color" block:^{
        NSURL *annotationSavingURL = [samplesURL URLByAppendingPathComponent:@"annotation-missing-colors.pdf"];

        // copy file from the bundle to a location where we can write on it.
        NSURL *newURL = [self copyFileURLToDocumentFolder:annotationSavingURL overrideFile:YES];
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:newURL];
        return [[PSCEmbeddedAnnotationTestViewController alloc] initWithDocument:document];
    }]];

    //    1. Run in iOS 5.1 in Simulator in landscape.
    //    2. Expand to fullscreen.
    //    3. Rotate to Portrait.
    //    4. Tap 'Done'
    //
    //    Expected behavior:
    //    PDF returns to page 7 and movie is visible
    //
    //    Bug behavior: (fixed as of 2.6.4)
    //    PDF returns to page 1 instead of page 7. If you scroll go back to page 7, the movie fails to load.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test Video Rotation" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"PDF with Video.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 6;
        return pdfController;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test that Fullscren Audio doesn't flicker" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"Lifescribe.pdf"]];
        return [[PSPDFViewController alloc] initWithDocument:document];
    }]];

    // Check that this doesn't auto-play, especially not on iOS5.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test Video No-Autoplay" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"multimedia-autostart-ios5.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Test video covers
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test multiple Video Covers" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"covertest/imrevi.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Ensure that videos do display.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test large video extraction code" block:^UIViewController *{
        // clear temp directory to force video extraction.
        [[NSFileManager defaultManager] removeItemAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"PSPDFKit"] error:NULL];
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"Embedded-video-large.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 11;
        return pdfController;
    }]];

    // Check that multiple videos work fine and all annotations are parsed.
    // Also check that dashed border is parsed correctly and displayed as dash.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Advanced annotation usage test" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"stamps2.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 8;
        return pdfController;
    }]];

    // Test that stamps are correctly displayed and movable.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Stamp annotation test" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"stamps2.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 1;
        return pdfController;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"Stamp annotation test, only allow stamp editing." block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"stamps2.pdf"]];
        document.editableAnnotationTypes = [NSOrderedSet orderedSetWithObject:PSPDFAnnotationTypeStringStamp];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 1;
        return pdfController;
    }]];

    // Line annotations generic, display, endings.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Line annotation test" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"stamps2.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 7;
        return pdfController;
    }]];

    // Test that the green shape is properly displayed in Adobe Acrobat for iOS.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Shape annotation AP test." block:^UIViewController *{
        // Copy file from the bundle to a location where we can write on it.
        NSURL *newURL = [self copyFileURLToDocumentFolder:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample] overrideFile:NO];
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:newURL];
        // Add the annotation
        PSPDFShapeAnnotation *annotation = [[PSPDFShapeAnnotation alloc] initWithShapeType:PSPDFShapeAnnotationSquare];
        annotation.boundingBox = CGRectInset([document pageInfoForPage:0].rotatedPageRect, 100, 100);
        annotation.color = [UIColor colorWithRed:0.0 green:100.0/255.f blue:0.f alpha:1.f];
        annotation.fillColor = annotation.color;
        annotation.alpha = 0.5f;
        [document addAnnotations:@[annotation] forPage:0];
        // Save it
        NSError *error = nil;
        if (![document saveChangedAnnotationsWithError:&error]) {
            NSLog(@"Failed to save: %@", [error localizedDescription]);
        }

        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.openInButtonItem.openOptions = PSPDFOpenInOptionsOriginal;
        pdfController.rightBarButtonItems = @[pdfController.openInButtonItem];
        return pdfController;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"Stamps test with appearance streams" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"stamptest.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"FreeText annotation" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"stamps2.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 2;
        return pdfController;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test image extraction with CMYK images" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"CMYK-image-mokafive.pdf"]];

        NSDictionary *images = [document objectsAtPDFRect:[document rectBoxForPage:0] page:0 options:@{kPSPDFObjectsImages : @YES}];
        NSLog(@"Detected images: %@", images);

        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test image extraction - top left" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"image-topleft.pdf"]];

        NSDictionary *images = [document objectsAtPDFRect:[document rectBoxForPage:0] page:0 options:@{kPSPDFObjectsImages : @YES}];
        NSLog(@"Detected images: %@", images);

        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test image extraction - not inverted" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"inverted-image.pdf"]];

        NSDictionary *images = [document objectsAtPDFRect:[document rectBoxForPage:0] page:0 options:@{kPSPDFObjectsImages : @YES}];
        NSLog(@"Detected images: %@", images);

        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // test that even many links don't create any performance problem on saving.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Performance with many links." block:^UIViewController *{

        NSURL *documentURL = [samplesURL URLByAppendingPathComponent:@"PDFReference17.pdf"];
        NSURL *newURL = [self copyFileURLToDocumentFolder:documentURL overrideFile:YES];

        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:newURL];
        document.annotationSaveMode = PSPDFAnnotationSaveModeEmbedded;
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 2;
        return pdfController;
    }]];

    // Check that the link annotation on page one actually works, even if it's encoded in a weird way.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test invalid URI encodings" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"weird-link-annotation-siteLinkTargetIsRaw.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Check that the link on page one opens the internal web view both on the simulator and device.
    // There was a bug that prevented opening local html pages on the device until PSPDFKit 2.7.
    // Also check that the inline web view shows a nice error message + image as html.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test link on page 1" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"weblink-page1.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Check that telephone numbers are dynamically converted to annotations.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Detect Telephone Numbers and Links" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"detect-telephone-numbers.pdf"]];
        NSArray *newAnnotations = [document detectLinkTypes:PSPDFTextCheckingTypeAll forPagesInRange:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)]];
        NSLog(@"Created %d new annotations: %@", newAnnotations.count, newAnnotations);
        __unused NSArray *newAnnotations2 = [document detectLinkTypes:PSPDFTextCheckingTypeAll forPagesInRange:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)]];
        NSAssert(newAnnotations2.count == 0, @"A second run should not create new annotations");
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Check that those links actually work.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test latex generated PDF links" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"pdf_pagelinks_latex.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Check that font caching works correctly and doesn't corrupt future search runs.
    // Also check search support to ignore no-break-space
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test Font Caching" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"fontcaching-bug.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 12;
        //[PSPDFFontCacheTest runWithDocumentAtPath:[document.fileURL path]];

        int64_t delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [pdfController searchForString:@"control points" animated:YES];
        });

        NSLog(@"%@", [[document textParserForPage:12] glyphs]);

        return pdfController;
    }]];

    // This document has a font XObject recursion depth of > 4. Test if it's parsed correctly and doesn't crash PSPDFKit.
    // Simply opening will crash if this isn't handled correctly.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test font XObject recursion depth" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"font-xobject-recursion-depth-crashtest.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Ensure that parsing completes and doesn't loop. If the document opens, everything is OK.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test parsing of recursive XRef table" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"recursive-xref-table.pdf"]];
        [[document documentParserForPage:0] objectNumberForAnnotationIndex:0 onPageIndex:0]; // start parsing
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Check that blocks are recognized and that it is fast (not 10 seconds!)
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test block detection" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"block-detection-test.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        // Debug: Visualizes glyphs and text blocks.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for (PSPDFPageView *pageView in pdfController.visiblePageViews)
                [pageView.selectionView showTextFlowData:YES animated:NO];

            NSLog(@"%@", [document textParserForPage:0].glyphs);
        });
        return pdfController;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test animated GIFs + Links" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"animatedgif.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Test that we preserve the scrollEnabled setting.
    // Check that scroll is still blocked after drawing.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test scroll blocking" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        // Finds the right timing to set properties.
        [pdfController setUpdateSettingsForRotationBlock:^(PSPDFViewController *aPDFController, UIInterfaceOrientation toInterfaceOrientation) {
            aPDFController.pagingScrollView.scrollEnabled = NO;
        }];
        return pdfController;
    }]];

    // Add note annotation via toolbar, close toolbar, ensure that the PDF was saved correctly, then test if the annotation still can be moved. If annotations haven't been correctly reloaded after saving the move will fail.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test annotation updating after a save" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.imageSelectionEnabled = NO;
        pdfController.annotationButtonItem.annotationToolbar.saveAfterToolbarHiding = YES;
        pdfController.rightBarButtonItems = @[pdfController.annotationButtonItem];
        return pdfController;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"Parse weird outline format." block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"weird-outline.pdf"]];
        [document.outlineParser outline]; // PARSE!
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test outline parsing" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"LearningFlex4-outline.pdf"]];
        [document.outlineParser outline]; // PARSE!
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.rightBarButtonItems = @[pdfController.outlineButtonItem];
        return pdfController;
    }]];

    // should only take a few seconds, not 120.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test outline parsing speed" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"5000pages-slow-outline.pdf"]];
        [document.outlineParser outline]; // PARSE!
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.rightBarButtonItems = @[pdfController.outlineButtonItem];
        return pdfController;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test audio" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"pdf_mp3/650_v2.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 36;
        pdfController.doublePageModeOnFirstPage = YES;
        return pdfController;
    }]];

    // Check that even extremely long pages are correctly rendered.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test extremely long pages" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"pepsico-slow.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test JavaScript actions" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"US-GardeningMain2013-US.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 91;
        return pdfController;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"View state restoration for continuous scrolling." block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = 10;
        pdfController.pageTransition = PSPDFPageScrollContinuousTransition;
        return pdfController;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test annotation saving + NSData" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithData:[NSData dataWithContentsOfURL:[samplesURL URLByAppendingPathComponent:@"annotations_nsdata.pdf"]]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test image drawing" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"imagestest.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test freetext annotation" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"freetext-test.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // There was a bug where free text annotations with a too small boundingBox were not drawn.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test small freetext annotation" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"SmallTextAnnotationTest.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // If the encoding is wrong, the freeText annotation will not be displayed.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test annotation encoding" block:^UIViewController *{
        NSURL *URL = [self copyFileURLToDocumentFolder:[samplesURL URLByAppendingPathComponent:@"A.pdf"] overrideFile:YES];
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:URL];

        PSPDFFreeTextAnnotation *freeText = [PSPDFFreeTextAnnotation new];
        freeText.contents = @"發音正確\n眼睛看聽眾\n準備充足\n聲音響亮\n運用適當的語氣\n用自己的話講故事\n內容";
        freeText.boundingBox = CGRectMake(100, 100, 400, 400);
        [document addAnnotations:@[freeText] forPage:0];
        [document saveChangedAnnotationsWithError:NULL];

        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"Tests thumbnail extraction" block:^UIViewController *{
        NSURL *URL = [[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"Samples"] URLByAppendingPathComponent:@"landscapetest.pdf"];
        PSPDFDocument *doc = [PSPDFDocument PDFDocumentWithURL:URL];
        NSError *error = nil;
        UIImage *thumbnail = [doc renderImageForPage:0 withSize:CGSizeMake(300, 300) clippedToRect:CGRectZero withAnnotations:nil options:nil receipt:NULL error:&error];
        if (!thumbnail) {
            PSPDFLogError(@"Failed to generate thumbnail: %@", [error localizedDescription]);
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
    }]];

    // Check that there's a red note annotation in landscape mode or when you zoom out.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test annotation outside of page" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"noteannotation-outside.pdf"]];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        return pdfController;
    }]];

    // Test flattening, especially for notes.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test annotation flattening" block:^UIViewController *{
        NSURL *tempURL = PSPDFTempFileURLWithPathExtension(@"annotationtest", @"pdf");
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"stamps2.pdf"]];
        [[PSPDFProcessor defaultProcessor] generatePDFFromDocument:document pageRange:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)] outputFileURL:tempURL options:@{kPSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeAll)} progressBlock:NULL error:NULL];

        // show file
        PSPDFDocument *newDocument = [PSPDFDocument PDFDocumentWithURL:tempURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:newDocument];
        return pdfController;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test annotation flattening 2" block:^UIViewController *{
        NSURL *tempURL = PSPDFTempFileURLWithPathExtension(@"annotationtest2", @"pdf");
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;
        PSPDFNoteAnnotation *noteAnnotation = [PSPDFNoteAnnotation new];
        noteAnnotation.boundingBox = CGRectMake(100, 100, 50, 50);
        noteAnnotation.contents = @"This is a test for the note annotation flattening. This is a test for the note annotation flattening. This is a test for the note annotation flattening. This is a test for the note annotation flattening.";
        [document addAnnotations:@[noteAnnotation] forPage:0];
        [[PSPDFProcessor defaultProcessor] generatePDFFromDocument:document pageRange:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)] outputFileURL:tempURL options:@{kPSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeAll)} progressBlock:NULL error:NULL];

        // show file
        PSPDFDocument *newDocument = [PSPDFDocument PDFDocumentWithURL:tempURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:newDocument];
        return pdfController;
    }]];

    // Check that annotations are there, links work.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test PDF generation + annotation adding 1" block:^UIViewController *{
        NSURL *tempURL = PSPDFTempFileURLWithPathExtension(@"annotationtest", @"pdf");
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
        [[PSPDFProcessor defaultProcessor] generatePDFFromDocument:document pageRange:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)] outputFileURL:tempURL options:@{kPSPDFProcessorAnnotationAsDictionary : @YES, kPSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeAll)} progressBlock:NULL error:NULL];

        // show file
        PSPDFDocument *newDocument = [PSPDFDocument PDFDocumentWithURL:tempURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:newDocument];
        return pdfController;
    }]];

    // Check that annotations are there.
    [testSection addContent:[[PSContent alloc] initWithTitle:@"Test PDF generation + annotation adding 2" block:^UIViewController *{
        NSURL *tempURL = PSPDFTempFileURLWithPathExtension(@"annotationtest", @"pdf");
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:@"stamps2.pdf"]];
        [[PSPDFProcessor defaultProcessor] generatePDFFromDocument:document pageRange:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)] outputFileURL:tempURL options:@{kPSPDFProcessorAnnotationAsDictionary : @YES, kPSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeAll)} progressBlock:NULL error:NULL];

        // show file
        PSPDFDocument *newDocument = [PSPDFDocument PDFDocumentWithURL:tempURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:newDocument];
        return pdfController;
    }]];

    [testSection addContent:[[PSContent alloc] initWithTitle:@"PSPDFProcessor PPTX (Microsoft Office) conversion" block:^UIViewController *{
        NSURL *URL = [NSURL fileURLWithPath:@"/Users/steipete/Documents/Projects/PSPDFKit_meta/converts/Neu_03_VZ3_Introduction.pptx"];
        NSURL *outputURL = PSPDFTempFileURLWithPathExtension(@"converted", @"pdf");
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
        return nil;
    }]];
    [content addObject:textExtractionSection];

#endif

    [content addObject:testSection];
    ///////////////////////////////////////////////////////////////////////////////////////////


    PSCSectionDescriptor *delegateSection = [[PSCSectionDescriptor alloc] initWithTitle:@"Delegate" footer:!PSIsIpad() ? PSPDFVersionString() : @""];
    [delegateSection addContent:[[PSContent alloc] initWithTitle:@"Custom drawing" block:^UIViewController *{
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
        document.title = @"Custom drawing";
        PSPDFViewController *pdfController = [[PSCCustomDrawingViewController alloc] initWithDocument:document];
        return pdfController;
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
            // Split view controllers can't just be added to a UINavigationController
            self.view.window.rootViewController = splitVC;
            return (UIViewController *)nil;
        }]];
        [content addObject:iPadTests];
    }

    _content = content.array;

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

    // Private API - don't ship this in App Store builds.
    [_searchDisplayController setValue:@(UITableViewStyleGrouped) forKey:[NSString stringWithFormat:@"%@TableViewStyle", @"searchResults"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Restore state as it was before.
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [UIApplication.sharedApplication setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
    [UIApplication.sharedApplication setStatusBarHidden:NO withAnimation:animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone];
    PSPDFFixNavigationBarForNavigationControllerAnimated(self.navigationController, NO);
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;

    // clear cache (for night mode)
    if (_clearCacheNeeded) {
        _clearCacheNeeded = NO;
        [[PSPDFCache sharedCache] clearCache];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    PSPDFFixNavigationBarForNavigationControllerAnimated(self.navigationController, animated);

#ifdef kPSPDFAutoSelectCellNumber
    if (!_firstShown && kPSPDFAutoSelectCellNumber) {
        if ([self isValidIndexPath:kPSPDFAutoSelectCellNumber]) {
            [self tableView:self.tableView didSelectRowAtIndexPath:kPSPDFAutoSelectCellNumber];
            _firstShown = YES;
        }
        if (!_firstShown) {
            NSLog(@"Invalid row/section count: %@ (sections: %d, rows:%d)", kPSPDFAutoSelectCellNumber, numberOfSections, numberOfRowsInSection);
        }
    }
#endif

    // Load last state
    if (!_firstShown) {
        NSData *indexData = [[NSUserDefaults standardUserDefaults] objectForKey:kPSPDFLastIndexPath];
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
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPSPDFLastIndexPath];
    }
}

// Support for iOS5. iOS6 does this differently and also correct by default.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return PSIsIpad() ? YES : toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
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

- (NSURL *)copyFileURLToDocumentFolder:(NSURL *)documentURL overrideFile:(BOOL)override {
    // copy file from the bundle to a location where we can write on it.
    NSString *docsFolder = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *newPath = [docsFolder stringByAppendingPathComponent:[documentURL lastPathComponent]];
    NSURL *newURL = [NSURL fileURLWithPath:newPath];

    BOOL needsCopy = ![[NSFileManager defaultManager] fileExistsAtPath:newPath];
    if (override) {
        needsCopy = YES;
        [[NSFileManager defaultManager] removeItemAtURL:newURL error:NULL];
    }

    NSError *error;
    if (needsCopy &&
        ![[NSFileManager defaultManager] copyItemAtURL:documentURL toURL:newURL error:&error]) {
        NSLog(@"Error while copying %@: %@", documentURL.path, error.localizedDescription);
    }

    return newURL;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return [_content count];
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return [[_content[section] contentDescriptors] count];
    }else {
        return self.filteredContent.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return [_content[section] title];
    }else {
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return [_content[section] footer];
    }else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PSCatalogCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

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
    NSLog(@"Invoking [NSIndexPath indexPathForRow:%d inSection:%d]", indexPath.row, indexPath.section);

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
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:unfilteredIndexPath] forKey:kPSPDFLastIndexPath];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _firstShown = YES; // don't re-show after saving it first.

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

- (void)pdfDocument:(PSPDFDocument *)document failedToSaveAnnotations:(NSArray *)annotations withError:(NSError *)error {
    PSCLog(@"\n\n Warning: Saving of %@ failed: %@", document, error);
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITextFieldDelegate

// enable the return key on the alert view
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    UIAlertView *alertView = objc_getAssociatedObject(textField, &kPSCAlertViewKey);
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

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    NSMutableArray *filteredContent = [NSMutableArray array];

    if (searchText.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"self.title CONTAINS[cd] '%@'", searchText]];
        for (PSCSectionDescriptor *section in self.content) {
            [filteredContent addObjectsFromArray:[section.contentDescriptors filteredArrayUsingPredicate:predicate]];
        }
    }
    self.filteredContent = filteredContent;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Debug Helper

- (void)addDebugButtons {
#ifdef PSPDF_USE_SOURCE
    UIBarButtonItem *memoryButton = [[UIBarButtonItem alloc] initWithTitle:@"Memory" style:UIBarButtonItemStyleBordered target:self action:@selector(debugCreateLowMemoryWarning)];
    self.navigationItem.leftBarButtonItem = memoryButton;

    UIBarButtonItem *cacheButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear Cache" style:UIBarButtonItemStyleBordered target:self action:@selector(debugClearCache)];
    self.navigationItem.rightBarButtonItem = cacheButton;
#endif
}

// Only for debugging - this will get you rejected on the App Store!
- (void)debugCreateLowMemoryWarning {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [[UIApplication sharedApplication] performSelector:NSSelectorFromString(@"_performMemoryWarning")];
#pragma clang diagnostic pop

    // Clear any reference of items that would retain controllers/pages.
    [[UIMenuController sharedMenuController] setMenuItems:nil];
}

- (void)debugClearCache {
    [PSPDFRenderQueue.sharedRenderQueue cancelAllJobs];
    [PSPDFCache.sharedCache clearCache];
}

@end

// Fixes a behavior of UIModalPresentationFormSheet
// http://stackoverflow.com/questions/3372333/ipad-keyboard-will-not-dismiss-if-modal-view-controller-presentation-style-is-ui
@implementation UINavigationController (PSPDFKeyboardDismiss)
- (BOOL)disablesAutomaticKeyboardDismissal { return NO; }
@end
