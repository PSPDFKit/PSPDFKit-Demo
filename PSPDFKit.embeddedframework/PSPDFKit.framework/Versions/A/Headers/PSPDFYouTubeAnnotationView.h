//
//  PSPDFYouTubeAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFAnnotationViewProtocol.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PSPDFLinkAnnotationBaseView.h"

@class PSPDFVideoAnnotationView, PSPDFAnnotation;

/// Encapsulates the YouTube plugin of `UIWebView`.
@interface PSPDFYouTubeAnnotationView : PSPDFLinkAnnotationBaseView <UIWebViewDelegate>

/// Keep a reference at the annotation.
@property (nonatomic, strong) PSPDFAnnotation *annotation;

/// Access the YouTube URL. Parsed when `annotation is set`.
/// (e.g. http://www.youtube.com/watch?v=Vo0Cazxj_yc)
@property (nonatomic, strong, readonly) NSURL *youTubeURL;

/// Set if extracting the YouTube mp4 fails.
@property (nonatomic, strong, readonly) NSError *error;

/// YES to enable auto-start as soon as the view is loaded.
@property (nonatomic, assign, getter=isAutoplayEnabled) BOOL autoplayEnabled;

/// Used in the default implementation.
@property (nonatomic, strong) UIWebView *webView;

/// Control YouTube plugin -> play.
- (void)play;

/// Control YouTube plugin -> pause.
- (void)pause;

@end

@interface PSPDFYouTubeAnnotationView (Private)

// Helper that converts the YouTube URL into the correct format.
+ (NSURL *)convertYouTubeURLToEmbeddedURL:(NSURL *)youtubeURL;

@end
