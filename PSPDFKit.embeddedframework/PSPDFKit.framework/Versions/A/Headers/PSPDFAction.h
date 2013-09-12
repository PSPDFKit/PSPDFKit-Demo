//
//  PSPDFAction.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFModel.h"
#import "PSPDFJSONAdapter.h"

typedef NS_ENUM(UInt8, PSPDFActionType) {
    PSPDFActionTypeURL,
    PSPDFActionTypeGoTo,
    PSPDFActionTypeRemoteGoTo,
    PSPDFActionTypeNamed,
    PSPDFActionTypeLaunch,
    PSPDFActionTypeJavaScript,
    PSPDFActionTypeRendition,
    PSPDFActionTypeRichMediaExecute, // See Adobe® Supplement to the ISO 32000, Page 40ff.
    PSPDFActionTypeSubmitForm,
    PSPDFActionTypeResetForm,

    // Unimplemented actions
    PSPDFActionTypeSound,
    PSPDFActionTypeMovie,
    PSPDFActionTypeHide,   // Implemented
    PSPDFActionTypeThread,
    PSPDFActionTypeImportData,
    PSPDFActionTypeSetOCGState,
    PSPDFActionTypeTrans,
    PSPDFActionTypeGoTo3DView,
    PSPDFActionTypeGoToEmbedded,

    PSPDFActionTypeUnknown = UINT8_MAX
};

@class PSPDFDocumentProvider;

// Set to @YES in the options dictionary to make links modal.
extern NSString *const PSPDFActionOptionModal;

// Constant to convert PSPDFActionType into NSString and back.
extern NSString *const PSPDFActionTypeTransformerName;

/// Defines an action that is defined in the PDF spec, either from an outline or an annotation object.
/// See the Adobe PDF Specification for more about actions and action types.
/// @note The PDF spec defines both 'destinations' and 'actions'. PSPDFKit will convert a 'destination' into an equivalent PSPDFActionTypeGoTo.
@interface PSPDFAction : PSPDFModel <PSPDFJSONSerializing>

/// @name Initialization

/// Return the class responsible for `actionType`.
+ (Class)actionClassForType:(PSPDFActionType)actionType;

/// Init for subclasses.
- (id)initWithType:(PSPDFActionType)actionType;

/// @name Properties

/// The PDF action type.
@property (nonatomic, assign, readonly) PSPDFActionType type;

/// PDF actions can be chained together. Defines the next action.
@property (atomic, strong) PSPDFAction *nextAction;

/// If the action contained a pspdfkit:// URL, options between the URL will be parsed and extracted as key/value.
/// Can also be used for generic key/value storage (but remember that PSPDFActions usually are regenerated when using any of the convenience setters)
/// Will be persisted externally but not within PDF documents.
@property (atomic, copy) NSDictionary *options;

/// Returns the most appropriate description (Like "Page 3" or "http://google.com")
- (NSString *)localizedDescription;

@end
