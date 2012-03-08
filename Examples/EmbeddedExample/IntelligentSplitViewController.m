//
//  IntelligentSplitViewController.m
//  From TexLege by Gregory S. Combs
//
//  Released under the Creative Commons Attribution 3.0 Unported License
//  Please see the included license page for more information.
//
//  In a nutshell, you can use this, just attribute this to me in your "thank you" notes or about box.
//

#import "IntelligentSplitViewController.h"
#import <objc/message.h>

@implementation IntelligentSplitViewController

- (id) init {
	if ((self = [super init])) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(willRotate:)
													 name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(didRotate:)
													 name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];

        // disable, as this breaks our gesture recognizers for pageCurl.
        // TODO: find a way to hook into their gesture recognizers to create a dependency.
        // If this doesn't compile for you, please update to Xcode 4.3.1 (needs iOS5.1 SDK)
        if ([self respondsToSelector:@selector(setPresentsWithGesture:)]) {
            self.presentsWithGesture = NO;
        }
	}
	return self;
}

- (void)dealloc {
	@try {
		[[NSNotificationCenter defaultCenter] removeObserver:self];
	}
	@catch (NSException * e) {
		NSLog(@"IntelligentSplitViewController DE-OBSERVING CRASHED: %@ ... error:%@", self.title, [e description]);
	}

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)willRotate:(id)sender {
	if (![self isViewLoaded]) // we haven't even loaded up yet, let's turn away from this place
		return;
		  
	NSNotification *notification = sender;
	if (!notification)
		return;
	
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

		
#define YOU_DONT_FEEL_QUEAZY_ABOUT_THIS_BECAUSE_IT_PASSES_THE_APP_STORE 1		
		
#if YOU_DONT_FEEL_QUEAZY_ABOUT_THIS_BECAUSE_IT_PASSES_THE_APP_STORE
		UIBarButtonItem *button = [super valueForKey:@"_barButtonItem"];
		
#else //YOU_DO_FEEL_QUEAZY_AND_FOR_SOME_REASON_YOU_PREFER_THE_LESSER_EVIL_____FRIGHTENING_STUFF
		UIBarButtonItem *button = [[[[[self.viewControllers objectAtIndex:1] 
									  viewControllers] objectAtIndex:0] 
									navigationItem] rightBarButtonItem];
#endif
		
		if (UIInterfaceOrientationIsPortrait(toOrientation)) {
			if (theDelegate && [theDelegate respondsToSelector:@selector(splitViewController:willHideViewController:withBarButtonItem:forPopoverController:)]) {

				@try {
					UIPopoverController *popover = [super valueForKey:@"_hiddenPopoverController"];
					objc_msgSend(theDelegate, @selector(splitViewController:willHideViewController:withBarButtonItem:forPopoverController:), self, master, button, popover);
				}
				@catch (NSException * e) {
					NSLog(@"There was a nasty error while notifyng splitviewcontrollers of an orientation change: %@", [e description]);
				}
			}
		}
		else if (UIInterfaceOrientationIsLandscape(toOrientation)) {
			if (theDelegate && [theDelegate respondsToSelector:@selector(splitViewController:willShowViewController:invalidatingBarButtonItem:)]) {
				@try {
					objc_msgSend(theDelegate, @selector(splitViewController:willShowViewController:invalidatingBarButtonItem:), self, master, button);
				}
				@catch (NSException * e) {
					NSLog(@"There was a nasty error while notifyng splitviewcontrollers of an orientation change: %@", [e description]);
				}
			}
		}
	}
}

- (void)didRotate:(id)sender {
	if (![self isViewLoaded]) // we haven't even loaded up yet, let's turn away from this place
		return;

	NSNotification *notification = sender;
	if (!notification)
		return;
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
