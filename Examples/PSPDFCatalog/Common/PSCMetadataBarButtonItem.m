//
//  PSCMetadataBarButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSCMetadataBarButtonItem.h"

@interface PSPDFMetadataController : UITableViewController
- (id)initWithDocument:(PSPDFDocument *)document;
@property (nonatomic, ps_weak) PSPDFDocument *document;
@end

@implementation PSCMetadataBarButtonItem

- (BOOL)isAvailable {
    return [self.pdfController.document.metadata count] > 0;
}

- (UIBarButtonItemStyle)itemStyle {
    return UIBarButtonItemStylePlain;
}

- (NSString *)actionName {
    return NSLocalizedString(@"Metadata", @"");
}

- (UIImage *)image {
    return [[UIImage pspdf_imageNamed:@"Help" bundle:PSPDFKitBundle()] pspdf_imageToFitSize:CGSizeMake(24, 24) method:PSPDFImageResizeScale honorScaleFactor:YES opaque:NO];
}

- (id)presentAnimated:(BOOL)animated sender:(PSPDFBarButtonItem *)sender {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[PSPDFMetadataController alloc] initWithDocument:self.pdfController.document]];
    navController.topViewController.title = [self actionName];
    return [self presentModalOrInPopover:navController sender:sender];
}

- (void)dismissAnimated:(BOOL)animated {
    [self dismissModalOrPopoverAnimated:animated];
}

@end

@implementation PSPDFMetadataController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDocument:(PSPDFDocument *)document {
    if((self = [super init])) {
        _document = document;
        self.title = [document.fileURL lastPathComponent];
        self.contentSizeForViewInPopover = CGSizeMake(350, [self.document.metadata count] * 44);
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource

- (NSString *)metadataForRow:(NSUInteger)row {
    NSArray *sortedKeys = [[self.document.metadata allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *metadata = self.document.metadata[sortedKeys[row]];
    if (![metadata isKindOfClass:[NSString class]]) {
        if ([metadata isKindOfClass:[NSArray class]]) {
            metadata = [(NSArray *)metadata componentsJoinedByString:@", "];
        }else {
            metadata = [metadata description];
        }
    }
    return metadata;
}

- (NSString *)metadataKeyForRow:(NSUInteger)row {
    NSArray *sortedKeys = [[self.document.metadata allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return sortedKeys[row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = [self.document.metadata count] > 0 ? 1 : 0;
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = [self.document.metadata count];
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"PSCMetadataCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [self metadataKeyForRow:indexPath.row];
    cell.detailTextLabel.text = [self metadataForRow:indexPath.row];
    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath*)indexPath withSender:(id)sender {
    if (action == @selector(copy:)) {
        [UIPasteboard generalPasteboard].string = [self metadataForRow:indexPath.row];
    }
}

- (BOOL)tableView:(UITableView*)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath*)indexPath withSender:(id)sender {
    return action == @selector(copy:);
}

- (BOOL)tableView:(UITableView*)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath*)indexPath {
    return YES;
}

@end
