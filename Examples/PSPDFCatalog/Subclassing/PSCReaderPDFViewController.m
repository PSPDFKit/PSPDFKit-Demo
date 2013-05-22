//
//  PSCReaderPDFViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCReaderPDFViewController.h"

@interface PSCReaderPDFViewController ()
@property (nonatomic, strong) PSPDFSearchHighlightView *highlightView;
@property (nonatomic, strong) NSTimer *wordTimer;
@property (nonatomic, strong) PSPDFWord *currentWord;
@property (nonatomic, strong) NSArray *currentWords;
@end

@implementation PSCReaderPDFViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

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
        self.currentWord = [self.currentWords ps_firstObject];
    }else {
        NSUInteger index = [self.currentWords indexOfObjectIdenticalTo:self.currentWord];
        index++;
        if (index < [self.currentWords count]) {
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
        PSPDFSearchResult *result = [PSPDFSearchResult new];
        result.document = self.document;
        result.pageIndex = self.page;
        result.selection = [[PSPDFTextBlock alloc] initWithGlyphs:word.glyphs];
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
