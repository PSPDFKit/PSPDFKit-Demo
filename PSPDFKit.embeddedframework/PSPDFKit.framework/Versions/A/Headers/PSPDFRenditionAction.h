//
//  PSPDFRenditionAction.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAction.h"

@class PSPDFScreenAnnotation;

typedef NS_ENUM(NSUInteger, PSPDFRenditionActionType) {
    PSPDFRenditionActionTypePlayStop,
    PSPDFRenditionActionTypeStop,
    PSPDFRenditionActionTypePause,
    PSPDFRenditionActionTypeResume,
    PSPDFRenditionActionTypePlay,
};

/// A rendition action (PDF 1.5) controls the playing of multimedia content (see PDF Reference 1.7, 13.2, “Multimedia”).
/// @note JavaScript actions are not supported.
@interface PSPDFRenditionAction : PSPDFAction

/// Designated initializer.
- (id)initWithOperation:(PSPDFRenditionActionType)operation annotation:(PSPDFScreenAnnotation *)annotation;

/// The rendition action operation.
@property (nonatomic, assign, readonly) PSPDFRenditionActionType operation;

/// The associated screen annotation. Optional. Will link to an already existing annotation.
@property (nonatomic, weak, readonly) PSPDFScreenAnnotation *annotation;

@end
