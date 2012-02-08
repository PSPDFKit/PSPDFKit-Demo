//
//  PSPDFCacheSettingsController.h
//  PSPDFKitExample
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#define kGlobalVarChangeNotification @"kGlobalVarChangeNotification"

@interface PSPDFSettingsController : UITableViewController {
    NSArray *content_;
}

- (id)initWithStyle:(UITableViewStyle)style;

// called on startup to init device specific defaults
+ (void)setupDefaults;

// global settings read by PSPDFGridController

+ (PSPDFPageMode)pageMode;
+ (PSPDFScrolling)pageScrolling;
+ (BOOL)doublePageModeOnFirstPage;
+ (BOOL)zoomingSmallDocumentsEnabled;
+ (BOOL)fitWidth;
+ (BOOL)pagingEnabled;
+ (BOOL)scrobbleBar;
+ (BOOL)aspectRatioEqual;
+ (BOOL)search;
+ (BOOL)pdfoutline;
+ (BOOL)annotations;
+ (BOOL)twoStepRendering;
+ (BOOL)pageCurl;

@end
