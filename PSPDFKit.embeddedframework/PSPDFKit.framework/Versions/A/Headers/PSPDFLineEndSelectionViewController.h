//
//  PSPDFLineEndSelectionViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>
#import "PSPDFStaticTableViewController.h"
#import "PSPDFAnnotation.h"
#import "PSPDFLineHelper.h"

@protocol PSPDFLineEndSelectionViewControllerDelegate;
@class PSPDFLineEndSelectionViewController;

/// Line end selection controller.
@interface PSPDFLineEndSelectionViewController : PSPDFStaticTableViewController

/// Show the line end picker.
/// `context` can be used to store additional context that gets sent to the delegates.
- (PSPDFLineEndSelectionViewController *)initWithTitle:(NSString *)title annotation:(PSPDFAnnotation *)annotation isStart:(BOOL)isStart delegate:(id<PSPDFLineEndSelectionViewControllerDelegate>)delegate context:(void *)context;

/// Action delegate.
@property (nonatomic, weak) IBOutlet id<PSPDFLineEndSelectionViewControllerDelegate> delegate;

@end

/// Line end picker delegate.
@protocol PSPDFLineEndSelectionViewControllerDelegate <NSObject>

@required

/// Asks for the currently selected line end.
- (PSPDFLineEndType)lineEndSelectionControllerSelectedLineEnd:(UIViewController *)controller isStart:(BOOL)isStart context:(void *)context;

/// Sent when a line end has been selected.
- (void)lineEndSelectionController:(UIViewController *)controller didSelectLineEnd:(PSPDFLineEndType)lineEnd isStart:(BOOL)isStart context:(void *)context;

@end
