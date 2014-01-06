//
//  PSPDFLinkAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAnnotation.h"

// PSPDFKit has some custom sub-sets of the `PSPDFAnnotationTypeLink` that can be resolved to Video, Audio, Image or Browser views.
typedef NS_ENUM(UInt8, PSPDFLinkAnnotationType) {
    PSPDFLinkAnnotationPage = 0,
    PSPDFLinkAnnotationWebURL,  // 1
    PSPDFLinkAnnotationDocument,// 2
    PSPDFLinkAnnotationVideo,   // 3
    PSPDFLinkAnnotationYouTube, // 4
    PSPDFLinkAnnotationAudio,   // 5
    PSPDFLinkAnnotationImage,   // 6
    PSPDFLinkAnnotationBrowser, // 7
    PSPDFLinkAnnotationCustom   // Any annotation format that is not recognized is custom. (e.g. tel://)
};

@class PSPDFAction, PSPDFURLAction, PSPDFGoToAction;

/**
 The `PSPDFLinkAnnotation` represents both classic PDF page/document/web links, and more types not supported by other PDF readers (video, audio, image, etc)

 PSPDFKit will automatically figure out the type for PDF link annotations loaded from a document, based on the file type. ("mp4" belongs to `PSPDFLinkAnnotationVideo`; a YouTube-URL to `PSPDFLinkAnnotationYouTube`, etc)

 If you create a `PSPDFLinkAnnotation` at runtime, be sure to set the correct type and use the URL parameter for your link.
 `boundingBox` defines the frame, in PDF space coordinates.

 If you want to customize how links look in the PDF, customize `PSPDFLinkAnnotationView's` properties. There's currently no mapping between color/lineWidth/etc and the properties of the view. This might change in future releases.
 */
@interface PSPDFLinkAnnotation : PSPDFAnnotation

/// Designated initializer for custom, at runtime created `PSPDFLinkAnnotations`.
- (id)initWithLinkAnnotationType:(PSPDFLinkAnnotationType)linkAnotationType;

/// Initialize link annotation with target URL.
- (id)initWithURL:(NSURL *)URL;

/// Initialize link annotation with target URL string.
/// Can also be used for pspdfkit:// URLs.
/// For example, to add a PSPDFKit image annotation, use `[NSString stringWithFormat:@"pspdfkit://[contentMode=%d]localhost/%@/exampleimage.jpg", UIViewContentModeScaleAspectFill, NSBundle.mainBundle.bundlePath]` as `URLString`.
- (id)initWithURLString:(NSString *)URLString;

/// Initialize link annotation with target page.
- (id)initWithPage:(NSUInteger)page;

/// PSPDFKit addition - will be updated if the `pspdfkit://` protocol is detected.
@property (nonatomic, assign) PSPDFLinkAnnotationType linkType;

/// The associated PDF action that will be executed on tap.
/// Will update the `linkType` when set.
/// @note Only evaluated if `isMultimediaExtension` returns NO.
@property (nonatomic, strong) PSPDFAction *action;

/// Convenience cast. Will return the URL action if action is of type `PSPDFActionTypeURL`, else nil.
- (PSPDFURLAction *)URLAction;

/// Convenience method, will create a new `PSPDFURLAction` and get the URL from it.
@property (nonatomic, strong) NSURL *URL;

/// Will be YES if this is a regular link or a multimedia link annotation that should be displayed as link. (e.g. if `isPopover/isModal` is set to yes)
@property (nonatomic, assign, readonly) BOOL showAsLinkView;

/// Returns YES if this link is specially handled by PSPDFKit.
/// Returns true for any linkType >= `PSPDFLinkAnnotationVideo` && linkType <= `PSPDFLinkAnnotationBrowser`.
@property (nonatomic, assign, readonly, getter=isMultimediaExtension) BOOL multimediaExtension;

/// Show or hide controls. Only valid for `PSPDFLinkAnnotationVideo` and `PSPDFLinkAnnotationAudio`. Defaults to YES.
/// Some controls will add alternative ways to control if this is disabled.
/// The gallery will not receive touches if controlsEnabled is set to NO.
/// e.g. Videos can be paused via touch on the view if this is set to NO.
@property (nonatomic, assign) BOOL controlsEnabled;

/// Autoplay video/audio. Only valid for `PSPDFLinkAnnotationVideo` and `PSPDFLinkAnnotationAudio`. Defaults to NO.
@property (nonatomic, assign, getter=isAutoplayEnabled) BOOL autoplayEnabled;

/// Loop media. Only valid for `PSPDFLinkAnnotationVideo` and `PSPDFLinkAnnotationAudio`. Defaults to NO.
@property (nonatomic, assign, getter=isLoopEnabled) BOOL loopEnabled;

/// Used for the preview string when the user long-presses on a link annotation.
/// Forwards to `action.localizedDescription`.
- (NSString *)targetString;

@end
