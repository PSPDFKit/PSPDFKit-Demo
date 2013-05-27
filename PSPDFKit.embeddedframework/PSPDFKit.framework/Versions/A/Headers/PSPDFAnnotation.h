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

@class PSPDFDocument, PSPDFDocumentProvider;

/// List of editable annotation types.
/// Set those constants in the editableAnnotationTypes set of PSPDFDocument.
extern NSString *const PSPDFAnnotationTypeStringLink;
extern NSString *const PSPDFAnnotationTypeStringHighlight;
extern NSString *const PSPDFAnnotationTypeStringUnderline;
extern NSString *const PSPDFAnnotationTypeStringStrikeout;
extern NSString *const PSPDFAnnotationTypeStringNote;
extern NSString *const PSPDFAnnotationTypeStringFreeText;
extern NSString *const PSPDFAnnotationTypeStringInk;
extern NSString *const PSPDFAnnotationTypeStringSquare;
extern NSString *const PSPDFAnnotationTypeStringCircle;
extern NSString *const PSPDFAnnotationTypeStringLine;
extern NSString *const PSPDFAnnotationTypeStringSignature;  // Signature is an image annotation.
extern NSString *const PSPDFAnnotationTypeStringStamp;
extern NSString *const PSPDFAnnotationTypeStringCaret; // There's no menu entry for Caret yet.
extern NSString *const PSPDFAnnotationTypeStringWidget; // Widget is currently handled similar to Link.
extern NSString *const PSPDFAnnotationTypeStringFile;
extern NSString *const PSPDFAnnotationTypeStringSound;
extern NSString *const PSPDFAnnotationTypeStringPolygon;
extern NSString *const PSPDFAnnotationTypeStringPolyLine;

// Sent when a new annotation is added to the default PSPDFFileAnnotationProvider.
// Will also be sent if an annotation is added because a editable copy is created.
extern NSString *const PSPDFAnnotationAddedNotification;  // object = new PSPDFAnnotation.

// Internal events to notify the annotation providers when annotations are being changed.
extern NSString *const PSPDFAnnotationChangedNotification;                      // object = new PSPDFAnnotation.
extern NSString *const PSPDFAnnotationChangedNotificationAnimatedKey;           // set to NO to not animate updates (if it can be animated, that is)
extern NSString *const PSPDFAnnotationChangedNotificationIgnoreUpdateKey;       // set to YES to disable handling by views.
extern NSString *const PSPDFAnnotationChangedNotificationKeyPathKey;            // NSArray of selector names.
extern NSString *const PSPDFAnnotationChangedNotificationOriginalAnnotationKey; // original PSPDFAnnotation.

// UIImagePickerController used in the image add feature will throw a UIApplicationInvalidInterfaceOrientation exception if your app does not include portrait in UISupportedInterfaceOrientations (Info.plist).
// For landscape only apps, we suggest enabling portrait orientation(s) in your Info.plist and rejecting these in UIViewController's auto-rotation methods. This way, you can be landscape only for your view controllers and still be able to use UIImagePickerController.
extern NSString *const PSPDFAnnotationTypeStringImage;      // Image is a stamp annotation.

// Annotations defined after the PDF standard.
typedef NS_OPTIONS(NSUInteger, PSPDFAnnotationType) {
    PSPDFAnnotationTypeNone      = 0,
    PSPDFAnnotationTypeUndefined = 1 << 0, // Any annotation whose type couldn't be recognized.
    PSPDFAnnotationTypeLink      = 1 << 1,  // Links and PSPDFKit multimedia extensions.
    PSPDFAnnotationTypeHighlight = 1 << 2,  // Highlight, Underline, StrikeOut
    PSPDFAnnotationTypeText      = 1 << 3,  // FreeText
    PSPDFAnnotationTypeInk       = 1 << 4,  // Ink (includes Signatures)
    PSPDFAnnotationTypeShape     = 1 << 5,  // Square, Circle
    PSPDFAnnotationTypeLine      = 1 << 6,  // Line
    PSPDFAnnotationTypeNote      = 1 << 7,  // Note
    PSPDFAnnotationTypeStamp     = 1 << 8,  // Stamp (includes images)
    PSPDFAnnotationTypeCaret     = 1 << 9,  // Caret
    PSPDFAnnotationTypeRichMedia = 1 << 10, // Embedded PDF videos
    PSPDFAnnotationTypeScreen    = 1 << 11, // Embedded PDF videos
    PSPDFAnnotationTypeWidget    = 1 << 12, // Widget
    PSPDFAnnotationTypeFile      = 1 << 13, // FileAttachment
    PSPDFAnnotationTypeSound     = 1 << 14, // Sound
    PSPDFAnnotationTypePolygon   = 1 << 15, // Polygon (includes PolyLine)
    PSPDFAnnotationTypeAll       = NSUIntegerMax
};

// Converts an annotation type into the string representation.
extern NSString *PSPDFTypeStringFromAnnotationType(PSPDFAnnotationType annotationType);

// Annotation border style. PSPDFKit currently only supports Solid and Dashed.
typedef NS_ENUM(NSUInteger, PSPDFAnnotationBorderStyle) {
    PSPDFAnnotationBorderStyleNone,
    PSPDFAnnotationBorderStyleSolid,
    PSPDFAnnotationBorderStyleDashed,
    PSPDFAnnotationBorderStyleBelved,
    PSPDFAnnotationBorderStyleInset,
    PSPDFAnnotationBorderStyleUnderline,
    PSPDFAnnotationBorderStyleUnknown
};

// A set of flags specifying various characteristics of the annotation. PSPDFKit doesn't yet support all of those flag settings.
typedef NS_OPTIONS(NSUInteger, PSPDFAnnotationFlags) {
    PSPDFAnnotationFlagInvisible      = 1 << 0, // If set, ignore annotation AP stream if there is no handler available.
    PSPDFAnnotationFlagHidden         = 1 << 1, // [TODO] If set, do not display or print the annotation or allow it to interact with the user.
    PSPDFAnnotationFlagPrint          = 1 << 2, // [TODO] If set, print the annotation when the page is printed. Default value.
    PSPDFAnnotationFlagNoZoom         = 1 << 3, // [TODO] If set, don't scale the annotation’s appearance to match the magnification of the page.
    PSPDFAnnotationFlagNoRotate       = 1 << 4, // [TODO] If set, don't rotate the annotation’s appearance to match the rotation of the page.
    PSPDFAnnotationFlagNoView         = 1 << 5, // [TODO] If set, don't display the annotation on the screen. (But printing might be allowed)
    PSPDFAnnotationFlagReadOnly       = 1 << 6, // [TODO] If set, don't allow the annotation to interact with the user. Ignored for Widget.
    PSPDFAnnotationFlagLocked         = 1 << 7, // [TODO] If set, don't allow the annotation to be deleted or properties modified (except contents)
    PSPDFAnnotationFlagToggleNoView   = 1 << 8, // [TODO] If set, invert the interpretation of the NoView flag for certain events.
    PSPDFAnnotationFlagLockedContents = 1 << 9, // [TODO] If set, don't allow the contents of the annotation to be modified by the user.
};

/**
 Defines a PDF annotation.

 PSPDFAnnotationParser searches the runtime for subclasses of PSPDFAnnotation and builds up a dictionary using supportedTypes.

 Don't directly make an instance of this class, use subclasses like PSPDFNoteAnnotations or PSPDFLinkAnnotations. This class will return nil if initialized directly, unless with the type PSPDFAnnotationTypeUndefined.

 Subclasses need to implement - (id)initWithAnnotationDictionary:(CGPDFDictionaryRef)annotationDictionary inAnnotsArray:(CGPDFArrayRef)annotsArray.

 Ensure that custom subclasses also correctly implement hash and isEqual.
 
 Annotation objects should only ever be edited on ONE thread. Modify properties on the main thread only if they are already active (for creation, it doesn't matter which thread creates them). Before rendering, obtain a copy of the annotation to ensure it's not mutated while properties are read.
*/
@interface PSPDFAnnotation : PSPDFModel

/// Returns the annotation type strings that are supported. Implemented in each subclass.
+ (NSArray *)supportedTypes;

/// Returns YES if PSPDFKit has support to write this annotation type back into the PDF.
+ (BOOL)isWriteable;

/// Returns YES if this annotation type is moveable.
- (BOOL)isMovable;

/// Returns YES if this annotation type is resizable (all but note annotations usually are).
- (BOOL)isResizable;

/// Use this to create custom user annotations.
- (id)initWithType:(PSPDFAnnotationType)annotationType;

/// Designated initializer. Also used for generic PSPDFAnnotations (those that are not recognized by PSPDFAnnotationParser)
/// Implement this in your subclass.
- (id)initWithAnnotationDictionary:(CGPDFDictionaryRef)annotDict inAnnotsArray:(CGPDFArrayRef)annotsArray documentRef:(CGPDFDocumentRef)documentRef;

/// Initialize annotation with the corresponding PDF dictionary. Call this from your direct subclass.
- (id)initWithAnnotationDictionary:(CGPDFDictionaryRef)annotationDictionary inAnnotsArray:(CGPDFArrayRef)annotsArray documentRef:(CGPDFDocumentRef)documentRef type:(PSPDFAnnotationType)annotationType;

/// Check if point is inside annotation area.
- (BOOL)hitTest:(CGPoint)point;

/// Calculates the exact annotation position in the current page.
- (CGRect)rectForPageRect:(CGRect)pageRect;

- (NSComparisonResult)compareByPositionOnPage:(PSPDFAnnotation *)otherAnnotation;

- (CGRect)rectFromPDFArray:(CGPDFArrayRef)array;

- (NSArray *)rectsFromQuadPointsInArray:(CGPDFArrayRef)quadPointsArray;

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
extern NSString *const kPSPDFAnnotationDrawFlattened;

/// Allows to customize the drawing process.
/// Currently used to allow different annotation drawings during the annotation flattening process.
- (void)drawInContext:(CGContextRef)context withOptions:(NSDictionary *)options;

extern NSString *const kPSPDFAnnotationDrawCentered; // CGFloat, draw in the middle of the image, if size has a different aspect ratio.
extern NSString *const kPSPDFAnnotationMargin;       // UIEdgeInsets.

/// Renders annotation into an image.
- (UIImage *)imageWithSize:(CGSize)size withOptions:(NSDictionary *)options;

/// Current annotation type.
@property (nonatomic, assign, readonly) PSPDFAnnotationType type;

/// If YES, the annotation will be rendered as a overlay. If NO, it will be statically rendered within the PDF content image.
/// PSPDFAnnotationTypeLink and PSPDFAnnotationTypeNote currently are rendered as overlay.
/// If overlay is set to YES, you must also register the corresponding *annotationView class to render (override PSPDFAnnotationParser's defaultAnnotationViewClassForAnnotation)
@property (nonatomic, assign, getter=isOverlay) BOOL overlay;

/// Per default, annotations are editable when isWriteable returns YES.
/// Override this to lock certain annotations (menu won't be shown)
@property (nonatomic, assign, getter=isEditable) BOOL editable;

/// Annotation type string as defined in the PDF.
/// Usually read from the annotDict. Don't change this unless you know what you're doing.
@property (nonatomic, copy) NSString *typeString;

/// Alpha value of the annotation color.
@property (nonatomic, assign) float alpha;

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

/// Annotation flags.
@property (nonatomic, assign) NSUInteger flags;

/// The annotation name, a text string uniquely identifying it among all the annotations on its page.
/// (Optional; PDF1.4, "NM" key)
@property (nonatomic, copy) NSString *name;

/// Date where the annotation was last modified.
/// Saved into the PDF as the "M" property (Optional, since PDF 1.1)
/// Will be updated by PSPDFKit as soon as a property is changed.
@property (nonatomic, strong) NSDate *lastModified;

/// Date when the annotation was created. Might be nil.
/// PSPDFKit will set this for newly created annotations.
@property (nonatomic, strong) NSDate *creationDate;

/// Border Line Width (only used in certain annotations)
@property (nonatomic, assign) float lineWidth;

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

/// Certain annotation types like highlight might have multiple rects.
@property (nonatomic, copy) NSArray *rects;

/// Line, Polyline and Polygon annotations have points.
@property (nonatomic, copy) NSArray *points;

/// User (title) flag. ("T" property)
@property (nonatomic, copy) NSString *user;

/// Page for current annotation. Page is relative to the documentProvider.
@property (nonatomic, assign) NSUInteger page;

/// Page relative to the document.
/// Will be calculated from page and will change page if set.
@property (nonatomic, assign) NSUInteger absolutePage;

/// If this annotation isn't backed by the PDF, it's dirty by default.
/// After the annotation has been written to the file, this will be reset until the annotation has been changed.
@property (nonatomic, assign, getter=isDirty) BOOL dirty;

/// Corresponding documentProvider, weak.
@property (atomic, weak) PSPDFDocumentProvider *documentProvider;

/// Document is inferred from the documentProvider.
@property (nonatomic, assign, readonly) PSPDFDocument *document;

/**
 Returns YES if a custom appearance stream is attached to this annotation.

 An appearance stream is a custom representation for annotations, much like a PDF within a PDF. PSPDFKit has only very limited support for appearance streams, currently only for stamp/ink annotations and that only under certain conditions.
 */
@property (nonatomic, assign, readonly) BOOL hasAppearanceStream;

/// Allows to save arbitrary data (e.g. a CoreData Object ID)
/// Will be preserved within app sessions and copy, but NOT serialized to disk or within the PDF.
@property (atomic, copy) NSDictionary *userInfo;

/// Returns self.contents or something appropriate per annotation type to describe the object.
- (NSString *)infoDescription;

/// Compare.
- (BOOL)isEqualToAnnotation:(PSPDFAnnotation *)otherAnnotation;

/// Copy to UIPasteboard.
- (void)copyToClipboard;

/// Color string <-> UIColor transformer.
+ (NSValueTransformer *)colorTransformer;

/// PDF border style string representation <-> PSPDFAnnotationBorderStyle transformer.
+ (NSValueTransformer *)borderStyleTransformer;

/// ISO8601 date string <-> NSDate transformer.
+ (NSValueTransformer *)lastModifiedTransformer;

@end

// Private UIPasteboard support.
extern NSString *const PSPDFAnnotationPasteboardPrivateData;


@interface PSPDFAnnotation (PSPDFAnnotationWriting)

// PDF rect string representation (/Rect [%f %f %f %f])
- (NSString *)pdfRectString;

extern NSString *PSPDFRectStringFromRect(CGRect rect);

// Color string representation (/C [%f %f %f])
- (NSString *)pdfColorString;

- (NSString *)pdfColorStringWithKey:(NSString *)key andColor:(UIColor *)color;

// Fill Color string representation (/IC [%f %f %f])
- (NSString *)pdfFillColorString;

// Color string representation (/C [%f %f %f] /CA %f)
- (NSString *)pdfColorWithAlphaString;

// Border dictionary. e.g. /BS <</Type /Border /W 3 /S /U>>
- (NSString *)pdfBorderString;

// rects representation.
- (NSString *)pdfQuadPointsString;

// Appends escaped contents data if contents length is > 0.
// Will also add common PDF properties like user name, date.
- (void)appendEscapedContents:(NSMutableData *)pdfData withStreamOptions:(NSDictionary *)streamOptions;

// Converts an array of NSValue-CGRect's into an array of CGRect-NSString's.
+ (NSArray *)stringsFromRectsArray:(NSArray *)rects;

// Converts an array of CGRect-NSString's into a array of NSValue-CGRect's.
+ (NSArray *)rectsFromStringsArray:(NSArray *)rectStrings;

/// Starts the mutable data for writing.
- (NSMutableData *)pdfMutableDataRepresentationHeader;

/// Returns NSData string representations in the PDF standard.
/// Per convention, the first returned object has to be an annotation objects, all other can be supportive objects.
- (NSArray *)pdfDataRepresentationsWithOptions:(NSDictionary *)streamOptions;

extern NSString *const kPSPDFRepresentationAPStreamNumber;
extern NSString *const kPSPDFRepresentationFirstObjectNumber;

/// Annotations that have indexOnPage >= 0 will be copied before they're modified.
/// Returns same type as current class.
/// YOU NEED TO CALL THIS EVERY TIME BEFORE TRYING TO EDIT AN ANNOTATION.
- (instancetype)copyAndDeleteOriginalIfNeeded;

/// If indexOnPage is set, it's a native PDF annotation.
/// If this is -1, it's not yet saved in the PDF.
/// Annotations that have indexOnPage >= 0 will be copied before they're modified.
@property (nonatomic, readonly) NSInteger indexOnPage;

/// If this is a copy of a deleted annotation, we still need to track the index.
@property (nonatomic, readonly) NSInteger previousIndexOnPage;

/// Some annotations may have a popupIndex. Defaults to -1.
@property (nonatomic, assign) NSInteger popupIndex;

@end

@interface PSPDFAnnotation (SubclassingHooks)

// Will be called after document and page have been set.
- (void)parse;

// Draw the bounding box.
- (void)drawBoundingBox:(CGContextRef)context;

// Helper that will prepare the context for the border style.
- (void)prepareBorderStyleInContext:(CGContextRef)context;

// Helper that queries the page rotation.
- (NSInteger)pageRotation;

@end

// Helper for pdfDataRepresentation creation.
@interface NSMutableData (PSPDFAdditions)
- (void)pspdf_appendDataString:(NSString *)dataString;
@end

// Helps to properly encode strings to PDF UTF16.
// Will only convert strings that can't be represented in ASCII.
extern NSData *PSPDFUTF16EncodedStringWithTitle(NSString *string, NSString *title);

// Helper to properly escape ASCII strings.
extern NSString *PSPDFEscapedString(NSString *string);

// Calculates a new rectangle expanded by a line width.
extern CGRect PSPDFGrowRectByLineWidth(CGRect boundingBox, CGFloat lineWidth);
