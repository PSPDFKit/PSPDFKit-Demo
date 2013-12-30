//
//  PSPDFVideoAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PSPDFLinkAnnotationBaseView.h"
#import "PSPDFMediaPlayerCoverView.h"

@class PSPDFVideoAnnotationCoverView;

/// Displays audio/movie annotations with an embedded `MPMoviePlayerController`.
@interface PSPDFVideoAnnotationView : PSPDFLinkAnnotationBaseView

/// Movie URL. (can be local, or external)
@property (nonatomic, strong) NSURL *URL;

/// YES to enable auto-start as soon as the view is loaded. Defaults to NO.
@property (nonatomic, assign, getter=isAutoplayEnabled) BOOL autoplayEnabled;

/// Instance of the MPMoviePlayerController.
@property (nonatomic, strong, readonly) MPMoviePlayerController *player;

/// Cover view is only set if cover option is set.
@property (nonatomic, strong) PSPDFVideoAnnotationCoverView *coverView;

/// Video has a zIndex of 10.
@property (nonatomic, assign) NSUInteger zIndex;

@end


/// This is here for compatibility reasons only. Please use `PSPDFMediaPlayerCoverView` instead.
@interface PSPDFVideoAnnotationCoverView : PSPDFMediaPlayerCoverView
@end


@interface PSPDFVideoAnnotationView (SubclassingHooks)

/// Looks into (self.linkAnnotation.options)[@"cover"] for the cover URL.
/// Might return something else; check type before using it as an NSURL.
- (NSURL *)coverURL;

/// Adds the coverView if not yet added.
- (void)addCoverViewAnimated:(BOOL)animated;

@end
