//
//  LinkAnnotation.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFAnnotation.h"

// PSPDFKit has some custom sub-sets of the PSPDFAnnotationTypeLink
// that can be resolved to video, audio, image or browser views.
typedef NS_ENUM(NSInteger, PSPDFLinkAnnotationType) {
    PSPDFLinkAnnotationPage = 0,
    PSPDFLinkAnnotationWebURL,  // 1
    PSPDFLinkAnnotationDocument,// 2
    PSPDFLinkAnnotationVideo,   // 3
    PSPDFLinkAnnotationYouTube, // 4
    PSPDFLinkAnnotationAudio,   // 5
    PSPDFLinkAnnotationImage,   // 6
    PSPDFLinkAnnotationBrowser, // 7
    PSPDFLinkAnnotationCustom  /// any annotation format that is not recognized is custom, calling the delegate viewForAnnotation:
};

/**
    The PSPDFLinkAnnotation represents both classic PDF page/document/web links,
    and more types not supported by other PDF readers (video, audio, image, etc)
 
    PSPDFKit will automatically figure out the type for PDF link annotations loaded from a document, based on the file type. ("mpg" belongs to PSPDFLinkAnnotationVideo; a YouTube-URL to PSPDFLinkAnnotationYouTube, etc)
 
    If you create a PSPDFLinkAnnotation at runtime, be sure to set the correct type and use the URL parameter for your link.
 
    boundingBox defines the frame, in PDF space coordinates.
 */
@interface PSPDFLinkAnnotation : PSPDFAnnotation

/// Designated initializer for custom, at runtime created PSPDFLinkAnnotations.
- (id)initWithLinkAnnotationType:(PSPDFLinkAnnotationType)linkAnotationType;

/// Init with siteLinkTarget. Use this for custom pspdfkit:// annotatations that get parsed at runtime.
/// This will automatically set the linkAnnotationType.
- (id)initWithSiteLinkTarget:(NSString *)siteLinkTarget;

/// PSPDFKit addition - set if the pspdfkit:// protocol is detected.
@property (nonatomic, assign) PSPDFLinkAnnotationType linkType;

/// link if target is a page if siteLinkTarget is nil.
@property (nonatomic, assign) NSUInteger pageLinkTarget;

/// Returns YES if this link is specially handled by PSPDFKit.
/// Returns true for any linkType >= PSPDFLinkAnnotationVideo
@property (nonatomic, assign, readonly, getter=isMultimediaExtension) BOOL multimediaExtension;

/** 
    Link if target is a website.
 
    If you createa  PSPDFLinkAnnotation in code, setting the siteLinkTarget will invoke the parsing at the time you're adding the annotation to the PSPDFAnnotationParser.
 
    After parsing, the linkType will be set and the generate URL will be set.
 
    If you don't want this processing, directly set the URL and the linkType and don't use siteLinkTarget.
 
    An example for a siteLinkTarget to an image annotation would be:
    PSPDFLinkAnnotation *annotation = [[PSPDFLinkAnnotation alloc] initWithLinkAnnotationType:PSPDFLinkAnnotationImage];
    annotation.siteLinkTarget = [NSString stringWithFormat:@"pspdfkit://[contentMode=%d]localhost/%@/exampleimage.jpg", UIViewContentModeScaleAspectFill, [[NSBundle mainBundle] bundlePath]];
    // annotation frame is in PDF coordinate space. Use pageRect for the full page.
    annotation.boundingBox = [self.document pageInfoForPage:0].pageRect;
    // annotation.page/document is auomatically set.
    [self.document.annotationParser addAnnotations:@[annotation] forPage:0];
 
    Note: Do not add NSURL-encoded strings to siteLinkTarget.( no %20 - real space!)
    If you convert a path fron NSURL, use [url path] and NOT [url description].
    (Actually, never use url description, except when you're debugging)
*/
@property (nonatomic, strong) NSString *siteLinkTarget;

/// URL (generated from the siteLinkTarget after parsing)
@property (nonatomic, strong) NSURL *URL;

/// A Link annotation might have multiple rects.
/// Note: This is currently NOT supported in PSPDFKit. Use boundingBox.
@property (nonatomic, strong) NSArray *rects;

/// If values between pspdfkit://[...] are set, this will contain those options.
@property (nonatomic, strong) NSDictionary *options;

/// Indicator if "modal" is set in options. Will add "modal" to options if setModal is used.
@property (nonatomic, assign, getter=isModal) BOOL modal;

/// Indicator if "popover" is set in options. Will add "popover" to options if setPopover is used.
@property (nonatomic, assign, getter=isPopover) BOOL popover;

/// Tries to extract a size out of options "size". Returns CGSizeZero if conversion fails.
@property (nonatomic, assign) CGSize size;

@end
