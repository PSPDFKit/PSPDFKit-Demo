//
//  PSPDFViewModeBarButtonItem.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBarButtonItem.h"
#import "PSPDFSegmentedControl.h"

typedef NS_ENUM(NSUInteger, PSPDFViewModeBarButtonStyle) {
    PSPDFViewModeBarButtonStyleToggle, // Show single button that transforms from page to thumbnail. PSPDFKit 3.x. Better fits with iOS7.
    PSPDFViewModeBarButtonStyleSwitch  // Show switch-like control where grid/page is both visible.  PSPDFKit 2.x default
};

/// Offers a way to switch between thumbnail and page mode.
@interface PSPDFViewModeBarButtonItem : PSPDFBarButtonItem

/// Defines the view mode style. Allowed values are `PSPDFViewModeBarButtonStyleSwitch` (default) and `PSPDFViewModeBarButtonStyleToggle`.
@property (nonatomic, assign) PSPDFViewModeBarButtonStyle viewModeStyle;

@end

@interface PSPDFViewModeBarButtonItem (SubclassingHooks)

/// The internally used segment. Only valid for `PSPDFViewModeBarButtonStyleSwitch`.
/// @note The custom subclass `PSPDFSegmentedControl` is used here which allows changing the image on selection.
@property (nonatomic, strong, readonly) PSPDFSegmentedControl *viewModeSegment;

@end
