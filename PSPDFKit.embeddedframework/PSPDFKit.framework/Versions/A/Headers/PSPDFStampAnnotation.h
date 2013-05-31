//
//  PSPDFStampAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAnnotation.h"

/// Set this in the userInfo of the annotation to 'suggest' a size when the annotation is added to the pageView.
/// This value is used for the example stamps in PSPDFStampViewController and will not be persisted.
extern NSString *const PSPDFStampAnnotationSuggestedSizeKey;

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

/// Stamp subject. Will be displayed uppercase italic bold.
@property (nonatomic, copy) NSString *subject;

/// Stamp subtext.
///
/// Used for custom stamps, will render beneath the subject or as the subject if subject is not set.
@property (nonatomic, copy) NSString *subtext;

/// Stamp image. Defaults to nil. Set to render an image.
@property (nonatomic, strong) UIImage *image;

/// Parses the AP stream, searches for an image and loads it.
/// Will also update imageTransform.
- (UIImage *)loadImageWithError:(NSError **)error;

/// Stamp image transform. Defaults to CGAffineTransformIdentity.
@property (nonatomic, assign) CGAffineTransform imageTransform;

@end

