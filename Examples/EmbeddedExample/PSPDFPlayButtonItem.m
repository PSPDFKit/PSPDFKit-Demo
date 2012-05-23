//
//  PSPDFPlayButtonItem.m
//  EmbeddedExample
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFPlayButtonItem.h"

@implementation PSPDFPlayButtonItem
{
    UIButton *playButton_;
    NSTimer *autoplayTimer_;
    BOOL autoplay_;
}

- (UIButton *)playButton {
    if (!playButton_) {
        playButton_ = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        playButton_.showsTouchWhenHighlighted = YES;
        [playButton_ addTarget:self action:@selector(playPauseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self updatePlayButton];
    }
    return playButton_;
}

- (UIView *)customView {
    return self.playButton;
}

- (void)updatePlayButton {
    // Don't use kitImageNamed in shipping code!
    UIImage *playImage = [UIImage performSelector:@selector(kitImageNamed:) withObject:@"UIButtonBarPlay.png"];
    UIImage *pauseImage = [UIImage performSelector:@selector(kitImageNamed:) withObject:@"UIButtonBarPause.png"];
    [self.playButton setImage:autoplay_ ? pauseImage : playImage forState:UIControlStateNormal];
}

- (void)playPauseAction:(id)sender {
    [PSPDFBarButtonItem dismissPopoverAnimated:NO];
    
    if (!autoplay_) {
        autoplay_ = YES;
        autoplayTimer_ = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self.pdfViewController selector:@selector(advanceToNextPage) userInfo:nil repeats:YES];
        [self updatePlayButton];
    }else {
        autoplay_ = NO;
        [autoplayTimer_ invalidate];
        [self updatePlayButton];
    }
}

@end
