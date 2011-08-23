//
//  SplitTableViewController.h
//  EmbeddedExample
//
//  Created by Peter Steinberger on 8/22/11.
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PSPDFKit/PSPDFKit.h>

@class  SplitMasterViewController;

@interface SplitTableViewController : UITableViewController {
    SplitMasterViewController *masterVC_;
    NSArray *content_;
}

@property(nonatomic, assign) SplitMasterViewController *masterVC;

@end
