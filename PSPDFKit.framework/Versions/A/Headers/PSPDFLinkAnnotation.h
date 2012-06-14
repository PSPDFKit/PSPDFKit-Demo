//
//  LinkAnnotation.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSPDFAnnotation.h"

// PSPDFKit has some custom sub-sets of the PSPDFAnnotationTypeLink
// that can be resolved to video, audio, image or browser views.
typedef enum {
    PSPDFLinkAnnotationPage = 0,
    PSPDFLinkAnnotationWebURL,
    PSPDFLinkAnnotationVideo,
    PSPDFLinkAnnotationYouTube,
    PSPDFLinkAnnotationAudio,
    PSPDFLinkAnnotationImage,
    PSPDFLinkAnnotationBrowser,
    PSPDFLinkAnnotationCustom  /// any annotation format that is not recognized is custom, calling the delegate viewForAnnotation:
} PSPDFLinkAnnotationType;

/// PDF Link Annotation (Page links, Web links, PSPDFKit custom links)
@interface PSPDFLinkAnnotation : PSPDFAnnotation

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

/// Tries to extract a size out of options "size". Returns CGSizeZero if conversion fails.
@property(nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGPDFDictionaryRef pageRef;
@property (nonatomic, strong) NSString *destinationName;
@property (nonatomic, strong) NSString *linkURL;

@end
