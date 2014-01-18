//
//  PSPDFActivityBarButtonItem.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBarButtonItem.h"

/// Pre-Provided UIActivity subclasses.
extern NSString *const PSPDFActivityTypeGoToPage;
extern NSString *const PSPDFActivityTypeSearch;
extern NSString *const PSPDFActivityTypeOutline;
extern NSString *const PSPDFActivityTypeBookmarks;
extern NSString *const PSPDFActivityTypeOpenIn;

/// Shows the `UIActivityViewController` for actions and sharing.
@interface PSPDFActivityBarButtonItem : PSPDFBarButtonItem

/// Add custom activities. (subclasses of `UIActivity` or PSPDFActivityType* strings.)
/// Defaults to `PSPDFActivityTypeOpenIn`.
@property (nonatomic, copy) NSArray *applicationActivities;

/// Excluded activities (strings).
/// Defaults to `UIActivityTypeCopyToPasteboard`, `UIActivityTypeAssignToContact`, `UIActivityTypePostToFacebook`, `UIActivityTypePostToTwitter`, `UIActivityTypePostToWeibo`.
@property (nonatomic, copy) NSArray *excludedActivityTypes;

/// The `UIActivityViewController` will be created during `presentAnimated:`.
@property (nonatomic, strong, readonly) UIActivityViewController *activityController;

@end
