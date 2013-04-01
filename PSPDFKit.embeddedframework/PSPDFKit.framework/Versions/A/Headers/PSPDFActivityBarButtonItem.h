//
//  PSPDFActivityBarButtonItem.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFBarButtonItem.h"

/// Implements the new UIActivityViewController of iOS6 (Twitter/Facebook/etc). (Thus, this button is only available on iOS6)
@interface PSPDFActivityBarButtonItem : PSPDFBarButtonItem

/// Add custom activities.
@property (nonatomic, copy) NSArray *applicationActivities;

/// Excluded activities. Defaults to UIActivityTypeAssignToContact.
@property (nonatomic, copy) NSArray *excludedActivityTypes;

/// The UIActivityViewController will be created during presentAnimated.
@property (nonatomic, strong, readonly) UIActivityViewController *activityController;

@end
