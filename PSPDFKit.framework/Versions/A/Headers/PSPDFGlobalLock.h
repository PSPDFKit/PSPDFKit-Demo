//
//  PSPDFGlobalLock.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class PSPDFDocument;

/// pdf reading needs memory, which is a rare resource. So we lock access very carefully.
@interface PSPDFGlobalLock : NSObject

/// get global singleton.
+ (PSPDFGlobalLock *)sharedPSPDFGlobalLock;

/// TRY to lock with document and logical page number (starts at 0).
/// returns nil if currently locked.
- (CGPDFPageRef)tryLockWithDocument:(PSPDFDocument *)document page:(NSUInteger)page error:(NSError **)error; // returns early

/// lock with document and logical page number (starts at 0).
- (CGPDFPageRef)lockWithDocument:(PSPDFDocument *)document page:(NSUInteger)page error:(NSError **)error;    // waits

/// free lock with CGPDFPageRef.
- (void)freeWithPDFPageRef:(CGPDFPageRef)pdfPage;

/// special lock for your application (e.g. unzip)
// use this if you perform an operation in background that needs lots of memory.
- (void)lockGlobal;

/// special global unlock. Use with lockGlobal.
- (void)unlockGlobal;

/// clears internal document/page cache. Usually no need to call externally, until you change a already displayed pdf file.
- (void)requestClearCacheAndWait:(BOOL)wait;

@end
