//
//  PSPDFStatefulTableViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBaseTableViewController.h"

typedef NS_ENUM(NSUInteger, PSPDFStatefulTableViewState) {
    PSPDFStatefulTableViewStateLoading,  // Controller is querying data
    PSPDFStatefulTableViewStateEmpty,    // Controller finished loading, has no data.
    PSPDFStatefulTableViewStateFinished  // Controller has data.
};

/// Shows a message when the controller is empty.
@interface PSPDFStatefulTableViewController : PSPDFBaseTableViewController

/// Empty view.
@property (nonatomic, strong) UIView *emptyView;

/// Loading view.
@property (nonatomic, strong) UIView *loadingView;

/// Changes the controller state and shows/hides the emptyView/loadingView depending on the state.
@property (nonatomic, assign) PSPDFStatefulTableViewState controllerState;

@end
