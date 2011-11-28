//
//  PSPDFGlobalLock.h
//  PSPDFKit
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

/// pdf reading needs memory, which is a rare resource. So we lock access very carefully.
@interface PSPDFGlobalLock : NSObject

/// get global singleton.
+ (PSPDFGlobalLock *)sharedPSPDFGlobalLock;

/// TRY to lock with path and real pdf page number (starts at 1). Get page via [PSPDFDocument pageNumberForPage:].
/// returns nil if currently locked.
- (CGPDFPageRef)tryLockWithPath:(NSURL *)pdfPath page:(NSUInteger)page; // returns early

/// lock with path and real pdf page number (starts at 1). Get page via [PSPDFDocument pageNumberForPage:].
- (CGPDFPageRef)lockWithPath:(NSURL *)pdfPath page:(NSUInteger)page;    // waits

/// returns auto-released document reference, doesn't use the lock.
- (CGPDFDocumentRef)documentRefWithPath:(NSURL *)pdfPath; 

/// returns a page reference that is autoreleased, doesn't lock the system.
/// still needs to be returned, we crash if the underlying CGPDFDocumentRef is released prematurely. 
- (CGPDFPageRef)pageRefWithPath:(NSURL *)pdfPath page:(NSUInteger)page; // DANGER, WILL ROBINSON!

/// free lock with CGPDFPageRef.
- (void)freeWithPDFPageRef:(CGPDFPageRef)pdfPage;

/// optain a document reference with real path.
- (CGPDFDocumentRef)lockDocumentWithPath:(NSURL *)pdfPath;

/// free document reference. only use if opened via lockDocumentWithPath.
- (void)freeWithPDFDocument:(CGPDFDocumentRef)pdfDocument;

/// special lock for your application (e.g. unzip)
// use this if you perform an operation in background that needs lots of memory.
- (void)lockGlobal;

/// special global unlock. Use with lockGlobal.
- (void)unlockGlobal;

/// clears internal document/page cache. Usually no need to call externally, until you change a already displayed pdf file.
- (void)requestClearCacheAndWait:(BOOL)wait;

@end
