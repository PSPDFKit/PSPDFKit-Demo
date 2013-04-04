//
//  PSPDFGlobalLock.h
//  PSPDFKit
//
//  Copyright 2011-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFDocumentProvider;

/// PDF reading needs memory, which is a rare resource. So we lock access very carefully.
@interface PSPDFGlobalLock : NSObject <NSLocking>

/// Get global singleton.
+ (instancetype)sharedGlobalLock;

/// @name Render Lock

/// Will lock if the internal counter is depleted.
/// Counter value will depend on the device (cores, memory)
- (void)lock;

/// Will unlock and potentially signal waiting threads on lock.
- (void)unlock;

/// @name Document Provider Tracking

/// Register any document provider that opens a CGPDFDocument reference.
- (void)registerDocumentProvider:(PSPDFDocumentProvider *)documentProvider;

/// Removes any document provider who closed the document reference.
- (void)deregisterDocumentProvider:(PSPDFDocumentProvider *)documentProvider;

/// Requests a document close on all providers - might not be instant if they curently work with the reference.
- (void)freeAllDocumentProviders;

/// Number of requests we allow to keep in memory for faster access.
@property (atomic, assign) NSUInteger allowedOpenDocumentRequests;

/// Sends close messages until we have the allowed number of document providers open.
- (void)limitOpenDocumentProviders;

@end
