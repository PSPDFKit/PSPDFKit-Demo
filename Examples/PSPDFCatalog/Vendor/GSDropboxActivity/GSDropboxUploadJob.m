//
//  GSDropboxUploadJob.m
//
//  Created by Simon Whitaker on 24/11/2012.
//  Copyright (c) 2012 Goo Software Ltd. All rights reserved.
//

#import "GSDropboxUploadJob.h"

@implementation GSDropboxUploadJob

+ (GSDropboxUploadJob *)uploadJobWithFileURL:(NSURL *)fileURL andDestinationPath:(NSString *)destinationPath
{
    GSDropboxUploadJob *job = [[GSDropboxUploadJob alloc] init];
    NSParameterAssert([fileURL isKindOfClass:[NSURL class]]);
    NSParameterAssert([destinationPath isKindOfClass:[NSString class]]);
    job.fileURL = fileURL;
    job.destinationPath = destinationPath;
    return job;
}

@end
