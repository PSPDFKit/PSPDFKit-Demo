//
//  NSURL+SampleLoading.m
//  PSPDFCatalog-static
//
//  Created by Peter Steinberger on 02/08/14.
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//

#import "NSURL+SampleLoading.h"

@implementation NSURL (SampleLoading)

+ (NSURL *)psc_sampleURLWithName:(NSString *)name {
    NSParameterAssert(name);
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    return [samplesURL URLByAppendingPathComponent:name];
}

@end
