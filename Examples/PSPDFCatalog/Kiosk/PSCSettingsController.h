//
//  PSCSettingsController.h
//  PSPDFCatalog
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#define kGlobalVarChangeNotification @"kGlobalVarChangeNotification"

/**
 The settings controller is meant to show off the flexibility of PSPDFKit.

 It's not intended to be used in shipping apps.
 Make smart choices for the user and don't over-burdem them with settings.
 */
@interface PSCSettingsController : UITableViewController

@property (nonatomic, ps_weak) UIViewController *owningViewController;

// Settings are saved within the dictionary.
+ (NSDictionary *)settings;

// converts is* strings to regular strings.
+ (NSString *)setterKeyForGetter:(NSString *)getter;

@end
