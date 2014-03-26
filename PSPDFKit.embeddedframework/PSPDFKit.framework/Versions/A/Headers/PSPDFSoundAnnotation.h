//
//  PSPDFSoundAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFLinkAnnotation.h"

/// List of available encodings. Used in `PSPDFSoundAnnotation.encoding` and in the `defaultEncoding` property of `PSPDFAudioHelper`.
extern NSString *const PSPDFSoundAnnotationEncodingRaw;
extern NSString *const PSPDFSoundAnnotationEncodingSigned;
extern NSString *const PSPDFSoundAnnotationEncodingMuLaw;
extern NSString *const PSPDFSoundAnnotationEncodingALaw;

/// A sound annotation (PDF 1.2) shall analogous to a text annotation except that instead of a text note, it contains sound recorded from the iPad/iPhone's microphone or imported from a file.
@interface PSPDFSoundAnnotation : PSPDFAnnotation

/// Designated initializer.
- (id)initWithRate:(NSUInteger)rate channels:(UInt32)channels bits:(UInt32)bits encoding:(NSString *)encoding;

/// The sound icon name.
@property (nonatomic, copy) NSString *iconName;

/// URL to the sound content.
@property (nonatomic, copy) NSURL *soundURL;

/// Bits of the sound stream.
@property (nonatomic, assign, readonly) NSUInteger bits;

/// Sampling rate of the sound stream.
@property (nonatomic, assign, readonly) NSUInteger rate;

/// Channel count of the sound stream.
@property (nonatomic, assign, readonly) NSUInteger channels;

/// Encoding of the sound stream. Use `PSPDFSoundAnnotationEncoding*` for values.
@property (nonatomic, copy, readonly) NSString *encoding;

/// Loads bits, sample rate, channels, encoding from sound file.
- (void)loadAttributesFromAudioFile;

@end
