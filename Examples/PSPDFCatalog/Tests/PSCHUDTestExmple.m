//
//  PSCHUDTestExmple.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCHUDTestExmple.h"

@implementation PSCHUDTestExmple

- (id)init {
    if (self = [super init]) {
        self.title = @"Test the PSPDFStatusHUD";
        self.category = PSCExampleCategoryTests;
        self.priority = 1;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    [self performSelector:@selector(updateHud) withObject:nil afterDelay:0.1f];
    return nil;
}

- (void)updateHud {
    PSPDFStatusHUDItem *item = [PSPDFStatusHUDItem progressWithText:@"Hello"];
    item.title = @"Title";
    item.subtitle = @"Subtitle";
    item.progress = 0.7;
    [item pushAnimated:YES];
    [self performSelector:@selector(showError:) withObject:item afterDelay:1.0];
}

- (void)showError:(PSPDFStatusHUDItem *)oldItem {
    PSPDFStatusHUDItem *item = [PSPDFStatusHUDItem errorWithText:@"Omg!"];
    item.title = @"Error";
    [item pushAnimated:YES];
    [self performSelector:@selector(showSuccess:) withObject:item afterDelay:1.0];
}

- (void)showSuccess:(PSPDFStatusHUDItem *)oldItem {
    PSPDFStatusHUDItem *item = [PSPDFStatusHUDItem successWithText:@"Omg!"];
    item.title = @"Success";
    [item pushAnimated:YES];
    [self performSelector:@selector(switchToBlackStyle:) withObject:item afterDelay:1.0];
}

- (void)switchToBlackStyle:(PSPDFStatusHUDItem *)oldItem {
    [oldItem setHUDStyle:PSPDFStatusHUDStyleBlack];
    [self performSelector:@selector(switchToClearStyle:) withObject:oldItem afterDelay:1.0];
}

- (void)switchToClearStyle:(PSPDFStatusHUDItem *)oldItem {
    [oldItem setHUDStyle:PSPDFStatusHUDStyleClear];
    [self performSelector:@selector(switchToGradientStyle:) withObject:oldItem afterDelay:1.0];
}

- (void)switchToGradientStyle:(PSPDFStatusHUDItem *)oldItem {
    [oldItem setHUDStyle:PSPDFStatusHUDStyleGradient];
    [self performSelector:@selector(popAll) withObject:nil afterDelay:2.0];
}

- (void)popAll {
    [self performSelector:@selector(updateHud) withObject:nil afterDelay:2.0];
}

@end
