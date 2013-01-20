//
//  PSPDFStampAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFAnnotation.h"

/**
 PDF Stamp annotation
 
 PSPDFKit supports all common stamp types (subject, image) and has even has limited support for stamps built using appearance streams.

 @warning Classic text stamps won't be rendered in Apple's Preview.app (last tested with 10.8.2). Adobe Acrobat can display them.
*/
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

/// Stamp image (if one is found in the appearance stream)
@property (nonatomic, strong, readonly) UIImage *image;

@end
