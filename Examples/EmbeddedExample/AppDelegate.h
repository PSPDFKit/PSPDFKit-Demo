//
//  AppDelegate.h
//  EmbeddedExample
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#define kDevelopersGuideFileName @"DevelopersGuide.pdf"
#define kPaperExampleFileName @"amazon-dynamo-sosp2007.pdf"
#define kMacbookAirFileName @"macbook_air_users_guide.pdf"
#define kPSPDFKitExample @"PSPDFKit.pdf"

@interface AppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UITabBarController *tabBarController;

@end
