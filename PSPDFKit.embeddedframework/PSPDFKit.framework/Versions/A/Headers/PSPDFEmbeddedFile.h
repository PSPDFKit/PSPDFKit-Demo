//
//  PSPDFEmbeddedFile.h
//  PSPDFKit
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFModel.h"

@class PSPDFDocumentProvider;

/// Abstracts an embedded file.
@interface PSPDFEmbeddedFile : PSPDFModel

/// Designated initializer.
- (id)initWithFileName:(NSString *)fileName size:(NSUInteger)fileSize description:(NSString *)description modificationDate:(NSDate *)modificationDate index:(NSUInteger)index;

/// File name.
@property (nonatomic, copy, readonly) NSString *fileName;

/// File size.
@property (nonatomic, assign, readonly) NSUInteger fileSize;

/// File description. Optional.
@property (nonatomic, copy, readonly) NSString *fileDescription;

/// File modification date (if set)
@property (nonatomic, strong, readonly) NSDate *modificationDate;

/// The source document provider. Not used, but important if we want to get the actual file content via `PSPDFEmbeddedFileParser`.
@property (nonatomic, weak) PSPDFDocumentProvider *documentProvider;

@end
