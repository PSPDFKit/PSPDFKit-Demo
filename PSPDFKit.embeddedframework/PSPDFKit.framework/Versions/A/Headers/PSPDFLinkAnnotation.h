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
    PSPDFLinkAnnotationVideo,   // 2
    PSPDFLinkAnnotationYouTube, // 3
    PSPDFLinkAnnotationAudio,   // 4
    PSPDFLinkAnnotationImage,   // 5
    PSPDFLinkAnnotationBrowser, // 6
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

/// PSPDFKit addition - set if the pspdfkit:// protocol is detected.
@property(nonatomic, assign) PSPDFLinkAnnotationType linkType;

/// link if target is a page if siteLinkTarget is nil.
@property(nonatomic, assign) NSUInteger pageLinkTarget;

/// link if target is a website.
@property(nonatomic, strong) NSString *siteLinkTarget;

/// URL for PSPDFLinkAnnotationVideo.
@property(nonatomic, strong) NSURL *URL;

/// A Link annotation might have multiple rects.
@property (nonatomic, strong) NSArray *rects;

/// If values between pspdfkit://[...] are set, this will contain those options.
@property(nonatomic, strong) NSDictionary *options;

/// Indicator if "modal" is set in options. Will add "modal" to options if setModal is used.
@property(nonatomic, assign, getter=isModal) BOOL modal;

/// Indicator if "popover" is set in options. Will add "popover" to options if setPopover is used.
@property(nonatomic, assign, getter=isPopover) BOOL popover;

/// Tries to extract a size out of options "size". Returns CGSizeZero if conversion fails.
@property(nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGPDFDictionaryRef pageRef;
@property (nonatomic, strong) NSString *destinationName;
@property (nonatomic, strong) NSString *linkURL;

@end
