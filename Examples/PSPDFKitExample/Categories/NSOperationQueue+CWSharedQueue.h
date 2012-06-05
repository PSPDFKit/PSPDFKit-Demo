//
//  NSOperationQueue+CWSharedQueue.h
//
//  Created by Fredrik Olsson on 2008-10-28.
//  Copyright 2008 Fredrik Olsson. All rights reserved.
//

#ifndef CW_DEFAULT_OPERATION_COUNT
	#define CW_DEFAULT_OPERATION_COUNT 3
#endif

@interface NSOperationQueue (CWSharedQueue)

/*!
 * Returns the shared NSOperationQueue instance. A shared instance with max
 * concurent operations set to CW_DEFAULT_OPERATION_COUNT will be created if no
 * shared instance has previously been set, or created.
 *
 * @result a shared NSOperationQueue instance.
 */
+ (NSOperationQueue*)sharedOperationQueue;

/*!
 * Set the shared NSOperationQueue instance.
 *
 * @param operationQueue the new shared NSOperationQueue instance.
 */
+ (void)setSharedOperationQueue:(NSOperationQueue*)operationQueue;

@end
