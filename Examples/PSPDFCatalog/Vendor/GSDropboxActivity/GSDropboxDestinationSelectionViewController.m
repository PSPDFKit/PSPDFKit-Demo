//
//  GSDropboxDestinationSelectionViewController.m
//
//  Created by Simon Whitaker on 06/11/2012.
//  Copyright (c) 2012 Goo Software Ltd. All rights reserved.
//

#import "GSDropboxDestinationSelectionViewController.h"
#import <DropboxSDK/DropboxSDK.h>

@interface GSDropboxDestinationSelectionViewController () <DBRestClientDelegate>
@property (nonatomic) BOOL isLoading;
@property (nonatomic, strong) NSArray *subdirectories;
@property (nonatomic, strong) DBRestClient *dropboxClient;

- (void)handleCancel;
- (void)handleSelectDestination;

@end

@implementation GSDropboxDestinationSelectionViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _isLoading = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                           target:self
                                                                                           action:@selector(handleCancel)];
    
    self.toolbarItems = @[
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
        [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Choose", @"Title for button that user taps to specify the current folder as the storage location for uploads.")
                                         style:UIBarButtonItemStyleDone
                                        target:self
                                        action:@selector(handleSelectDestination)]
    ];
    
    [self.navigationController setToolbarHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationController.toolbar.tintColor = [UIColor darkGrayColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.rootPath == nil)
        self.rootPath = @"/";
    
    if ([self.rootPath isEqualToString:@"/"]) {
        self.title = NSLocalizedString(@"Dropbox", @"The name of the service at www.dropbox.com");
    } else {
        self.title = [self.rootPath lastPathComponent];
    }
    self.navigationItem.prompt = NSLocalizedString(@"Choose a destination for uploads.", @"Prompt asking user to select a destination folder on Dropbox to which uploads will be saved.") ;
    self.isLoading = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    } else {
        [self.dropboxClient loadMetadata:self.rootPath];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (DBRestClient *)dropboxClient
{
    if (_dropboxClient == nil && [DBSession sharedSession] != nil) {
        _dropboxClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        _dropboxClient.delegate = self;
    }
    return _dropboxClient;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isLoading || self.subdirectories == nil || [self.subdirectories count] == 0) {
        return 1;
    }
    return [self.subdirectories count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if (self.isLoading) {
        cell.textLabel.text = NSLocalizedString(@"Loading...", @"Progress message while app is loading a list of folders from Dropbox");
    } else if (self.subdirectories == nil) {
        cell.textLabel.text = NSLocalizedString(@"Error loading folder contents", @"Error message if the app couldn't load a list of a folder's contents from Dropbox");
    } else if ([self.subdirectories count] == 0) {
        cell.textLabel.text = NSLocalizedString(@"Contains no folders", @"Status message when the current folder contains no sub-folders");
    } else {
        cell.textLabel.text = [[self.subdirectories objectAtIndex:indexPath.row] lastPathComponent];
        cell.imageView.image = [UIImage imageNamed:@"folder-icon.png"];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.subdirectories count] > indexPath.row) {
        GSDropboxDestinationSelectionViewController *vc = [[GSDropboxDestinationSelectionViewController alloc] init];
        vc.delegate = self.delegate;
        vc.rootPath = [self.rootPath stringByAppendingPathComponent:[self.subdirectories objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Dropbox client delegate methods

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata
{
    NSMutableArray *array = [NSMutableArray array];
    for (DBMetadata *file in metadata.contents) {
        if (file.isDirectory && [file.filename length] > 0 && [file.filename characterAtIndex:0] != '.') {
            [array addObject:file.filename];
        }
    }
    self.subdirectories = [array sortedArrayUsingSelector:@selector(compare:)];
    self.isLoading = NO;
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    self.isLoading = NO;
}

- (void)setIsLoading:(BOOL)isLoading
{
    if (_isLoading != isLoading) {
        _isLoading = isLoading;
        [self.tableView reloadData];
    }
}

- (void)handleCancel
{
    if ([self.delegate respondsToSelector:@selector(dropboxDestinationSelectionViewControllerDidCancel:)]) {
        [self.delegate dropboxDestinationSelectionViewControllerDidCancel:self];
    }
}

- (void)handleSelectDestination
{
    if ([self.delegate respondsToSelector:@selector(dropboxDestinationSelectionViewController:didSelectDestinationPath:)]) {
        [self.delegate dropboxDestinationSelectionViewController:self
                                        didSelectDestinationPath:self.rootPath];
    }
}

@end
