//
//  PSPDFAnnotation.h
//  PSPDFKit
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFModel.h"
#import "PSPDFUndoProtocol.h"
#import "PSPDFJSONAdapter.h"

@class PSPDFDocument, PSPDFDocumentProvider;

// List of available annotation types. Set in the editableAnnotationTypes set of PSPDFDocument.
extern NSString *const PSPDFAnnotationStringLink;
extern NSString *const PSPDFAnnotationStringHighlight;
extern NSString *const PSPDFAnnotationStringUnderline;
extern NSString *const PSPDFAnnotationStringStrikeOut;
extern NSString *const PSPDFAnnotationStringSquiggly;
extern NSString *const PSPDFAnnotationStringNote;
extern NSString *const PSPDFAnnotationStringFreeText;
extern NSString *const PSPDFAnnotationStringInk;
extern NSString *const PSPDFAnnotationStringSquare;
extern NSString *const PSPDFAnnotationStringCircle;
extern NSString *const PSPDFAnnotationStringLine;
extern NSString *const PSPDFAnnotationStringPolygon;
extern NSString *const PSPDFAnnotationStringPolyLine;
extern NSString *const PSPDFAnnotationStringSignature;  // Signature is an `PSPDFAnnotationStringInk` annotation.
extern NSString *const PSPDFAnnotationStringStamp;

// Sound annotations can be played back and recorded by default, but playback and recording will not work when the host app is in the background. If you want to enable background playback and recording, you'll need to add the "audio" entry to the "UIBackgroundModes" array in the app's Info.plist. If you do not add this, then recording will be stopped and playback will be silenced when your app is sent into the background.
extern NSString *const PSPDFAnnotationStringSound;

// UIImagePickerController used in the image add feature will throw a UIApplicationInvalidInterfaceOrientation exception if your app does not include portrait in UISupportedInterfaceOrientations (Info.plist). For landscape only apps, we suggest enabling portrait orientation(s) in your Info.plist and rejecting these in UIViewController's auto-rotation methods. This way, you can be landscape only for your view controllers and still be able to use UIImagePickerController.
extern NSString *const PSPDFAnnotationStringImage;      // Image is a `PSPDFAnnotationStringStamp` annotation.

// Non-writable annotation types:
extern NSString *const PSPDFAnnotationStringWidget;     // Widget is currently handled similar to Link.
extern NSString *const PSPDFAnnotationStringFile;
extern NSString *const PSPDFAnnotationStringRichMedia;
extern NSString *const PSPDFAnnotationStringScreen;
extern NSString *const PSPDFAnnotationStringCaret;      // There's no menu entry for Caret yet.
extern NSString *const PSPDFAnnotationStringPopup;      // Placeholder. Not yet supported.
extern NSString *const PSPDFAnnotationStringTextFieldFormElement;
extern NSString *const PSPDFAnnotationStringButtonFormElement;
extern NSString *const PSPDFAnnotationStringChoiceFormElement;
extern NSString *const PSPDFAnnotationStringSignatureFormElement;

// Annotations types
typedef NS_OPTIONS(NSUInteger, PSPDFAnnotationType) {
    PSPDFAnnotationTypeNone        = 0,
    PSPDFAnnotationTypeUndefined   = 1 << 0,  // Any annotation whose type couldn't be recognized.
    PSPDFAnnotationTypeLink        = 1 << 1,  // Links and PSPDFKit multimedia extensions.
    PSPDFAnnotationTypeHighlight   = 1 << 2,
    PSPDFAnnotationTypeStrikeOut   = 1 << 17,
    PSPDFAnnotationTypeUnderline   = 1 << 18,
    PSPDFAnnotationTypeSquiggly    = 1 << 19,
    PSPDFAnnotationTypeFreeText    = 1 << 3,
    PSPDFAnnotationTypeInk         = 1 << 4,  // Ink (includes Signatures)
    PSPDFAnnotationTypeSquare      = 1 << 5,
    PSPDFAnnotationTypeCircle      = 1 << 20,
    PSPDFAnnotationTypeLine        = 1 << 6,
    PSPDFAnnotationTypeNote        = 1 << 7,
    PSPDFAnnotationTypeStamp       = 1 << 8,  // A stamp can be an image as well.
    PSPDFAnnotationTypeCaret       = 1 << 9,
    PSPDFAnnotationTypeRichMedia   = 1 << 10, // Embedded PDF video
    PSPDFAnnotationTypeScreen      = 1 << 11, // Embedded PDF video
    PSPDFAnnotationTypeWidget      = 1 << 12, // Widget (includes special links all form types)
    PSPDFAnnotationTypeFile        = 1 << 13, // FileAttachment
    PSPDFAnnotationTypeSound       = 1 << 14,
    PSPDFAnnotationTypePolygon     = 1 << 15,
    PSPDFAnnotationTypePolyLine    = 1 << 16,
    PSPDFAnnotationTypePopup       = 1 << 21, // Not yet supported.
    PSPDFAnnotationTypeAll         = NSUIntegerMax
};

// Mask for all text markup types.
// PSPDFAnnotationTypeHighlight|PSPDFAnnotationTypeStrikeOut|PSPDFAnnotationTypeUnderline|PSPDFAnnotationTypeSquiggly
extern const PSPDFAnnotationType PSPDFAnnotationTypeTextMarkup;

// Converts an annotation type into the string representation and back.
extern NSString *PSPDFStringFromAnnotationType(PSPDFAnnotationType annotationType);
extern PSPDFAnnotationType PSPDFAnnotationTypeFromString(NSString *string);

// Annotation border style. PSPDFKit currently only supports Solid and Dashed.
typedef NS_ENUM(NSUInteger, PSPDFAnnotationBorderStyle) {
    PSPDFAnnotationBorderStyleNone,
    PSPDFAnnotationBorderStyleSolid,
    PSPDFAnnotationBorderStyleDashed,    // Not yet supported.
    PSPDFAnnotationBorderStyleBelved,    // Not yet supported.
    PSPDFAnnotationBorderStyleInset,     // Not yet supported.
    PSPDFAnnotationBorderStyleUnderline, // Not yet supported.
    PSPDFAnnotationBorderStyleUnknown
};

// A set of flags specifying various characteristics of the annotation.
// PSPDFKit doesn't yet support all of those flag settings (this might change in future releases)
typedef NS_OPTIONS(NSUInteger, PSPDFAnnotationFlags) {
    PSPDFAnnotationFlagInvisible      = 1 << 0, // If set, ignore annotation AP stream if there is no handler available.
    PSPDFAnnotationFlagHidden         = 1 << 1, // If set, do not display or print the annotation or allow it to interact with the user.
    PSPDFAnnotationFlagPrint          = 1 << 2, // [IGNORED] If set, print the annotation when the page is printed. Default value.
    PSPDFAnnotationFlagNoZoom         = 1 << 3, // [IGNORED] If set, don't scale the annotation’s appearance to match the magnification of the page.
    PSPDFAnnotationFlagNoRotate       = 1 << 4, // [IGNORED] If set, don't rotate the annotation’s appearance to match the rotation of the page.
    PSPDFAnnotationFlagNoView         = 1 << 5, // [IGNORED] If set, don't display the annotation on the screen. (But printing might be allowed)
    PSPDFAnnotationFlagReadOnly       = 1 << 6, // [IGNORED] If set, don't allow the annotation to interact with the user. Ignored for Widget.
    PSPDFAnnotationFlagLocked         = 1 << 7, // [IGNORED] If set, don't allow the annotation to be deleted or properties modified (except contents)
    PSPDFAnnotationFlagToggleNoView   = 1 << 8, // [IGNORED] If set, invert the interpretation of the NoView flag for certain events.
    PSPDFAnnotationFlagLockedContents = 1 << 9, // [IGNORED] If set, don't allow the contents of the annotation to be modified by the user.
};

// See PDF Reference 1.7, 423ff. PSPDFKit currently only supports the MouseDown event.
typedef NS_ENUM(UInt8, PSPDFAnnotationTriggerEvent) {
    PSPDFAnnotationTriggerEventCursorEnters,  // E
    PSPDFAnnotationTriggerEventCursorExits,   // X
    PSPDFAnnotationTriggerEventMouseDown,     // D
    PSPDFAnnotationTriggerEventMouseUp,       // U
    PSPDFAnnotationTriggerEventReceiveFocus,  // Fo
    PSPDFAnnotationTriggerEventLooseFocus,    // Bl
    PSPDFAnnotationTriggerEventPageOpened,    // PO
    PSPDFAnnotationTriggerEventPageClosed,    // PC
    PSPDFAnnotationTriggerEventPageVisible,   // PV
    PSPDFAnnotationTriggerEventPageInvisible, // PI
};

/**
 Defines a PDF annotation.

 PSPDFAnnotationManager searches the runtime for subclasses of PSPDFAnnotation and builds up a dictionary using supportedTypes.

 Don't directly make an instance of this class, use subclasses like PSPDFNoteAnnotations or PSPDFLinkAnnotations. This class will return nil if initialized directly, unless with the type PSPDFAnnotationTypeUndefined.

 Subclasses need to implement - (id)initWithAnnotationDictionary:(CGPDFDictionaryRef)annotationDictionary inAnnotsArray:(CGPDFArrayRef)annotsArray.

 Ensure that custom subclasses also correctly implement hash and isEqual.

 Annotation objects should only ever be edited on ONE thread. Modify properties on the main thread only if they are already active (for creation, it doesn't matter which thread creates them). Before rendering, obtain a copy of the annotation to ensure it's not mutated while properties are read.
*/
@interface PSPDFAnnotation : PSPDFModel <PSPDFUndoProtocol, PSPDFJSONSerializing>

/// Returns the annotation type strings that are supported. Implemented in each subclass.
+ (NSArray *)supportedTypes;

/// Converts JSON representation back into PSPDFAnnotation-subclasses.
/// Will return nil for invalid JSON or not recognized types.
/// `document` is optional and if given the override dictionary will be honored (to return your custom PSPDFAnnotation* subclasses)
+ (PSPDFAnnotation *)annotationFromJSONDictionary:(NSDictionary *)JSONDictionary document:(PSPDFDocument *)document error:(NSError **)error;

/// Returns YES if PSPDFKit has support to write this annotation type back into the PDF.
+ (BOOL)isWriteable;

/// Returns YES if this annotation type is moveable.
- (BOOL)isMovable;

/// Returns YES if this annotation type is resizable (all but note annotations usually are).
- (BOOL)isResizable;

/// Returns YES if the annotation should maintain its aspect ratio when resized. Defaults to NO
/// for most annotations, except for the PSPDFStampAnnotation.
- (BOOL)shouldMaintainAspectRatio;

/// Returns the minimum size that an annotation can properly display. Defaults to (32.0, 32.0).
- (CGSize)minimumSize;

/// Use this to create custom user annotations.
- (id)initWithType:(PSPDFAnnotationType)annotationType;

/// Check if point is inside annotation area.
- (BOOL)hitTest:(CGPoint)point;

/// Calculates the exact annotation position in the current page.
- (CGRect)boundingBoxForPageRect:(CGRect)pageRect;

/**
 Draw current annotation in context.
 Coordinates here are in PDF coordinate space.

 Use PSPDFConvertViewRectToPDFRect to convert your coordinates accordingly.
 (For performance considerations, you want to do this once, not every time drawInContext is called)

 This draws the annotation border.
 Some annotations handle borders differently, so decide in your subclass if you call [super drawInContext] or not.
 */
- (void)drawInContext:(CGContextRef)context;

// Options to use for drawInContext:withOptions:
extern NSString *const PSPDFAnnotationDrawFlattened;

/// Allows to customize the drawing process.
/// Currently used to allow different annotation drawings during the annotation flattening process.
- (void)drawInContext:(CGContextRef)context withOptions:(NSDictionary *)options;

extern NSString *const PSPDFAnnotationDrawCentered; // CGFloat, draw in the middle of the image, if size has a different aspect ratio.
extern NSString *const PSPDFAnnotationMargin;       // UIEdgeInsets.

/// Renders annotation into an image.
- (UIImage *)imageWithSize:(CGSize)size withOptions:(NSDictionary *)options;

/// Current annotation type.
@property (nonatomic, assign, readonly) PSPDFAnnotationType type;

/// If YES, the annotation will be rendered as a overlay. If NO, it will be statically rendered within the PDF content image.
/// PSPDFAnnotationTypeLink and PSPDFAnnotationTypeNote currently are rendered as overlay.
/// If overlay is set to YES, you must also register the corresponding *annotationView class to render (override PSPDFAnnotationManager's defaultAnnotationViewClassForAnnotation)
@property (nonatomic, assign, getter=isOverlay) BOOL overlay;

/// Per default, annotations are editable when isWriteable returns YES.
/// Override this to lock certain annotations (menu won't be shown)
@property (nonatomic, assign, getter=isEditable) BOOL editable;

/// Annotation type string as defined in the PDF.
/// Usually read from the annotDict. Don't change this unless you know what you're doing.
@property (nonatomic, copy) NSString *typeString;

/// Alpha value of the annotation color.
@property (nonatomic, assign) CGFloat alpha;

/// Color associated with the annotation or nil if there is no color.
/// Note: use .alpha for transparency, not the alpha value in color.
@property (nonatomic, strong) UIColor *color;

/// Color with added alpha value.
@property (nonatomic, strong, readonly) UIColor *colorWithAlpha;

/**
 Fill color. Only used for certain annotation types. ("IC" key, e.g. Shape Annotations)

 FillColor might be nil - treat like clearColor in that case.
 FillColor will *share* the alpha value set in the .alpha property, and will ignore any custom alpha value set here.

 Note: Apple Preview.app will not show you transparency in the fillColor. (tested under 10.8.2)
 */
@property (nonatomic, strong) UIColor *fillColor;

/// FillColor with added alpha value.
@property (nonatomic, strong, readonly) UIColor *fillColorWithAlpha;

/// Optional. Various annotation types may contain text.
@property (nonatomic, copy) NSString *contents;

/// (Optional; inheritable) The field’s value, whose format varies depending on the field type. See the descriptions of individual field types for further information.
@property (nonatomic, copy) id value;

/// Annotation flags.
@property (nonatomic, assign) NSUInteger flags;

/// The annotation name, a text string uniquely identifying it among all the annotations on its page.
/// (Optional; PDF1.4, "NM" key)
@property (nonatomic, copy) NSString *name;

/// Annotation group key. Allows to have multiple annotations that behave as single one, if their `group` string is equal. Only works within one page.
/// This is a proprietary extension and saved into the PDF as "PSPDF:GROUP" key.
@property (nonatomic, copy) NSString *group;

/// Date where the annotation was last modified.
/// Saved into the PDF as the "M" property (Optional, since PDF 1.1)
/// Will be updated by PSPDFKit as soon as a property is changed.
@property (nonatomic, strong) NSDate *lastModified;

/// Date when the annotation was created. Might be nil.
/// PSPDFKit will set this for newly created annotations.
@property (nonatomic, strong) NSDate *creationDate;

/// Border Line Width (only used in certain annotations)
@property (nonatomic, assign) CGFloat lineWidth;

/// Annotation border style.
@property (nonatomic, assign) PSPDFAnnotationBorderStyle borderStyle;

/// If borderStyle is set to PSPDFAnnotationBorderStyleDashed, we expect a dashStyle array here (int-values)
@property (nonatomic, copy) NSArray *dashArray;

/// Annotation may already be deleted locally, but not written back.
@property (nonatomic, assign, getter=isDeleted) BOOL deleted;

/// Rectangle of specific annotation. (PDF coordinates)
@property (nonatomic, assign) CGRect boundingBox;

/// Rotation property (should be a multiple of 90, but there are exceptions, e.g. for stamp annotations)
/// Defaults to 0. Allowed values are between 0 and 360.
@property (nonatomic, assign) NSUInteger rotation;

/// Certain annotation types like highlight can have multiple rects.
@property (nonatomic, copy) NSArray *rects;

/// Line, Polyline and Polygon annotations have points.
@property (nonatomic, copy) NSArray *points;

/// User (title) flag. ("T" property)
@property (nonatomic, copy) NSString *user;

/// Page for current annotation. Page is relative to the documentProvider.
/// @warning Only set the page at creation time and don't change it later on. This would break internal caching. If you want to move an annotations to a different page, copy an annotation, add it again and then delete the original.
@property (atomic, assign) NSUInteger page;

/// Page relative to the document.
/// @note Will be calculated each time from `page` and the current `documentProvider` and will change `page` if set.
@property (nonatomic, assign) NSUInteger absolutePage;

/// If this annotation isn't backed by the PDF, it's dirty by default.
/// After the annotation has been written to the file, this will be reset until the annotation has been changed.
@property (nonatomic, assign, getter=isDirty) BOOL dirty;

/// Corresponding documentProvider.
@property (nonatomic, weak) PSPDFDocumentProvider *documentProvider;

/// Document is inferred from the documentProvider.
@property (nonatomic, assign, readonly) PSPDFDocument *document;

/**
 Returns YES if a custom appearance stream is attached to this annotation.

 An appearance stream is a custom representation for annotations, much like a PDF within a PDF. PSPDFKit has only very limited support for appearance streams, currently only for stamp/ink annotations and that only under certain conditions.
 */
@property (nonatomic, assign, readonly) BOOL hasAppearanceStream;

/// If indexOnPage is set, it's a native PDF annotation.
/// If this is -1, it's not yet saved in the PDF.
@property (atomic, readonly) NSInteger indexOnPage;

/// Allows to save arbitrary data (e.g. a CoreData Object ID)
/// Will be preserved within app sessions and copy, but NOT serialized to disk or within the PDF.
@property (atomic, copy) NSDictionary *userInfo;

/// Subject property (corresponding to "Subj" key).
@property (nonatomic, copy) NSString *subject;

/// Dictionary for additional action types.
@property (nonatomic, copy) NSDictionary *additionalActions;

/// Returns self.contents or something appropriate per annotation type to describe the object.
- (NSString *)localizedDescription;

/// Return icon for the annotation, if there's one defined.
- (UIImage *)annotationIcon;

/// Compare.
- (BOOL)isEqualToAnnotation:(PSPDFAnnotation *)otherAnnotation;

/// Copy to UIPasteboard.
- (void)copyToClipboard;

extern NSString * const PSPDFBorderStyleTransformerName;

@end

// Support v2 format. If you're using NSKeyedArchiver manually, call this to allow v2 archives to open.
extern void PSPDFAnnotationSupportLegacyFormat(NSKeyedUnarchiver *unarchiver);
// After you loaded your v2 annotation array, call this method to migrate to the v3 format.
extern NSArray *PSPDFPostprocessAnnotationInLegacyFormat(NSArray *annotations);

