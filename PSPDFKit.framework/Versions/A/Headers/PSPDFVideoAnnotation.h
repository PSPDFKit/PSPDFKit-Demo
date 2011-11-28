//
//  PSPDFVideoAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "PSPDFAnnotationDelegate.h"

/// Displays audio/movie annotations with an embedded MPMoviePlayerController.
@interface PSPDFVideoAnnotation : UIView <PSPDFAnnotationDelegate>

/// Initialize with frame.
- (id)initWithFrame:(CGRect)frame;

/// Movie url. (can be local, or external)
@property(nonatomic, retain) NSURL *URL;

/// YES to enable auto-start as soon as the view is loaded. Defaults to YES.
@property(nonatomic, assign, getter=isAutostartEnabled) BOOL autostartEnabled;

/// Instance of the MPMoviePlayerController.
@property(nonatomic, retain, readonly) MPMoviePlayerController *player;

@end
