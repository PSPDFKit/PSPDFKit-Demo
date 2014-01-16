//
//  PSCPopoverTestViewController.m
//  PSPDFCatalog-
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCPopoverTestViewController.h"
#import "PSPDFPopoverController.h"
#import "PSPDFAvailability.h"


@interface PSCPopoverTestViewController () <UIPopoverControllerDelegate>

@property (nonatomic, copy) NSArray *buttons;
@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) UISwitch *systemSwitch;
@property (nonatomic, assign) BOOL useSystemPopover;

@end


static const NSUInteger noHorizontalButtons = 3;
static const NSUInteger noVerticalButtons = 6;


@implementation PSCPopoverTestViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setUpViews];
	self.title = @"Popover test";
}

#pragma mark - Views

- (void)setUpViews {
	self.view.backgroundColor = [UIColor whiteColor];
	[self setUpControls];
	[self setUpButtons];
}

- (void)setUpControls {
	if (PSPDFIsIPad()) {
		UISwitch *systemSwitch = [[UISwitch alloc] init];
		systemSwitch.on = self.useSystemPopover;
		[systemSwitch addTarget:self action:@selector(systemSwitchToggle:) forControlEvents:UIControlEventValueChanged];
		self.systemSwitch = systemSwitch;
		UIBarButtonItem *switchItem = [[UIBarButtonItem alloc] initWithCustomView:systemSwitch];
		self.navigationItem.rightBarButtonItem = switchItem;
	}
}

- (void)setUpButtons {
	NSMutableArray *buttons = [NSMutableArray array];
	for (NSUInteger idx = 0; idx < noHorizontalButtons * noVerticalButtons; idx++) {
		UIButton *button = [self popoverButtonWithIndex:idx];
		[buttons addObject:button];
		[self.view addSubview:button];
	}
	self.buttons = buttons;
}

- (UIButton *)popoverButtonWithIndex:(NSUInteger)index {
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:[NSString stringWithFormat:@"%tu", index+1] forState:UIControlStateNormal];
	[button setBackgroundColor:[self randomColor]];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(showPopoverPressed:) forControlEvents:UIControlEventTouchUpInside];
	button.tag = index;
	return button;
}

- (UIColor *)randomColor {
	return [UIColor colorWithHue:((arc4random() % 256) / 256.f) saturation:((arc4random() % 256) / 256.f) brightness:.8f alpha:1.f];
}

#pragma mark - Layout

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	CGRect buttonBounds = self.view.bounds;
	CGFloat verticalTranslation = 0.f;
	PSPDF_IF_IOS7_OR_GREATER(verticalTranslation = self.topLayoutGuide.length;)
	buttonBounds.origin.y += verticalTranslation;
	buttonBounds.size.height -= verticalTranslation;
	CGFloat buttonWidth = buttonBounds.size.width / noHorizontalButtons;
	CGFloat buttonHeight = buttonBounds.size.height / noVerticalButtons;
	[self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
		CGRect buttonFrame = CGRectMake((idx%3)*buttonWidth + buttonBounds.origin.x, (idx/3)*buttonHeight + buttonBounds.origin.y, buttonWidth, buttonHeight);
		button.frame = buttonFrame;
	}];
}

#pragma mark - Actions

- (void)showPopoverPressed:(UIButton *)sender {
	if (self.popover) {
		[self.popover dismissPopoverAnimated:YES];
		self.popover = nil;
		return;
	}
	
	UIViewController *sample = [UIViewController new];
	PSPDF_IF_PRE_IOS7(sample.view.backgroundColor = [UIColor whiteColor];)
	sample.contentSizeForViewInPopover = CGSizeMake(300, 400);
	
	UIPopoverController *popover;
	if (self.useSystemPopover && PSPDFIsIPad()) {
		popover = [[UIPopoverController alloc] initWithContentViewController:sample];
	} else {
		popover = (UIPopoverController *)[[PSPDFPopoverController alloc] initWithContentViewController:sample];
	}
	
	// Resize after a few seconds (if the controller is still around)
	__weak typeof(sample) wSamle = sample;
	double delayInSeconds = 5.0;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		[wSamle setContentSizeForViewInPopover:CGSizeMake(200, 300)];
	});
	
	popover.delegate = self;
	
	[popover presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	self.popover = popover;
}

- (void)systemSwitchToggle:(UISwitch *)sender {
	self.useSystemPopover = sender.on;
}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	self.popover = nil;
}

@end
