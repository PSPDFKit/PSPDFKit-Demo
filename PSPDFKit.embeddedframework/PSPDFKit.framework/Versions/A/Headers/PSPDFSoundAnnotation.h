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

#import <AVFoundation/AVFoundation.h>

/// List of available encodings. Used in `PSPDFSoundAnnotation.encoding` and in
/// the `defaultEncoding` property of `PSPDFAudioHelper`.
extern NSString *const PSPDFSoundAnnotationEncodingRaw;
extern NSString *const PSPDFSoundAnnotationEncodingSigned;
extern NSString *const PSPDFSoundAnnotationEncodingMuLaw;
extern NSString *const PSPDFSoundAnnotationEncodingALaw;

@class PSPDFSoundAnnotationController;

/// A sound annotation (PDF 1.2) shall analogous to a text annotation except that instead of a text
/// note, it contains sound recorded from the iOS device's microphone or imported from a file.
/// To ensure maximum compatiblity set the `boundingBox` for sound annotations to the same size Adobe Acrobat uses (20x15pt).
/// PSPDFKit will always render sound annotations at a fixed size of 74x44pt, centered in the provided `boundingBox`.
@interface PSPDFSoundAnnotation : PSPDFAnnotation

- (instancetype)initRecorder;
- (instancetype)initWithRate:(NSUInteger)rate channels:(UInt32)channels bits:(UInt32)bits encoding:(NSString *)encoding;
- (instancetype)initWithURL:(NSURL *)soundURL error:(NSError *__autoreleasing*)error;

/// The annotation controller
@property (nonatomic, strong) PSPDFSoundAnnotationController *controller;

/// The sound icon name.
@property (nonatomic, copy) NSString *iconName;

/// If the annotation is able to record audio
@property (nonatomic, assign, readonly) BOOL canRecord;

/// URL to the sound content.
@property (nonatomic, copy, readonly) NSURL *soundURL;

/// Bits of the sound stream.
@property (nonatomic, assign, readonly) NSUInteger bits;

/// Sampling rate of the sound stream.
@property (nonatomic, assign, readonly) NSUInteger rate;

/// Channel count of the sound stream.
@property (nonatomic, assign, readonly) NSUInteger channels;

/// Encoding of the sound stream. Use `PSPDFSoundAnnotationEncoding*` for values.
@property (nonatomic, copy, readonly) NSString *encoding;

/// Loads bits, sample rate, channels, encoding from sound file.
- (BOOL)loadAttributesFromAudioFile:(NSError *__autoreleasing*)error;

/// Get the direct sound data.
- (NSData *)soundData;

@end
