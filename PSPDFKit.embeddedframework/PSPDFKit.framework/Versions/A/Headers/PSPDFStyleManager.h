//
//  PSPDFStyleManager.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSPDFAnnotationStyle.h"

// This key will return the last used style.
extern NSString *const kPSPDFStyleManagerLastUsedStylesKey;

// This key will mark styles as generic, thus they'll be returned with all other style types except the last used trait.
extern NSString *const kPSPDFStyleManagerGenericStylesKey;


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

/// @name Conveniece Helpers

/// Get the last used style for `key`.
- (PSPDFAnnotationStyle *)lastUsedStyleForKey:(NSString *)key;

/// Convenience method. Will fetch the last used style for `key` and fetches the styleProperty for it. Might return nil.
- (id)lastUsedProperty:(NSString *)styleProperty forKey:(NSString *)key;

/// Convenience method. Will set the last used style for `key` and styleProperty.
- (void)setLastUsedValue:(id)value forProperty:(NSString *)styleProperty forKey:(NSString *)key;

@end
