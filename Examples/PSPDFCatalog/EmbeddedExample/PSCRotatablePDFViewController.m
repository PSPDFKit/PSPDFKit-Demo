//
//  PSCRotatablePDFViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSCRotatablePDFViewController.h"

@interface PSPDFRotatableScrollView : PSPDFScrollView @end

@implementation PSCRotatablePDFViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document {
    [super commonInitWithDocument:document];

    // prevents page flashing when there's cached content available at the cost of slight main thread blocking.
    self.renderingMode = PSPDFPageRenderingModeFullPageBlocking;

    // Optional: Allow rotation via a gesture.
    self.overrideClassNames = @{(id)[PSPDFScrollView class] : [PSPDFRotatableScrollView class]};

    // Add manual rotation button.
    UIBarButtonItem *rotate = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(rotateAction:)];
    self.leftBarButtonItems = @[rotate];
    self.navigationItem.leftItemsSupplementBackButton = YES;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)rotateAction:(id)sender {
    // we need to invalidate the cache
    [[PSPDFCache sharedCache] removeCacheForDocument:self.document deleteDocument:NO error:NULL];

    // rotate 90 degree counter-clock-wise (and make sure we don't set something >= 360)
    BOOL rotateAll = NO;
    if (rotateAll) {
        for (NSUInteger pageIndex=0; pageIndex < [self.document pageCount]; pageIndex++) {
            PSPDFPageInfo *pageInfo = [self.document pageInfoForPage:pageIndex];
            pageInfo.pageRotation = PSPDFNormalizeRotation(pageInfo.pageRotation - 90);
        }
    }else {
        PSPDFPageInfo *pageInfo = [self.document pageInfoForPage:self.page];
        pageInfo.pageRotation = PSPDFNormalizeRotation(pageInfo.pageRotation - 90);
    }
    
    // request an immediate rendering of the current page, will block the main thread but prevent flashing.
    [[PSPDFCache sharedCache] renderAndCacheImageForDocument:self.document page:self.page size:PSPDFSizeNative error:NULL];

    // reload the controller
    [self reloadData];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFRotatableScrollView

@implementation PSPDFRotatableScrollView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Add page rotation gesture.
        UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
        rotationGesture.delegate = self;
        [self addGestureRecognizer:rotationGesture];
    }
    return self;
}

- (void)handleRotation:(UIRotationGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // Invalidate the cache.
        // TODO: this could be made more fine grained. (just update the current page)
        [[PSPDFCache sharedCache] removeCacheForDocument:self.document deleteDocument:NO error:NULL];

        // Get rotation and snap to the closest position.
        PSPDFPageInfo *pageInfo = [self.document pageInfoForPage:self.page];
        CGFloat degrees = PSPDFRadiansToDegrees(atan2f(self.transform.b, self.transform.a));
        pageInfo.pageRotation = PSPDFNormalizeRotation(pageInfo.pageRotation+degrees);
        PSCLog(@"Snap rotation to: %d", pageInfo.pageRotation);

        // request an immediate rendering, will block the main thread but prevent flashing.
        [[PSPDFCache sharedCache] renderAndCacheImageForDocument:self.document page:self.page size:PSPDFSizeNative error:NULL];

        // Reset view and reload the controller. (this is efficient and will re-use views)
        gestureRecognizer.view.transform = CGAffineTransformIdentity;
        [self.pdfController reloadData];
    }else {
        // Transform the current view.
        gestureRecognizer.view.transform = CGAffineTransformRotate(gestureRecognizer.view.transform, gestureRecognizer.rotation);
        gestureRecognizer.rotation = 0;
    }
}

// Allow zooming and rotating at the same time.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]) return YES;
    return [super gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
}

@end
