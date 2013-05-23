//
//  PSPDFActivityBarButtonItem.h
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

/// Implements the new UIActivityViewController of iOS6 (Twitter/Facebook/etc). (Thus, this button is only available on iOS6)
@interface PSPDFActivityBarButtonItem : PSPDFBarButtonItem

/// Add custom activities.
@property (nonatomic, copy) NSArray *applicationActivities;

/// Excluded activities. Defaults to UIActivityTypeAssignToContact.
@property (nonatomic, copy) NSArray *excludedActivityTypes;

/// The UIActivityViewController will be created during presentAnimated.
@property (nonatomic, strong, readonly) UIActivityViewController *activityController;

@end
