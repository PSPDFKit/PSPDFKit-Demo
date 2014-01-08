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

@protocol PSPDFRemoteContentObject <NSObject>

/// The URL request used for loading the remote content.
- (NSURLRequest *)URLRequestForRemoteContent;

/// The remote content of the object. This property is managed by `PSPDFDownloadManager`.
@property (nonatomic, strong) id remoteContent;

@optional

/// The loading state of the object. This property is managed by `PSPDFDownloadManager`.
@property (nonatomic, assign, getter = isLoadingRemoteContent) BOOL loadingRemoteContent;

/// The download progress of the object. Only meaningful if loadingRemoteContent is YES.
/// This property is managed by PSPDFDownloadManager.
@property (nonatomic, assign) CGFloat remoteContentProgress;

/// The remote content error of the object. This property is managed by PSPDFDownloadManager.
@property (nonatomic, strong) NSError *remoteContentError;

/// Return YES if you want `PSPDFDownloadManager` to cache the remote content. Defaults to NO.
- (BOOL)shouldCacheRemoteContent;

/// Return YES if you want `PSPDFDownloadManager` to retry downloading remote content if a connection
/// error occured. Defaults to NO.
- (BOOL)shouldRetryLoadingRemoteContentOnConnectionFailure;

/// Return a block if you need to handle a authentication challenge.
- (void (^)(NSURLAuthenticationChallenge *challenge))remoteContentAuthenticationChallengeBlock;

/// Return a custom `NSValueTransform` that is applied to the downloaded data before setting `remoteContent`.
/// An example for this would be a transformer that transform NSData into an UIImage. The transformation
/// happens on a background thread and is part of the loading state.
- (NSValueTransformer *)valueTransformerForRemoteContent;

/// Return `YES` if the object actually has remote content. Since most `PSPDFRemoteContentObject`s
/// will have remote content, this method is optional. If it is not implemented, `YES` will be
/// assumed.
- (BOOL)hasRemoteContent;

@end
