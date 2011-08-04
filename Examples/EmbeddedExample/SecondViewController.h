//
//  SecondViewController.h
//  EmbeddedExample
//
//  Created by Peter Steinberger on 8/4/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PSPDFKit/PSPDFKit.h>

@interface SecondViewController : PSPDFViewController <PSPDFViewControllerDelegate> {
    UISegmentedControl *customViewModeSegment_;
}

@end
