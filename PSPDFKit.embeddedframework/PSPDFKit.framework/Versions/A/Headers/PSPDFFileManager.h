//
//  PSPDFFileManager.h
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
#import "PSPDFSecurityAuditor.h"

// Wraps file system calls. Internal class cluster.
// Can be replaced with Enterprise SDK wrappers like Good Technology or MobileIron AppConnect.
@protocol PSPDFFileManager <PSPDFPlugin>

// If YES, then we can't use certain more optimized methods like `UIGraphicsBeginPDFContextToFile` since they would use write methods that we can't override.
- (BOOL)usesEncryption;

// We query the file manager for exceptions where we require unencrypted files on disk.
// This method expects to return YES for any type if `usesEncryption` returns NO.
// Various features in PSPDFKit require unencryted files while usage (Open In, QuickLook, Audio Recording)
- (BOOL)allowsSecurityException:(PSPDFSecurityEvent)exception;

// Copies a file to an unencrypted location if the security check passes.
- (NSURL *)copyFileToUnencryptedLocationIfRequired:(NSURL *)fileURL securityException:(PSPDFSecurityEvent)securityException error:(NSError *__autoreleasing*)error;

// Cleans up a temporary file. Searches both in encrypted store (if encrypted) and default disk store.
- (BOOL)cleanupIfTemporaryFile:(NSURL *)URL;

// Directories
- (NSString *)libraryDirectory;
- (NSString *)cachesDirectory;
- (NSString *)documentDirectory;
- (NSString *)temporaryDirectoryWithUID:(NSString *)UID;
- (NSString *)unencryptedTemporaryDirectoryWithUID:(NSString *)UID; // by default same as `temporaryDirectoryWithUID:`.
- (BOOL)isNativePath:(NSString *)path; // Returns true if path is native to the iOS file system.

// Existence checks
- (BOOL)fileExistsAtPath:(NSString *)path;
- (BOOL)fileExistsAtPath:(NSString *)path isDirectory:(BOOL *)isDirectory;
- (BOOL)fileExistsAtURL:(NSURL *)url;
- (BOOL)fileExistsAtURL:(NSURL *)url isDirectory:(BOOL *)isDirectory;

// Creation
- (BOOL)createFileAtPath:(NSString *)path contents:(NSData *)data attributes:(NSDictionary *)attr;
- (BOOL)createDirectoryAtPath:(NSString *)path withIntermediateDirectories:(BOOL)createIntermediates attributes:(NSDictionary *)attributes error:(NSError *__autoreleasing*)error;

// Writing
- (BOOL)writeData:(NSData *)data toFile:(NSString *)path options:(NSDataWritingOptions)writeOptionsMask error:(NSError *__autoreleasing*)error;

// Reading
- (NSData *)dataWithContentsOfFile:(NSString *)path options:(NSDataReadingOptions)readOptionsMask error:(NSError *__autoreleasing*)error;

// Copy / Move
- (BOOL)copyItemAtURL:(NSURL *)srcURL toURL:(NSURL *)dstURL error:(NSError *__autoreleasing*)error;
- (BOOL)moveItemAtURL:(NSURL *)srcURL toURL:(NSURL *)dstURL error:(NSError *__autoreleasing*)error;

// Deletion
- (BOOL)removeItemAtPath:(NSString *)path error:(NSError *__autoreleasing*)error;
- (BOOL)removeItemAtURL:(NSURL *)URL error:(NSError *__autoreleasing*)error;

// File Statistics
- (NSDictionary *)attributesOfFileSystemForPath:(NSString *)path error:(NSError *__autoreleasing*)error;
- (NSDictionary *)attributesOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing*)error;
- (BOOL)isDeletableFileAtPath:(NSString *)path;
- (BOOL)isWritableFileAtPath:(NSString *)path;

// Directory Query
- (NSArray *)contentsOfDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing*)error;
- (NSArray *)subpathsOfDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing*)error;

// Misc
- (NSDirectoryEnumerator *)enumeratorAtPath:(NSString *)path;
- (NSString *)destinationOfSymbolicLinkAtPath:(NSString *)path error:(NSError *__autoreleasing*)error;

// Returns the absolute path as C string.
- (const char *)fileSystemRepresentationForPath:(NSString *)path NS_RETURNS_INNER_POINTER;

// NSFileHandle
- (BOOL)fileHandleForReadingFromURL:(NSURL *)url error:(NSError *__autoreleasing*)error withBlock:(BOOL(^)(NSFileHandle *))reader;
- (BOOL)fileHandleForWritingToURL:(NSURL *)url error:(NSError *__autoreleasing*)error withBlock:(BOOL(^)(NSFileHandle *))writer;
- (BOOL)fileHandleForUpdatingURL:(NSURL *)url error:(NSError *__autoreleasing*)error withBlock:(BOOL(^)(NSFileHandle *))updater;

@end

// The default file manager implementation.

extern NSString * const PSPDFFileManagerOptionCoordinatedAccess;
extern NSString * const PSPDFFileManagerOptionFilePresenter;

@interface PSPDFDefaultFileManager : NSObject <PSPDFFileManager>
@end
