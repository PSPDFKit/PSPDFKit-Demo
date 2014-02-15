//
//  PSPDFRemoteFileObject.h
//  PSPDFKit
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import "PSPDFRemoteContentObject.h"

@interface PSPDFRemoteFileObject : NSObject <PSPDFRemoteContentObject>

// Designated initializer.
- (id)initWithRemoteURL:(NSURL *)remoteURL targetURL:(NSURL *)targetFileURL;

// The remote URL to fetch the content from.
@property (nonatomic, strong, readonly) NSURL *remoteURL;
@property (nonatomic, strong, readonly) NSURL *targetURL;

/// @name PSPDFRemoteContentObject

/// The remote content of the object. This property is managed by `PSPDFDownloadManager`.
@property (nonatomic, strong) NSURL *remoteContent;

/// The loading state of the object. This property is managed by `PSPDFDownloadManager`.
@property (nonatomic, assign, getter = isLoadingRemoteContent) BOOL loadingRemoteContent;

/// The download progress of the object. Only meaningful if `loadingRemoteContent` is YES.
/// This property is managed by `PSPDFDownloadManager`.
@property (nonatomic, assign) CGFloat remoteContentProgress;

/// The remote content error of the object. This property is managed by `PSPDFDownloadManager`.
@property (nonatomic, strong) NSError *remoteContentError;

/// Custom request data. Not used by PSPDFKit.
@property (nonatomic, copy) NSDictionary *userInfo;

// The completion block.
@property (nonatomic, copy) void (^completionBlock)(id <PSPDFRemoteContentObject> remoteObject);

@end
