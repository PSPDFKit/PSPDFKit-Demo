//
//  PSPDFUndoProtocol.h
//  PSPDFKit
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PSPDFUndoCoalescing) {
    /// Does not coalesce events with the same key at all but rather creates one new undo event for
    /// every single change.
    PSPDFUndoCoalescingNone,

    /// Coalesces events with the same key by time. Assuming that a key changes a number of times over a
    /// short period of time, only the initial value will be recorded.
    PSPDFUndoCoalescingTimed,

    /// Puts all subsequent changes to one key into the same group. This means that constant changes
    /// of the same value will result in exactly one event, which restores the property to its initial value.
    PSPDFUndoCoalescingAll
};

// Implement on model objects that should allow undo/redo.
@protocol PSPDFUndoProtocol <NSObject>

@required

/// Keys that should be KVO observed. Observed collections will be deeply introspected.
/// @warning Only observe collections of type NSSet, NSOrderedSet and NSArray.
/// @warning Do not change the result of this method dynamically.
+ (NSSet *)keysForValuesToObserveForUndo;

@optional

/// Returns the localized undo action name for a given key.
/// @note If this method is not implemented, the name of the key is used.
+ (NSString *)localizedUndoActionNameForKey:(NSString *)key;

/// Returns the coalescing for a given key.
/// @note If this method is not implemented, PSPDFUndoCoalescingNone will be used for all keys.
/// @warning Do not change the result of this method dynamically.
+ (PSPDFUndoCoalescing)undoCoalescingForKey:(NSString *)key;

/// Required when observing collections. It is your responsibility to update the affected collection.
/// @note The index of an element is not preserved, so the order of elements in a collection might change
/// during an undo operation.
/// @warning It is your responsibility to trigger appropriate KVO events when you insert or remove an
/// object! The easiest way to do this is to call mutable<CollectionType>ValueForKey: on self and to modify that
/// collection object.
- (void)insertUndoObjects:(NSSet *)objects forKey:(NSString *)key;
- (void)removeUndoObjects:(NSSet *)objects forKey:(NSString *)key;

/// Called when changes caused by an undo or redo were applied to an object.
- (void)didUndoOrRedoChange:(NSString *)key;

@end
