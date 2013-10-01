//
//  PSCMergeDocumentsViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCMergeDocumentsViewController.h"
#import "PSCFileHelper.h"

@interface PSCMergePDFViewController : PSPDFViewController
@end


@interface PSCMergeDocumentsViewController () <PSPDFDocumentPickerControllerDelegate>
@property (nonatomic, strong) PSPDFDocument *leftDocument;
@property (nonatomic, strong) PSPDFDocument *rightDocument;
@property (nonatomic, strong) UINavigationController *leftNavigator;
@property (nonatomic, strong) UINavigationController *rightNavigator;
@property (nonatomic, strong) PSCMergePDFViewController *leftController;
@property (nonatomic, strong) PSCMergePDFViewController *rightController;
@end

@implementation PSCMergeDocumentsViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithLeftDocument:(PSPDFDocument *)leftDocument rightDocument:(PSPDFDocument *)rightDocument {
    if (self = [super init]) {
        _leftDocument = leftDocument;
        _rightDocument = rightDocument;
        PSC_IF_IOS7_OR_GREATER(self.edgesForExtendedLayout = UIRectEdgeAll & ~UIRectEdgeTop;)
        //self.title = @"Merge Documents";
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
    PSC_IF_IOS7_OR_GREATER(self.leftNavigator.view.tintColor = self.navigationController.navigationBar.barTintColor;)
    [self addChildViewController:self.leftNavigator];
    [self.view addSubview:self.leftNavigator.view];
    [self.leftNavigator didMoveToParentViewController:self];

    // Initialize right controller.
    self.rightController = [[PSCMergePDFViewController alloc] initWithDocument:self.rightDocument];
    self.rightController.title = @"Your Version";
    self.rightNavigator = [[UINavigationController alloc] initWithRootViewController:self.rightController];
    PSC_IF_IOS7_OR_GREATER(self.rightNavigator.view.tintColor = self.navigationController.navigationBar.barTintColor;)
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PSC_IF_IOS7_OR_GREATER([[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];)
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
    }];
}

// Replace visble page on the left with the right one.
- (void)replacePage {
    [self updateDocumentWithMutatingFiles:^(NSMutableArray *files) {
        NSString *replacementFile = self.leftDocument.files[self.leftController.page];
        [files replaceObjectAtIndex:self.rightController.page withObject:replacementFile];
    }];
}

- (void)removePage {
    [self updateDocumentWithMutatingFiles:^(NSMutableArray *files) {
        [files removeObjectAtIndex:self.rightController.page];
    }];
}

- (void)updateDocumentWithMutatingFiles:(void (^)(NSMutableArray *files))fileMutationBlock {
    [self.rightDocument saveAnnotationsWithError:NULL]; // always save.
    [self splitAllDocumentsIfRequired];

    NSMutableArray *files = [self.rightDocument.files mutableCopy];
    fileMutationBlock(files);

    PSPDFDocument *newDocument = [PSPDFDocument documentWithBaseURL:self.rightDocument.baseURL files:files];
    // Clear old cache. This is not required, but a good thing to do.
    // The new document will have a new autogenerated UID since the files array changed.
    [[PSPDFCache sharedCache] removeCacheForDocument:self.rightDocument deleteDocument:NO error:NULL];

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
    [[PSPDFProcessor defaultProcessor] generatePDFFromDocument:self.rightDocument pageRange:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.rightDocument.pageCount)] outputFileURL:savedDocumentURL options:@{PSPDFProcessorAnnotationAsDictionary : @YES, PSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeAll)} progressBlock:NULL error:NULL];

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
        self.leftDocument  = [self splitDocumentIfRequired:self.leftDocument];
        self.rightDocument = [self splitDocumentIfRequired:self.rightDocument];
    }];
}

// To make the right document customizable, we need to split it up into single pages.
// TODO: Misses progress display and error handling.
- (PSPDFDocument *)splitDocumentIfRequired:(PSPDFDocument *)document {
    if (document.isValid && document.files.count != document.pageCount) {
        NSURL *baseURL = nil;
        NSMutableArray *files = [NSMutableArray array];
        for (NSUInteger pageIndex = 0; pageIndex < document.pageCount; pageIndex++) {
            NSURL *splitURL = PSCTempFileURLWithPathExtension([NSString stringWithFormat:@"%@_split_%d", document.fileURL.lastPathComponent, pageIndex], @"pdf");
            if (!baseURL) baseURL = [splitURL URLByDeletingLastPathComponent];
            [[PSPDFProcessor defaultProcessor] generatePDFFromDocument:document pageRange:[NSIndexSet indexSetWithIndex:pageIndex] outputFileURL:splitURL options:@{PSPDFProcessorAnnotationAsDictionary : @YES, PSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeAll)} progressBlock:NULL error:NULL];
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

    // Match styling. Set statusbar to inherit, and bars to light color.
    self.statusBarStyleSetting = PSPDFStatusBarStyleInherit;
    self.navigationBarStyle = UIBarStyleDefault;
    self.HUDViewMode = PSPDFHUDViewModeAlways;
    self.pageMode = PSPDFPageModeSingle; // prevent two-page mode.

    // We already set the title at controller generation time.
    self.allowToolbarTitleChange = NO;

    self.leftBarButtonItems = nil; // hide close button
    self.rightBarButtonItems = @[self.annotationButtonItem, self.outlineButtonItem, self.viewModeButtonItem];

    // If the annotation toolbar is invoked, there's not enough space for the default configuration.
    self.annotationButtonItem.annotationToolbar.editableAnnotationTypes = [NSOrderedSet orderedSetWithObjects:PSPDFAnnotationStringHighlight, PSPDFAnnotationStringFreeText, PSPDFAnnotationStringNote, PSPDFAnnotationStringInk, PSPDFAnnotationStringStamp, nil];

    // Disable the long press menu.
    self.createAnnotationMenuEnabled = NO;

    // fit 3 thumbs nicely next to each other on iPad/landscape.
    self.thumbnailSize = CGSizeMake(150, 200);

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
