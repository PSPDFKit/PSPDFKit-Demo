//
//  PSPDFFlexibleAnnotationToolbar.h
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

/**
 The annotation toolbar allows the creation of most annotation types supported by PSPDFKit.
 
 To customize which annotation icons should be displayed, edit `editableAnnotationTypes` in PSPDFDocument.
 
 This class is conceptually similar to `PSPDFAnnotationToolbar`, but since it inherits from `PSPDFFlexibleToolbar` instead of
 `UIToolbar` it features some additional functionality (mainly the ability to drag & drop the toolbar to various positions).
 `PSPDFFlexibleAnnotationToolbar` needs to be used together with a `PSPDFFlexibleToolbarContainerView` just like it's superclass.
 */
@interface PSPDFFlexibleAnnotationToolbar : PSPDFFlexibleToolbar <PSPDFAnnotationStateManagerDelegate>

/// Designated initializer.
- (id)initWithAnnotationStateManager:(PSPDFAnnotationStateManager *)annotationStateManager;

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
/// Groups are defined as dictionaries containing arrays of `editableAnnotationType`-objects, paired with an index indicating the current choice within each array.
/// Annotation types that are defined in the group but are missing in `annotationStateManager.editableAnnotationTypes` will be ignored silently.
/// Use `PSPDFAnnotationGroupKeyChoice` and `PSPDFAnnotationGroupKeyGroup`, define in `PSPDFAnnotationToolbar`, as constants to configure the array.
@property (nonatomic, copy) NSArray *annotationGroups;

/// This will issue a save event after the toolbar has been dismissed.
/// @note Since saving can take some time, this defaults to NO.
@property (nonatomic, assign) BOOL saveAfterToolbarHiding;

@end
