//
//  PSPDFXFDFWriter.h
//  PSPDFKit
//
//  Copyright 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFAnnotation.h"
#import "PSPDFAnnotationProvider.h"

/// Writes an XML in XFDF standard from PSPDFKit annotations.
/// http://partners.adobe.com/public/developer/en/xml/XFDF_Spec_3.0.pdf
@interface PSPDFXFDFWriter : NSObject

/// Writes the given annotations to the given outputstream, blockingly.
- (BOOL)writeAnnotations:(NSArray *)annotations toOutputStream:(NSOutputStream *)outputStream documentProvider:(PSPDFDocumentProvider *)documentProvider error:(NSError **)error;

@end
