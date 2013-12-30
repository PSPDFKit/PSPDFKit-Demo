//
//  PSPDFStampAnnotation.h
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

/// PDF Stamp annotation.
///
/// PSPDFKit supports all common stamp types (subject, image) and has even has limited support for stamps built using appearance streams.
@interface PSPDFStampAnnotation : PSPDFAnnotation

/// Returns predefined colors for special subjects, like red for "void" or green for "completed".
+ (UIColor *)stampColorForSubject:(NSString *)subject;

/// Designated initializer.
- (id)init;

/// Init with a default subject and uses a matching color.
- (id)initWithSubject:(NSString *)subject;

/// Init with image.
- (id)initWithImage:(UIImage *)image;

/// Stamp subtext.
/// Used for custom stamps, will render beneath the subject or as the subject if subject is not set.
@property (nonatomic, copy) NSString *subtext;

/// If set, will be used instead of the subject for the rendered text.
/// @note To translate the "default" stamps like "Approved" or "Accepted", you should use `localizedSubject` instead of changing subtext. Various strings are hardcoded to render differently accordin to the non-localized default stamps defined in the PDF spec. PSPDFKit renders appearance streams for stamps, so we can now localize the subtext but will still save the original, unlocalized title for compatibility reasons with readers that can't render AP streams.
@property (nonatomic, copy) NSString *localizedSubject;

/// Stamp image. Defaults to nil. Set to render an image.
@property (nonatomic, strong) UIImage *image;

/// Parses the AP stream, searches for an image and loads it.
/// Will also update `imageTransform`.
- (UIImage *)loadImageWithError:(NSError **)error;

/// Stamp image transform. Defaults to `CGAffineTransformIdentity`.
@property (nonatomic, assign) CGAffineTransform imageTransform;

/// @name Sizing

/// Return 'best' size to fit given size. does not actually resize the `boundingBox`.
/// Will only work for simple stamp annotations with a subtext.
- (CGSize)sizeThatFits:(CGSize)size;

/// Calls `sizeThatFits:` with the current `boundingBox` and changes the `boundingBox`.
- (void)sizeToFit;

@end

