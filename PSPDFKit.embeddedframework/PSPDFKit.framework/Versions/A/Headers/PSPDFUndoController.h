//
//  PSPDFUndoManager.h
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
#import "PSPDFUndoProtocol.h"

/// This is a custom undo manager that can coalesce similar changes within the same group.
/// This class is also completely thread safe.
@interface PSPDFUndoController : NSObject

/// Designated initializer.
/// If `undoEnabled` is set to NO, the performBlock* operations will directly call block.
- (id)initWithUndoEnabled:(BOOL)undoEnabled;

/// Returns YES if the undo controller is currently either undoing or redoing.
- (BOOL)isWorking;

/// Returns YES if undoable operations have been recorded.
- (BOOL)canUndo;

/// Returns YES if redoable operations have been recorded.
- (BOOL)canRedo;

/// Performs an undo operation.
- (void)undo;

/// Performs a redo operation.
- (void)redo;

/// Begin/end an undo group.
/// @note -performBlockAsGroup: is preferred since it is less error prone.
/// If `groupName` is nil, a default name for the changes will be inferred.
- (void)beginUndoGrouping;
- (void)endUndoGroupingWithName:(NSString *)groupName;

/// Helper that will infer a good name for `changedProperty` of `object`.
- (void)endUndoGroupingWithProperty:(NSString *)changedProperty ofObject:(id)object;

/// Removes all recorded actions.
- (void)removeAllActions;

/// Register/unregister objects.
- (void)registerObjectForUndo:(NSObject <PSPDFUndoProtocol> *)object;
- (void)unregisterObjectForUndo:(NSObject <PSPDFUndoProtocol> *)object;
- (BOOL)isObjectRegisteredForUndo:(NSObject <PSPDFUndoProtocol> *)object;

/// Performs a block and groups all observed changes into one event.
- (void)performBlockAsGroup:(dispatch_block_t)block name:(NSString *)groupName;

/// Performs a block and ignores all observed changes.
- (void)performBlockWithoutUndo:(dispatch_block_t)block;

/// Undo can be disabled globally, set this before any objects are registered on the controller.
@property (nonatomic, assign, getter=isUndoEnabled, readonly) BOOL undoEnabled;

/// Provides access to the underlying NSUndoManager. You are strongly encouraged to not use this
/// property since it is not thread safe and PSPDFUndoController manages the state of this undo manager.
/// However, since UIResponders can provide an undo manager, this property is exposed.
@property (nonatomic, strong, readonly) NSUndoManager *undoManager;

/// Specifies the time interval that is used for PSPDFUndoCoalescingTimed. Defaults to 1 second.
@property (nonatomic, assign) NSTimeInterval timedCoalescingInterval;

/// Specifies the levels of undo we allow. Defaults to 20. More means higher memory usage.
@property (nonatomic, assign) NSUInteger levelsOfUndo;

@end

@interface PSPDFUndoController (TimeCoalescingSupport)

/// Commits all incomplete undo actions. This method is automatically called before undoing or redoing,
/// so there's usually no need to call this method directly.
- (void)commitIncompleteUndoActions;

/// Indicates that there are still incomplete undo actions because of a coalescing policy.
- (BOOL)hasIncompleteUndoActions;

/// Returns the name of the most recent incomplete action or nil.
- (NSString *)incompleteUndoActionName;

@end
