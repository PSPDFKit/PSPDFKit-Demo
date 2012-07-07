//
//  SplitMasterViewController.m
//  EmbeddedExample
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//  Original code by Gregory S. Combs, Creative Commons Attribution 3.0 Unported License.
//

#import "IntelligentSplitViewController.h"
#import <objc/message.h>

@implementation IntelligentSplitViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
	if ((self = [super init])) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(willRotate:)
													 name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];

		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(didRotate:)
													 name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];

        // iOS 5.1: Disable, as this breaks our gesture recognizers for pageCurl.
        // TODO: find a way to hook into their gesture recognizers to create a dependency.
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_5_0
        if ([self respondsToSelector:@selector(setPresentsWithGesture:)]) {
            [self setPresentsWithGesture:NO];
        }
#endif
	}
	return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)willRotate:(id)sender {
	if (![self isViewLoaded] || !sender) return;

	NSNotification *notification = sender;
	UIInterfaceOrientation toOrientation = [[notification.userInfo valueForKey:UIApplicationStatusBarOrientationUserInfoKey] integerValue];

	UITabBarController *tabBar = self.tabBarController;
	BOOL notModal = (!tabBar.modalViewController);
	BOOL isSelectedTab = [self.tabBarController.selectedViewController isEqual:self];

	NSTimeInterval duration = [[UIApplication sharedApplication] statusBarOrientationAnimationDuration];

	if (!isSelectedTab || !notModal)  {
		// Looks like we're not "visible" ... propogate rotation info
		[super willRotateToInterfaceOrientation:toOrientation duration:duration];

		UIViewController *master = [self.viewControllers objectAtIndex:0];
		NSObject *theDelegate = (NSObject *)self.delegate;

        // careful... uses obfuscated private API.
        UIBarButtonItem *button = [super valueForKey:[NSString stringWithFormat:@"%@ttonItem", @"_barBu"]];

		if (UIInterfaceOrientationIsPortrait(toOrientation)) {
			if ([theDelegate respondsToSelector:@selector(splitViewController:willHideViewController:withBarButtonItem:forPopoverController:)]) {

				@try {
					UIPopoverController *popover = [super valueForKey:[NSString stringWithFormat:@"%@denPopoverController", @"_hid"]];
					objc_msgSend(theDelegate, @selector(splitViewController:willHideViewController:withBarButtonItem:forPopoverController:), self, master, button, popover);
				}
				@catch (NSException *e) {
					PSPDFLogError(@"There was a nasty error while notifyng splitviewcontrollers of an orientation change: %@", [e description]);
				}
			}
		}
		else if (UIInterfaceOrientationIsLandscape(toOrientation)) {
			if ([theDelegate respondsToSelector:@selector(splitViewController:willShowViewController:invalidatingBarButtonItem:)]) {
				@try {
					objc_msgSend(theDelegate, @selector(splitViewController:willShowViewController:invalidatingBarButtonItem:), self, master, button);
				}
				@catch (NSException * e) {
					PSPDFLogError(@"There was a nasty error while notifing splitviewcontrollers of an orientation change: %@", [e description]);
				}
			}
		}
	}
}

- (void)didRotate:(id)sender {
	if (![self isViewLoaded] || !sender) return;

	NSNotification *notification = sender;
	UIInterfaceOrientation fromOrientation = [[notification.userInfo valueForKey:UIApplicationStatusBarOrientationUserInfoKey] integerValue];

	UITabBarController *tabBar = self.tabBarController;
	BOOL notModal = (!tabBar.modalViewController);
	BOOL isSelectedTab = [self.tabBarController.selectedViewController isEqual:self];

	if (!isSelectedTab || !notModal)  {
		// Looks like we're not "visible" ... propogate rotation info
		[super didRotateFromInterfaceOrientation:fromOrientation];
	}
}

@end
