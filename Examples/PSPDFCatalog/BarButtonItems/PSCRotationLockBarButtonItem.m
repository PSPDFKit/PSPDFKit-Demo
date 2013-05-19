//
//  PSCRotationLockBarButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSCRotationLockBarButtonItem.h"

@implementation PSCRotationLockBarButtonItem {
    UIButton *_button;
}

- (UIBarButtonItemStyle)style {
    return UIBarButtonItemStylePlain;
}

- (UIView *)customView {
    NSString *imageName = self.pdfController.rotationLockEnabled ? @"RotationLocked" : @"RotationUnlocked";
    UIImage *image = [UIImage imageNamed:imageName];
    if(!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];

        CGRect rect = CGRectZero;
        rect.size = image.size;
        [_button setFrame:rect];
    }
    [_button setShowsTouchWhenHighlighted:YES];
    [_button setImage:image forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    return _button;
}

- (void)action:(PSPDFBarButtonItem *)sender {
    PSPDFViewController *pdfController = self.pdfController;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        pdfController.rotationLockEnabled = !pdfController.rotationLockEnabled;
        [self customView];
    }];
}

@end
