//
//  PSPDFCacheSettingsController.m
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/24/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFCacheSettingsController.h"

@implementation PSPDFCacheSettingsController

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        content_ = [[NSArray alloc] initWithObjects:@"Disable Cache", @"Thumbnails & near Pages", @"Cache Opportunistic", nil];
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentSizeForViewInPopover = CGSizeMake(300, 160);
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [content_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CacheSettingsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [content_ objectAtIndex:indexPath.row];
    if (indexPath.row == [PSPDFCache sharedPSPDFCache].strategy) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[PSPDFCache sharedPSPDFCache] clearCache];
    [PSPDFCache sharedPSPDFCache].strategy = indexPath.row;
    
    [self.tableView reloadData];
}

@end
