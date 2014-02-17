//
//  PSCDocumentDataProviders.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCDocumentDataProvidersExample.h"
#import "PSCAssetLoader.h"
#import "PSCFileHelper.h"

@implementation PSCDocumentDataProvidersNSURLExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"NSURL";
        self.category = PSCExampleCategoryDocumentDataProvider;
        self.priority = 10;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
    controller.rightBarButtonItems = @[controller.emailButtonItem, controller.printButtonItem, controller.searchButtonItem, controller.outlineButtonItem, controller.viewModeButtonItem];
    return controller;
}

@end

@implementation PSCDocumentDataProvidersNSDataExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"NSData";
        self.category = PSCExampleCategoryDocumentDataProvider;
        self.priority = 20;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    NSURL *hackerMagURL = [samplesURL URLByAppendingPathComponent:kHackerMagazineExample];
    
    NSData *data = [NSData dataWithContentsOfMappedFile:[hackerMagURL path]];
    PSPDFDocument *document = [PSPDFDocument documentWithData:data];
    document.title = @"NSData PDF";
    PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
    controller.rightBarButtonItems = @[controller.emailButtonItem, controller.searchButtonItem, controller.outlineButtonItem, controller.viewModeButtonItem];
    return controller;
}

@end

@implementation PSCDocumentDataProvidersCGDocumentProviderExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"CGDocumentProvider";
        self.category = PSCExampleCategoryDocumentDataProvider;
        self.priority = 30;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    NSURL *hackerMagURL = [samplesURL URLByAppendingPathComponent:kHackerMagazineExample];
    
    NSData *data = [NSData dataWithContentsOfURL:hackerMagURL options:NSDataReadingMappedIfSafe error:NULL];
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((CFDataRef)(data));
    PSPDFDocument *document = [PSPDFDocument documentWithDataProvider:dataProvider];
    document.title = @"CGDataProviderRef PDF";
    CGDataProviderRelease(dataProvider);
    PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
    controller.rightBarButtonItems = @[controller.emailButtonItem, controller.searchButtonItem, controller.outlineButtonItem, controller.viewModeButtonItem];
    return controller;
}

@end

@implementation PSCDocumentDataProvidersMultipleFilesExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"MultipleFiles";
        self.category = PSCExampleCategoryDocumentDataProvider;
        self.priority = 40;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    
    NSArray *files = @[@"A.pdf", @"B.pdf", @"C.pdf", @"D.pdf"];
    PSPDFDocument *document = [PSPDFDocument documentWithBaseURL:samplesURL files:files];
    PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
    controller.rightBarButtonItems = @[controller.searchButtonItem, controller.outlineButtonItem, controller.annotationButtonItem, controller.viewModeButtonItem];
    controller.additionalBarButtonItems = @[controller.openInButtonItem, controller.emailButtonItem];
    return controller;
}

@end

@implementation PSCDocumentDataProvidersMultipleNSDataObjectsMemoryMappedExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Multiple NSData objects (memory mapped)";
        self.category = PSCExampleCategoryDocumentDataProvider;
        self.priority = 50;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    
    static PSPDFDocument *document = nil;
    if (!document) {
        NSURL *file1 = [samplesURL URLByAppendingPathComponent:@"A.pdf"];
        NSURL *file2 = [samplesURL URLByAppendingPathComponent:@"B.pdf"];
        NSURL *file3 = [samplesURL URLByAppendingPathComponent:@"C.pdf"];
        NSData *data1 = [NSData dataWithContentsOfURL:file1 options:NSDataReadingMappedIfSafe error:NULL];
        NSData *data2 = [NSData dataWithContentsOfURL:file2 options:NSDataReadingMappedIfSafe error:NULL];
        NSData *data3 = [NSData dataWithContentsOfURL:file3 options:NSDataReadingMappedIfSafe error:NULL];
        document = [PSPDFDocument documentWithDataArray:@[data1, data2, data3]];
    }else {
        // this is not needed, just an example how to use the changed dataArray (the data will be changed when annotations are written back)
        document = [PSPDFDocument documentWithDataArray:document.dataArray];
    }
    
    // make sure your NSData objects are either small or memory mapped; else you're getting into memory troubles.
    PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
    controller.rightBarButtonItems = @[controller.annotationButtonItem, controller.searchButtonItem, controller.viewModeButtonItem];
    controller.additionalBarButtonItems = @[controller.openInButtonItem, controller.emailButtonItem];
    return controller;

}

@end

@implementation PSCDocumentDataProvidersMultipleNSDataObjectsExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Multiple NSData objects";
        self.category = PSCExampleCategoryDocumentDataProvider;
        self.priority = 60;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    
    PSPDFDocument *document = nil;
    if (!document) {
        NSURL *file1 = [samplesURL URLByAppendingPathComponent:@"A.pdf"];
        NSURL *file2 = [samplesURL URLByAppendingPathComponent:@"B.pdf"];
        NSURL *file3 = [samplesURL URLByAppendingPathComponent:@"C.pdf"];
        NSData *data1 = [NSData dataWithContentsOfURL:file1];
        NSData *data2 = [NSData dataWithContentsOfURL:file2];
        NSData *data3 = [NSData dataWithContentsOfURL:file3];
        document = [PSPDFDocument documentWithDataArray:@[data1, data2, data3]];
    }
    
    document.annotationSaveMode = PSPDFAnnotationSaveModeExternalFile;
    
    // make sure your NSData objects are either small or memory mapped; else you're getting into memory troubles.
    PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
    controller.rightBarButtonItems = @[controller.annotationButtonItem, controller.searchButtonItem, controller.viewModeButtonItem];
    controller.additionalBarButtonItems = @[controller.openInButtonItem, controller.emailButtonItem];
    return controller;
    
}

@end

@implementation PSCDocumentDataProvidersMultipleNSDataObjectsMergedExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Multiple NSData objects (merged)";
        self.category = PSCExampleCategoryDocumentDataProvider;
        self.priority = 70;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    
    NSArray *fileNames = @[@"A.pdf", @"B.pdf", @"C.pdf"];
    //NSArray *fileNames = @[@"Test6.pdf", @"Test5.pdf", @"Test4.pdf", @"Test1.pdf", @"Test2.pdf", @"Test3.pdf", @"rotated-northern.pdf", @"A.pdf", @"rotated360degrees.pdf", @"Rotated PDF.pdf"];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSString *fileName in fileNames) {
        NSURL *file = [samplesURL URLByAppendingPathComponent:fileName];
        NSData *data = [NSData dataWithContentsOfURL:file];
        [dataArray addObject:data];
    }
    PSPDFDocument *document = [PSPDFDocument documentWithDataArray:dataArray];
    
    // Here we combine the NSData pieces in the PSPDFDocument into one piece of NSData (for sharing)
    NSDictionary *options = @{PSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeNone & ~PSPDFAnnotationTypeLink)};
    NSData *consolidatedData = [PSPDFProcessor.defaultProcessor generatePDFFromDocument:document pageRanges:@[[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)]] options:options progressBlock:NULL error:NULL];
    PSPDFDocument *documentWithConsolidatedData = [PSPDFDocument documentWithData:consolidatedData];
    
    PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:documentWithConsolidatedData];
    controller.rightBarButtonItems = @[controller.annotationButtonItem, controller.searchButtonItem, controller.viewModeButtonItem];
    controller.additionalBarButtonItems = @[controller.openInButtonItem, controller.emailButtonItem];
    return controller;
    
}

@end

@implementation PSCDocumentDataProvidersExtractSinglePagesExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Extract single pages with PSPDFProcessor";
        self.category = PSCExampleCategoryDocumentDataProvider;
        self.priority = 80;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    
    PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
    
    // Here we combine the NSData pieces in the PSPDFDocument into one piece of NSData (for sharing)
    NSMutableIndexSet *pageIndexes = [[NSMutableIndexSet alloc] initWithIndex:1];
    [pageIndexes addIndex:3];
    [pageIndexes addIndex:5];
    
    // Extract pages into new document
    NSData *newDocumentData = [PSPDFProcessor.defaultProcessor generatePDFFromDocument:document pageRanges:@[pageIndexes] options:nil progressBlock:NULL error:NULL];
    
    // add a page from a second document
    PSPDFDocument *landscapeDocument = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
    NSData *newLandscapeDocumentData = [PSPDFProcessor.defaultProcessor generatePDFFromDocument:landscapeDocument pageRanges:@[[NSIndexSet indexSetWithIndex:0]] options:nil progressBlock:NULL error:NULL];
    
    // merge into new PDF
    PSPDFDocument *twoPartDocument = [PSPDFDocument documentWithDataArray:@[newDocumentData, newLandscapeDocumentData]];
    NSData *mergedDocumentData = [PSPDFProcessor.defaultProcessor generatePDFFromDocument:twoPartDocument pageRanges:@[[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, twoPartDocument.pageCount)]] options:nil progressBlock:NULL error:NULL];
    PSPDFDocument *mergedDocument = [PSPDFDocument documentWithData:mergedDocumentData];
    
    // Note: PSPDFDocument supports having multiple data sources right from the start, this is just to demonstrate how to generate a new, single PDF from PSPDFDocument sources.
    
    PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:mergedDocument];
    return controller;
    
}

@end

@implementation PSCDocumentDataProvidersExtractSinglePagesFastExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Extract single pages with PSPDFProcessor, the fast way";
        self.category = PSCExampleCategoryDocumentDataProvider;
        self.priority = 90;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    
    PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
    document.undoEnabled = NO; // faster!

    // Here we use the `pageRange` feature to skip the intermediate `NSDate` objects we had to create in the last example.
    NSMutableIndexSet *pageIndexes = [[NSMutableIndexSet alloc] initWithIndex:1];
    [pageIndexes addIndex:3];
    [pageIndexes addIndex:5];
    [pageIndexes addIndex:document.pageCount + 3]; // next document!
    
    [document appendFile:kPaperExampleFileName]; // Append second file
    document.pageRange = pageIndexes;    // Define new page range.

    // Merge pages into new document.
    NSURL *tempURL = PSCTempFileURLWithPathExtension(@"temp", @"pdf");
    [PSPDFProcessor.defaultProcessor generatePDFFromDocument:document pageRanges:@[[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)]] outputFileURL:tempURL options:nil progressBlock:NULL error:NULL];
    PSPDFDocument *mergedDocument = [PSPDFDocument documentWithURL:tempURL];

    // Note: `PSPDFDocument` supports having multiple data sources right from the start, this is just to demonstrate how to generate a new, single PDF from `PSPDFDocument` sources.
    PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:mergedDocument];
    return controller;
}

@end

//@implementation PSCDocumentDataProvidersMergeLandscapeWithPortraitPageExample
//
/////////////////////////////////////////////////////////////////////////////////////////////
//#pragma mark - PSCExample
//
//- (id)init {
//    if (self = [super init]) {
//        self.title = @"Merge landscape with portrait page";
//        self.category = PSCExampleCategoryDocumentDataProvider;
//        self.priority = 100;
//    }
//    return self;
//}
//
//- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
//    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
//    
//    PSPDFDocument *document = [PSPDFDocument documentWithBaseURL:samplesURL files:@[@"Testcase_consolidate_A.pdf", @"Testcase_consolidate_B.pdf"]];
//    NSMutableIndexSet *pageRange = [NSMutableIndexSet indexSetWithIndex:0];
//    [pageRange addIndex:5];
//    document.pageRange = pageRange;
//    
//    // Merge pages into new document.
//    NSURL *tempURL = PSCTempFileURLWithPathExtension(@"temp-merged", @"pdf");
//    [PSPDFProcessor.defaultProcessor generatePDFFromDocument:document pageRange:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)] outputFileURL:tempURL options:nil progressBlock:NULL error:NULL];
//    PSPDFDocument *mergedDocument = [PSPDFDocument documentWithURL:tempURL];
//    PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:mergedDocument];
//    return controller;
//    
//}
//
//@end
