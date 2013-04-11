//
//  PSPDFActionGoTo.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFAction.h"

/// Defines the action of going to a specific location within the PDF document.
@interface PSPDFActionGoTo : PSPDFAction

/// Initializer.
- (id)initWithPageIndex:(NSUInteger)pageIndex;

/// Initializer, will set pageIndex to NSNotFound.
- (id)initWithNamedDestination:(NSString *)namedDestination;

/// Set to NSNotFound if not valid.
@property (nonatomic, assign) NSUInteger pageIndex;

/// @name Named Destination

/// Named destination. if pageIndex is NSNotFound, the named destination hasn't yet been resolved.
/// Once the named destination has been resolved (or failed to resolve) this property will be set to nil.
@property (nonatomic, copy, readonly) NSString *namedDestination;

/// Resolve named destination using `documentProvider`. Only valid for PSPDFActionTypeGoTo.
/// On success, returns YES and sets `pageIndex`.
- (BOOL)resolveNamedDestionationWithDocumentProvider:(PSPDFDocumentProvider *)documentProvider;

/// Similar to `resolveNamedDestionationWithDocumentProvider:` but will optimize the calls to not resolve similar destinations twice.
/// `documentRef` needs to be the matching documentRef.
/// @return Returns the number of resolved actions.
+ (NSUInteger)resolveActionsWithNamedDestinations:(NSArray *)actions documentRef:(CGPDFDocumentRef)documentRef;

@end
