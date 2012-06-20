//
//  PSPDFMagazine.m
//  PSPDFKitExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFMagazine.h"
#import "PSPDFMagazineFolder.h"
#import <QuartzCore/CATiledLayer.h>

@implementation PSPDFMagazine

@synthesize folder = folder_;
@synthesize downloading = downloading_;
@synthesize available = available_;
@synthesize URL = URL_;
@synthesize imageURL = imageURL_;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

+ (PSPDFMagazine *)magazineWithPath:(NSString *)path {
    NSURL *URL = path ? [NSURL fileURLWithPath:path] : nil;
    PSPDFMagazine *magazine = [(PSPDFMagazine *)[[self class] alloc] initWithURL:URL];
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
    NSString *description = [NSString stringWithFormat:@"<%@ uid:%@ pageCount:%d URL:%@ basePath:%@, files:%@>", NSStringFromClass([self class]), self.uid, [self pageCount], self.URL, self.basePath, self.files];
    return description;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Meta Data

- (UIImage *)coverImageForSize:(CGSize)size {
    UIImage *coverImage = nil;
    
    // basic check if file is available - don't check for pageCount here, it's lazy evaluated.
    if (self.basePath) {
        coverImage = [[PSPDFCache sharedPSPDFCache] cachedImageForDocument:self page:0 size:PSPDFSizeThumbnail];
    }
    
    // draw a custom, centered lock image if the magazine is password protected.
    @autoreleasepool {
        if (self.isLocked) {
            if (!CGSizeEqualToSize(size, CGSizeZero)) {
                UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
                [[UIColor colorWithWhite:0.9 alpha:1.f] setFill];
                CGContextFillRect(UIGraphicsGetCurrentContext(), (CGRect){.size=size});
                UIImage *lockImage = [UIImage imageNamed:@"lock"];
                CGSize lockImageTargetSize = PSPDFSizeForScale(lockImage.size, 0.6);
                [lockImage drawInRect:(CGRect){.origin={floorf((size.width-lockImageTargetSize.width)/2), floorf((size.height-lockImageTargetSize.height)/2)}, .size=lockImageTargetSize}];
                coverImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
        }
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
            [self clearCache];
            
            // request coverImage - grid listens for those events
            [self coverImageForSize:CGSizeZero];
        }
    }
}

@end
