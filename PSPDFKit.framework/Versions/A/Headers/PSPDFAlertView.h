//
//  PSPDFAlertView.h
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//
//  Loosely based on Landon Fullers "Using Blocks", Plausible Labs Cooperative.
//  http://landonf.bikemonkey.org/code/iphone/Using_Blocks_1.20090704.html
//

@interface PSPDFAlertView : NSObject <UIAlertViewDelegate> {
  NSMutableArray *blocks_;
}

+ (PSPDFAlertView *)alertWithTitle:(NSString *)title;
+ (PSPDFAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message;

- (id)initWithTitle:(NSString *)title message:(NSString *)message;

- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)())block;
- (void)addButtonWithTitle:(NSString *)title block:(void (^)())block;

- (void)show;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@property (nonatomic, retain) UIAlertView *alertView;

@end
