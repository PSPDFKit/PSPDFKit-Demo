//
//  PSCAssetLoader.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAssetLoader.h"

@implementation PSCAssetLoader

+ (PSPDFDocument *)sampleDocumentWithName:(NSString *)name {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:name]];
    return document;
}

@end
