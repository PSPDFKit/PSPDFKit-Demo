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

@class PSPDFFlexibleAnnotationToolbar;
@class PSPDFAnnotationGroupItem;

extern NSString * const PSPDFAnnotationStringInkVariantPen;
extern NSString * const PSPDFAnnotationStringInkVariantHighlighter;

typedef UIImage *(^PSPDFAnnotationGroupItemConfigurationBlock)(PSPDFAnnotationGroupItem *item, PSPDFFlexibleAnnotationToolbar *toolbar);

/**
 The annotation toolbar allows the creation of most annotation types supported by PSPDFKit.
 
 To customize which annotation icons should be displayed, edit `editableAnnotationTypes` in PSPDFDocument.
 Further appearance customization options are documented in the superclass header (`PSPDFFlexibleToolbar.h`).
 
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
/// Groups are defined as an array of `PSPDFAnnotationGroup` objects, which themselves contain `PSPDFAnnotationGroupItem` instances.
/// @note Annotation types that are defined in the group but are missing in `annotationStateManager.editableAnnotationTypes` will be ignored silently.
/// @see PSPDFAnnotationGroup, PSPDFAnnotationGroupItem
@property (nonatomic, copy) NSArray *annotationGroups;

/// Allows custom `UIButton` objects to be added after the buttons in `annotationGroups`.
/// For best results use `PSPDFFlexibleToolbarButton` objects.
/// Defaults to nil.
@property (nonatomic, copy) NSArray *additionalButtons;

/// @name Behavior

/// This will issue a save event after the toolbar has been dismissed.
/// @note Since saving can take some time, this defaults to NO.
@property (nonatomic, assign) BOOL saveAfterToolbarHiding;

@end

@interface PSPDFAnnotationGroup : NSObject

/// Creates a new annotation group with the provided items and designates the first item as the current choice.
/// @see groupWithItems:choice:
+ (instancetype)groupWithItems:(NSArray *)items;

/// Creates a new annotation group with the provided items and designates the item at index `choice` as the current selection.
+ (instancetype)groupWithItems:(NSArray *)items choice:(NSUInteger)choice;

@end

@interface PSPDFAnnotationGroupItem : NSObject

/// Creates a group item with the specified annotation type.
/// @see itemWithType:variant:configurationBlock:
+ (instancetype)itemWithType:(NSString *)type;

/// Creates a group item with the specified annotation type and optional variant identifier.
/// @see itemWithType:variant:configurationBlock:
+ (instancetype)itemWithType:(NSString *)type variant:(NSString *)variant;

/// Creates a group item with the specified annotation type, an optional variant identifier and configuration block.
/// @param type The annotation type. See `PSPDFAnnotation.h` for a list of valid types.
/// @param variant An optional string identifier for the item variant. Use variants to add several instances of the same tool with uniquely preservable annotation style settings.
/// @param block An option block, that should return the button's image. Defaults to a block that configures an preset image based on the annotation type, if set to nil.
+ (instancetype)itemWithType:(NSString *)type variant:(NSString *)variant configurationBlock:(PSPDFAnnotationGroupItemConfigurationBlock)block;

@end

@interface PSPDFFlexibleAnnotationToolbar (SubclassingHooks)

- (UIButton *)doneButton;
- (UIButton *)undoButton;
- (UIButton *)redoButton;

// The done action.
- (void)done:(id)sender;

@end
