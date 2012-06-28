//
//  PSPDFVideoAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PSPDFLinkAnnotationBaseView.h"

/// Displays audio/movie annotations with an embedded MPMoviePlayerController.
@interface PSPDFVideoAnnotationView : PSPDFLinkAnnotationBaseView

/// Movie URL. (can be local, or external)
@property(nonatomic, strong) NSURL *URL;

/// YES to enable auto-start as soon as the view is loaded. Defaults to NO.
@property(nonatomic, assign, getter=isAutostartEnabled) BOOL autostartEnabled;

/// If this is set to YES, the video will play with it's own audio session, and will *ignore* the silent switch.
/// This is was people expect when they press play on a video, and they will often report a bug becuase they forgot
/// that the silent switch is set to YES (esp. on the iPad it is not very visible).
/// Defaults to NO. If you have a lot of autostarting content, you might wanna set this to NO.
/// Just be aware of user reactions. You might wanna check if the silent switch is set and show an alert.
/// Property will reset itself after setting a new annotation.
@property(nonatomic, assign) BOOL useApplicationAudioSession;

/// Instance of the MPMoviePlayerController.
@property(nonatomic, strong, readonly) MPMoviePlayerController *player;

@end
