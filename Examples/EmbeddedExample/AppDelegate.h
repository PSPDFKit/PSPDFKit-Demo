//
//  AppDelegate.h
//  EmbeddedExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#define kDevelopersGuideFileName @"DevelopersGuide.pdf"
#define kPaperExampleFileName @"amazon-dynamo-sosp2007.pdf"
#define kPSPDFKitExample @"PSPDFKit.pdf"
#define kHackerMagazineExample @"hackermonthly12.pdf"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UITabBarController *tabBarController;

@end
