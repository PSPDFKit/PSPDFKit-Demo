//
//  PSCTwoFingerSwipeGestureViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCTwoFingerSwipeGestureViewController.h"

@interface PSCSwipePagingScrollView : PSPDFPagingScrollView
@property (nonatomic, strong) UIPanGestureRecognizer *customPanRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeRecognizer;
@end

@interface PSCSwipeScrollView : PSPDFScrollView
@property (nonatomic, assign) BOOL hasGesturesConfigured;
@end

/**
 Proof-of-concept how to add swipe gestures. It's not recommended though, since this will slow down your regular scrollView interactions.
 */
@implementation PSCTwoFingerSwipeGestureViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document {
    [super commonInitWithDocument:document];
    [self overrideClass:PSPDFPagingScrollView.class withClass:PSCSwipePagingScrollView.class];
    [self overrideClass:PSPDFScrollView.class withClass:PSCSwipeScrollView.class];
}

@end

@implementation PSCSwipePagingScrollView

#define kPSCTouchesRequired 2

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        // This is taken from:
        // * http://stackoverflow.com/questions/8210614/disable-2-finger-scrolling-in-uiscrollview
        // * http://stackoverflow.com/questions/8711395/two-finger-swipe-in-uiscrollview-for-ipad-application
        //
        // Set up a two-finger pan recognizer as a dummy to steal two-finger scrolls from the scroll view
        // we initialize without a target or action because we don't want the two-finger pan to be handled
        UIPanGestureRecognizer *multitouchPan = [[UIPanGestureRecognizer alloc] init];
        multitouchPan.minimumNumberOfTouches = kPSCTouchesRequired;
        multitouchPan.maximumNumberOfTouches = kPSCTouchesRequired;
        [self addGestureRecognizer:multitouchPan];
        self.customPanRecognizer = multitouchPan;
        [self.panGestureRecognizer requireGestureRecognizerToFail:multitouchPan];

        // set up the two-finger left and right swipe recognizers
        UISwipeGestureRecognizer *multitouchLeftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureFrom:)];
        multitouchLeftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        multitouchLeftSwipe.numberOfTouchesRequired = kPSCTouchesRequired;
        [self addGestureRecognizer:multitouchLeftSwipe];
        self.leftSwipeRecognizer = multitouchLeftSwipe;

        UISwipeGestureRecognizer *multitouchRightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureFrom:)];
        multitouchRightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
        multitouchRightSwipe.numberOfTouchesRequired = kPSCTouchesRequired;
        [self addGestureRecognizer:multitouchRightSwipe];
        self.rightSwipeRecognizer = multitouchRightSwipe;

        // prevent the two-finger pan recognizer from stealing the two-finger swipe gestures
        // this is essential for the swipe recognizers to work
        [multitouchPan requireGestureRecognizerToFail:self.leftSwipeRecognizer];
        [multitouchPan requireGestureRecognizerToFail:self.rightSwipeRecognizer];

        [self.pinchGestureRecognizer requireGestureRecognizerToFail:self.leftSwipeRecognizer];
        [self.pinchGestureRecognizer requireGestureRecognizerToFail:self.rightSwipeRecognizer];
    }
    return self;
}

- (void)handleGestureFrom:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [PSPDFProgressHUD showSuccessWithStatus:@"Swiped left"];
        NSLog(@"Swiped left.");
    } else {
        [PSPDFProgressHUD showSuccessWithStatus:@"Swiped right"];
        NSLog(@"Swiped right.");
    }
}

@end

@implementation PSCSwipeScrollView

- (void)displayDocument:(PSPDFDocument *)document withPage:(NSUInteger)page {
    [super displayDocument:document withPage:page];
    if (!self.hasGesturesConfigured) {
        PSCSwipePagingScrollView *pagingScrollView = (PSCSwipePagingScrollView *)self.pdfController.pagingScrollView;
        if ([pagingScrollView isKindOfClass:[PSCSwipePagingScrollView class]]) {
            [self.panGestureRecognizer requireGestureRecognizerToFail:pagingScrollView.customPanRecognizer];
            [self.pinchGestureRecognizer requireGestureRecognizerToFail:pagingScrollView.leftSwipeRecognizer];
            [self.pinchGestureRecognizer requireGestureRecognizerToFail:pagingScrollView.rightSwipeRecognizer];
        }
        self.hasGesturesConfigured = YES;
    }
}

@end
