//
//  PSPDFOutlineBarButtonItem.h
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

typedef NS_ENUM(NSUInteger, PSPDFOutlineBarButtonItemOption) {
    PSPDFOutlineBarButtonItemOptionOutline,     // The outline (Table of Contents) controller.
    PSPDFOutlineBarButtonItemOptionBookmarks,   // Bookmark list controller.
    PSPDFOutlineBarButtonItemOptionAnnotations, // Annotation list controller. PSPDFKit Annotate only.
};

/// The outline button shows a controller that can be a container for several different controllers, like outline, bookmark or annotation list.
@interface PSPDFOutlineBarButtonItem : PSPDFBarButtonItem

/// Some PSPDFBarButtonItem are designed for performance, they will perform check on a background thread and update later.
/// The evaluation IF we can actually show a outline is done async, so initially isAvailable will be YES always.
/// Use this blocking check to make a synchronous check for the availability.
/// @note If `availableControllerOptions` contains anything else than just `PSPDFOutlineBarButtonItemOptionOutline` this will always return YES.
- (BOOL)isAvailableBlocking;

/// Choose the controller type.
/// Defaults to PSPDFOutlineBarButtonItemOptionOutline, PSPDFOutlineBarButtonItemOptionBookmarks, PSPDFOutlineBarButtonItemOptionAnnotations.
/// @note Change this before the controller is being displayed.
@property (nonatomic, copy) NSOrderedSet *availableControllerOptions;

/// Called after a controller has been created. Set a block to allow custom modifications.
@property (nonatomic, copy) void (^didCreateControllerBlock)(UIViewController *controller, PSPDFOutlineBarButtonItemOption option);

@end

@interface PSPDFOutlineBarButtonItem (SubclassingHooks)

// Subclass both to allow adding/customizing controllers.
- (NSString *)titleForOption:(PSPDFOutlineBarButtonItemOption)option;

- (UIViewController *)controllerForOption:(PSPDFOutlineBarButtonItemOption)option;

@end
