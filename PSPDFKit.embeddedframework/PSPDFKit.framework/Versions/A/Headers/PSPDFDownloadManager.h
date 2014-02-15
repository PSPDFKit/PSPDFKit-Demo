//
//  PSPDFDownloadManager.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import "PSPDFReachabilityObserver.h"

typedef NS_ENUM(NSUInteger, PSPDFDownloadManagerObjectState) {
    PSPDFDownloadManagerObjectStateNotHandled,
    PSPDFDownloadManagerObjectStateWaiting,
    PSPDFDownloadManagerObjectStateLoading,
    PSPDFDownloadManagerObjectStateFailed
};

@class PSPDFFileCache;
@protocol PSPDFRemoteContentObject, PSPDFDownloadManagerDelegate;

@interface PSPDFDownloadManager : NSObject

/// @name Configuration

/// The maximum number of concurrent downloads. Defaults to 2.
/// If `enableDynamicNumberOfConcurrentDownloads` is enabled, this property will change dynamically
/// and must be considered readonly.
@property (nonatomic, assign) NSUInteger numberOfConcurrentDownloads;

/// Enable this property to let `PSPDFDownloadManager` decide what the best number of concurrent downloads
/// is depending on the network connection. Defaults to YES.
@property (nonatomic, assign) BOOL enableDynamicNumberOfConcurrentDownloads;

/// The `PSPDFDownloadManager` delegate.
@property (nonatomic, assign) id <PSPDFDownloadManagerDelegate> delegate;

/// Controls if objects that are currently loading when the app moves to the background
/// should be completed in the background. Defaults to YES.
@property (nonatomic, assign) BOOL shouldFinishLoadingObjectsInBackground;

/// @name Enqueueing and Dequeueing Objects

/// The cache used for caching. Defaults to `[PSPDFFileCache defaultCache]`.
@property (nonatomic, strong) PSPDFFileCache *cache;

/// See enqueueObject:atFront:. Enqueues the object at the end of the queue.
- (void)enqueueObject:(id <PSPDFRemoteContentObject>)object;

/**
 * Enqueues an `PSPDFRemoteContentObject` for download. If the object is already downloading,
 * nothing is enqueued. If the object has been downloaded previously and has failed, it will be
 * removed from the failedObjects array and re-enqueued.
 *
 * @param object The object to enqueue.
 * @param enqueueAtFront Set this to YES to add the object to the front of the queue.
 */
- (void)enqueueObject:(id <PSPDFRemoteContentObject>)object atFront:(BOOL)enqueueAtFront;

/// Calls enqueueObject:atFont: multiple times. Enqueues the object at the end of the queue.
- (void)enqueueObjects:(NSArray *)objects;

/// Calls enqueueObject:atFont: multiple times.
- (void)enqueueObjects:(NSArray *)objects atFront:(BOOL)enqueueAtFront;

/**
 * Cancels the download process for the given object.
 *
 * @param object The object to be cancelled.
 */
- (void)cancelObject:(id <PSPDFRemoteContentObject>)object;

/// Calls `cancelObject:` for all objects in `pendingObjects`, `loadingObjects`, and `failedObjects`.
- (void)cancelAllObjects;

/// @name State

/// The current reachability of the device.
@property (nonatomic, assign, readonly) PSPDFReachability reachability;

/// Contains all objects waiting to be downloaded.
@property (nonatomic, copy, readonly) NSArray *waitingObjects;

/// Contains all currently loading objects.
@property (nonatomic, copy, readonly) NSArray *loadingObjects;

/// Contains all objects that have failed because of a network error and are scheduled for retry.
@property (nonatomic, copy, readonly) NSArray *failedObjects;

/**
 * Checks if the given object is currently handled by the download manager.
 * @param object The object.
 * @return YES if the download manager handles the object, that is if it is either pending, loading or failed.
 */
- (BOOL)handlesObject:(id <PSPDFRemoteContentObject>)object;

/**
 * Checks and returns the current state of a given object. If the object has never been enqueued,
 * `PSPDFDownloadManagerObjectStateNotHandled` will be returned.
 * @param object The object.
 * @return The state of the object.
 */
- (PSPDFDownloadManagerObjectState)stateForObject:(id <PSPDFRemoteContentObject>)object;

@end

@protocol PSPDFDownloadManagerDelegate <NSObject>

@optional

/**
 * Informs the delegate that the state of the given object has changed.
 * @param downloadManager The download manager.
 * @param object The changed object.
 */
- (void)downloadManager:(PSPDFDownloadManager *)downloadManager didChangeObject:(id <PSPDFRemoteContentObject>)object;

/**
 * Informs the delegate that the reachability has changed.
 * @param downloadManager The download manager.
 * @param reachability The new reachability.
 */
- (void)downloadManager:(PSPDFDownloadManager *)downloadManager reachabilityDidChange:(PSPDFReachability)reachability;

@end
