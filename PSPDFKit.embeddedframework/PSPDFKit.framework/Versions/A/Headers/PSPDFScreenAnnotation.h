//
//  PSPDFScreenAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFLinkAnnotation.h"
#import "PSPDFStreamProvider.h"

typedef NS_ENUM(NSUInteger, PSPDFMediaScreenWindowType) {
    PSPDFMediaScreenWindowTypeFloating,
    PSPDFMediaScreenWindowTypeFullscreen,
    PSPDFMediaScreenWindowTypeHidden,
    PSPDFMediaScreenWindowTypeUseAnnotationRectangle // Default value
};

/// A screen annotation (PDF 1.5) specifies a region of a page upon which media clips may be played. It also serves as an object from which actions can be triggered. PSPDFKit also supports the matching Rendition Actions to control the video play state.
/// @note iOS cannot play all video/audio formats that can be used for PDF.
@interface PSPDFScreenAnnotation : PSPDFLinkAnnotation <PSPDFStreamProvider>

/// The name of the embedded asset.
@property (nonatomic, copy, readonly) NSString *assetName;

/// Defaults the window type the media should play in.
/// @note only `.UseAnnotationRectangle` and `.Hidden` is currently supported.
@property (nonatomic, assign, readonly) PSPDFMediaScreenWindowType mediaScreenWindowType;

@end
