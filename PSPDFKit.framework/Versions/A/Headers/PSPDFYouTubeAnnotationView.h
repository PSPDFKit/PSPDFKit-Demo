//
//  PSPDFYouTubeAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFAnnotationView.h"
#import <MediaPlayer/MediaPlayer.h>

@class PSPDFVideoAnnotationView, PSPDFAnnotation;

/// Uses MPMoviePlayerController whenever possible, else falls back to the UIWebView YouTube plugin.
/// Note: The YouTube plugin doesn't show up in the Simulator. Test on the device!
@interface PSPDFYouTubeAnnotationView : UIView <PSPDFAnnotationView>

/// Keep a reference at the annotation
@property(nonatomic, strong) PSPDFAnnotation *annotation;

/// Access the original YouTube URL (e.g. http://www.youtube.com/watch?v=Vo0Cazxj_yc)
@property(nonatomic, strong, readonly) NSURL *youTubeURL;

/// Raw mp4 URL, if it could be extracted.
@property(nonatomic, strong, readonly) NSURL *youTubeMovieURL;

/// Set if extracting the YouTube mp4 fails.
@property(nonatomic, strong, readonly) NSError *error;

/// YES to enable auto-start as soon as the view is loaded. Relayed to PSPDFVideoAnnotationView. Doesn't work with UIWebView.
@property(nonatomic, assign, getter=isAutostartEnabled) BOOL autostartEnabled;

/// YES if MPMoviePlayerController is used. NO if we had to fallback to UIWebView.
@property(nonatomic, assign, readonly, getter=isNativeView) BOOL nativeView;

/// Animates view changes. Defaults to YES. Fades windows on a change.
@property(nonatomic, assign, getter=isAnimated) BOOL animated;

/// Is called initially, and once if a MP4 is found. Default implementation is provided.
@property(nonatomic, strong) void (^setupNativeView)(void);

/// Used in the default implementation.
@property(nonatomic, strong) MPMoviePlayerController *moviePlayerController;

// Called only if MP4 could not be found. Default implementation is provided.
@property(nonatomic, strong) void (^setupWebView)(void);

/// Used in the default implementation.
@property (nonatomic, strong) UIWebView *webView;

@end
