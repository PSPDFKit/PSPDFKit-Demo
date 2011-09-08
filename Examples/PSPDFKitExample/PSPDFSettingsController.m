//
//  PSPDFCacheSettingsController.m
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/24/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFSettingsController.h"
#import <UIKit/UIKit.h>

@implementation PSPDFSettingsController

static PSPDFPageMode pageMode = PSPDFPageModeAutomatic;
static PSPDFScrolling pageScrolling = PSPDFScrollingHorizontal;
static BOOL doublePageModeOnFirstPage = NO;
static BOOL zoomingSmallDocumentsEnabled = YES;
static BOOL fitWidth = NO;
static BOOL scrobbleBar = YES;
static BOOL aspectRatioEqual = YES;
static BOOL search = YES;
static BOOL pdfoutline = YES;
static BOOL annotations = YES;

#define kOptionBlockIndex    4
#define kDocOptionBlockIndex 5

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithStyle:(UITableViewStyle)style; {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        content_ = [[NSArray alloc] initWithObjects:
                    [NSArray arrayWithObjects:@"Disable Cache", @"Thumbnails & near Pages", @"Cache Opportunistic", nil], 
                    [NSArray arrayWithObjects:@"Horizontal (Magazine style)", @"Vertial (like UIWebView)", nil],                    
                    [NSArray arrayWithObjects:@"Single Page", @"Double Pages", @"Automatic on Rotation", nil], 
                    [NSArray arrayWithObjects:@"Single First Page", @"Always Two Pages", nil],
                    [NSArray arrayWithObjects:@"Zoom small files", @"Zoom to width", @"Scrobblebar", nil],
                    [NSArray arrayWithObjects:@"Search", @"Outline", @"Annotations", @"AspectRatio Equal", nil],                    
                    nil];
        
        //self.contentSizeForViewInPopover = CGSizeMake(300, 500);
    }
    return self;
}

- (void)dealloc {
    [content_ release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView flashScrollIndicators];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return PSIsIpad() ? YES : interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Cache";
            break;
        case 1:
            return @"Scrolling";
            break;
        case 2:
            return @"PSPDFViewController Display";
            break;
        case 3:
            return @"Double Page Mode";
            break;
        case kOptionBlockIndex:
            return @"";
            break;            
        case kDocOptionBlockIndex:
            return @"PSPDFDocument";
            break;            
        default:
            return @"";
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Cache Settings are global, more aggressive settings need more disk memory.";
            break;
        case 1:
            return @"";
            break;
        case 2:
            return @"";
            break;
        case 3:
            return @"";
            break;
        case kOptionBlockIndex:
            return @"If small file zooming is enabled, pdf files will always be shown in full width/height, regardless of the defined CropBox.";
            break;            
        case kDocOptionBlockIndex:
            return @"Usually, you have an equal aspect ratio, which speeds up displaying pdf files quite a bit. Disable if you have pages of different size inside your document.";
            break;            
        default:
            return @"";
            break;
    }
}

- (void)switchChanged:(UISwitch *)cellSwitch {
    UITableViewCell *cell = (UITableViewCell *)cellSwitch.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    if (indexPath.section == kOptionBlockIndex) {
        switch (indexPath.row) {
            case 0:
                zoomingSmallDocumentsEnabled = cellSwitch.on;
                break;
            case 1:
                fitWidth = cellSwitch.on;
                break;   
            case 2:
                scrobbleBar = cellSwitch.on;
                break;                
            default:
                break;
        }
    }else if(indexPath.section == kDocOptionBlockIndex) {
        switch (indexPath.row) {
            case 0:
                search = cellSwitch.on;
                break;
            case 1:
                pdfoutline = cellSwitch.on;
                break;
            case 2:
                annotations = cellSwitch.on;
                break;
            case 3:
                aspectRatioEqual = cellSwitch.on;
                break;
            default:
                break;
        }        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kGlobalVarChangeNotification object:indexPath];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [content_ count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[content_ objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"PSPDFCacheSettingsCell_%d", indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [[content_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    switch (indexPath.section) {
        case 0:
            cell.accessoryType = (indexPath.row == [PSPDFCache sharedPSPDFCache].strategy) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;   
            break;
        case 1:
            cell.accessoryType = (indexPath.row == pageScrolling) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;   
            break;
        case 2:
            cell.accessoryType = (indexPath.row == pageMode) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;   
            break;
        case 3:
            cell.accessoryType = (indexPath.row == doublePageModeOnFirstPage) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;   
            break;
        case kOptionBlockIndex:
        case kDocOptionBlockIndex: {
            UISwitch *cellSwitch = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
            [cellSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = cellSwitch;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (indexPath.section == kOptionBlockIndex) {
                switch (indexPath.row) {
                    case 0:
                        cellSwitch.on = zoomingSmallDocumentsEnabled;
                        break;
                    case 1:
                        cellSwitch.on = fitWidth;
                        break;
                    case 2:
                        cellSwitch.on = scrobbleBar;
                        break;
                    default:
                        break;
                }
            }else if(indexPath.section == kDocOptionBlockIndex) {
                switch (indexPath.row) {
                    case 0:
                        cellSwitch.on = search;
                        break;
                    case 1:
                        cellSwitch.on = pdfoutline;
                        break;
                    case 2:
                        cellSwitch.on = annotations;
                        break;
                    case 3:
                        cellSwitch.on = aspectRatioEqual;
                        break;
                    default:
                        break;
                }        
            }
        }break;
            
        default:
            break;
    }
    
    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            [[PSPDFCache sharedPSPDFCache] clearCache];
            [PSPDFCache sharedPSPDFCache].strategy = indexPath.row;
            break;
        case 1:
            pageScrolling = indexPath.row;
            break;
        case 2:
            pageMode = indexPath.row;
            break;
        case 3:
            doublePageModeOnFirstPage = indexPath.row == 1;
            break;
            
        default:
            break;
    }
    
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:kGlobalVarChangeNotification object:indexPath];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Static

+ (PSPDFPageMode)pageMode; {
    return pageMode;
}

+ (PSPDFScrolling)pageScrolling {
    return pageScrolling;
}

+ (BOOL)doublePageModeOnFirstPage; {
    return doublePageModeOnFirstPage;
}

+ (BOOL)zoomingSmallDocumentsEnabled {
    return zoomingSmallDocumentsEnabled;
}

+ (BOOL)fitWidth; {
    return fitWidth;
}

+ (BOOL)scrobbleBar; {
    return scrobbleBar;
}

+ (BOOL)aspectRatioEqual {
    return aspectRatioEqual;
}

+ (BOOL)search; {
    return search;
}

+ (BOOL)pdfoutline; {
    return pdfoutline;
}

+ (BOOL)annotations; {
    return annotations;
}


@end
