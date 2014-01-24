//
//  PSCAnnotationsExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAnnotationsExample.h"
#import "PSCAssetLoader.h"
#import "PSCFileHelper.h"
#import "PSCEmbeddedAnnotationTestViewController.h"
#import "PSCExampleAnnotationViewController.h"
#import "PSCSaveAsPDFViewController.h"

@interface PSCAnnotationsWriteAnnotationsIntoThePDFExample () <PSPDFDocumentDelegate> {
    UISearchDisplayController *_searchDisplayController;
    BOOL _firstShown;
    BOOL _clearCacheNeeded;
}

@end

@implementation PSCAnnotationsWriteAnnotationsIntoThePDFExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Write annotations into the PDF";
        self.category = PSCExampleCategoryPDFAnnotations;
        self.priority = 10;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    NSURL *annotationSavingURL = [samplesURL URLByAppendingPathComponent:kHackerMagazineExample];
    //NSURL *annotationSavingURL = [samplesURL URLByAppendingPathComponent:kPaperExampleFileName];
    //NSURL *annotationSavingURL = [samplesURL URLByAppendingPathComponent:@"Form_AP_Stream.pdf"];
    
    // Copy file from the bundle to a location where we can write on it.
    NSURL *newURL = PSCCopyFileURLToDocumentFolderAndOverride(annotationSavingURL, NO);
    PSPDFDocument *document = [PSPDFDocument documentWithURL:newURL];
    document.annotationSaveMode = PSPDFAnnotationSaveModeEmbedded;
    
    // Allows to configure each annotation type.
    document.editableAnnotationTypes = [NSOrderedSet orderedSetWithObjects:
                                        PSPDFAnnotationStringLink, // not added by default.
                                        PSPDFAnnotationStringHighlight,
                                        PSPDFAnnotationStringUnderline,
                                        PSPDFAnnotationStringSquiggly,
                                        PSPDFAnnotationStringStrikeOut,
                                        PSPDFAnnotationStringNote,
                                        PSPDFAnnotationStringFreeText,
                                        PSPDFAnnotationStringInk,
                                        PSPDFAnnotationStringLine,
                                        PSPDFAnnotationStringSquare,
                                        PSPDFAnnotationStringCircle,
                                        PSPDFAnnotationStringSignature,
                                        PSPDFAnnotationStringStamp,
                                        PSPDFAnnotationStringImage,
                                        PSPDFAnnotationStringPolygon,
                                        PSPDFAnnotationStringPolyLine,
                                        PSPDFAnnotationStringSound,
                                        
                                        PSPDFAnnotationStringSelectionTool,
                                        PSPDFAnnotationStringEraser,
                                        PSPDFAnnotationStringSavedAnnotations,
                                        nil];
    document.delegate = self;
    return [[PSCEmbeddedAnnotationTestViewController alloc] initWithDocument:document];
}

@end

@implementation PSCAnnotationsPDFAnnotationWritingWithNSDataExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"PDF annotation writing with NSData";
        self.category = PSCExampleCategoryPDFAnnotations;
        self.priority = 20;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    
    NSData *PDFData = [NSData dataWithContentsOfURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
    PSPDFDocument *document = [PSPDFDocument documentWithData:PDFData];
    return [[PSCEmbeddedAnnotationTestViewController alloc] initWithDocument:document];
}

@end

@implementation PSCAnnotationsVerticalAlwaysVisibleAnnotationBarExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Vertical always-visible annotation bar";
        self.category = PSCExampleCategoryPDFAnnotations;
        self.priority = 30;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    NSURL *hackerMagURL = [samplesURL URLByAppendingPathComponent:kHackerMagazineExample];
    
    PSPDFDocument *document = [PSPDFDocument documentWithURL:hackerMagURL];
    PSPDFViewController *controller = [[PSCExampleAnnotationViewController alloc] initWithDocument:document];
    return controller;
}

@end

@implementation PSCAnnotationsCustomAnnotationsWithMultipleFilesExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Custom annotations with multiple files";
        self.category = PSCExampleCategoryPDFAnnotations;
        self.priority = 40;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    
    NSArray *files = @[@"A.pdf", @"B.pdf", @"C.pdf", @"D.pdf"];
    PSPDFDocument *document = [PSPDFDocument documentWithBaseURL:samplesURL files:files];
    
    // We're lazy here. 2 = UIViewContentModeScaleAspectFill
    PSPDFLinkAnnotation *aVideo = [[PSPDFLinkAnnotation alloc] initWithURLString:@"pspdfkit://[contentMode=2]localhost/Bundle/big_buck_bunny.mp4"];
    aVideo.boundingBox = [document pageInfoForPage:5].rotatedPageRect;
    aVideo.page = 5;
    [document addAnnotations:@[aVideo]];
    
    PSPDFLinkAnnotation *anImage = [[PSPDFLinkAnnotation alloc] initWithURLString:@"pspdfkit://[contentMode=2]localhost/Bundle/exampleImage.jpg"];
    anImage.boundingBox = [document pageInfoForPage:2].rotatedPageRect;
    anImage.page = 2;
    [document addAnnotations:@[anImage]];
    
    PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
    return controller;
}

@end

@implementation PSCAnnotationsProgramaticallyCreateAnnotationsExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Programmatically create annotations";
        self.category = PSCExampleCategoryPDFAnnotations;
        self.priority = 50;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    NSURL *hackerMagURL = [samplesURL URLByAppendingPathComponent:kHackerMagazineExample];
    
    // we use a NSData document here but it'll work even better with a file-based variant.
    PSPDFDocument *document = [PSPDFDocument documentWithData:[NSData dataWithContentsOfURL:hackerMagURL options:NSDataReadingMappedIfSafe error:NULL]];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;
    document.title = @"Programmatically create annotations";
    
    NSMutableArray *annotations = [NSMutableArray array];
    CGFloat maxHeight = [document pageInfoForPage:0].rotatedPageRect.size.height;
    for (int i=0; i<5; i++) {
        PSPDFNoteAnnotation *noteAnnotation = [PSPDFNoteAnnotation new];
        // width/height will be ignored for note annotations.
        noteAnnotation.boundingBox = (CGRect){CGPointMake(100.f, 50.f + i*maxHeight/5), PSPDFNoteAnnotationViewFixedSize};
        noteAnnotation.contents = [NSString stringWithFormat:@"Note %d", 5-i]; // notes are added bottom-up
        [annotations addObject:noteAnnotation];
    }
    [document addAnnotations:annotations];
    
    PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
    return controller;

}

@end

@implementation PSCAnnotationsAnnotationLinkstoExternalDocumentsExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Annotation Links to external documents";
        self.category = PSCExampleCategoryPDFAnnotations;
        self.priority = 60;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    
    PSPDFDocument *linkDocument = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"one.pdf"]];
    return [[PSPDFViewController alloc] initWithDocument:linkDocument];
}

@end

@implementation PSCAnnotationsSaveAsForAnnotationEditingExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Save as... for annotation editing";
        self.category = PSCExampleCategoryPDFAnnotations;
        self.priority = 70;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    
    NSURL *documentURL = [samplesURL URLByAppendingPathComponent:kHackerMagazineExample];
    NSURL *writableDocumentURL = PSCCopyFileURLToDocumentFolderAndOverride(documentURL, YES);
    PSPDFDocument *linkDocument = [PSPDFDocument documentWithURL:writableDocumentURL];
    return [[PSCSaveAsPDFViewController alloc] initWithDocument:linkDocument];
}

@end

@implementation PSCAnnotationsXFDFAnnotationProviderExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"XFDF Annotation Provider";
        self.category = PSCExampleCategoryPDFAnnotations;
        self.priority = 80;
    }
    return self;
}

// This example shows how you can create an XFDF provider instead of the default file-based one.
// XFDF is an industry standard and the file will be interopable with Adobe Acrobat or any other standard-compliant PDF framework.

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    NSURL *documentURL = [samplesURL URLByAppendingPathComponent:kHackerMagazineExample];
    //NSURL *documentURL = [samplesURL URLByAppendingPathComponent:@"Testcase_Form_YesNo.pdf"];

    // Load from an example XFDF file.
    NSString *docsFolder = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSURL *fileXML = [NSURL fileURLWithPath:[docsFolder stringByAppendingPathComponent:@"XFDFTest.xfdf"]];
    NSLog(@"Using XFDF file at %@", fileXML.path);
    
    // Create an example XFDF from the current document if one doesn't already exist.
    //[NSFileManager.defaultManager removeItemAtURL:fileXML error:NULL]; // DEBUG HELPER: delete existing file.
    if (![NSFileManager.defaultManager fileExistsAtPath:fileXML.path]) {
        // Collect all existing annotations from the document
        PSPDFDocument *tempDocument = [PSPDFDocument documentWithURL:documentURL];
        NSMutableArray *annotations = [NSMutableArray array];
        for (NSArray *pageAnnots in [tempDocument allAnnotationsOfType:PSPDFAnnotationTypeAll].allValues) {
            [annotations addObjectsFromArray:pageAnnots];
        }
        // Write the file
        NSError *error = nil;
        NSOutputStream *outputStream = [NSOutputStream outputStreamWithURL:fileXML append:NO];
        if (![[PSPDFXFDFWriter new] writeAnnotations:annotations toOutputStream:outputStream documentProvider:tempDocument.documentProviders[0] error:&error]) {
            NSLog(@"Failed to write XFDF file: %@", error.localizedDescription);
        }
        [outputStream close];
    }
    
    // Create document and set up the XFDF provider
    PSPDFDocument *document = [PSPDFDocument documentWithURL:documentURL];
    document.annotationSaveMode = PSPDFAnnotationSaveModeExternalFile;
    [document setDidCreateDocumentProviderBlock:^(PSPDFDocumentProvider *documentProvider) {
        PSPDFXFDFAnnotationProvider *XFDFProvider = [[PSPDFXFDFAnnotationProvider alloc] initWithDocumentProvider:documentProvider fileURL:fileXML];
        documentProvider.annotationManager.annotationProviders = @[XFDFProvider];
    }];
    
    return [[PSPDFViewController alloc] initWithDocument:document];
}

@end

@implementation PSCAnnotationsXFDFWritingExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"XFDF Writing";
        self.category = PSCExampleCategoryPDFAnnotations;
        self.priority = 90;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    NSURL *documentURL = [samplesURL URLByAppendingPathComponent:@"Annotation Test.pdf"];
    
    NSString *docsFolder = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSURL *fileXML = [NSURL fileURLWithPath:[docsFolder stringByAppendingPathComponent:@"XFDFTest.xfdf"]];
    NSLog(@"fileXML: %@",fileXML);
    
    // Collect all existing annotations from the document
    PSPDFDocument *tempDocument = [PSPDFDocument documentWithURL:documentURL];
    NSMutableArray *annotations = [NSMutableArray array];
    
    
    PSPDFLinkAnnotation *linkAnnotation = [[PSPDFLinkAnnotation alloc] initWithURLString:@"http://pspdfkit.com"];
    linkAnnotation.boundingBox = CGRectMake(100, 80, 200, 300);
    linkAnnotation.page = 1;
    [annotations addObject:linkAnnotation];
    
    PSPDFLinkAnnotation *aStream = [[PSPDFLinkAnnotation alloc] initWithURLString:@"pspdfkit://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"];
    aStream.boundingBox = CGRectMake(100, 100, 200, 300);
    aStream.page = 0;
    [annotations addObject:aStream];
    
    //        PSPDFLinkAnnotation *anImage = [[PSPDFLinkAnnotation alloc] initWithURLString:@"pspdfkit://[contentMode=2]localhost/Bundle/exampleImage.jpg"];
    PSPDFLinkAnnotation *anImage = [[PSPDFLinkAnnotation alloc] initWithURLString:@"pspdfkit://ramitia.files.wordpress.com/2011/05/durian1.jpg"];
    anImage.boundingBox = CGRectMake(100, 100, 200, 300);
    anImage.page = 3;
    [annotations addObject:anImage];
    
    
    PSPDFLinkAnnotation *aVideo2 = [[PSPDFLinkAnnotation alloc] initWithURLString:@"pspdfkit://[autostart:true]localhost/Bundle/big_buck_bunny.mp4"];
    aVideo2.boundingBox = CGRectMake(100, 100, 200, 300);
    aVideo2.page = 2;
    [annotations addObject:aVideo2];
    
    PSPDFLinkAnnotation *anImage3 = [[PSPDFLinkAnnotation alloc] initWithLinkAnnotationType:PSPDFLinkAnnotationImage];
    anImage3.URL = [NSURL URLWithString:[NSString stringWithFormat:@"pspdfkit://[contentMode=%zd]ramitia.files.wordpress.com/2011/05/durian1.jpg", UIViewContentModeScaleAspectFill]];
    anImage3.boundingBox = CGRectMake(100, 100, 200, 300);
    anImage3.page = 4;
    [annotations addObject:anImage3];
    
    NSLog(@"annotations: %@", annotations);
    
    // Write the file
    NSError *error = nil;
    NSOutputStream *outputStream = [NSOutputStream outputStreamWithURL:fileXML append:NO];
    if (![[PSPDFXFDFWriter new] writeAnnotations:annotations toOutputStream:outputStream documentProvider:tempDocument.documentProviders[0] error:&error]) {
        NSLog(@"Failed to write XFDF file: %@", error.localizedDescription);
    }
    [outputStream close];
    
    // Create document and set up the XFDF provider
    PSPDFDocument *document = [PSPDFDocument documentWithURL:documentURL];
    [document setDidCreateDocumentProviderBlock:^(PSPDFDocumentProvider *documentProvider) {
        PSPDFXFDFAnnotationProvider *XFDFProvider = [[PSPDFXFDFAnnotationProvider alloc] initWithDocumentProvider:documentProvider fileURL:fileXML];
        documentProvider.annotationManager.annotationProviders = @[XFDFProvider];
    }];
    
    return [[PSPDFViewController alloc] initWithDocument:document];
}

@end






