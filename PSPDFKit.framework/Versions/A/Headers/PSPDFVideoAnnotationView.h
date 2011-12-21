//
//  PSPDFVideoAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PSPDFAnnotationView.h"

/// Displays audio/movie annotations with an embedded MPMoviePlayerController.
@interface PSPDFVideoAnnotationView : UIView <PSPDFAnnotationView>

/// Movie url. (can be local, or external)
@property(nonatomic, strong) NSURL *URL;

/// YES to enable auto-start as soon as the view is loaded. Defaults to NO.
@property(nonatomic, assign, getter=isAutostartEnabled) BOOL autostartEnabled;

/// Instance of the MPMoviePlayerController.
@property(nonatomic, strong, readonly) MPMoviePlayerController *player;

@end
