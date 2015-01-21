//
//  PSCRotationLockBarButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2013-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

//#import "PSCRotationLockBarButtonItem.h"
//
//@interface PSCRotationLockBarButtonItem ()
//@property (nonatomic, strong) UIButton *button;
//@end
//
//@implementation PSCRotationLockBarButtonItem
//
//- (NSString *)actionName {
//    return @"Lock/Unlock Rotation";
//}
//
//- (UIBarButtonItemStyle)style {
//    return UIBarButtonItemStylePlain;
//}
//
//- (UIView *)customView {
//    NSString *imageName = self.pdfController.rotationLockEnabled ? @"RotationLocked" : @"RotationUnlocked";
//    UIImage *image = [UIImage imageNamed:imageName];
//    if (!self.button) {
//        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
//
//        CGRect rect = CGRectZero;
//        rect.size = image.size;
//        [self.button setFrame:rect];
//    }
//    self.button.showsTouchWhenHighlighted = YES;
//    [self.button setImage:image forState:UIControlStateNormal];
//    [self.button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
//    return self.button;
//}
//
//- (void)action:(id)sender {
//    PSPDFViewController *pdfController = self.pdfController;
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        pdfController.rotationLockEnabled = !pdfController.rotationLockEnabled;
//        [self customView];
//    }];
//}
//
//@end
