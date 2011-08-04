//
//  FirstViewController.h
//  EmbeddedExample
//
//  Created by Peter Steinberger on 8/4/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PSPDFKit/PSPDFKit.h>

@interface FirstViewController : UIViewController {
    PSPDFViewController *pdfController_;
    UIInterfaceOrientation lastOrientation_;
}

@property(nonatomic, retain) PSPDFViewController *pdfController;

@end
