//
//  GSDropboxUploader.h
//
//  Created by Simon Whitaker on 06/11/2012.
//  Copyright (c) 2012 Goo Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSDropboxUploader : NSObject

/* NSNotification names */
extern NSString *const GSDropboxUploaderDidStartUploadingFileNotification;
extern NSString *const GSDropboxUploaderDidFinishUploadingFileNotification;
extern NSString *const GSDropboxUploaderDidGetProgressUpdateNotification;
extern NSString *const GSDropboxUploaderDidFailNotification;

/* UserInfo dictionary keys */
extern NSString *const GSDropboxUploaderFileURLKey;
extern NSString *const GSDropboxUploaderProgressKey;

/* The singleton Dropbox uploader - use this for all your Dropbox uploads */
+ (GSDropboxUploader*)sharedUploader;

- (void)uploadFileWithURL:(NSURL *)fileURL toPath:(NSString *)destinationPath;

/* Uploads are processed one at a time. If you call uploadFileWithURL:toPath: while an upload's already in progress the new upload will be queued. pendingUploadCount returns the number of uploads currently in the queue pending processing. */
- (NSUInteger)pendingUploadCount;

@end
