//
//  PSPDFXFDFParser.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import "PSPDFAnnotation.h"
#import "PSPDFAnnotationProvider.h"

/// Parses an XML in the XFDF standard.
/// http://partners.adobe.com/public/developer/en/xml/XFDF_Spec_3.0.pdf
@interface PSPDFXFDFParser : NSObject

/// Designated initializer.
- (instancetype)initWithInputStream:(NSInputStream *)inputStream documentProvider:(PSPDFDocumentProvider *)documentProvider NS_DESIGNATED_INITIALIZER;

/// Parse XML and block until it's done. Returns the resulting annotations after parsing is finished
/// (which can also be accessed later on).
- (NSArray *)parseWithError:(NSError *__autoreleasing*)error;

/// Return all annotations as array. Annotations are sorted by page.
@property (nonatomic, copy, readonly) NSArray *annotations;

/// Returns YES while we're parsing.
@property (atomic, assign, readonly, getter = isParsing) BOOL parsing;

/// Returns YES if parsing has ended for `inputStream`.
@property (atomic, assign, readonly) BOOL parsingEnded;

/// The attached document provider.
@property (nonatomic, weak, readonly) PSPDFDocumentProvider *documentProvider;

/// The used inputStream
@property (nonatomic, strong, readonly) NSInputStream *inputStream;

@end

// Converts sound encoding format name from XFDF spec values to PDF spec values
extern NSString *PSPDFConvertXFDFSoundEncodingToPDF(NSString *encoding);
