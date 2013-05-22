//
//  PSCAnnotationTrailerCaptureDocument.m
//  PSPDFCatalog
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCAnnotationTrailerCaptureDocument.h"

@implementation PSCAnnotationTrailerCaptureDocument

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocumentProviderDelegate

// You can transmit the annotation trailer over to your server and re-attach the annotations there.
- (void)documentProvider:(PSPDFDocumentProvider *)documentProvider didAppendData:(NSData *)data {
    // Transmit it as *binary* data, not as string - the data output might also contain UTF16 parts and binary parts, the conversion here is just for debugging purposes, and the ascii conversion will break once it finds encoded stream data.
    NSLog(@"Annotation Trailer attached: %@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
}

@end
