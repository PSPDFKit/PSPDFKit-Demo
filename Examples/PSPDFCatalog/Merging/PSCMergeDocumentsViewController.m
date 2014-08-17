//
//  PSCMergeDocumentsViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCMergeDocumentsViewController.h"
#import "PSCCoreDataAnnotationProvider.h"
#import "PSCFileHelper.h"

#define PSCCoreDataAnnotationProviderEnabled

@interface PSCMergePDFViewController : PSPDFViewController @end

@interface PSCMergeDocumentsViewController () <PSPDFDocumentPickerControllerDelegate>
@property (nonatomic, strong) PSPDFDocument *leftDocument;
@property (nonatomic, strong) PSPDFDocument *rightDocument;
@property (nonatomic, strong) UINavigationController *leftNavigator;
@property (nonatomic, strong) UINavigationController *rightNavigator;
@property (nonatomic, strong) PSCMergePDFViewController *leftController;
@property (nonatomic, strong) PSCMergePDFViewController *rightController;
@end

#ifdef PSCCoreDataAnnotationProviderEnabled
// After we split the document into single pages, we have one provider per page.
// We still want to use our original database - thus we need a provider that translates to the global one.
@interface PSCPagedCoreDataAnnotationProvider : NSObject <PSPDFAnnotationProvider>
- (instancetype)initWithDocumentProvider:(PSPDFDocumentProvider *)documentProvider NS_DESIGNATED_INITIALIZER;
// Associated documentProvider.
@property (nonatomic, weak) PSPDFDocumentProvider *documentProvider;
@end
#endif

// If we use core data and split the document into single pages, we need a global provider since there is only one database, but there is one annotation provider per page afterwards.
#import <objc/runtime.h>
const char *PSCCoreDataAnnotationProviderStorageKey;
static PSCCoreDataAnnotationProvider *PSCCoreDataAnnotationProviderForDocument(PSPDFDocument *document) {
    return document ? objc_getAssociatedObject(document, &PSCCoreDataAnnotationProviderStorageKey) : nil;
}

@implementation PSCMergeDocumentsViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (instancetype)initWithLeftDocument:(PSPDFDocument *)leftDocument rightDocument:(PSPDFDocument *)rightDocument {
    if (self = [super init]) {
        _leftDocument = leftDocument;
        _rightDocument = rightDocument;
        self.edgesForExtendedLayout = UIRectEdgeAll & ~UIRectEdgeTop;
        self.title = @"Merge Documents";
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Initialize left controller.
    self.leftController = [[PSCMergePDFViewController alloc] initWithDocument:self.leftDocument];
    self.leftController.title = @"Their Version";
    self.leftNavigator = [[UINavigationController alloc] initWithRootViewController:self.leftController];
    self.leftNavigator.view.tintColor = self.navigationController.navigationBar.barTintColor;
    [self addChildViewController:self.leftNavigator];
    [self.view addSubview:self.leftNavigator.view];
    [self.leftNavigator didMoveToParentViewController:self];

    // Initialize right controller.
    self.rightController = [[PSCMergePDFViewController alloc] initWithDocument:self.rightDocument];
    self.rightController.title = @"Your Version";
    self.rightNavigator = [[UINavigationController alloc] initWithRootViewController:self.rightController];
    self.rightNavigator.view.tintColor = self.navigationController.navigationBar.barTintColor;
    [self addChildViewController:self.rightNavigator];
    [self.view addSubview:self.rightNavigator.view];
    [self.rightNavigator didMoveToParentViewController:self];

    // Allow to change source document.
    UIBarButtonItem *loadDocumentButton = [[UIBarButtonItem alloc] initWithTitle:@"Source" style:UIBarButtonItemStyleBordered target:self action:@selector(selectLeftSource:)];
    self.leftController.leftBarButtonItems = @[loadDocumentButton];

    // Allow to save document
    UIBarButtonItem *saveDocument = [[UIBarButtonItem alloc] initWithTitle:@"Save Document" style:UIBarButtonItemStyleBordered target:self action:@selector(saveDocument)];
    self.rightController.leftBarButtonItems = @[saveDocument];

    // Page modification bar
    UIBarButtonItem *addPage = [[UIBarButtonItem alloc] initWithTitle:@"Add Page" style:UIBarButtonItemStyleBordered target:self action:@selector(addPage)];
    UIBarButtonItem *replacePage = [[UIBarButtonItem alloc] initWithTitle:@"Replace Page" style:UIBarButtonItemStyleBordered target:self action:@selector(replacePage)];
    UIBarButtonItem *removePage = [[UIBarButtonItem alloc] initWithTitle:@"Remove Page" style:UIBarButtonItemStyleBordered target:self action:@selector(removePage)];

    UIBarButtonItem *mergeAnnotations = [[UIBarButtonItem alloc] initWithTitle:@"Merge Annotations" style:UIBarButtonItemStyleBordered target:self action:@selector(mergeAnnotations)];
    UIBarButtonItem *replaceAnnotations = [[UIBarButtonItem alloc] initWithTitle:@"Replace Annotations" style:UIBarButtonItemStyleBordered target:self action:@selector(replaceAnnotations)];

    UIBarButtonItem *spacing = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL];
    spacing.width = 30.f;
    self.navigationItem.rightBarButtonItems = @[removePage, replacePage, addPage, spacing, replaceAnnotations, mergeAnnotations];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    // lay out controllers next to each other.
    CGRect bounds = self.view.bounds;
    self.leftNavigator.view.frame  = CGRectMake(0, 0, bounds.size.width/2, bounds.size.height);
    self.rightNavigator.view.frame = CGRectMake(bounds.size.width/2, 0, bounds.size.width/2, bounds.size.height);
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Properties

- (void)setLeftDocument:(PSPDFDocument *)leftDocument {
    if (leftDocument != _leftDocument) {
        _leftDocument = leftDocument;
        self.leftController.document = leftDocument;
    }
}

- (void)setRightDocument:(PSPDFDocument *)rightDocument {
    if (rightDocument != _rightDocument) {
        _rightDocument = rightDocument;
        self.rightController.document = rightDocument;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Actions

- (void)addPage {
    [self updateDocumentWithMutatingFiles:^(NSMutableArray *files) {
        NSString *newFile = self.leftDocument.files[self.leftController.page];
        [files insertObject:newFile atIndex:self.rightController.page];

#ifdef PSCCoreDataAnnotationProviderEnabled
        // If we have a database backend store, we need to move around all annotations.
        PSCCoreDataAnnotationProvider *coreDataProvider = PSCCoreDataAnnotationProviderForDocument(self.rightController.document);
        [coreDataProvider insertPagesAtRange:NSMakeRange(self.rightController.page, 1)];
#endif
    }];
}

// Replace visble page on the left with the right one.
- (void)replacePage {
    [self updateDocumentWithMutatingFiles:^(NSMutableArray *files) {
        NSString *replacementFile = self.leftDocument.files[self.leftController.page];
        files[self.rightController.page] = replacementFile;
    }];
}

- (void)removePage {
    [self updateDocumentWithMutatingFiles:^(NSMutableArray *files) {
        [files removeObjectAtIndex:self.rightController.page];

#ifdef PSCCoreDataAnnotationProviderEnabled
        // If we have a database backend store, we need to move around all annotations.
        PSCCoreDataAnnotationProvider *coreDataProvider = PSCCoreDataAnnotationProviderForDocument(self.rightController.document);
        [coreDataProvider deletePagesInRange:NSMakeRange(self.rightController.page, 1)];
#endif
    }];
}

- (void)updateDocumentWithMutatingFiles:(void (^)(NSMutableArray *files))fileMutationBlock {
    [self.rightDocument saveAnnotationsWithError:NULL]; // always save.
    [self splitAllDocumentsIfRequired];

    NSMutableArray *files = [self.rightDocument.files mutableCopy];
    fileMutationBlock(files);

    // Create new document and preserve the provider customization block.
    PSPDFDocument *newDocument = [PSPDFDocument documentWithBaseURL:self.rightDocument.baseURL files:files];
    newDocument.UID = self.rightDocument.UID; // Preserve the UID for the annotation store.
    newDocument.didCreateDocumentProviderBlock = self.rightDocument.didCreateDocumentProviderBlock;

    // Clear old cache. This is not required, but a good thing to do.
    // The new document will have a new autogenerated UID since the files array changed.
    [PSPDFCache.sharedCache removeCacheForDocument:self.rightDocument deleteDocument:NO error:NULL];

    [self performWithPreservingPages:^{
        self.rightDocument = newDocument;
    }];
}

- (void)mergeAnnotations {
    NSUInteger page = self.rightController.page;

    // Build set of current annotation names.
    NSArray *currentAnnotations = [self.rightDocument annotationsForPage:page type:PSPDFAnnotationTypeAll & ~PSPDFAnnotationTypeLink];
    NSMutableSet *currentNames = [NSMutableSet set];
    for (PSPDFAnnotation *currentAnnotation in currentAnnotations) {
        if (currentAnnotation.name.length > 0) [currentNames addObject:currentAnnotation.name];
    }

    // Extract annotations from left document.
    NSArray *newAnnotations = [self.leftDocument annotationsForPage:self.leftController.page type:PSPDFAnnotationTypeAll & ~PSPDFAnnotationTypeLink];
    for (PSPDFAnnotation *annotation in newAnnotations) {
        // Check if we already have an annotation with the same name in the document, and delete if so.
        if ([currentNames containsObject:annotation.name]) {
            for (PSPDFAnnotation *currentAnnotation in currentAnnotations) {
                if ([currentAnnotation.name isEqualToString:annotation.name]) {
                    [self.rightDocument removeAnnotations:@[currentAnnotation]];
                    break;
                }
            }
        }

        // Copy annotation object - else we would remove them from the current document.
        PSPDFAnnotation *copiedAnnotation = [annotation copy];
        copiedAnnotation.documentProvider = nil; // separate from old document.
        copiedAnnotation.absolutePage = page;
        [self.rightDocument addAnnotations:@[copiedAnnotation]];
    }
}

- (void)clearAnnotations {
    // Clear all current annotations (except links)
    NSArray *currentAnnotations = [self.rightDocument annotationsForPage:self.rightController.page type:PSPDFAnnotationTypeAll & ~PSPDFAnnotationTypeLink];
    [self.rightDocument removeAnnotations:currentAnnotations];
}

- (void)replaceAnnotations {
    [self clearAnnotations];
    [self mergeAnnotations];
}

- (void)saveDocument {
    // Save current and create the new document.
    [self.rightDocument saveAnnotationsWithError:NULL];
    [self.rightController reloadData];

    NSURL *savedDocumentURL = PSCTempFileURLWithPathExtension(@"final", @"pdf");
    [PSPDFProcessor.defaultProcessor generatePDFFromDocument:self.rightDocument pageRanges:@[[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.rightDocument.pageCount)]] outputFileURL:savedDocumentURL options:@{PSPDFProcessorAnnotationAsDictionary : @YES, PSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeAll)} progressBlock:NULL error:NULL];

    // Present the new document.
    PSPDFDocument *savedDocument = [PSPDFDocument documentWithURL:savedDocumentURL];
    PSPDFViewController *resultController = [[PSPDFViewController alloc] initWithDocument:savedDocument];
    resultController.rightBarButtonItems = @[resultController.openInButtonItem, resultController.emailButtonItem, resultController.outlineButtonItem, resultController.searchButtonItem, resultController.viewModeButtonItem];
    UINavigationController *resultsNavController = [[UINavigationController alloc] initWithRootViewController:resultController];
    [self.navigationController presentViewController:resultsNavController animated:YES completion:NULL];
}

- (void)selectLeftSource:(id)sender {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    PSPDFDocumentPickerController *documentPicker = [[PSPDFDocumentPickerController alloc] initWithDirectory:samplesURL.path includeSubdirectories:NO library:Nil delegate:self];
    [self.leftController presentModalOrInPopover:documentPicker embeddedInNavigationController:YES withCloseButton:NO animated:YES sender:sender options:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)performWithPreservingPages:(dispatch_block_t)block {
    NSUInteger leftPage  = self.leftController.page;
    NSUInteger rightPage = self.rightController.page;
    block();
    self.leftController.page = leftPage;
    self.rightController.page = rightPage;
}

- (void)splitAllDocumentsIfRequired {
    [self performWithPreservingPages:^{
        // Splitting up the left document is wasteful - we could extract the file on-the-fly,
        // but for the sake of this simple example we just split the whole document.
        self.leftDocument  = [self splitDocumentIfRequired:self.leftDocument saveAnnotationsInsidePDF:YES];

#ifdef PSCCoreDataAnnotationProviderEnabled
        PSPDFDocument *newRightDocument = [self splitDocumentIfRequired:self.rightDocument saveAnnotationsInsidePDF:NO];
        newRightDocument.UID = self.rightDocument.UID; // Need to have the same UID for the annotation store.

        // We don't yet support undo for custom annotation providers.
        newRightDocument.undoEnabled = NO;
        [newRightDocument setDidCreateDocumentProviderBlock:^(PSPDFDocumentProvider *documentProvider) {
            PSCPagedCoreDataAnnotationProvider *provider = [[PSCPagedCoreDataAnnotationProvider alloc] initWithDocumentProvider:documentProvider];
            documentProvider.annotationManager.annotationProviders = @[provider];
        }];

        self.rightDocument = newRightDocument;
#else
        self.rightDocument = [self splitDocumentIfRequired:self.rightDocument saveAnnotationsInsidePDF:YES];
#endif
    }];
}

// To make the right document customizable, we need to split it up into single pages.
// TODO: Misses progress display and error handling.
- (PSPDFDocument *)splitDocumentIfRequired:(PSPDFDocument *)document saveAnnotationsInsidePDF:(BOOL)saveAnnotationsInsidePDF {
    if (document.isValid && document.files.count != document.pageCount) {
        NSURL *baseURL = nil;
        NSMutableArray *files = [NSMutableArray array];
        for (NSUInteger pageIndex = 0; pageIndex < document.pageCount; pageIndex++) {
            NSURL *splitURL = PSCTempFileURLWithPathExtension([NSString stringWithFormat:@"%@_split_%tu", document.fileURL.lastPathComponent, pageIndex], @"pdf");
            if (!baseURL) baseURL = [splitURL URLByDeletingLastPathComponent];

            // Generate split files
            NSDictionary *options = saveAnnotationsInsidePDF ? @{PSPDFProcessorAnnotationAsDictionary : @YES, PSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeAll)} : NULL;
            [PSPDFProcessor.defaultProcessor generatePDFFromDocument:document pageRanges:@[[NSIndexSet indexSetWithIndex:pageIndex]]outputFileURL:splitURL options:options progressBlock:NULL error:NULL];
            [files addObject:splitURL.lastPathComponent];
        }
        return [PSPDFDocument documentWithBaseURL:baseURL files:files];
    }
    return document;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocumentPickerControllerDelegate

- (void)documentPickerController:(PSPDFDocumentPickerController *)controller didSelectDocument:(PSPDFDocument *)document page:(NSUInteger)pageIndex searchString:(NSString *)searchString {
    self.leftDocument = document;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCMergePDFViewController

@implementation PSCMergePDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document {
    [super commonInitWithDocument:document];

    self.HUDViewMode = PSPDFHUDViewModeAlways;
    self.pageMode = PSPDFPageModeSingle; // prevent two-page mode.

    // We already set the title at controller generation time.
    self.allowToolbarTitleChange = NO;

    self.leftBarButtonItems = nil; // hide close button
    self.rightBarButtonItems = @[self.annotationButtonItem, self.outlineButtonItem, self.viewModeButtonItem];

    // If the annotation toolbar is invoked, there's not enough space for the default configuration.
    self.annotationButtonItem.flexibleAnnotationToolbar.editableAnnotationTypes = [NSOrderedSet orderedSetWithObjects:PSPDFAnnotationStringHighlight, PSPDFAnnotationStringFreeText, PSPDFAnnotationStringNote, PSPDFAnnotationStringInk, PSPDFAnnotationStringStamp, nil];

    // Disable the long press menu.
    self.createAnnotationMenuEnabled = NO;

    // fit 3 thumbs nicely next to each other on iPad/landscape.
    self.thumbnailSize = CGSizeMake(150.f, 200.f);

    // Hide bookmark filter
    self.thumbnailController.filterOptions = [NSOrderedSet orderedSetWithObjects:@(PSPDFThumbnailViewFilterShowAll), @(PSPDFThumbnailViewFilterAnnotations), nil];
    [self updateDocumentSettings:document];
}

- (void)setDocument:(PSPDFDocument *)document {
    [self updateDocumentSettings:document];
    [super setDocument:document];
}

- (void)updateDocumentSettings:(PSPDFDocument *)document {
    // We don't care about bookmarks.
    document.bookmarksEnabled = NO;
    document.annotationSaveMode = PSPDFAnnotationSaveModeEmbedded; // only allow saving into the PDF.
}

@end

// We need to subclass the parent provider to support custom page translation
@interface PSCCustomPagedCoreDataAnnotationProvider : PSCCoreDataAnnotationProvider @end

@implementation PSCPagedCoreDataAnnotationProvider

- (instancetype)initWithDocumentProvider:(PSPDFDocumentProvider *)documentProvider {
    if (self = [super init]) {
        _documentProvider = documentProvider;

        // Check if we already have a master provider and create if we don't.
        PSPDFDocument *document = documentProvider.document;
        @synchronized(document) {
            if (![self coreDataProvider]) {
                PSCCoreDataAnnotationProvider *coreDataProvider = [[PSCCustomPagedCoreDataAnnotationProvider alloc] initWithDocumentProvider:documentProvider databasePath:nil];
                objc_setAssociatedObject(document, &PSCCoreDataAnnotationProviderStorageKey, coreDataProvider, OBJC_ASSOCIATION_RETAIN);
            }
        }
    }
    return self;
}

- (PSCCoreDataAnnotationProvider *)coreDataProvider {
    return PSCCoreDataAnnotationProviderForDocument(self.documentProvider.document);
}

static NSUInteger PSCDocumentRelativePageForPage(PSPDFDocumentProvider *documentProvider, NSUInteger page) {
    return page + documentProvider.pageOffsetForDocument;
}

// Translate page and forward
- (NSArray *)annotationsForPage:(NSUInteger)page {
    NSUInteger documentPage = PSCDocumentRelativePageForPage(self.documentProvider, page);
    PSCCoreDataAnnotationProvider *provider = [self coreDataProvider];
    NSArray *annotations = [provider annotationsForPage:documentPage];
    // Make sure page is correctly set to the relative provider.
    for (PSPDFAnnotation *annotation in annotations) {
        annotation.page = page;
    }
    return annotations;
}

// Simply forward to the actual provider.
- (NSArray *)addAnnotations:(NSArray *)annotations {
    return [[self coreDataProvider] addAnnotations:annotations];
}
- (NSArray *)removeAnnotations:(NSArray *)annotations {
    return [[self coreDataProvider] removeAnnotations:annotations];
}
- (BOOL)saveAnnotationsWithOptions:(NSDictionary *)options error:(NSError *__autoreleasing*)error {
    return [[self coreDataProvider] saveAnnotationsWithOptions:options error:error];
}
- (BOOL)shouldSaveAnnotations {
    return [[self coreDataProvider] shouldSaveAnnotations];
}

@end

@implementation PSCCustomPagedCoreDataAnnotationProvider

// Translates the page accordingly.
- (NSUInteger)pageForAnnotation:(PSPDFAnnotation *)annotation {
    return PSCDocumentRelativePageForPage(self.documentProvider, annotation.page);
}

@end
