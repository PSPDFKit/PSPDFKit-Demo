//
//  PSPDFAnnotationStyleViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import "PSPDFColorSelectionViewController.h"
#import "PSPDFFontPickerViewController.h"
#import "PSPDFFontStyleViewController.h"
#import "PSPDFStaticTableViewController.h"
#import "PSPDFStyleable.h"

@class PSPDFAnnotationStyleViewController, PSPDFAnnotation;

/// Delegate for `PSPDFAnnotationStyleViewController`.
@protocol PSPDFAnnotationStyleViewControllerDelegate <PSPDFOverridable>

/// Called whenever a style property of `PSPDFAnnotationStyleViewController` changes.
- (void)annotationStyleController:(PSPDFAnnotationStyleViewController *)styleController didChangeProperty:(NSString *)propertyName;

@optional

/// Called when a user starts changing a property (e.g. touch down on the slider)
/// @warning There might not be a call to `didChangeProperty:` if the user doesn't actually change the value (just touches it)
/// @note Will not be fired for all properties.
- (void)annotationStyleController:(PSPDFAnnotationStyleViewController *)styleController willStartChangingProperty:(NSString *)propertyName;

/// Called when a user finishes changing a property (e.g. slider touch up)
/// @note Will not be fired for all properties.
- (void)annotationStyleController:(PSPDFAnnotationStyleViewController *)styleController didEndChangingProperty:(NSString *)propertyName;

@end


/// Allows to set/change the style of an annotation.
/// @note: The inspector currently only supports setting *one* annotation, but since long-term we want multi-select-change, the API has already been prepared for.
@interface PSPDFAnnotationStyleViewController : PSPDFStaticTableViewController <PSPDFColorSelectionViewControllerDelegate, PSPDFFontPickerViewControllerDelegate, PSPDFFontStyleViewControllerDelegate, PSPDFStyleable>

/// Designated initializer.
/// Initialize the controller with one or multiple annotations and the delegate.
- (instancetype)initWithAnnotations:(NSArray *)annotations delegate:(id<PSPDFAnnotationStyleViewControllerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

/// Controller delegate. Informs about begin/end editing a property.
@property (nonatomic, weak, readonly) IBOutlet id<PSPDFAnnotationStyleViewControllerDelegate> delegate;

/// The current selected annotations.
@property (nonatomic, copy) NSArray *annotations;

/// Shows a preview area on top. Defaults to NO.
@property (nonatomic, assign) BOOL showPreviewArea;

/// Returns YES if we can edit this annotation.
+ (BOOL)hasPropertiesForAnnotations:(NSArray *)annotations;

/// @name Customization

/// Customize the inspector globally. Dictionary in format annotation type string : array of arrays of property strings OR a block that returns this and takes `annotations` as argument.
/// @note Setting `properties` to nil will re-set the default properties dictionary.
/// @warning Only set on main thread. Set before the annotation controller is being accessed/opened.
+ (void)setPropertiesForAnnotations:(NSDictionary *)properties;

/**
 Return current dictionary of properties.

 Following properties are currently supported:
 - `color`, `fillColor`, `alpha`
 - `lineWidth`, `lineEnd1`, `lineEnd2`
 - `fontName`, `fontSize`, `textAlignment`, `lineEnd`
 */
+ (NSDictionary *)propertiesForAnnotations;

@end


@interface PSPDFAnnotationStyleViewController (SubclassingHooks)

// Returns the list of properties (arrays of `NSString`) where we want to build cells for.
// @note The arrays can be used to split the properties into different sections.
- (NSArray *)propertiesForAnnotations:(NSArray *)annotations;

// Allows to customize what cell models (`PSPDFCellModel`) we return for `property`.
// You might also return nil here to block a property from being edited.
- (NSArray *)cellModelsForProperty:(NSString *)property;

@end
