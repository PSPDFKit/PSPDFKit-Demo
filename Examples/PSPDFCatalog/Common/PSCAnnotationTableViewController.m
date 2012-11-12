//
//  PSCAnnotationTableViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSCAnnotationTableViewController.h"

@interface PSCAnnotationTableViewController ()
@property (nonatomic, copy) NSArray *pagesWithAnnotations;
@end

@implementation PSCAnnotationTableViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithPDFViewController:(PSPDFViewController *)pdfController {
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        _hideLinkAnnotations = YES;
        self.contentSizeForViewInPopover = CGSizeMake(600.f, 2000.f);
        self.title = PSPDFLocalize(@"Annotation List (for debugging)");
        [self updateToolbar];
        _pdfController = pdfController;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return PSIsIpad() ? YES : toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)reloadData {
    NSMutableArray *pagesWithAnnotations = [NSMutableArray array];

    PSPDFDocument *document = self.pdfController.document;
    for (NSUInteger pageIndex=0; pageIndex<[document pageCount]; pageIndex++) {
        NSArray *annotations = [document annotationsForPage:pageIndex type:[self annotationTypes]];
        if ([annotations count]) {
            [pagesWithAnnotations addObject:@(pageIndex)];
        }
    }
    self.pagesWithAnnotations = pagesWithAnnotations;
    [self.tableView reloadData];
}

- (void)updateToolbar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:PSPDFLocalize(_hideLinkAnnotations ? @"Show Links" : @"Hide Links") style:UIBarButtonItemStyleBordered target:self action:@selector(showHideLinkAnnotations)];
}

- (void)showHideLinkAnnotations {
    self.hideLinkAnnotations = !self.hideLinkAnnotations;
}

- (void)setHideLinkAnnotations:(BOOL)hideLinkAnnotations {
    _hideLinkAnnotations = hideLinkAnnotations;
    [self reloadData];
    [self updateToolbar];
}

// allow filtering link annotations
- (PSPDFAnnotationType)annotationTypes {
    PSPDFAnnotationType annotationTypes = PSPDFAnnotationTypeAll;
    if (_hideLinkAnnotations) {
        annotationTypes &= ~PSPDFAnnotationTypeLink;
    }
    return annotationTypes;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.pagesWithAnnotations count];
}

- (NSUInteger)pageForSection:(NSInteger)section {
    return [self.pagesWithAnnotations[section] unsignedIntegerValue];
}

- (PSPDFAnnotation *)annotationForIndexPath:(NSIndexPath *)indexPath {
    PSPDFDocument *document = self.pdfController.document;
    NSArray *annotations = [document annotationsForPage:[self pageForSection:indexPath.section] type:[self annotationTypes]];
    annotations = [annotations sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES]]];
    return annotations[indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PSPDFDocument *document = self.pdfController.document;
    return [[document annotationsForPage:[self pageForSection:section] type:[self annotationTypes]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PSCAnnotationCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 5;
    }

    // load all annotations
    PSPDFDocument *document = self.pdfController.document;
    NSArray *annotations = [document annotationsForPage:[self pageForSection:indexPath.section] type:[self annotationTypes]];
    annotations = [annotations sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES]]];

    // configure cell
    cell.textLabel.text = [annotations[indexPath.row] description];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Page %d", [self.pagesWithAnnotations[section] unsignedIntegerValue]+1];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    PSPDFAnnotation *annotation = [self annotationForIndexPath:indexPath];
    return annotation.isEditable;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    PSPDFAnnotation *annotation = [self annotationForIndexPath:indexPath];
    [annotation copyAndDeleteOriginalIfNeeded].deleted = YES;
    NSUInteger annotationPage = annotation.page + [self.pdfController.document pageOffsetForDocumentProvider:annotation.documentProvider];
    [[self.pdfController pageViewForPage:annotationPage] updateView];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // log annotation
    PSPDFDocument *document = self.pdfController.document;
    NSArray *annotations = [document annotationsForPage:indexPath.section type:PSPDFAnnotationTypeAll];
    PSPDFAnnotation *annotation = annotations[indexPath.row];
    NSLog(@"Touched %@", annotation);

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
