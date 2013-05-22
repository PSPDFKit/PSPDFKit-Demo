//
//  PSCSettingsController.h
//  PSPDFCatalog
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
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
