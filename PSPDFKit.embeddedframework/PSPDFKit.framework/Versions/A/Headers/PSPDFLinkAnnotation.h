//
//  PSPDFLinkAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
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
    PSPDFLinkAnnotationControl, // 8
    PSPDFLinkAnnotationCustom  /// any annotation format that is not recognized is custom (e.g. tel://)
};

/**
 The PSPDFLinkAnnotation represents both classic PDF page/document/web links, and more types not supported by other PDF readers (video, audio, image, etc)

 PSPDFKit will automatically figure out the type for PDF link annotations loaded from a document, based on the file type. ("mpg" belongs to PSPDFLinkAnnotationVideo; a YouTube-URL to PSPDFLinkAnnotationYouTube, etc)

 If you create a PSPDFLinkAnnotation at runtime, be sure to set the correct type and use the URL parameter for your link.
 BoundingBox defines the frame, in PDF space coordinates.

 If you want to customize how links look in the PDF, customize PSPDFLinkAnnotationView's properties. There's currently no mapping between color/lineWidth/etc and the properties of the view. This might change in future releases.
 */
@interface PSPDFLinkAnnotation : PSPDFAnnotation

/// Designated initializer for custom, at runtime created PSPDFLinkAnnotations.
- (id)initWithLinkAnnotationType:(PSPDFLinkAnnotationType)linkAnotationType;

/// Init with siteLinkTarget. Use this for custom pspdfkit:// annotations that get parsed at runtime.
/// This will automatically set the linkAnnotationType.
- (id)initWithSiteLinkTarget:(NSString *)siteLinkTarget;

/// PSPDFKit addition - set if the pspdfkit:// protocol is detected.
@property (nonatomic, assign) PSPDFLinkAnnotationType linkType;

/// Will be YES if this is a regular link or a multimedia link annotation that should be displayed as link. (e.g. if isPopover/isModal is set to yes)
@property (nonatomic, assign, readonly) BOOL showAsLinkView;

/// Link if target is a page if siteLinkTarget is nil.
/// pageLinkTarget starts at page index 1.
@property (nonatomic, assign) NSUInteger pageLinkTarget;

/// Returns YES if this link is specially handled by PSPDFKit.
/// Returns true for any linkType >= PSPDFLinkAnnotationVideo
@property (nonatomic, assign, readonly, getter=isMultimediaExtension) BOOL multimediaExtension;

/**
 Link if target is a website.

 If you create a PSPDFLinkAnnotation in code, setting the siteLinkTarget will invoke the parsing at the time you're adding the annotation to the PSPDFAnnotationParser.

 After parsing, the linkType will be set and the generate URL will be set.
 If you don't want this processing, directly set the URL and the linkType and don't use siteLinkTarget.

 An example for a siteLinkTarget to an image annotation would be:
 PSPDFLinkAnnotation *annotation = [[PSPDFLinkAnnotation alloc] initWithLinkAnnotationType:PSPDFLinkAnnotationImage];
 annotation.siteLinkTarget = [NSString stringWithFormat:@"pspdfkit://[contentMode=%d]localhost/%@/exampleimage.jpg", UIViewContentModeScaleAspectFill, [[NSBundle mainBundle] bundlePath]];
 // annotation frame is in PDF coordinate space. Use pageRect for the full page.
 annotation.boundingBox = [self.document pageInfoForPage:0].pageRect;
 // annotation.page/document is autodetecting set.
 [self.document.annotationParser addAnnotations:@[annotation] forPage:0];

 @note Do not add NSURL-encoded strings to siteLinkTarget.(no %20 - real space!)
 If you convert a path from NSURL, use URL.path and NOT [url description]. (Actually, never use URL description, except when you're debugging)
*/
@property (nonatomic, copy) NSString *siteLinkTarget;

/// URL (generated from the siteLinkTarget after parsing. Will not be saved.)
/// If set to nil, this will be autocreated from siteLinkTarget.
@property (nonatomic, strong) NSURL *URL;

/// Used for the preview string when the user long-presses on a link annotation.
/// Per default either formats "Go to %@" with siteLinkTarget or "Page %@" for pageLinkTarget (using the pageLabel if one is available)
/// Override this if you implement custom actions.
- (NSString *)targetString;

/// If values between pspdfkit://[...] are set, this will contain those options.
@property (nonatomic, copy) NSDictionary *options;

/// Indicator if "modal" is set in options. Will add "modal" to options if setModal is used.
@property (nonatomic, assign, getter=isModal) BOOL modal;

/// Indicator if "popover" is set in options. Will add "popover" to options if setPopover is used.
@property (nonatomic, assign, getter=isPopover) BOOL popover;

/**
 Indicator if "controls" is set in options.
 Will hide controls for movies/browser/etc if set. Defaults to YES.

 Some controls will add alternative ways to control if this is disabled.
 E.g. videos can be paused via touch on the view if this is set to NO.
 */
@property (nonatomic, assign) BOOL controlsEnabled;

/// Controls auto-play of video annotations.
@property (nonatomic, assign, getter=isAutoplayEnabled) BOOL autoplayEnabled;

/// Video offset.
@property (nonatomic, assign) CGFloat offset;

/// Tries to extract a size out of options "size". Returns CGSizeZero if conversion fails.
@property (nonatomic, assign) CGSize size;

/// Link Type String <-> PSPDFLinkAnnotationType transformer.
+ (NSValueTransformer *)linkTypeTransformer;

@end
