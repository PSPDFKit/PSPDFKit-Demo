//
//  PSCSettingsController.h
//  PSPDFCatalog
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#define kGlobalVarChangeNotification @"kGlobalVarChangeNotification"

/**
 The settings controller is meant to show off the flexibility of PSPDFKit.

 It's not intended to be used in shipping apps.
 Make smart choices for the user and don't over-burdem them with settings.
 */
@interface PSCSettingsController : UITableViewController

@property (nonatomic, weak) UIViewController *owningViewController;

// Settings are saved within the dictionary.
+ (NSMutableDictionary *)settings;

// converts is* strings to regular strings.
+ (NSString *)setterKeyForGetter:(NSString *)getter;

@end
