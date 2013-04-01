//
//  PSPDFAnnotationParser.h
//  PSPDFKit
//
//  Copyright 2011-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFAnnotation.h"
#import "PSPDFAnnotationProvider.h"

@protocol PSPDFAnnotationViewProtocol;
@class PSPDFDocumentProvider, PSPDFFileAnnotationProvider;

// Sent when a new annotation is added to the default PSPDFFileAnnotationProvider.
// Will also be sent if an annotation is added because a editable copy is created.
extern NSString *const PSPDFAnnotationAddedNotification;  // object = new PSPDFAnnotation.

// Internal events to notify the providers when annotations are being changed.
extern NSString *const PSPDFAnnotationChangedNotification;                  // object = new PSPDFAnnotation.
extern NSString *const PSPDFAnnotationChangedNotificationAnimatedKey;       // set to NO to not animate updates (if it can be animated, that is)
extern NSString *const PSPDFAnnotationChangedNotificationIgnoreUpdateKey;   // set to YES to disable handling by views.
extern NSString *const PSPDFAnnotationChangedNotificationKeyPathKey;        // NSArray of selector names.
extern NSString *const PSPDFAnnotationChangedNotificationOriginalAnnotationKey; // original PSPDFAnnotation.

/**
 Parses and saves annotations for each page in a PDF.
 Supports many sources with the PSPDFAnnotationProvider protocol.

 Usually you want to add your custom PSPDFAnnotationProvider instead of subclassing this.
 If you subclass, use overrideClassNames in PSPDFDocument.

 This class will set the documentProvider on both annotation adding and retrieving. You don't have to handle this in your annotationProvider subclass.
*/
@interface PSPDFAnnotationParser : NSObject <PSPDFAnnotationProviderChangeNotifier>

/// Initializes the annotation parser with the associated documentProvider.
- (id)initWithDocumentProvider:(PSPDFDocumentProvider *)documentProvider;

/**
 The simplest way to extend PSPDFAnnotationParser is to register a custom PSPDFAnnotationProvider.
 You can even remove the default PSPDFFileAnnotationProvider if you don't want file-based annotations.

 On default, this array will contain the fileAnnotationProvider.
 @note The order of the array is important. Setting/getting is thread safe.
 */
@property (nonatomic, copy) NSArray *annotationProviders;

/// Direct access to the file annotation provider, who default is the only registered annotationProvider.
/// Will never be nil, but can be removed from the annotationProviders list.
@property (nonatomic, strong, readonly) PSPDFFileAnnotationProvider *fileAnnotationProvider;

/**
 Return annotation array for specified page.

 This method will be called OFTEN. Multiple times during a page display, and basically each time you're scrolling or zooming. Ensure it is fast.
 This will query all annotationProviders and merge the result.
 For example, to get all annotations except links, use PSPDFAnnotationTypeAll &~ PSPDFAnnotationTypeLink as type.

 @note Fetching annotations may take a while. You can do this in a background thread.
*/
- (NSArray *)annotationsForPage:(NSUInteger)page type:(PSPDFAnnotationType)type;

/**
 Returns all annotations of all annotationProviders.

 Returns dictionary NSNumber->NSArray. Only adds entries for a page if there are annotations.
 @warning This might take some time if the annotation cache hasn't been built yet.
 */
- (NSDictionary *)allAnnotationsOfType:(PSPDFAnnotationType)annotationType;

/// YES if annotations are loaded for a specific page.
/// This is used to determine if annotationsForPage:type: should be called directly or in a background thread.
- (BOOL)hasLoadedAnnotationsForPage:(NSUInteger)page;

/**
 Any annotation that returns YES on isOverlay needs a view class to be displayed.
 Will be called on all annotationProviders until someone doesn't return nil.

 If no class is found, the view will be ignored.
 */
- (Class)annotationViewClassForAnnotation:(PSPDFAnnotation *)annotation;

/**
 Add annotations at a specific page.

 PSPDFAnnotationParser will query all registered annotationProviders until one returns YES on addAnnotations.
 Will return false if no annotationProviders handled the annotation. (By default, the PSPDFFileAnnotationProvider will handle all annotation additions.)

 If you're just interested in being notified, you can register a custom annotationProvider and set in the array before the file annotationProvider. Implement addAnnotations:forPage: and return NO. You'll be notified of all add operations.
 */
- (BOOL)addAnnotations:(NSArray *)annotations forPage:(NSUInteger)page;

/**
 Will be called by PSPDF internally every time an annotation is changed.
 Call will be relayed to all annotationProviders.

 This method will be called on ALL annotations, not just the ones that you provided.
 @note If you have custom code that changes annotations and you rely on the didChangeAnnotation: event, you need to call it manually.

 For file-based annotations we might have to make a copy before the annotation can be edited. (see copyAndDeleteOriginalIfNeeded on PSPDFAnnotation.h)
 If the annotation object wasn't changed itself, set originalAnnotation = annotation.

 Options is used internally to determine of the file annotation provider should request an annotation update. (the userInfo notification dict will be forwarded.)
 */
- (void)didChangeAnnotation:(PSPDFAnnotation *)annotation originalAnnotation:(PSPDFAnnotation *)originalAnnotation keyPaths:(NSArray *)keyPaths options:(NSDictionary *)options;

/// Save annotations. (returning NO + eventually an error if it fails)
/// Saving will be forwarded to all annotation providers.
/// Usually you want to override the method in PSPDFFileAnnotationProvider instead.
- (BOOL)saveAnnotationsWithError:(NSError **)error;

/// Provided to the PSPDFAnnotationProviders via PSPDFAnnotationProviderChangeNotifier.
/// Will update any visible annotation.
/// If no objects were replace, you can set originalAnnotations to nil. Ensure that originalAnnotations is either nil or has the same item count as annotations.
- (void)updateAnnotations:(NSArray *)annotations originalAnnotations:(NSArray *)originalAnnotations animated:(BOOL)animated;

/// document provider for annotation parser. weak.
@property (nonatomic, weak, readonly) PSPDFDocumentProvider *documentProvider;

@end


@interface PSPDFAnnotationParser (SubclassingHooks)

/// Fast path, same as annotationsForPage:type: but with already opened pageRef.
/// If you want to override annotationsfForPage:type, override this instead.
- (NSArray *)annotationsForPage:(NSUInteger)page type:(PSPDFAnnotationType)type pageRef:(CGPDFPageRef)pageRef;

/// Searches the annotation cache for annotations that have the dirty flag set.
/// Dictionary key are the pages, object an array of annotations.
- (NSDictionary *)dirtyAnnotations;

@end


// Lots of methods have been moved to PSPDFFileAnnotationProvider.
@interface PSPDFAnnotationParser (Deprecated)

@property (nonatomic, copy) NSString *protocolString __attribute__ ((deprecated("Use fileAnnotationProvider.protocolString instead")));

@property (nonatomic, copy) NSString *annotationsPath __attribute__ ((deprecated("Use fileAnnotationProvider.annotationsPath instead")));

- (void)setAnnotations:(NSArray *)annotations forPage:(NSUInteger)page __attribute__ ((deprecated("Use the method in fileAnnotationProvider instead.")));

- (void)clearCache __attribute__ ((deprecated("Use the method in fileAnnotationProvider instead.")));

@end
