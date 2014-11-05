//
//  PSPDFRenderJob.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import "PSPDFRenderQueue.h"

@class PSPDFDocument;

// A render job is designed to be created and then treated as immutable.
// The internal hash is cached and you'll get weird results if renderJob is changed after being added to the queue.
@interface PSPDFRenderJob : NSObject

@property (nonatomic, strong, readonly) PSPDFDocument *document;
@property (nonatomic, assign, readonly) NSUInteger page;
@property (nonatomic, assign, readonly) CGSize size;
@property (nonatomic, assign, readonly) CGRect clipRect;
@property (nonatomic, assign, readonly) float zoomScale;
@property (nonatomic, copy,   readonly) NSArray *annotations;
@property (nonatomic, assign, readonly) PSPDFRenderQueuePriority priority;
@property (nonatomic, copy,   readonly) NSDictionary *options;
@property (nonatomic, weak,   readonly) id<PSPDFRenderDelegate> delegate;
@property (nonatomic, strong, readonly) UIImage *renderedImage;
@property (nonatomic, strong, readonly) PSPDFRenderReceipt *renderReceipt;
@property (nonatomic, assign, readonly) uint64_t renderTime;

@property (nonatomic, copy,   readonly) void (^completionBlock)(PSPDFRenderJob *renderJob, PSPDFRenderQueue *renderQueue);

@end
