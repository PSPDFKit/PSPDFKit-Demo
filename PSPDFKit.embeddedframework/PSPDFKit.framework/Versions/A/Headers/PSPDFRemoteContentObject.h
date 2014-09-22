//
//  PSPDFRemoteContentObject.h
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

typedef void(^PSPDFRemoteContentObjectAuthenticationBlock)(NSURLAuthenticationChallenge *, void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential));
typedef id(^PSPDFRemoteContentObjectTransformerBlock)(NSURL *location);

@protocol PSPDFRemoteContentObject <NSObject>

/// The URL request used for loading the remote content.
- (NSURLRequest *)URLRequestForRemoteContent;

/// The remote content of the object. This property is managed by `PSPDFDownloadManager`.
@property (nonatomic, strong) id remoteContent;

@optional

/// The loading state of the object. This property is managed by `PSPDFDownloadManager`.
@property (nonatomic, assign, getter=isLoadingRemoteContent) BOOL loadingRemoteContent;

/// The download progress of the object. Only meaningful if `loadingRemoteContent` is YES.
/// This property is managed by `PSPDFDownloadManager`.
@property (nonatomic, assign) CGFloat remoteContentProgress;

/// The remote content error of the object. This property is managed by `PSPDFDownloadManager`.
@property (nonatomic, strong) NSError *remoteContentError;

/// Return YES if you want `PSPDFDownloadManager` to cache the remote content. Defaults to NO.
- (BOOL)shouldCacheRemoteContent;

/// Return YES if you want `PSPDFDownloadManager` to retry downloading remote content if a connection
/// error occurred. Defaults to NO.
- (BOOL)shouldRetryLoadingRemoteContentOnConnectionFailure;

/// Return a block if you need to handle a authentication challenge.
- (PSPDFRemoteContentObjectAuthenticationBlock)remoteContentAuthenticationChallengeBlock;

/// Return a custom `PSPDFRemoteContentObjectTransformerBlock`. The passed-in `NSURL` points to the
/// file that stores the downloaded data. The return value is set to `remoteContent`. If no transformer
/// block is provided, `remoteContent` will be set to data (represented by `NSData`) of the downloaded
/// content.
/// @note If `shouldCacheRemoteContent` returns `YES` the location of the file is not temporary.
/// @note `remoteContentTransformerBlock` will be called on a background queue, so you may perform
/// long-running tasks.
/// @warning Since this runs on a background queue, you should not access state outside of the block's
/// scope to avoid thread-safety problems.
- (PSPDFRemoteContentObjectTransformerBlock)remoteContentTransformerBlock;

/// Return `YES` if the object actually has remote content. Since most `PSPDFRemoteContentObject`s
/// will have remote content, this method is optional. If it is not implemented, `YES` will be assumed.
- (BOOL)hasRemoteContent;

/// The completion block, called after loading finished.
@property (nonatomic, copy) void (^completionBlock)(id<PSPDFRemoteContentObject> remoteObject);

@end
