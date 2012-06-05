//
//  NSOperationQueue+CWSharedQueue.m
//
//  Created by Fredrik Olsson on 2008-10-28.
//  Copyright 2008 Fredrik Olsson. All rights reserved.
//

#import "NSOperationQueue+CWSharedQueue.h"

@implementation NSOperationQueue (CWSharedQueue)

static NSOperationQueue* cw_sharedOperationQueue = nil;

+ (NSOperationQueue *)sharedOperationQueue {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cw_sharedOperationQueue = [[NSOperationQueue alloc] init];
        [cw_sharedOperationQueue setMaxConcurrentOperationCount:CW_DEFAULT_OPERATION_COUNT];
    });
  return cw_sharedOperationQueue;
}

+ (void)setSharedOperationQueue:(NSOperationQueue *)operationQueue {
	if (operationQueue != cw_sharedOperationQueue) {
    cw_sharedOperationQueue = operationQueue;
  }
}

@end
