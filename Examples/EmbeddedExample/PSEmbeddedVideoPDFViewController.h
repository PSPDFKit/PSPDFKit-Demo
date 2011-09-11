//
//  PSEmbeddedVideoPDFViewController.h
//  EmbeddedExample
//
//  Created by Peter Steinberger on 9/11/11.
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PSEmbeddedVideoPDFViewController : PSPDFViewController <PSPDFViewControllerDelegate> {
    MPMoviePlayerController *moviePlayer_;
}

@property(nonatomic, retain) MPMoviePlayerController *moviePlayer;

@end
