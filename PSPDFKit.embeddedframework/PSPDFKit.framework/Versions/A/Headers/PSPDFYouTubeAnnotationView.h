//
//  PSPDFYouTubeAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFAnnotationView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PSPDFLinkAnnotationBaseView.h"

@class PSPDFVideoAnnotationView, PSPDFAnnotation;

/// Uses MPMoviePlayerController whenever possible, else falls back to the UIWebView YouTube plugin.
/// Note: The YouTube plugin doesn't show up in the Simulator. Test on the device!
@interface PSPDFYouTubeAnnotationView : PSPDFLinkAnnotationBaseView

/// Keep a reference at the annotation
@property (nonatomic, strong) PSPDFAnnotation *annotation;

/// Access the original YouTube URL (e.g. http://www.youtube.com/watch?v=Vo0Cazxj_yc)
@property (nonatomic, strong, readonly) NSURL *youTubeURL;

/// Set if extracting the YouTube mp4 fails.
@property (nonatomic, strong, readonly) NSError *error;

/// YES to enable auto-start as soon as the view is loaded. Relayed to PSPDFVideoAnnotationView. Doesn't work with UIWebView.
@property (nonatomic, assign, getter=isAutostartEnabled) BOOL autostartEnabled;

/// Used in the default implementation.
@property (nonatomic, strong) UIWebView *webView;

@end
