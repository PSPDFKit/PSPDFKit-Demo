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

typedef NS_ENUM(UInt8, PSPDFActionType) {
    PSPDFActionTypeURL,
    PSPDFActionTypeGoTo,
    PSPDFActionTypeRemoteGoTo,
    PSPDFActionTypeNamed,
    PSPDFActionTypeLaunch,
    PSPDFActionTypeJavaScript,
    PSPDFActionTypeRendition,
    PSPDFActionTypeRichMediaExecute // See Adobe® Supplement to the ISO 32000, Page 40ff
};

@class PSPDFDocumentProvider;

// Is inside the option dictionary if a pspdfkit:// URL has been detected.
extern NSString *const kPSPDFActionIsPSPDFPrefixedURL;
extern NSString *const kPSPDFActionURLProcessed;
extern NSString *const kPSPDFActionOptionModal;

/// Defines an action that is defined in the PDF spec, either from an outline or an annotation object.
/// See the Adobe PDF Specification for more about actions and action types.
/// @note The PDF spec defines both 'destinations' and 'actions'. PSPDFKit will convert a 'destination' into an equivalent PSPDFActionTypeGoTo.
@interface PSPDFAction : PSPDFModel

/// @name Initialization

/// Parses a PDF dictionary and creates the action object.
/// `pageCache` can be nil but will speed up page resolving under certain conditions.
/// @return Will return the appropriate subclass of PSPDFAction or nil if action couldn't be resolved.
+ (instancetype)actionWithPDFDictionary:(CGPDFDictionaryRef)actionDictionary documentRef:(CGPDFDocumentRef)documentRef pageCache:(CFMutableDictionaryRef)pageCache;

/// Init for subclasses.
- (id)initWithType:(PSPDFActionType)type;

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


@interface PSPDFAction (PageResolving)

/// Static helper, resolves named destination entries, returns dict with name -> page NSNumber
+ (NSDictionary *)resolveDestNames:(NSSet *)destNames documentRef:(CGPDFDocumentRef)documentRef;

@end
