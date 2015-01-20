//
//  PSCMetadataViewController.m
//  PSPDFKit
//
//  Copyright (c) 2014-2015 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCMetadataViewController.h"

@implementation PSCMetadataViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (instancetype)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super init])) {
        _document = document;
        self.title = NSLocalizedString(@"Metadata", @"");
        self.preferredContentSize = CGSizeMake(350.f, document.metadata.count * 44.f);
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource

- (NSString *)metadataForRow:(NSUInteger)row {
    PSPDFDocument *document = self.document;

    NSArray *sortedKeys = [[document.metadata allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *metadata = document.metadata[sortedKeys[row]];
    if (![metadata isKindOfClass:[NSString class]]) {
        if ([metadata isKindOfClass:[NSArray class]]) {
            metadata = [(NSArray *)metadata componentsJoinedByString:@", "];
        } else {
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
    return self.document.metadata.count > 0 ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.document.metadata.count;
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
        [UIPasteboard generalPasteboard].string = [self metadataForRow:indexPath.row] ?: @"";
    }
}

- (BOOL)tableView:(UITableView*)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath*)indexPath withSender:(id)sender {
    return action == @selector(copy:);
}

- (BOOL)tableView:(UITableView*)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath*)indexPath {
    return YES;
}

@end
