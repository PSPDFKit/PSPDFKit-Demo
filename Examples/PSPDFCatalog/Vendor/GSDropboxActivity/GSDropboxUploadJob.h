//
//  GSDropboxUploadJob.h
//
//  Created by Simon Whitaker on 24/11/2012.
//  Copyright (c) 2012 Goo Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSDropboxUploadJob : NSObject

@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, strong) NSString *destinationPath;

+ (GSDropboxUploadJob *)uploadJobWithFileURL:(NSURL *)fileURL andDestinationPath:(NSString *)destinationPath;

@end
