//
//  PSCScreenReaderExample.m
///  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"

@interface PSCReaderPDFViewController : PSPDFViewController <PSPDFViewControllerDelegate>
@property (nonatomic, strong) PSPDFSearchHighlightView *highlightView;
@property (nonatomic, strong) NSTimer *wordTimer;
@property (nonatomic, strong) PSPDFWord *currentWord;
@property (nonatomic, strong) NSArray *currentWords;
@end

@interface PSCScreenReaderExample : PSCExample @end
@implementation PSCScreenReaderExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Screen Reader";
        self.contentDescription = @"Creates a sample interface for a screen-reader application";
        self.category = PSCExampleCategoryViewCustomization;
        self.priority = 300;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    PSPDFViewController *pdfController = [[PSCReaderPDFViewController alloc] initWithDocument:document];
    pdfController.page = 3;
    return pdfController;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCReaderPDFViewController

@implementation PSCReaderPDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document {
    [super commonInitWithDocument:document];
    self.pageMode = PSPDFPageModeSingle;
    self.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startWordTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopWordTimer];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)startWordTimer {
    [self stopWordTimer];
    self.wordTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(wordTimerFired:) userInfo:nil repeats:YES];
    [self wordTimerFired:self.wordTimer];
}

- (void)stopWordTimer {
    [self.wordTimer invalidate];
}

- (void)prepareNewPage {
    PSPDFTextParser *textParser = [self.document textParserForPage:self.page];
    self.currentWord = nil;
    self.currentWords = [[PSPDFTextBlock alloc] initWithGlyphs:textParser.glyphs].words;
}

- (void)wordTimerFired:(NSTimer *)timer {
    if (!self.currentWords) [self prepareNewPage];

    if (!self.currentWord) {
        if (self.currentWords.count > 0) {
            self.currentWord = [self.currentWords objectAtIndex:0];
        }
    }else {
        NSUInteger index = [self.currentWords indexOfObjectIdenticalTo:self.currentWord];
        index++;
        if (index < self.currentWords.count) {
            self.currentWord = self.currentWords[index];
        }else {
            // we hit the end of the page.
            self.currentWord = nil;
            [self stopWordTimer];
        }
    }

    [self highlightWord:self.currentWord];
}

- (void)highlightWord:(PSPDFWord *)word {
    NSLog(@"Highlighting: %@", [word stringValue]);
    PSPDFSearchHighlightView *highlightView = nil;

    // we (ab)use the search highlight system here.
    if (word) {
        PSPDFSearchResult *result = [[PSPDFSearchResult alloc] initWithDocument:self.document page:self.page range:NSMakeRange(NSNotFound, 0) previewText:nil rangeInPreviewText:NSMakeRange(NSNotFound, 0) selection:[[PSPDFTextBlock alloc] initWithGlyphs:word.glyphs] annotation:nil];
        highlightView = [[PSPDFSearchHighlightView alloc] initWithSearchResult:result];
    }
    self.highlightView = highlightView;
}

- (void)setHighlightView:(PSPDFSearchHighlightView *)highlightView {
    if (highlightView != _highlightView) {
        [_highlightView removeFromSuperview];
        _highlightView = highlightView;

        PSPDFPageView *pageView = [self pageViewForPage:self.page];
        [pageView addSubview:highlightView];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

// Restart on new page.
- (void)pdfViewController:(PSPDFViewController *)pdfController didShowPageView:(PSPDFPageView *)pageView {
    [self prepareNewPage];
    [self startWordTimer];
}

// Pause when in thumbnail view.
- (void)pdfViewController:(PSPDFViewController *)pdfController didChangeViewMode:(PSPDFViewMode)viewMode {
    if (viewMode == PSPDFViewModeThumbnails) {
        [self stopWordTimer];
    }else {
        [self startWordTimer];
    }
}

@end
