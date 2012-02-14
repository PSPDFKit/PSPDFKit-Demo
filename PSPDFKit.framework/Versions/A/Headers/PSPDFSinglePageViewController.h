//
//  PSPDFSinglePageViewController.h
//  PSPDFKit
//
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFKitGlobal.h"

@class PSPDFViewController, PSPDFScrollView, PSPDFPageView;

/// displays a single pdf page.
@interface PSPDFSinglePageViewController : UIViewController

/// create page controller suing the master pdf controller
- (id)initWithPDFController:(PSPDFViewController *)pdfController page:(NSUInteger)page;

/// attached pdfController
@property(nonatomic, ps_weak) PSPDFViewController *pdfController;

/// internally used pageView
@property(nonatomic, strong, readonly) PSPDFPageView *pageView;

/// current visible page.
@property(nonatomic, assign, readonly) NSUInteger page;

/// If set to YES, the background of the UIViewController is used. Else you may get some animation artifacts. Defaults to NO.
@property(nonatomic, assign) BOOL useSolidBackground;

@end
