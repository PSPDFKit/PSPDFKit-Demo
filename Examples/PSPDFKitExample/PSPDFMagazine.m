//
//  PSPDFMagazine.m
//  PSPDFKitExample
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFMagazine.h"
#import "PSPDFMagazineFolder.h"
#import <QuartzCore/CATiledLayer.h>

@implementation PSPDFMagazine

@synthesize folder = folder_;
@synthesize downloading = downloading_;
@synthesize available = available_;
@synthesize url = url_;
@synthesize imageUrl = imageUrl_;
@dynamic deletable;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

+ (PSPDFMagazine *)magazineWithPath:(NSString *)path {
    NSURL *url = path ? [NSURL fileURLWithPath:path] : nil;
    PSPDFMagazine *magazine = [(PSPDFMagazine *)[[self class] alloc] initWithUrl:url];
    magazine.available = YES;    
    return magazine;
}

- (id)init {
    if ((self = [super init])) {
        // most magazines can enable this to speed up display (aspect ration doesn't need to be recalculated)
        //aspectRatioEqual_ = YES;
    }
    return self;
}

- (void)dealloc {
    folder_ = nil;
}

- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"<PSPDFMagazine uid:%@ pageCount:%d url:%@ basePath:%@, files:%@>", self.uid, [self pageCount], self.url, self.basePath, self.files];
    return description;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Meta Data

- (UIImage *)coverImage {
    UIImage *coverImage = nil;
    
    // basic check if file is available - don't check for pageCount here, it's lazy evaluated.
    if (self.basePath) {
        coverImage = [[PSPDFCache sharedPSPDFCache] cachedImageForDocument:self page:0 size:PSPDFSizeThumbnail];
    }
    
    return coverImage;
}

// example how to manually rotate a page
/*
- (PSPDFPageInfo *)pageInfoForPage:(NSUInteger)page pageRef:(CGPDFPageRef)pageRef {
    PSPDFPageInfo *pi = [super pageInfoForPage:page pageRef:pageRef];
    pi.pageRotation = (pi.pageRotation + 90) % 360;
    return pi;
}*/

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (BOOL)isDeletable {
    static NSString *bundlePath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundlePath = [[NSBundle mainBundle] bundlePath];
    });

    // if magazine is within the app bundle, we can't delete it.
    BOOL deletable = ![[[self pathForPage:0] path] hasPrefix:bundlePath];
    return deletable;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocument

- (void)setDownloading:(BOOL)downloading {
    if (downloading != downloading_) {
        downloading_ = downloading;
        
        if(!downloading) {
            // clear cache, needed to recalculate pageCount
            [self clearCacheForced:YES];
            
            // request coverImage - grid listens for those events
            [self coverImage];
        }
    }
}

@end
