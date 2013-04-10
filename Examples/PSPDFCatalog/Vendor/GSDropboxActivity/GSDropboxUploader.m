//
//  GSDropboxUploader.m
//
//  Created by Simon Whitaker on 06/11/2012.
//  Copyright (c) 2012 Goo Software Ltd. All rights reserved.
//

#import "GSDropboxUploader.h"
#import "GSDropboxUploadJob.h"
#import <DropboxSDK/DropboxSDK.h>

NSString *const GSDropboxUploaderDidStartUploadingFileNotification = @"GSDropboxUploaderDidStartUploadingFileNotification";
NSString *const GSDropboxUploaderDidFinishUploadingFileNotification = @"GSDropboxUploaderDidFinishUploadingFileNotification";
NSString *const GSDropboxUploaderDidGetProgressUpdateNotification = @"GSDropboxUploaderDidGetProgressUpdateNotification";
NSString *const GSDropboxUploaderDidFailNotification = @"GSDropboxUploaderDidFailNotification";

NSString *const GSDropboxUploaderFileURLKey = @"GSDropboxUploaderFileURLKey";
NSString *const GSDropboxUploaderProgressKey = @"GSDropboxUploaderProgressKey";

@interface GSDropboxUploader() <DBRestClientDelegate>

// inFlightUploadJob: the file wrapper currently being uploaded
@property (nonatomic, strong) GSDropboxUploadJob *_inFlightUploadJob;
@property (nonatomic, strong) NSMutableArray *_uploadQueue;
@property (nonatomic, strong) DBRestClient *_dropboxClient;

- (void)_serviceQueue;

@end

@implementation GSDropboxUploader

- (id)init
{
    self = [super init];
    if (self) {
        self._uploadQueue = [NSMutableArray array];
    }
    return self;
}

+ (GSDropboxUploader *)sharedUploader
{
    static dispatch_once_t once;
    static GSDropboxUploader *singleton;
    dispatch_once(&once, ^ { singleton = [[GSDropboxUploader alloc] init]; });
    return singleton;
}

- (void)uploadFileWithURL:(NSURL *)fileURL toPath:(NSString *)destinationPath
{
    [self._uploadQueue addObject:[GSDropboxUploadJob uploadJobWithFileURL:fileURL
                                                       andDestinationPath:destinationPath]];
    [self _serviceQueue];
}

- (void)start
{
    [self _serviceQueue];
}

- (void)_serviceQueue
{
    if ([self._uploadQueue count] > 0 && self._inFlightUploadJob == nil) {
        @synchronized(self) {
            self._inFlightUploadJob = [self._uploadQueue objectAtIndex:0];
            [self._uploadQueue removeObjectAtIndex:0];
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:GSDropboxUploaderDidStartUploadingFileNotification
                                                            object:self
                                                          userInfo:@{GSDropboxUploaderFileURLKey: self._inFlightUploadJob.fileURL}];
        [self._dropboxClient uploadFile:self._inFlightUploadJob.fileURL.lastPathComponent
                                toPath:self._inFlightUploadJob.destinationPath
                         withParentRev:nil
                              fromPath:self._inFlightUploadJob.fileURL.path];
    }
}

- (NSUInteger)pendingUploadCount
{
    return [self._uploadQueue count];
}

- (DBRestClient *)_dropboxClient
{
    if (__dropboxClient == nil && [DBSession sharedSession] != nil) {
        __dropboxClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        __dropboxClient.delegate = self;
    }
    return __dropboxClient;
}

#pragma mark - Dropbox client delegate methods

- (void)restClient:(DBRestClient*)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath metadata:(DBMetadata*)metadata {
    [[NSNotificationCenter defaultCenter] postNotificationName:GSDropboxUploaderDidFinishUploadingFileNotification
                                                        object:self
                                                      userInfo:@{GSDropboxUploaderFileURLKey: self._inFlightUploadJob.fileURL}];
    self._inFlightUploadJob = nil;
    [self _serviceQueue];
//    NSLog(@"Upload finished");
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:GSDropboxUploaderDidFailNotification
                                                        object:self
                                                      userInfo:@{GSDropboxUploaderFileURLKey: self._inFlightUploadJob.fileURL}];
    self._inFlightUploadJob = nil;
    [self _serviceQueue];
//    NSLog(@"Upload failed with error: %@", error);
}

- (void)restClient:(DBRestClient*)client uploadProgress:(CGFloat)progress
           forFile:(NSString *)destPath from:(NSString *)srcPath
{
    NSDictionary *userInfo = @{
        GSDropboxUploaderFileURLKey: self._inFlightUploadJob.fileURL,
        GSDropboxUploaderProgressKey: @(progress),
    };
//    NSLog(@"%@", userInfo);
    [[NSNotificationCenter defaultCenter] postNotificationName:GSDropboxUploaderDidGetProgressUpdateNotification
                                                        object:self
                                                      userInfo:userInfo];
}

@end
