//
//  PSCSettingsController.h
//  PSPDFCatalog
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#define kGlobalVarChangeNotification @"kGlobalVarChangeNotification"

@interface PSCSettingsController : UITableViewController

@property (nonatomic, ps_weak) UIViewController *owningViewController;

// Settings are saved within the dictionary.
+ (NSDictionary *)settings;

// converts is* strings to regular strings.
+ (NSString *)setterKeyForGetter:(NSString *)getter;

@end
