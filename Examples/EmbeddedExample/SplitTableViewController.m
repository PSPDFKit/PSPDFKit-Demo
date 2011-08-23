//
//  SplitTableViewController.m
//  EmbeddedExample
//
//  Created by Peter Steinberger on 8/22/11.
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

#import "SplitTableViewController.h"
#import "SplitMasterViewController.h"

@interface SplitTableViewController()
@property(nonatomic, retain) NSArray *content;
@end

@implementation SplitTableViewController

@synthesize content = content_;
@synthesize masterVC = masterVC_;

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
            if (!isDir) {
                [folders addObject:folder];
            }
        }
    }
    return folders;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if ((self = [super init])) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.f, 600.f);
        self.title = @"Files";

        content_ = [[self filesFromSampleDir] copy];
    }
    return self;
}

- (void)dealloc {
    masterVC_ = nil;
    [content_ release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // ensure we have an initial selection [perform late, wait for master VC to load]
        if (![self.tableView indexPathForSelectedRow]) {
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:self.tableView didSelectRowAtIndexPath:selectedIndexPath];
        }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.content count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SplitTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [[self.content objectAtIndex:indexPath.row] lastPathComponent];
    
    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"pressed index %d", indexPath.row);

    // create folder reference
    NSString *sampleFolder = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Samples"];
    NSString *documentStringPath = [sampleFolder stringByAppendingPathComponent:[self.content objectAtIndex:indexPath.row]];
    
    // create and set pdf document
    PSPDFDocument *document = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:documentStringPath]];
    [self.masterVC displayDocument:document];
}

@end
