//
//  PSPDFDocumentSelectorController.m
//  TabbedExample
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFDocumentSelectorController.h"

@interface PSPDFDocumentSelectorController () <PSPDFCacheDelegate> {
    NSArray *content_;
}
@end

@implementation PSPDFDocumentSelectorController

@synthesize delegate = delegate_;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (NSArray *)filesFromSampleDir {
    NSMutableArray *folders = [NSMutableArray array];

    NSError *error = nil;
    NSString *sampleFolder = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Samples"];
    NSArray *documentContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sampleFolder error:&error];

    for (NSString *folder in documentContents) {
        // check if target path is a directory (all magazines are in directories)
        NSString *fullPath = [sampleFolder stringByAppendingPathComponent:folder];
        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir]) {
            if (!isDir && [[fullPath lowercaseString] hasSuffix:@"pdf"]) {
                PSPDFDocument *document = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:fullPath isDirectory:NO]];
                document.aspectRatioEqual = NO; // let them calculate!
                [folders addObject:document];
            }
        }
    }
    return folders;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        self.contentSizeForViewInPopover = CGSizeMake(320.f, 600.f);
        self.title = NSLocalizedString(@"Files", @"");

        content_ = [[self filesFromSampleDir] copy];

        [[PSPDFCache sharedPSPDFCache] addDelegate:self];
    }
    return self;
}

- (void)dealloc {
    [[PSPDFCache sharedPSPDFCache] removeDelegate:self];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    BOOL shouldAutorotate = PSIsIpad() ? YES : toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    return shouldAutorotate;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [content_ count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PSPDFDocumentSelectorCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    PSPDFDocument *document = [content_ objectAtIndex:indexPath.row];
    cell.textLabel.text = document.title;
    cell.imageView.image = [[PSPDFCache sharedPSPDFCache] cachedImageForDocument:document page:0 size:PSPDFSizeTiny];

    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"pressed index %d", indexPath.row);

    PSPDFDocument *document = [content_ objectAtIndex:indexPath.row];
    [delegate_ PDFDocumentSelectorController:self didSelectDocument:document];

    // hide controller
    if (PSIsIpad()) {
        [PSPDFBarButtonItem dismissPopoverAnimated:YES];
    }else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFCacheDelegate

- (void)didCachePageForDocument:(PSPDFDocument *)document page:(NSUInteger)page image:(UIImage *)cachedImage size:(PSPDFSize)size; {
    if (size == PSPDFSizeTiny && page == 0) {
        for (PSPDFDocument *aDocument in content_) {
            if (document == aDocument) {
                NSUInteger index = [content_ indexOfObject:document];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                break;
            }
        }
    }
}

@end
