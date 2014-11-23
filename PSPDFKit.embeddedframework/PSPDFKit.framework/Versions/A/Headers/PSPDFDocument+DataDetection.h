//
//  PSPDFDocument+DataDetection.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFDocument.h"

@interface PSPDFDocument (DataDetection)

/// Set this property to allow automatic link detection.
/// Will only add links where no link annotations already exist.
/// Defaults to `PSPDFTextCheckingTypeNone` for performance reasons.
///
/// Set to `PSPDFTextCheckingTypeLink` if you are see URLs in your document that are not clickable.
/// `PSPDFTextCheckingTypeLink` is the default behavior for desktop apps like Adobe Acrobat or Apple Preview.
///
/// @note This requires that you keep the `PSPDFFileAnnotationProvider` in the `annotationManager`.
/// (Default). Needs to be set before the document is being displayed or annotations are accessed!
/// The exact details how detection works are an implementation detail.
/// Apple's Data Detectors are currently used internally.
///
/// @warning Autodetecting links is useful but might slow down annotation display.
@property (nonatomic, assign) PSPDFTextCheckingType autodetectTextLinkTypes;

/// Iterates over all pages in `pageRange` and creates new annotations for defined types in `textLinkTypes`.
/// Will ignore any text that is already linked with the same URL.
/// It is your responsibility to add the annotations to the document.
///
/// @note To analyze the whole document, use
/// `[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)]`
///
/// `options` can take a PSPDFObjectsAnnotationsKey of type NSDictionary -> page to prevent auto-fetching for comparsion.
///
/// @warning Performs text and annotation extraction and analysis. Might be slow.
/// `progressBlock` might be called from different threads.
/// Ensure you dispatch to the main queue for progress updates.
- (NSDictionary *)annotationsFromDetectingLinkTypes:(PSPDFTextCheckingType)textLinkTypes
                                       pagesInRange:(NSIndexSet *)pageRange
                                            options:(NSDictionary *)options
                                           progress:(void (^)(NSArray *annotations, NSUInteger page, BOOL *stop))progressBlock
                                              error:(NSError *__autoreleasing*)error;

@end

@interface PSPDFDocument (ObjectFinder)

/// Return a textParser for the specific document page. Thread safe.
- (PSPDFTextParser *)textParserForPage:(NSUInteger)page;

/// Find objects (glyphs, words, images, annotations) at the specified `pdfPoint`.
/// If `options` is nil, we assume `PSPDFObjectsText` and `PSPDFObjectsFullWords`.
/// @note Unless set otherwise, for points `PSPDFObjectsTestIntersectionKey` is YES automatically.
/// Returns objects in certain key dictionaries .(`PSPDFObjectsGlyphsKey`, etc)
///
/// This method is thread safe.
- (NSDictionary *)objectsAtPDFPoint:(CGPoint)pdfPoint page:(NSUInteger)page options:(NSDictionary *)options;

/// Find objects (glyphs, words, images, annotations) at the specified `pdfRect`.
/// If `options` is nil, we assume `PSPDFObjectsGlyphsKey` only.
/// Returns objects in certain key dictionaries (`PSPDFObjectsGlyphsKey`, etc)
///
/// This method is thread safe.
- (NSDictionary *)objectsAtPDFRect:(CGRect)pdfRect page:(NSUInteger)page options:(NSDictionary *)options;

// Options for the object finder.

// Search glyphs.
extern NSString *const PSPDFObjectsGlyphsKey;

// Always return full `PSPDFWord`s. Implies `PSPDFObjectsTextKey`.
extern NSString *const PSPDFObjectsWordsKey;

// Include Text.
extern NSString *const PSPDFObjectsTextKey;

// Include text blocks, sorted after most appropriate.
extern NSString *const PSPDFObjectsTextBlocksKey;

// Include Image info.
extern NSString *const PSPDFObjectsImagesKey;

// Output category for annotations.
extern NSString *const PSPDFObjectsAnnotationsKey;

// Ignore too large text blocks (that are > 90% of a page)
extern NSString *const PSPDFObjectsIgnoreLargeTextBlocksKey;

// Include annotations of attached type
extern NSString *const PSPDFObjectsAnnotationTypesKey;

// Special case; used for PSPDFAnnotationTypeNote hit testing.
extern NSString *const PSPDFObjectsAnnotationPageBoundsKey;

// Special case; Used to correctly hit test zoom-invariant annotations.
extern NSString *const PSPDFObjectsPageZoomLevelKey;

// Include annotations that are part of a group.
extern NSString *const PSPDFObjectsAnnotationIncludedGroupedKey;

// Will sort words/annotations (smaller words/annots first). Use for touch detection.
extern NSString *const PSPDFObjectsSmartSortKey;

// Will use path-based hit-testing based on the center point if set.
extern NSString *const PSPDFObjectMinDiameterKey;

// Will look at the text flow and select full sentences, not just what's within the rect.
extern NSString *const PSPDFObjectsTextFlowKey;

// Will stop after finding the first matching object.
extern NSString *const PSPDFObjectsFindFirstOnlyKey;

// Only relevant for rect. Will test for intersection instead of objects that are fully included in the pdfRect.
extern NSString *const PSPDFObjectsTestIntersectionKey;

@end
