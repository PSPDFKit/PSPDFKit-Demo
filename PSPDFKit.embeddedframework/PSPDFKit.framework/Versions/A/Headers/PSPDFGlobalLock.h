//
//  PSPDFGlobalLock.h
//  PSPDFKit
//
//  Copyright 2011-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

/// PDF reading needs memory, which is a rare resource. So we lock access very carefully.
@interface PSPDFGlobalLock : NSObject

/// Get global singleton.
+ (instancetype)sharedGlobalLock;

/// Will lock if the internal counter is depleted.
/// Counter value will depend on the device (cores, memory)
- (void)lock;

/// Will unlock and potentially signal waiting threads on lock.
- (void)unlock;

@end
