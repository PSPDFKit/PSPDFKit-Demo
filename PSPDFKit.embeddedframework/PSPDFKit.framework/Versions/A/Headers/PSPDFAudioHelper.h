//
//  PSPDFAudioHelper.h
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

// Audio playback notifications.
extern NSString *const PSPDFAudioPlayerWillStartPlaybackNotification;
extern NSString *const PSPDFAudioPlayerDidStartPlaybackNotification;
extern NSString *const PSPDFAudioPlayerWillPausePlaybackNotification;
extern NSString *const PSPDFAudioPlayerWillResumePlaybackNotification;

extern NSString *const PSPDFAudioPlayerWillStopPlaybackNotification;
extern NSString *const PSPDFAudioPlayerDidFinishPlaybackNotification;

// Audio recording notifications.
extern NSString *const PSPDFAudioPlayerWillStartRecordingNotification;
extern NSString *const PSPDFAudioPlayerDidStartRecordingNotification;
extern NSString *const PSPDFAudioPlayerWillPauseRecordingNotification;
extern NSString *const PSPDFAudioPlayerDidPauseRecordingNotification;
extern NSString *const PSPDFAudioPlayerWillStopRecordingNotification;
extern NSString *const PSPDFAudioPlayerDidStopRecordingNotification;


@protocol AVAudioPlayerDelegate;

@class PSPDFSoundAnnotation, PSPDFDocument;

/// Delegate to control `PSPDFAudioHelper` behavior.
@protocol PSPDFAudioHelperDelegate <NSObject>

@optional

/// Called when the recording is about to start. Return 0 for unlimited recording.
- (NSTimeInterval)shouldLimitRecordingDurationForAnnotation:(PSPDFSoundAnnotation *)annotation;

@end


/// Audio play/record coordinator.
@interface PSPDFAudioHelper : NSObject

/// Singleton accessor.
+ (instancetype)sharedAudioHelper;

/// Delegate to control the audio helper
@property (nonatomic, weak) id<PSPDFAudioHelperDelegate> delegate;

/// Bits used for the new recordings. Default is 16.
@property (nonatomic, assign) NSUInteger defaultBits;

/// Sampling rate for the new recordings. Default is 44100.
@property (nonatomic, assign) NSUInteger defaultRate;

/// Channels used for the new recordings. Default is 1.
@property (nonatomic, assign) NSUInteger defaultChannels;

/// Encoding used for the new recordings. Default is `PSPDFSoundAnnotationEncodingRaw`.
@property (nonatomic, copy) NSString *defaultEncoding;

/// Whether or not a sound is currently playing.
@property (nonatomic, readonly) BOOL isPlaying;

/// Whether or not sound is currently being recorded.
@property (nonatomic, readonly) BOOL isRecording;

/// The sound annotation that is currently being played.
@property (nonatomic, weak) PSPDFSoundAnnotation *currentPlaybackAnnotation;

/// The sound annotation that is currently being recorded.
@property (nonatomic, weak) PSPDFSoundAnnotation *currentRecordingAnnotation;

/// The document that is currently involved in playback or recording.
@property (nonatomic, readonly) PSPDFDocument *activeDocument;

/// The duration of the currently playing sound, or 0 if there is no currently playing sound.
@property (nonatomic, readonly) NSTimeInterval playbackDuration;

/// The current playback time of the currently playing sound, or -1 if there is no currently playing sound.
@property (nonatomic, readonly) NSTimeInterval currentPlaybackTime;

/// Play a new sound annotation from the given url.
- (BOOL)playNewAnnotation:(PSPDFSoundAnnotation *)soundAnnotation withDelegate:(id<AVAudioPlayerDelegate>)delegate;

/// Pause playback.
- (void)pausePlayback;

/// Resume playback of a previously paused sound annotation.
- (void)resumePlayback;

/// Stop playback. Nils out the currently playing annotation, so resume will have no effect after this.
- (void)stopPlayback;

/// Start or resume recording.
- (BOOL)record;

/// Pause recording.
- (void)pauseRecording;

/// Stop recording.
- (void)stopRecording;

/// Stop recording and delete the current recording file, if any.
- (void)discardRecording;

@end

@interface PSPDFAudioHelper (Advanced)

/// Must be called before calling record. Takes a sound annotation object which should already have a temp location on disk set to its `soundURL` property.
- (void)prepareToRecordAnnotation:(PSPDFSoundAnnotation *)soundAnnotation completionBlock:(void (^)(NSError *error))completionBlock;

@end
