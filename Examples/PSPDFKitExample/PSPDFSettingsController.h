//
//  PSPDFCacheSettingsController.h
//  PSPDFKitExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#define kGlobalVarChangeNotification @"kGlobalVarChangeNotification"

@interface PSPDFSettingsController : UITableViewController

// Settings are saved within the dictionary.
+ (NSDictionary *)settings;

@end
