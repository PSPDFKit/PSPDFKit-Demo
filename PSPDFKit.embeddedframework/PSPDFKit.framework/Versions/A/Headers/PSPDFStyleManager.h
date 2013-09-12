//
//  PSPDFStyleManager.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import "PSPDFAnnotationStyle.h"

// This key will return the last used style.
extern NSString *const PSPDFStyleManagerLastUsedStylesKey;

// This key will mark styles as generic, thus they'll be returned with all other style types except the last used trait.
extern NSString *const PSPDFStyleManagerGenericStylesKey;

// Can be used to use a custom subclass of the PSPDFStyleManager. Defaults to nil, which will use PSPDFStyleManager.class.
// Set very early (in your AppDelegate) before you access PSPDFKit. Will be used to create the singleton.
extern Class PSPDFStyleManagerClass;

/// The style manager will save UI-specific properties for annotations and apply them after creation.
/// It also offers a selection of user-defined styles.
/// There are three categories: Last used, key-specific and generic styles.
@interface PSPDFStyleManager : NSObject

/// Access the style manager singleton.
+ (instancetype)sharedStyleManager;

/// Keeps a list of style keys we want to listen to (like "color" or "lineWidth").
/// @note If you want to disable automatic style saving, set this to nil.
@property (atomic, copy) NSSet *styleKeys;

/// Returns the 'last used' annotation style, a special variant that is kept per annotation string type.
/// Might return nil if there isn't anything saved yet.
- (NSArray *)stylesForKey:(NSString *)key;

/// Adds a style on the key store.
- (void)addStyle:(PSPDFAnnotationStyle *)style forKey:(NSString *)key;

/// Removes a style from the key store.
- (void)removeStyle:(PSPDFAnnotationStyle *)style forKey:(NSString *)key;

/// @name Convenience Helpers

/// Get the last used style for `key`.
- (PSPDFAnnotationStyle *)lastUsedStyleForKey:(NSString *)key;

/// Convenience method. Will fetch the last used style for `key` and fetches the styleProperty for it. Might return nil.
- (id)lastUsedProperty:(NSString *)styleProperty forKey:(NSString *)key;

/// Convenience method. Will set the last used style for `key` and styleProperty.
/// `value` might be a boxed CGFloat, color or whatever matches the property.
/// `styleProperty` is the NSString-name for the property (e.g. NSStringFromSelector(@selector(fontSize))
/// `key` is the annotation key, e.g. PSPDFAnnotationStringFreeText.
- (void)setLastUsedValue:(id)value forProperty:(NSString *)styleProperty forKey:(NSString *)key;

@end
