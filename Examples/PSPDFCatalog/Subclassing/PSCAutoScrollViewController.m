//
//  PSCAutoScrollViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCAutoScrollViewController.h"

@interface PSCStoppingContentScrollView : PSPDFContentScrollView @end

@interface PSCAutoScrollViewController() {
    NSTimer *_scrollTimer;
}
@property (nonatomic, assign) BOOL scrollingPaused;
@end

@implementation PSCAutoScrollViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithDocument:document])) {
        self.pageTransition = PSPDFPageScrollContinuousTransition;
        self.scrollDirection = PSPDFScrollDirectionVertical;
        self.fitToWidthEnabled = YES;

        // override all usages of PSPDFContentScrollView with the subclass PSCStoppingContentScrollView.
        self.overrideClassNames = @{(id)[PSPDFContentScrollView class] : [PSCStoppingContentScrollView class]};
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(scroll) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_scrollTimer invalidate];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)scroll {
    if (self.scrollingPaused) return;

    CGPoint currentOffset = self.pagingScrollView.contentOffset;
    self.pagingScrollView.contentOffset = CGPointMake(currentOffset.x, currentOffset.y + 0.5f);
}

@end

// Stop scrolling when we tap on the view.
@implementation PSCStoppingContentScrollView

// intercept both a quick touch...
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    ((PSCAutoScrollViewController *)self.pdfController).scrollingPaused = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    ((PSCAutoScrollViewController *)self.pdfController).scrollingPaused = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    ((PSCAutoScrollViewController *)self.pdfController).scrollingPaused = NO;
}

// and a long press.
- (void)longPress:(UILongPressGestureRecognizer *)recognizer {
    [super longPress:recognizer];

    // touchesCancelled is called after state change, so process a runloop later
    PSCAutoScrollViewController *autoController = (PSCAutoScrollViewController *)self.pdfController;
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (recognizer.state) {
            case UIGestureRecognizerStateBegan:
            case UIGestureRecognizerStateChanged:
                autoController.scrollingPaused = YES;
                break;
            default: autoController.scrollingPaused = NO; break;
        }
    });
}

@end
