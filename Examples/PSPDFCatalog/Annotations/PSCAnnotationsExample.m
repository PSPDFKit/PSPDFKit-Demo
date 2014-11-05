//
//  PSCAnnotationsExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"
#import "PSCFileHelper.h"
#import "PSCEmbeddedAnnotationTestViewController.h"

@interface PSCAnnotationsWriteAnnotationsIntoThePDFExample : PSCExample @end
@interface PSCAnnotationsPDFAnnotationWritingWithNSDataExample : PSCExample @end
@interface PSCAnnotationsCustomAnnotationsWithMultipleFilesExample : PSCExample @end
@interface PSCAnnotationsProgramaticallyCreateAnnotationsExample : PSCExample @end
@interface PSCAnnotationsAnnotationLinkstoExternalDocumentsExample : PSCExample @end
@interface PSCAnnotationsXFDFWritingExample : PSCExample @end

@interface PSCAnnotationsWriteAnnotationsIntoThePDFExample () <PSPDFDocumentDelegate> {
    UISearchDisplayController *_searchDisplayController;
    BOOL _firstShown;
    BOOL _clearCacheNeeded;
}
@end

@implementation PSCAnnotationsWriteAnnotationsIntoThePDFExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Write annotations into the PDF";
        self.category = PSCExampleCategoryAnnotations;
        self.priority = 1;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    NSURL *annotationSavingURL = [samplesURL URLByAppendingPathComponent:PSPDFQuickStartAsset];
    //NSURL *annotationSavingURL = [samplesURL URLByAppendingPathComponent:PSPDFDeveloperGuideAsset];
    //NSURL *annotationSavingURL = [samplesURL URLByAppendingPathComponent:@"news-portrait.pdf"];

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

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"PDF annotation writing with NSData";
        self.category = PSCExampleCategoryAnnotations;
        self.priority = 410;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    NSData *PDFData = [NSData dataWithContentsOfURL:[samplesURL URLByAppendingPathComponent:PSPDFHackerMagazineAsset]];
    PSPDFDocument *document = [PSPDFDocument documentWithData:PDFData];
    return [[PSCEmbeddedAnnotationTestViewController alloc] initWithDocument:document];
}

@end


@implementation PSCAnnotationsCustomAnnotationsWithMultipleFilesExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Custom annotations with multiple files";
        self.category = PSCExampleCategoryAnnotations;
        self.priority = 400;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];

    NSArray *files = @[@"A.pdf", @"B.pdf", @"C.pdf", @"D.pdf"];
    PSPDFDocument *document = [PSPDFDocument documentWithBaseURL:samplesURL files:files];

    // We're lazy here. 2 = UIViewContentModeScaleAspectFill
    PSPDFLinkAnnotation *aVideo = [[PSPDFLinkAnnotation alloc] initWithURL:[NSURL URLWithString:@"pspdfkit://[contentMode=2]localhost/Bundle/big_buck_bunny.mp4"]];
    aVideo.boundingBox = [document pageInfoForPage:5].rotatedRect;
    aVideo.page = 5;
    [document addAnnotations:@[aVideo]];

    PSPDFLinkAnnotation *anImage = [[PSPDFLinkAnnotation alloc] initWithURL:[NSURL URLWithString:@"pspdfkit://[contentMode=2]localhost/Bundle/exampleImage.jpg"]];
    anImage.boundingBox = [document pageInfoForPage:2].rotatedRect;
    anImage.page = 2;
    [document addAnnotations:@[anImage]];

    PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
    return controller;
}

@end

@implementation PSCAnnotationsProgramaticallyCreateAnnotationsExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Programmatically create annotations";
        self.category = PSCExampleCategoryAnnotations;
        self.priority = 500;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    NSURL *hackerMagURL = [samplesURL URLByAppendingPathComponent:PSPDFHackerMagazineAsset];

    // we use a NSData document here but it'll work even better with a file-based variant.
    PSPDFDocument *document = [PSPDFDocument documentWithData:[NSData dataWithContentsOfURL:hackerMagURL options:NSDataReadingMappedIfSafe error:NULL]];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;
    document.title = @"Programmatically create annotations";

    NSMutableArray *annotations = [NSMutableArray array];
    CGFloat maxHeight = [document pageInfoForPage:0].rotatedRect.size.height;
    for (int i=0; i<5; i++) {
        PSPDFNoteAnnotation *noteAnnotation = [PSPDFNoteAnnotation new];
        // width/height will be ignored for note annotations.
        noteAnnotation.boundingBox = CGRectMake(100.f, 50.f + i*maxHeight/5, 32.f, 32.f);
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

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Annotation Links to external documents";
        self.contentDescription = @"PDF links can point to pages within the same document, or also different documents or websites.";
        self.category = PSCExampleCategoryAnnotations;
        self.priority = 600;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:@"one.pdf"];
    return [[PSPDFViewController alloc] initWithDocument:document];
}

@end

@implementation PSCAnnotationsXFDFWritingExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"XFDF Writing";
        self.contentDescription = @"Custom code that creates annotations in code and exports them as XFDF.";
        self.category = PSCExampleCategoryAnnotations;
        self.priority = 900;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    NSURL *documentURL = [samplesURL URLByAppendingPathComponent:@"Annotation Test.pdf"];

    NSString *docsFolder = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSURL *fileXML = [NSURL fileURLWithPath:[docsFolder stringByAppendingPathComponent:@"XFDFTest.xfdf"]];
    NSLog(@"fileXML: %@",fileXML);

    // Collect all existing annotations from the document
    PSPDFDocument *tempDocument = [PSPDFDocument documentWithURL:documentURL];
    NSMutableArray *annotations = [NSMutableArray array];


    PSPDFLinkAnnotation *linkAnnotation = [[PSPDFLinkAnnotation alloc] initWithURL:[NSURL URLWithString:@"http://pspdfkit.com"]];
    linkAnnotation.boundingBox = CGRectMake(100.f, 80.f, 200.f, 300.f);
    linkAnnotation.page = 1;
    [annotations addObject:linkAnnotation];

    PSPDFLinkAnnotation *aStream = [[PSPDFLinkAnnotation alloc] initWithURL:[NSURL URLWithString:@"pspdfkit://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"]];
    aStream.boundingBox = CGRectMake(100.f, 100.f, 200.f, 300.f);
    aStream.page = 0;
    [annotations addObject:aStream];

    PSPDFLinkAnnotation *anImage = [[PSPDFLinkAnnotation alloc] initWithURL:[NSURL URLWithString:@"pspdfkit://ramitia.files.wordpress.com/2011/05/durian1.jpg"]];
    anImage.boundingBox = CGRectMake(100.f, 100.f, 200.f, 300.f);
    anImage.page = 3;
    [annotations addObject:anImage];


    PSPDFLinkAnnotation *aVideo2 = [[PSPDFLinkAnnotation alloc] initWithURL:[NSURL URLWithString:@"pspdfkit://[autostart:true]localhost/Bundle/big_buck_bunny.mp4"]];
    aVideo2.boundingBox = CGRectMake(100.f, 100.f, 200.f, 300.f);
    aVideo2.page = 2;
    [annotations addObject:aVideo2];

    PSPDFLinkAnnotation *anImage3 = [[PSPDFLinkAnnotation alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"pspdfkit://[contentMode=%zd]ramitia.files.wordpress.com/2011/05/durian1.jpg", UIViewContentModeScaleAspectFill]]];
    anImage3.linkType = PSPDFLinkAnnotationImage;
    anImage3.boundingBox = CGRectMake(100.f, 100.f, 200.f, 300.f);
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
