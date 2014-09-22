//
//  PSPDFAnnotationGroup.h
//  PSPDFKit
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

/**
 Used to configure custom annotation groups for the annotation toolbar.

 @code
 toolbar.annotationGroups = @[

 [PSPDFAnnotationGroup groupWithItems:@[
 [PSPDFAnnotationGroupItem itemWithType:PSPDFAnnotationStringInk variant:PSPDFAnnotationStringInkVariantPen
 configurationBlock:[PSPDFAnnotationGroupItem inkConfigurationBlock]]]],

 [PSPDFAnnotationGroup groupWithItems:@[
 [PSPDFAnnotationGroupItem itemWithType:PSPDFAnnotationStringLine],
 [PSPDFAnnotationGroupItem itemWithType:PSPDFAnnotationStringPolyLine]]]
 ];
 @endcode
 */
@interface PSPDFAnnotationGroup : NSObject

/// Creates a new annotation group with the provided items and designates the first item as the current choice.
/// @see groupWithItems:choice:
+ (instancetype)groupWithItems:(NSArray *)items;

/// Creates a new annotation group with the provided items and designates the item at index `choice` as the current selection.
+ (instancetype)groupWithItems:(NSArray *)items choice:(NSUInteger)choice;

@property (nonatomic, assign, readonly) NSUInteger choice;
@property (nonatomic, copy, readonly) NSArray *items;

@end
