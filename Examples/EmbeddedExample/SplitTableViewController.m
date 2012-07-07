//
//  SplitTableViewController.m
//  EmbeddedExample
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

#import "SplitTableViewController.h"
#import "SplitMasterViewController.h"

@interface SplitTableViewController()
@property(nonatomic, strong) NSArray *content;
@end

@implementation SplitTableViewController

@synthesize content = content_;
@synthesize masterVC = masterVC_;

///////////////////////////////////////////////////////////////////////////////////////////
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
                PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[NSURL fileURLWithPath:fullPath isDirectory:NO]];
                document.aspectRatioEqual = NO; // let them calculate!
                [folders addObject:document];
            }
        }
    }
    return folders;
}

// tests fast cycling through the pdf elements
- (void)cycleAction {
    [[PSPDFCache sharedPSPDFCache] clearCache];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        for (int i = 0; i < [content_ count]; i++) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                [self tableView:self.tableView didSelectRowAtIndexPath:selectedIndexPath];
            });
            [NSThread sleepForTimeInterval:0.1];
        }        
        
        // and back up!
        for (int i = [content_ count]-1; i >= 0; i--) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                [self tableView:self.tableView didSelectRowAtIndexPath:selectedIndexPath];
            });
            [NSThread sleepForTimeInterval:0.05];
        }           
    });
}

- (void)deselectAction {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    [self.masterVC displayDocument:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if ((self = [super init])) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.f, 600.f);
        self.title = NSLocalizedString(@"Files", @"");
        
        content_ = [[self filesFromSampleDir] copy];
        
        [[PSPDFCache sharedPSPDFCache] addDelegate:self];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cycle", @"") style:UIBarButtonItemStylePlain target:self action:@selector(cycleAction)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Deselect", @"") style:UIBarButtonItemStylePlain target:self action:@selector(deselectAction)];
    }
    return self;
}

- (void)dealloc {
    [[PSPDFCache sharedPSPDFCache] removeDelegate:self];
    masterVC_ = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    // ensure we have an initial selection [perform late, wait for master VC to load]
    if (![self.tableView indexPathForSelectedRow]) {
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        [self tableView:self.tableView didSelectRowAtIndexPath:selectedIndexPath];
    } */   
}

///////////////////////////////////////////////////////////////////////////////////////////
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    PSPDFDocument *document = [self.content objectAtIndex:indexPath.row];
    cell.textLabel.text = document.title;
    cell.imageView.image = [[PSPDFCache sharedPSPDFCache] cachedImageForDocument:document page:0 size:PSPDFSizeTiny];    

    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"pressed index %d", indexPath.row);
    
    PSPDFDocument *document = [self.content objectAtIndex:indexPath.row];
    [self.masterVC displayDocument:document];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFCacheDelegate

- (void)didCachePageForDocument:(PSPDFDocument *)document page:(NSUInteger)page image:(UIImage *)cachedImage size:(PSPDFSize)size; {
    if (size == PSPDFSizeTiny && page == 0) {
        for (PSPDFDocument *aDocument in self.content) {
            if (document == aDocument) {
                NSUInteger index = [content_ indexOfObject:document];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                break;
            }
        }
    }
}

@end
