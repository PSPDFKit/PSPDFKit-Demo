//
//  PSPDFXFDFParser.h
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

/// Parses an XML in the XFDF standard.
/// http://partners.adobe.com/public/developer/en/xml/XFDF_Spec_3.0.pdf
@interface PSPDFXFDFParser : NSObject

/// Designated initializer.
- (id)initWithInputStream:(NSInputStream *)inputStream documentProvider:(PSPDFDocumentProvider *)documentProvider;

/// Parse XML and block until it's done. Returns the resulting annotations after parsing is finished
/// (which can also be accessed later on).
- (NSArray *)parseWithError:(NSError **)error;

/// Return all annotations as array. Annotations are sorted by page.
- (NSArray *)annotations;

/// Returns YES if parsing has ended for `inputStream`.
@property (nonatomic, assign, readonly) BOOL parsingEnded;

/// The attached document provider.
@property (nonatomic, weak, readonly) PSPDFDocumentProvider *documentProvider;

/// The used inputStream
@property (nonatomic, strong, readonly) NSInputStream *inputStream;

@end
