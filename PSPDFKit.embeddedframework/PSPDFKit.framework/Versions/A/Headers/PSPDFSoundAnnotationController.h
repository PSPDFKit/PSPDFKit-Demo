//
//  PSPDFSoundAnnotationController.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

#import "PSPDFSoundAnnotation.h"


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

@interface PSPDFSoundAnnotationController : NSObject

/// Stops any currently active recording or playback, except the sender.
/// If the sender is nil, all annotations are stopped.
+ (void)stopRecordingOrPlaybackForAllExcept:(id)sender;

/// Checks if we have permission to record
+ (void)requestRecordPermission:(void (^)(BOOL granted))block;

- (instancetype)initWithSoundAnnotation:(PSPDFSoundAnnotation *)annot;

/// The controlled sound annotation
@property (nonatomic, weak, readonly) PSPDFSoundAnnotation *annotation;

/// The current playback state
@property (nonatomic, assign, readonly) PSPDFSoundAnnotationState state;

/// The audio player object
@property (nonatomic, strong, readonly) AVAudioPlayer *audioPlayer;

/// Starts or resumes playback
- (BOOL)startPlayback:(NSError *__autoreleasing*)error;

/// Starts or resumes recording
- (BOOL)startRecording:(NSError *__autoreleasing*)error;

/// Pauses playback or recording
- (void)pause;

/// Discards the current recording
- (void)discardRecording;

/// Stops playback or recording
- (BOOL)stop:(NSError *__autoreleasing*)error;

@end
