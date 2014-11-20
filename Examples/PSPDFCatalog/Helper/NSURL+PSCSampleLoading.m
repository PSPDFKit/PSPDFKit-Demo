//
//  NSURL+PSCSampleLoading.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "NSURL+PSCSampleLoading.h"

@implementation NSURL (PSCSampleLoading)

+ (NSURL *)psc_sampleURLWithName:(NSString *)name {
    NSParameterAssert(name);
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    return [samplesURL URLByAppendingPathComponent:name];
}

@end
