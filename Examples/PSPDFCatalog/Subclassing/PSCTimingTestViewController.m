//
//  PSCTimingTestViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCTimingTestViewController.h"
#import "PSPDFDocumentSelectorController.h"

@interface PSCTimingTestViewController ()
@property (nonatomic, strong) PSPDFViewController *pdfController;
@property (nonatomic, copy) NSArray *documents;
@end

@implementation PSCTimingTestViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

        // load sample documents
        PSPDFDocumentSelectorController *documentsController = [[PSPDFDocumentSelectorController alloc] initWithDirectory:@"/Bundle/Samples" delegate:NULL];
        _documents = documentsController.documents;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIVIewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self performSelector:@selector(showRandomPDFController) withObject:nil afterDelay:0.1];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showRandomPDFController) object:nil];
}

- (void)showRandomPDFController {
    if (self.documents.count == 0) return;

    NSUInteger index = arc4random_uniform([self.documents count]);
    PSPDFDocument *randomDocument = self.documents[index]; // create a copy to better simulate memory issues
    NSLog(@"Loading %@", randomDocument);

    if (self.pdfController && (arc4random_uniform(2) == 1 || YES)) {
        self.pdfController.document = randomDocument;
    }else {
        // remove old controller
        [self.pdfController willMoveToParentViewController:nil];
        [self.pdfController.view removeFromSuperview];
        [self.pdfController removeFromParentViewController];

        // add new controller
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:[randomDocument copy]];
        [self addChildViewController:pdfController];
        pdfController.view.frame = CGRectInset(self.view.bounds, 20, 20);
        pdfController.pageTransition = PSPDFPageCurlTransition;
        pdfController.pageMode = PSPDFPageModeAutomatic;
        [self.view addSubview:pdfController.view];
        [pdfController didMoveToParentViewController:self];
        self.pdfController = pdfController;
    }

    [self performSelector:@selector(showRandomPDFController) withObject:nil afterDelay:arc4random_uniform(100)/50];
}

@end
