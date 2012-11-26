//
//  PSPDFAnnotation.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
// 

#import "PSPDFKitGlobal.h"

@class PSPDFDocument, PSPDFDocumentProvider;

// list of editable annotation types.
extern NSString *const PSPDFAnnotationTypeStringLink;
extern NSString *const PSPDFAnnotationTypeStringHighlight;
extern NSString *const PSPDFAnnotationTypeStringUnderline;
extern NSString *const PSPDFAnnotationTypeStringStrikeout;
extern NSString *const PSPDFAnnotationTypeStringNote;
extern NSString *const PSPDFAnnotationTypeStringFreeText;
extern NSString *const PSPDFAnnotationTypeStringInk;
extern NSString *const PSPDFAnnotationTypeStringSquare;
extern NSString *const PSPDFAnnotationTypeStringCircle;

// Annotations defined after the PDF standard.
typedef NS_OPTIONS(NSUInteger, PSPDFAnnotationType) {
    PSPDFAnnotationTypeNone      = 0,
    PSPDFAnnotationTypeLink      = 1 << 1,  // Links and multimedia extensions
    PSPDFAnnotationTypeHighlight = 1 << 2,  // (Highlight, Underline, StrikeOut) - PSPDFHighlightAnnotationView
    PSPDFAnnotationTypeText      = 1 << 3,
    PSPDFAnnotationTypeInk       = 1 << 4,
    PSPDFAnnotationTypeShape     = 1 << 5,  // Square, Circle
    PSPDFAnnotationTypeLine      = 1 << 6,
    PSPDFAnnotationTypeNote      = 1 << 7,
    PSPDFAnnotationTypeStamp     = 1 << 8,
    PSPDFAnnotationTypeRichMedia = 1 << 10, // Embedded PDF videos
    PSPDFAnnotationTypeScreen    = 1 << 11, // Embedded PDF videos
    PSPDFAnnotationTypeUndefined = 1 << 31, // any annotation whose type couldn't be recognized
    PSPDFAnnotationTypeAll       = UINT_MAX
};

// Converts annotation type into the string representation.
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

/**
 Defines a PDF annotation.
 
 PSPDFAnnotationParser searches the runtime for subclasses of PSPDFAnnotation and builds up a dictionary using supportedTypes.
 
 Don't directly make an instance of this class, use the subclasses like PSPDFNoteAnnotations, PSPDFLinkAnnotations or others. This class will return nil if initialized directly, unless with the type PSPDFAnnotationTypeUndefined.

 Subclasses need to implement - (id)initWithAnnotationDictionary:(CGPDFDictionaryRef)annotationDictionary inAnnotsArray:(CGPDFArrayRef)annotsArray.
 
 Ensure that custom sublcasses also correctly implement hash and isEqual.
*/
@interface PSPDFAnnotation : NSObject <NSCoding, NSCopying>

/// Returns the annotation type strings that are supported. Implemented in each subclass.
+ (NSArray *)supportedTypes;

/// Returns YES if PSPDFKit has support to write this annotation type back into the PDF.
+ (BOOL)isWriteable;

/// Returns YES if this annotation type is moveable.
- (BOOL)isMovable;

/// Use this to create custom user annotations. 
- (id)initWithType:(PSPDFAnnotationType)annotationType;

/// Designated initializer. Also used for generic PSPDFAnnotations (those that are not recognized by PSPDFAnnotationParser)
/// Implement this in your subclass.
- (id)initWithAnnotationDictionary:(CGPDFDictionaryRef)annotDict inAnnotsArray:(CGPDFArrayRef)annotsArray;

/// Initialize annotation with the corresponding PDF dictionary. Call this from your direct subclass.
- (id)initWithAnnotationDictionary:(CGPDFDictionaryRef)annotationDictionary inAnnotsArray:(CGPDFArrayRef)annotsArray type:(PSPDFAnnotationType)annotationType;

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
 Some annotations handle borders differently, so decide in your supclass if you call [super drawInContext] or not.
 */
- (void)drawInContext:(CGContextRef)context;

/// Helper that will prepare the context for the border style.
- (void)prepareBorderStyleInContext:(CGContextRef)context;

/// Current annotation type. 
@property (nonatomic, assign, readonly) PSPDFAnnotationType type;

/// If YES, the annotation will be rendered as a overlay. If NO, it will be statically rendered within the PDF content image.
/// PSPDFAnnotationTypeLink and PSPDFAnnotationTypeNote currently are rendered as overlay.
/// Currently won't work if you just set arbitrary annotations to overlay=YES.
/// If overlay is set to YES, you must also register the corresponding *annotationView class to render (override PSPDFAnnotationParser's annotationClassForAnnotation)
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

/// Fill color. Only used for certain annotation types. ("IC" key)
/// (e.g. Square and Circle Annotations)
/// FillColor might be nil - treat like clearColor in that case.
@property (nonatomic, strong) UIColor *fillColor;

/// Optional. Various annotation types may contain text.
@property (nonatomic, copy) NSString *contents;

/// The annotation name, a text string uniquely identifying it among all the annotations on its page.
/// (Optional; PDF1.4, "NM" key)
@property (nonatomic, copy) NSString *name;

/// Border Line Width (only used in certain annotations)
@property (nonatomic, assign) float lineWidth;

/// Annotation border style.
@property (nonatomic, assign) PSPDFAnnotationBorderStyle borderStyle;

/// If borderStyle is set to PSPDFAnnotationBorderStyleDashed, we expect a dashStyle array here (int-values)
@property (nonatomic, copy) NSArray *dashArray;

/// Annotation may already be deleted locally, but not written back.
@property (nonatomic, assign, getter=isDeleted) BOOL deleted;

/// Rectangle of specific annotation.
@property (nonatomic, assign) CGRect boundingBox;

/// User (title) flag. ("T" property)
@property (nonatomic, copy) NSString *user;

/// Page for current annotation. Page is relative to the documentProvider.
@property (nonatomic, assign) NSUInteger page;

/// Page relative to the document.
@property (nonatomic, assign, readonly) NSUInteger absolutePage;

/// If this annotation isn't backed by the PDF, it's dirty by default.
/// After the annotation has been written to the file, this will be reset until the annotation has been changed.
@property (nonatomic, assign, getter=isDirty) BOOL dirty;

/// Corresponding documentProvider, weak.
@property (nonatomic, weak) PSPDFDocumentProvider *documentProvider;

/// Document is inferred from the documentProvider.
@property (nonatomic, assign, readonly) PSPDFDocument *document;

/// Rotation value, copied from the PSPDFPageInfo and set when documentProvider is set.
@property (nonatomic, assign) NSInteger rotation;

/// Compare.
- (BOOL)isEqualToAnnotation:(PSPDFAnnotation *)otherAnnotation;

@end


@interface PSPDFAnnotation (PSPDFAnnotationWriting)

// PDF rect string representation (/Rect [%f %f %f %f])
- (NSString *)pdfRectString;

// Color string representation (/C [%f %f %f])
- (NSString *)pdfColorString;

// Fill Color string representation (/IC [%f %f %f])
- (NSString *)pdfFillColorString;

// Color string representation (/C [%f %f %f] /CA %f)
- (NSString *)pdfColorWithAlphaString;

// Appends escaped contents data if contents length is > 0.
// Will also add user and name if set.
- (void)appendEscapedContents:(NSMutableData *)pdfData;

// Converts an array of NSValue-CGRect's into an array of CGRect-NSString's.
+ (NSArray *)stringsFromRectsArray:(NSArray *)rects;

// Converts an array of CGRect-NSString's into a array of NSValue-CGRect's.
+ (NSArray *)rectsFromStringsArray:(NSArray *)rectStrings;

/// Returns NSData string represnetation in the PDF Standard.
- (NSData *)pdfDataRepresentation;

/// Annotations that have indexOnPage >= 0 will be copied before they're modified.
/// Returns same type as current class.
- (instancetype)copyAndDeleteOriginalIfNeeded;

/// If indexOnPage is set, it's a native PDF annotation.
/// If this is -1, it's not yet saved in the PDF.
/// Annotations that have indexOnPage >= 0 will be copied before they're modified.
/// Don't set this property if you're loading annotations from your database.
@property (nonatomic, assign) int indexOnPage;

/// Some annotations may have a popupIndex. Defaults to -1.
@property (nonatomic, assign) int popupIndex;

@end

@interface PSPDFAnnotation (SubclassingHooks)

// Will be called after document and page have been set.
- (void)parse;

@end

// Helper for pdfDataRepresentation creation.
@interface NSMutableData (PSPDFAdditions)
- (void)pspdf_appendDataString:(NSString *)dataString;
@end


@interface PSPDFAnnotation (Deprecated)

- (void)setDocument:(PSPDFDocument *)document __attribute__ ((deprecated("Set the documentProvider instead")));

@end
