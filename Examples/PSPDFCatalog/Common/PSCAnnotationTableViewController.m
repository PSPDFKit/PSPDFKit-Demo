//
//  PSCAnnotationTableViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
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
    for (NSUInteger pageIndex=0; pageIndex<document.pageCount; pageIndex++) {
        NSArray *annotations = [self annotationsForPage:pageIndex];
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

- (NSUInteger)pageForSection:(NSInteger)section {
    return [self.pagesWithAnnotations[section] unsignedIntegerValue];
}

- (NSArray *)annotationsForSection:(NSUInteger)section {
    return [self annotationsForPage:[self pageForSection:section]];
}

- (NSArray *)annotationsForPage:(NSUInteger)page {
    PSPDFDocument *document = self.pdfController.document;
    NSArray *annotations = [document annotationsForPage:page type:[self annotationTypes]];
    // remove deleted items
    annotations = [annotations filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(PSPDFAnnotation *evaluatedAnnotation, NSDictionary *bindings) {
        return !evaluatedAnnotation.isDeleted;
    }]];
    annotations = [annotations sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES]]];
    return annotations;
}

- (PSPDFAnnotation *)annotationForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= [self.pagesWithAnnotations count]) return nil;
    
    NSArray *annotations = [self annotationsForSection:indexPath.section];
    return annotations[indexPath.row];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.pagesWithAnnotations count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *annotations = [self annotationsForSection:section];
    return [annotations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PSCAnnotationCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 6;
    }

    // configure cell
    NSArray *annotations = [self annotationsForSection:indexPath.section];
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
    PSPDFPageView *pageView = [self.pdfController pageViewForPage:annotation.absolutePage];
    pageView.selectedAnnotation = nil; // make sure annotation isn't currently selected.
    annotation.deleted = YES;

    // send change event for deleted = YES.
    [[NSNotificationCenter defaultCenter] postNotificationName:PSPDFAnnotationChangedNotification object:annotation userInfo:@{PSPDFAnnotationChangedNotificationKeyPathKey : @[NSStringFromSelector(@selector(isDeleted))], PSPDFAnnotationChangedNotificationOriginalAnnotationKey : annotation}];

    [pageView updateView];
    [pageView removeAnnotation:annotation animated:YES]; // if it's an overlay annotation

    [self reloadData];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // log annotation
    PSPDFAnnotation *annotation = [self annotationForIndexPath:indexPath];
    NSLog(@"Touched annotation\n%@", [annotation externalRepresentationInFormat:nil]);

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // scroll to page
    [self.pdfController setPage:annotation.absolutePage animated:YES];
}

@end
