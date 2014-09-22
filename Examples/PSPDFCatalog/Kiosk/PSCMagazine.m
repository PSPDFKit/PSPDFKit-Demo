//
//  PSPDFMagazine.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCMagazine.h"
#import <tgmath.h>

@implementation PSCMagazine

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

+ (PSCMagazine *)magazineWithPath:(NSString *)path {
    NSURL *URL = path ? [NSURL fileURLWithPath:path] : nil;
    PSCMagazine *magazine = [(PSCMagazine *)[self.class alloc] initWithURL:URL];
    magazine.available = YES;
    return magazine;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p: UID:%@ pageCount:%tu URL:%@ baseURL:%@, files:%@>", self.class, self, self.UID, self.pageCount, self.URL, self.baseURL, self.files];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Meta Data

- (UIImage *)coverImageForSize:(CGSize)size {
    UIImage *coverImage = nil;

    // Basic check if file is available - don't check for pageCount here, it's lazy evaluated.
    if (self.baseURL) {
        coverImage = [PSPDFCache.sharedCache imageFromDocument:self page:0 size:size options:PSPDFCacheOptionDiskLoadSync|PSPDFCacheOptionRenderSync];
    }

    // Draw a custom, centered lock image if the magazine is password protected.
    @autoreleasepool {
        if (self.isLocked) {
            if (!CGSizeEqualToSize(size, CGSizeZero)) {
                UIGraphicsBeginImageContextWithOptions(size, YES, 0.f);
                [[UIColor colorWithWhite:0.9f alpha:1.f] setFill];
                CGContextFillRect(UIGraphicsGetCurrentContext(), (CGRect){.size=size});
                UIImage *lockImage = [UIImage imageNamed:@"lock"];
                CGFloat scale = PSCIsIPad() ? 0.6f : 0.3f;
                CGSize lockImageTargetSize = CGSizeMake(__tg_round(lockImage.size.width * scale), __tg_round(lockImage.size.height * scale));
                [lockImage drawInRect:(CGRect){.origin={__tg_floor((size.width-lockImageTargetSize.width)/2), __tg_floor((size.height-lockImageTargetSize.height)/2)}, .size=lockImageTargetSize}];
                coverImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
        }
    }

    return coverImage;
}

- (PSPDFViewState *)lastViewState {
    PSPDFViewState *viewState = nil;

    // Restore viewState (sadly, NSKeyedUnarchiver might throw an exception on error.)
    if (self.isValid) {
        NSData *viewStateData = [NSUserDefaults.standardUserDefaults objectForKey:self.UID];
        @try {
            if (viewStateData) {
                viewState = [NSKeyedUnarchiver unarchiveObjectWithData:viewStateData];
            }
        }
        @catch (NSException *exception) {
            PSCLog(@"Failed to load saved viewState: %@", exception);
            [NSUserDefaults.standardUserDefaults removeObjectForKey:self.UID];
        }
    }
    return viewState;
}

- (void)setLastViewState:(PSPDFViewState *)lastViewState {
    if (self.isValid) {
        if (lastViewState) {
            NSData *viewStateData = [NSKeyedArchiver archivedDataWithRootObject:lastViewState];
            [NSUserDefaults.standardUserDefaults setObject:viewStateData forKey:self.UID];
        }else {
            [NSUserDefaults.standardUserDefaults removeObjectForKey:self.UID];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (BOOL)isDeletable {
    static NSString *bundlePath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundlePath = NSBundle.mainBundle.bundlePath;
    });

    // If magazine is within the app bundle, we can't delete it.
    BOOL deletable = ![[self pathForPage:0].path hasPrefix:bundlePath];
    return deletable;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocument

- (void)setDownloading:(BOOL)downloading {
    if (downloading != _downloading) {
        _downloading = downloading;

        if (!downloading) {
            // Clear cache, needed to recalculate pageCount.
            [self clearCache];

            // Request coverImage - grid listens for those events.
            [self coverImageForSize:CGSizeZero];
        }
    }
}

@end
