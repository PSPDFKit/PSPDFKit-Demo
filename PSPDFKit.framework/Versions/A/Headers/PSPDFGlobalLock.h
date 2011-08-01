//
//  AMPDFGlobalLock.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 7/20/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>

// pdf reading needs memory, which is a rare resource.  
@interface PSPDFGlobalLock : NSObject {
  BOOL                clearCacheRequested_;
  CGPDFPageRef        pdfPage_;
  NSUInteger          page_;
  CGPDFDocumentRef    pdfDocument_;
  NSURL               *pdfPath_;
  NSLock              *pdfGlobalLock_;
}

+ (PSPDFGlobalLock *)sharedPSPDFGlobalLock;

// lock and free
- (CGPDFPageRef)tryLockWithPath:(NSURL *)pdfPath page:(NSUInteger)page; // returns early
- (CGPDFPageRef)lockWithPath:(NSURL *)pdfPath page:(NSUInteger)page;    // waits
- (void)freeWithPDFPageRef:(CGPDFPageRef)pdfPage;

// special lock for zip
- (void)lockForZip;
- (void)unlockForZip;

@end
