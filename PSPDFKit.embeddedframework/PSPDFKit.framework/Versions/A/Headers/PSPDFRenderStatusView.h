//
//  PSPDFRenderStatusView.h
//  PSPDFKit
//
//  Copyright 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

/// The render status view is used within PSPDFPageView to show a progress indicator while we render the PDF.
@interface PSPDFRenderStatusView : UIView

/// The internally used activity indicator.
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@interface PSPDFRenderStatusView (SubclassingHooks)

// Sets the activity indicator. Override to disable/replace with your own class.
- (void)loadActivityIndicator;

@end
