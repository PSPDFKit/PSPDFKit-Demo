//
//  PSCFileHelper.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCFileHelper.h"

NSURL *PSCTempFileURLWithPathExtension(NSString *prefix, NSString *pathExtension) {
    if (pathExtension && ![pathExtension hasPrefix:@"."]) pathExtension = [NSString stringWithFormat:@".%@", pathExtension];
    if (!pathExtension) pathExtension = @"";

    CFUUIDRef UDIDRef = CFUUIDCreate(NULL);
    NSString *UDIDString = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL, UDIDRef));
    CFRelease(UDIDRef);
    if (prefix) UDIDString = [NSString stringWithFormat:@"_%@", UDIDString];

    NSURL *tempURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%@%@", prefix, UDIDString, pathExtension] isDirectory:NO];
    return tempURL;
}

NSURL *PSCCopyFileURLToDocumentFolderAndOverride(NSURL *documentURL, BOOL override) {
    // copy file from the bundle to a location where we can write on it.
    NSString *docsFolder = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *newPath = [docsFolder stringByAppendingPathComponent:[documentURL lastPathComponent]];
    NSURL *newURL = [NSURL fileURLWithPath:newPath];

    BOOL needsCopy = ![[NSFileManager defaultManager] fileExistsAtPath:newPath];
    if (override) {
        needsCopy = YES;
        [[NSFileManager defaultManager] removeItemAtURL:newURL error:NULL];
    }

    NSError *error;
    if (needsCopy &&
        ![[NSFileManager defaultManager] copyItemAtURL:documentURL toURL:newURL error:&error]) {
        NSLog(@"Error while copying %@: %@", documentURL.path, error.localizedDescription);
    }

    return newURL;
}
