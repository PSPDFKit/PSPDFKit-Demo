//
//  PSCSearchContainerChildPDFViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCSearchContainerChildPDFViewController.h"

@implementation PSCSearchContainerChildPDFViewController

- (UIView *)inlineSearchManagerContainerView:(PSPDFInlineSearchManager *)manager {
    // We want to display search UI over parent view controller's navigation controller.
    UIView *containerView = self.parentViewController.navigationController.view;
    // Fallback to default behavior if something went wrong.
    if (!containerView) {
        containerView = [super inlineSearchManagerContainerView:manager];
    }
    return containerView;
}

@end
