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
#import "PSPDFStreamProvider.h"

@class PSPDFDocumentProvider;

/// Abstracts an embedded file.
@interface PSPDFEmbeddedFile : PSPDFModel <PSPDFStreamProvider>

/// Designated initializer.
- (instancetype)initWithFileName:(NSString *)fileName size:(NSUInteger)fileSize description:(NSString *)description modificationDate:(NSDate *)modificationDate NS_DESIGNATED_INITIALIZER;

/// File name.
@property (nonatomic, copy, readonly) NSString *fileName;

/// File size.
@property (nonatomic, assign, readonly) NSUInteger fileSize;

/// File description. Optional.
@property (nonatomic, copy, readonly) NSString *fileDescription;

/// File modification date (if set)
@property (nonatomic, strong, readonly) NSDate *modificationDate;

/// If the file URL has been extracted by XFDF or external saving, it is set here.
@property (nonatomic, copy) NSURL *fileURL;

@end
