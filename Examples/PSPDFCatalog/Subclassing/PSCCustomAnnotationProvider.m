//
//  PSCCustomAnnotationProvider.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCCustomAnnotationProvider.h"

@interface PSCCustomAnnotationProvider() {
    NSMutableDictionary *_annotationDict;
    NSTimer *_timer;
}
@end

@implementation PSCCustomAnnotationProvider

@synthesize providerDelegate = _providerDelegate;

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if ((self = [super init])) {
        _annotationDict = [NSMutableDictionary new];

        // add timer in a way so it works while we're dragging pages (NSRunLoopCommonModes)
        _timer = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)setProviderDelegate:(id<PSPDFAnnotationProviderChangeNotifier>)providerDelegate {
    if (providerDelegate != _providerDelegate) {
        _providerDelegate = providerDelegate;

        // nil out timer to allow object to deallocate itself.
        if (!providerDelegate) { [_timer invalidate]; _timer = nil; }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFAnnotationProvider

- (NSArray *)annotationsForPage:(NSUInteger)page {
    NSArray *annotations;

    // it's important that this method is:
    // - fast
    // - thread safe
    // - and caches annotations (don't always create new objects!)
    @synchronized(self) {
        annotations = _annotationDict[@(page)];
        if (!annotations) {
            // create new note annotation and add it to the dict.
            PSPDFDocumentProvider *documentProvider = [self.providerDelegate parentDocumentProvider];
            PSPDFNoteAnnotation *noteAnnotation = [PSPDFNoteAnnotation new];
            noteAnnotation.page = page;
            noteAnnotation.documentProvider = documentProvider;
            noteAnnotation.contents = [NSString stringWithFormat:@"Annotation from the custom annotationProvider for page %d.", page+1];

            // place it top left (PDF coordinate space starts from bottom left)
            PSPDFPageInfo *pageInfo = [documentProvider.document pageInfoForPage:page];
            noteAnnotation.boundingBox = CGRectMake(100.f, pageInfo.rotatedPageRect.size.height-100.f, 32.f, 32.f);
            _annotationDict[@(page)] = @[noteAnnotation];
            annotations = @[noteAnnotation];
            noteAnnotation.editable = NO;
        }
    }
    return annotations;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

// Helper to generate a random color.
static UIColor *PSCRandomColor(void) {
    CGFloat hue = arc4random() % 256 / 256.0f;  //  0.0 to 1.0
    CGFloat saturation = (arc4random() % 128 / 256.0f) + 0.5f;  //  0.5 to 1.0, away from white
    CGFloat brightness = (arc4random() % 128 / 256.0f) + 0.5f;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.f];
}

// Change annotation color and notify the delegate that we have updates.
- (void)timerFired:(NSTimer *)timer {
    UIColor *color = PSCRandomColor();
    @synchronized(self) {
        [_annotationDict enumerateKeysAndObjectsUsingBlock:^(NSNumber *page, NSArray *annotations, BOOL *stop) {
            [annotations makeObjectsPerformSelector:@selector(setColor:) withObject:color];
            [self.providerDelegate updateAnnotations:annotations animated:YES];
        }];
    }
}

@end
