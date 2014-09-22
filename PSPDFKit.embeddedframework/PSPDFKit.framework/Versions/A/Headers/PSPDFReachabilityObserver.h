//
//  PSPDFReachabilityObserver.h
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

typedef NS_ENUM(NSUInteger, PSPDFReachability) {
    PSPDFReachabilityUnknown,
    PSPDFReachabilityUnreachable,
    PSPDFReachabilityWiFi,
    PSPDFReachabilityWWAN
};

/// Posted when the reachability changes.
extern NSString *const PSPDFReachabilityDidChangeNotification;

@interface PSPDFReachabilityObserver : NSObject

/// The current reachability. This property is only meaningful if `startObserving` has been called.
@property (nonatomic, assign, readonly) PSPDFReachability reachability;

/// Returns YES if the reachability is either `PSPDFReachabilityWiFi` or `PSPDFReachabilityWWAN`.
@property (nonatomic, assign, readonly, getter = isReachable) BOOL reachable;

/// Returns the default reachability observer.
+ (instancetype)defaultObserver;

/// Starts observing the reachability. This method is stack-based, so multiple calls are fine.
- (void)startObserving;

/// Stops observing the reachability. This method is stack-based, so multiple calls
// (as long as they are balanced with `startObserving`) are fine.
- (void)stopObserving;

@end

// Convenience tracker that uses the `defaultObserver` internally.
@interface PSPDFReachabilityTracker : NSObject

// `reachabilityBlock` will be executed once reachability changes in a way where it becomes reachable.
+ (instancetype)trackReachabilityWithBlock:(void (^)())reachabilityBlock;

@end
