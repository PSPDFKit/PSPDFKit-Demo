//
//  SplitTableViewController.h
//  EmbeddedExample
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

@class  SplitMasterViewController;

@interface SplitTableViewController : UITableViewController <PSPDFCacheDelegate>

@property(nonatomic, unsafe_unretained) SplitMasterViewController *masterVC;

@end
