//
//  PSPDFFileAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAnnotation.h"

@interface PSPDFFileAnnotation : PSPDFAnnotation

/// URL to the file content.
@property (nonatomic, strong) NSURL *URL;

/// File name, as extracted from the annotation.
@property (nonatomic, copy) NSString *fileName;

/// File appearance name. Defines how the attachment looks. Supported are PushPin, Paperclip, Graph and Tag.
@property (nonatomic, copy) NSString *appearanceName;

@end
