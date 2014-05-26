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

/// Set this property to allow automatic link detection. Will only add links where no link annotations already exist.
/// Defaults to `PSPDFTextCheckingTypeNone` for performance reasons. Set to `PSPDFTextCheckingTypeLink` if you are see URLs in your document that are not clickable. `PSPDFTextCheckingTypeLink` is the default behavior for desktop apps like Adobe Acrobat or Apple Preview.app.
/// @note This requires that you keep the `PSPDFFileAnnotationProvider` in the `annotationManager`. (Default). Needs to be set before the document is being displayed or annotations are accessed!
/// @warning Autodetecting links is useful but might slow down annotation display.
@property (nonatomic, assign) PSPDFTextCheckingType autodetectTextLinkTypes;

/// Iterates over all pages in `pageRange` and creates new annotations for the defined types in `textLinkTypes`.
/// Will ignore any text that is already linked with the same URL.
/// It is your responsibility to add the annotations to the document.
///
/// @note To analyze the whole document, use `[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)]`
/// @warning Performs text and annotation extraction and analysis. Might be slow.
/// @warning `progressBlock` might be called from different threads - ensure you dispatch to the main queue for progress updates.
- (NSDictionary *)annotationsFromDetectingLinkTypes:(PSPDFTextCheckingType)textLinkTypes pagesInRange:(NSIndexSet *)pageRange progress:(void (^)(NSArray *annotations, NSUInteger page, BOOL *stop))progressBlock error:(NSError **)error;

@end

@interface PSPDFDocument (ObjectFinder)

// Options for the object finder.
extern NSString *const PSPDFObjectsGlyphs;                // Search glyphs.
extern NSString *const PSPDFObjectsText;                  // Include Text.
extern NSString *const PSPDFObjectsFullWords;             // Always return full PSPDFWords. Implies PSPDFObjectsText.
extern NSString *const PSPDFObjectsTextBlocks;            // Include text blocks, sorted after most appropriate.
extern NSString *const PSPDFObjectsTextBlocksIgnoreLarge; // Ignore too large text blocks (that are > 90% of a page)
extern NSString *const PSPDFObjectsAnnotationTypes;       // Include annotations of attached type
extern NSString *const PSPDFObjectsAnnotationPageBounds;  // Special case; used for PSPDFAnnotationTypeNote hit testing.
extern NSString *const PSPDFObjectsImages;                // Include Image info.
extern NSString *const PSPDFObjectsSmartSort;             // Will sort words/annotations (smaller words/annots first). Use for touch detection.
extern NSString *const PSPDFObjectsTextFlow;              // Will look at the text flow and select full sentences, not just what's within the rect.
extern NSString *const PSPDFObjectsFindFirstOnly;         // Will stop after finding the first matching object.
extern NSString *const PSPDFObjectsTestIntersection;      // Only relevant for rect. Will test for intersection instead of objects that are fully included in the pdfRect.

// Output categories
extern NSString *const PSPDFObjectsGlyphKey;
extern NSString *const PSPDFObjectsWordKey;
extern NSString *const PSPDFObjectsTextKey;
extern NSString *const PSPDFObjectsTextBlockKey;
extern NSString *const PSPDFObjectsAnnotationKey;
extern NSString *const PSPDFObjectsImageKey;

/// Find objects (glyphs, words, images, annotations) at the specified `pdfPoint`. Thread safe.
/// If `options` is nil, we assume `PSPDFObjectsText` and `PSPDFObjectsFullWords`.
/// Unless set otherwise, for points `PSPDFObjectsTestIntersection` is YES automatically.
/// Returns objects in certain key dictionaries (`PSPDFObjectsGlyphKey`, etc)
- (NSDictionary *)objectsAtPDFPoint:(CGPoint)pdfPoint page:(NSUInteger)page options:(NSDictionary *)options;

/// Find objects (glyphs, words, images, annotations) at the specified `pdfRect`. Thread safe.
/// If `options` is nil, we assume `PSPDFObjectsGlyphKey` only.
/// Returns objects in certain key dictionaries (`PSPDFObjectsGlyphKey`, etc)
- (NSDictionary *)objectsAtPDFRect:(CGRect)pdfRect page:(NSUInteger)page options:(NSDictionary *)options;

/// Return a textParser for the specific document page. Thread safe.
- (PSPDFTextParser *)textParserForPage:(NSUInteger)page;

/// Checks if the text parser has already been loaded. Thread safe.
- (BOOL)hasLoadedTextParserForPage:(NSUInteger)page;

/// Text can be defined outside of the visible page area. Usually this is unexpected and a leftover, so this defaults to YES.
/// Set this early before any page textParser is accessed.
@property (nonatomic, assign) BOOL textParserHideGlyphsOutsidePageRect;

@end
