//
//  PSPDFCacheSettingsController.h
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/24/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kGlobalVarChangeNotification @"kGlobalVarChangeNotification"

@interface PSPDFCacheSettingsController : UITableViewController {
    NSArray *content_;
}

- (id)initWithStyle:(UITableViewStyle)style;

// global settings read by PSPDFGridController

+ (PSPDFPageMode)pageMode;
+ (PSPDFScrolling)pageScrolling;
+ (BOOL)doublePageModeOnFirstPage;
+ (BOOL)zoomingSmallDocumentsEnabled;
+ (BOOL)scrobbleBar;
+ (BOOL)aspectRatioEqual;
+ (BOOL)search;
+ (BOOL)pdfoutline;
+ (BOOL)annotations;

@end
