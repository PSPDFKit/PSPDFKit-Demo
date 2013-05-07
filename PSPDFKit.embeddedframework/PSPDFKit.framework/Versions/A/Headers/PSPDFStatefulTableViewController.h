//
//  PSPDFStatefulTableViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PSPDFStatefulTableViewState) {
    PSPDFStatefulTableViewStateLoading,  // Controller is querying data
    PSPDFStatefulTableViewStateEmpty,    // Controller finished loading, has no data.
    PSPDFStatefulTableViewStateFinished  // Controller has data.
};

/// Shows a message when the controller is empty.
@interface PSPDFStatefulTableViewController : UITableViewController

/// Empty view.
@property (nonatomic, strong) UIView *emptyView;

/// Loading view.
@property (nonatomic, strong) UIView *loadingView;

/// Changes the controller state and shows/hides the emptyView/loadingView depending on the state.
@property (nonatomic, assign) PSPDFStatefulTableViewState controllerState;

@end


// Preconfigured label subclass that optionally shows an activity indicator.
@interface PSPDFGrayBackgroundLabel : UILabel

// Convenience constructor.
+ (instancetype)labelWithText:(NSString *)text showActivity:(BOOL)showActivity;

// Enable spinning wheel next to text.
@property (nonatomic, assign) BOOL showActivity;

@end
