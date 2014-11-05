//
//  PSPDFAnnotationToolbar.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFFlexibleToolbar.h"
#import "PSPDFAnnotationStateManager.h"

@class PSPDFAnnotationToolbar;
@class PSPDFAnnotationGroupItem;
@class PSPDFColorButton;

/**
 The annotation toolbar allows the creation of most annotation types supported by PSPDFKit.

 To customize which annotation icons should be displayed, edit `editableAnnotationTypes` in PSPDFDocument.
 Further appearance customization options are documented in the superclass header (`PSPDFFlexibleToolbar.h`).

 `PSPDFAnnotationToolbar` needs to be used together with a `PSPDFFlexibleToolbarContainerView` just like its superclass `PSPDFFlexibleToolbar`.
 
 @note Directly updating `buttons` will not work. Use `additionalButtons` if you want to add custom buttons.
 */
@interface PSPDFAnnotationToolbar : PSPDFFlexibleToolbar <PSPDFAnnotationStateManagerDelegate>

/// Designated initializer.
- (instancetype)initWithAnnotationStateManager:(PSPDFAnnotationStateManager *)annotationStateManager NS_DESIGNATED_INITIALIZER;

/// Attached annotation state manager.
@property (nonatomic, strong) PSPDFAnnotationStateManager *annotationStateManager;

/// Base PDF view controller. A shortcut for annotationStateManager.pdfController.
@property (nonatomic, weak, readonly) PSPDFViewController *pdfController;

/// Parses the `editableAnnotationTypes` set from the document.
/// Per default this is the contents of the editableAnnotationTypes set in PSPDFDocument.
/// If set to nil, this will load from `pdfController.document.editableAnnotationTypes.allObjects`.
/// KVO observable.
@property (nonatomic, copy) NSOrderedSet *editableAnnotationTypes;

/// Annotations are grouped by default. Set to nil to disable grouping.
/// Groups are defined as an array of `PSPDFAnnotationGroup` objects, which themselves contain `PSPDFAnnotationGroupItem` instances.
/// @note Annotation types that are defined in the group but are missing in `annotationStateManager.editableAnnotationTypes` will be ignored silently.
/// @see PSPDFAnnotationGroup, PSPDFAnnotationGroupItem
@property (nonatomic, copy) NSArray *annotationGroups;

/// Returns `annotationGroups` if set, or implicitly created groups based on `editableAnnotationTypes`.
- (NSArray *)annotationGroupsOrGroupsFromEditableAnnotationTypes;

/// Allows custom `UIButton` objects to be added after the buttons in `annotationGroups`.
/// For best results use `PSPDFFlexibleToolbarButton` objects.
/// Defaults to nil.
@property (nonatomic, copy) NSArray *additionalButtons;

/// @name Behavior

/// This will issue a save event after the toolbar has been dismissed.
/// @note Since saving can take some time, this defaults to NO.
@property (nonatomic, assign) BOOL saveAfterToolbarHiding;

@end

@interface PSPDFAnnotationToolbar (SubclassingHooks)

// Standard toolbar buttons (return nil if you don't want them)
@property (nonatomic, strong, readonly) UIButton *doneButton;
@property (nonatomic, strong, readonly) UIButton *undoButton;
@property (nonatomic, strong, readonly) UIButton *redoButton;
@property (nonatomic, strong, readonly) PSPDFColorButton *strokeColorButton;

// The done action.
- (void)done:(id)sender;

@end
