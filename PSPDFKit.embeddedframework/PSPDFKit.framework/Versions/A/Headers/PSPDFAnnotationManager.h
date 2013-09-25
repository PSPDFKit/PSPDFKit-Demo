//
//  PSPDFAnnotationManager.h
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
#import "PSPDFAnnotation.h"
#import "PSPDFAnnotationProvider.h"

// Sent when new annotations are added to/removed from the default PSPDFFileAnnotationProvider.
extern NSString *const PSPDFAnnotationsAddedNotification;    // object = array of new PSPDFAnnotation(s).
extern NSString *const PSPDFAnnotationsRemovedNotification;  // object = array of removed PSPDFAnnotation(s).

/// Internal events to notify the annotation providers when annotations are being changed.
/// @warning Only send from main thread! Don't call save during a change notification.
extern NSString *const PSPDFAnnotationChangedNotification;                      // object = new PSPDFAnnotation.
extern NSString *const PSPDFAnnotationChangedNotificationAnimatedKey;           // set to NO to not animate updates (if it can be animated, that is)
extern NSString *const PSPDFAnnotationChangedNotificationIgnoreUpdateKey;       // set to YES to disable handling by views.
extern NSString *const PSPDFAnnotationChangedNotificationKeyPathKey;            // NSArray of selector names.

@protocol PSPDFAnnotationViewProtocol;
@class PSPDFDocumentProvider, PSPDFFileAnnotationProvider;

/**
 Collects annotations from the various PSPDFAnnotationProvider implementations.

 Usually you want to add your custom PSPDFAnnotationProvider instead of subclassing this class.
 If you subclass, use overrideClass:withClass: in PSPDFDocument.

 This class will set the `documentProvider` on both annotation adding and retrieving. You don't have to handle this in your annotationProvider subclass.
*/
@interface PSPDFAnnotationManager : NSObject <PSPDFAnnotationProviderChangeNotifier>

/// Initializes the annotation manager with the associated `documentProvider`.
- (id)initWithDocumentProvider:(PSPDFDocumentProvider *)documentProvider;

/**
 The simplest way to extend PSPDFAnnotationManager is to register a custom PSPDFAnnotationProvider.
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
 Add `annotations` to the currently set annotation providers.
 `page` is defined through the set page in each annotation object.

 @note PSPDFAnnotationManager will query all registered annotationProviders until one returns YES on addAnnotations.
 Will return NO if no annotationProvider can handle the annotations. (By default, the PSPDFFileAnnotationProvider will handle all annotations.)

 If you're just interested in being notified, you can register a custom annotationProvider and set in the array before the file annotationProvider. Implement addAnnotations: and return NO. You'll be notified of all add operations.
 */
- (BOOL)addAnnotations:(NSArray *)annotations;

/// Remove `annotations` from the pages they are registered in.
/// @note Will return NO if no annotationProvider can handle the annotations. (By default, the PSPDFFileAnnotationProvider will handle all annotations.)
- (BOOL)removeAnnotations:(NSArray *)annotations;

/**
 Will be called by PSPDF internally every time an annotation is changed.
 Call will be relayed to all annotationProviders.

 This method will be called on ALL annotations, not just the ones that you provided.
 @note If you have custom code that changes annotations and you rely on the didChangeAnnotation: event, you need to call it manually.

 Options is used internally to determine of the file annotation provider should request an annotation update. (the userInfo notification dict will be forwarded.)
 */
- (void)didChangeAnnotation:(PSPDFAnnotation *)annotation keyPaths:(NSArray *)keyPaths options:(NSDictionary *)options;

/// Save annotations. (returning NO + eventually an error if it fails)
/// Saving will be forwarded to all annotation providers.
/// Usually you want to override the method in PSPDFFileAnnotationProvider instead.
- (BOOL)saveAnnotationsWithOptions:(NSDictionary *)options error:(NSError **)error;

/// Return YES if the manager requires saving.
- (BOOL)shouldSaveAnnotations;

/// Provided to the PSPDFAnnotationProviders via PSPDFAnnotationProviderChangeNotifier.
/// Will update any visible annotation.
- (void)updateAnnotations:(NSArray *)annotations animated:(BOOL)animated;

/// Change the protocol that's used to parse pspdfkit-additions (links, audio, video). Defaults to 'pspdfkit://'.
/// @note This will affect all parsers that generate PSPDFAction objects.
/// @warning Set this early on or manually clear the cache to update the parsers.
@property (nonatomic, copy) NSString *protocolString;

/// The fileType translation table is used when we encounter pspdfkit:// links (or whatever is set to document.protocolString)
/// Maps e.g. "mpg" to PSPDFLinkAnnotationVideo. (NSString -> NSNumber)
@property (nonatomic, copy) NSDictionary *fileTypeTranslationTable;

/// Document provider for annotation parser.
@property (nonatomic, unsafe_unretained, readonly) PSPDFDocumentProvider *documentProvider;

@end


@interface PSPDFAnnotationManager (SubclassingHooks)

/// Fast path, same as annotationsForPage:type: but with already opened pageRef.
/// If you want to override annotationsForPage:type, override this instead.
- (NSArray *)annotationsForPage:(NSUInteger)page type:(PSPDFAnnotationType)type pageRef:(CGPDFPageRef)pageRef;

/// Searches the annotation cache for annotations that have the dirty flag set.
/// Dictionary key are the pages, object an array of annotations.
- (NSDictionary *)dirtyAnnotations;

/// Filtered fileTypeTranslationTable that only returns video or audio elements.
- (NSArray *)mediaFileTypes;

@end
