//
//  PSPDFRenderQueue.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFDocument, PSPDFRenderJob, PSPDFRenderQueue;

// Extension to options; set this to make PSPDFRenderQueue to auto-fetch the annotations
// of the type that'ss specified in this option.
// Will be ignored if annotations is not nil.
extern NSString *kPSPDFAnnotationAutoFetchTypes;

// Implement this delegate to get rendered pages.
@protocol PSPDFRenderDelegate <NSObject>

- (void)renderQueue:(PSPDFRenderQueue *)renderQueue jobDidFinish:(PSPDFRenderJob *)job;

@end

/// Render Queue. Does not cache. Used for rendering pages/page parts in PSPDFPageView.
@interface PSPDFRenderQueue : NSObject

/// Render Queue is a singleton.
+ (PSPDFRenderQueue *)sharedRenderQueue;

/// Requests a (freshly) rendered image from a specified document. Does not use the file cache.
/// For options, see PSPDFPageRender.
- (void)requestRenderedImageForDocument:(PSPDFDocument *)document forPage:(NSUInteger)page withSize:(CGSize)size clippedToRect:(CGRect)clipRect withAnnotations:(NSArray *)annotations options:(NSDictionary *)options delegate:(id<PSPDFRenderDelegate>)delegate;

/// Cancels all queued render-calls.
/// Async will perform on the next thread. (don't use async in dealloc)
- (void)cancelRenderingForDelegate:(id<PSPDFRenderDelegate>)delegate async:(BOOL)async;

/// Returns YES if currently a RenderJob is scheduled or running for delegate.
- (BOOL)hasRenderJobsForDelegate:(id<PSPDFRenderDelegate>)delegate;

/// Returns the currently rendered renderJob.
- (PSPDFRenderJob *)currentRenderJob;

/// Return how many jobs are currently queued.
- (NSUInteger)numberOfQueuedJobs;

@end

@interface PSPDFRenderJob : NSObject

@property (nonatomic, readonly) NSUInteger page;
@property (nonatomic, readonly) PSPDFDocument *document;
@property (nonatomic, readonly) CGSize fullSize;
@property (nonatomic, readonly) CGRect clipRect;
@property (nonatomic, readonly) float zoomScale;
@property (nonatomic, readonly) NSArray *annotations;
@property (nonatomic, strong, readonly) NSDictionary *options;
@property (nonatomic, weak) id<PSPDFRenderDelegate> delegate;
@property (nonatomic, strong) UIImage *renderedImage;

@end
