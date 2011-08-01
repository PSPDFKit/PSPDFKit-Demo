//
//  PSPDFMagazine.m
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/22/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFMagazine.h"
#import "PSPDFMagazineFolder.h"
#import <QuartzCore/CATiledLayer.h>

@implementation PSPDFMagazine

@synthesize folder = folder_;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSObject

+ (PSPDFMagazine *)magazineWithPath:(NSString *)path; {
    NSURL *url = [NSURL fileURLWithPath:path];
    PSPDFMagazine *magazine = [[(PSPDFMagazine *)[[self class] alloc] initWithUrl:url] autorelease];
    return magazine;
}

- (id)init {
    if ((self = [super init])) {
        
        // most magazines can enable this to speed up display (aspect ration doesn't need to be recalculated)
        aspectRatioEqual_ = YES;
    }
    return self;
}

- (void)dealloc {
    folder_ = nil;
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Meta Data

- (UIImage *)coverImage {
    UIImage *coverImage = [[PSPDFCache sharedPSPDFCache] cachedImageForDocument:self page:0 size:PSPDFSizeThumbnail];
    return coverImage;
}

@end
