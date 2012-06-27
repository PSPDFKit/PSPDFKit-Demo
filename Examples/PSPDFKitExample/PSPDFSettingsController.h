//
//  PSPDFCacheSettingsController.h
//  PSPDFKitExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#define kGlobalVarChangeNotification @"kGlobalVarChangeNotification"

@interface PSPDFSettingsController : UITableViewController

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
+ (BOOL)pdfOutline;
+ (BOOL)annotations;
+ (BOOL)pageCurl;

@end
