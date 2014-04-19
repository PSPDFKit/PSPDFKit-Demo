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

/// Posted when recording or playback is started, paused or stopped
extern NSString *const PSPDFSoundAnnotationChangedStateNotification;

/// Posted when +stopRecordingOrPlaybackForAllExcept is invoked
extern NSString *const PSPDFSoundAnnotationStopAll;

typedef NS_ENUM(NSInteger, PSPDFSoundAnnotationState) {
    PSPDFSoundAnnotationStateStopped = 0,
    PSPDFSoundAnnotationStateRecording,
    PSPDFSoundAnnotationStateRecordingPaused,
    PSPDFSoundAnnotationStatePlaying,
    PSPDFSoundAnnotationStatePlaybackPaused,
};

/// A sound annotation (PDF 1.2) shall analogous to a text annotation except that instead of a text
/// note, it contains sound recorded from the iPad/iPhone's microphone or imported from a file.
@interface PSPDFSoundAnnotation : PSPDFAnnotation

/// Stops any currently active recording or playback, except the sender.
/// If the sender is nil, all annotations are stopped.
+ (void)stopRecordingOrPlaybackForAllExcept:(id)sender;

/// Checks if we have permission to record
+ (void)requestRecordPermission:(void (^)(BOOL granted))block;

- (id)initRecorder;
- (id)initWithRate:(NSUInteger)rate channels:(UInt32)channels bits:(UInt32)bits encoding:(NSString *)encoding;

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

/// The current playback state
@property (nonatomic, assign, readonly) PSPDFSoundAnnotationState state;

/// The audio player object
@property (nonatomic, strong, readonly) AVAudioPlayer *audioPlayer;

/// Loads bits, sample rate, channels, encoding from sound file.
- (void)loadAttributesFromAudioFile;

/// Starts or resumes playback
- (BOOL)startPlayback:(NSError **)error;

/// Starts or resumes recording
- (BOOL)startRecording:(NSError **)error;

/// Pauses playback or recording
- (void)pause;

/// Stops playback or recording
- (BOOL)stop:(NSError **)error;

@end
