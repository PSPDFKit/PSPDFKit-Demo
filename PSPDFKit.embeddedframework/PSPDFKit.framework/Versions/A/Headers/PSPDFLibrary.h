//
//  PSPDFLibrary.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

@class PSPDFDocument, PSPDFLibrary, PSPDFTextParser;

// The library version.
extern NSUInteger const PSPDFLibraryVersion;

// PSPDFLibrary uses NSNotifications to post status updates.
extern NSString *const PSPDFLibraryWillStartIndexingDocumentNotification;
extern NSString *const PSPDFLibraryDidFinishIndexingDocumentNotification;
extern NSString *const PSPDFLibraryDidFailIndexingDocumentNotification;

typedef NS_ENUM(NSUInteger, PSPDFLibraryIndexStatus) {
    PSPDFLibraryIndexStatusUnknown, // Not in library
    PSPDFLibraryIndexStatusQueued,
    PSPDFLibraryIndexStatusPartial,
    PSPDFLibraryIndexStatusPartialAndIndexing,
    PSPDFLibraryIndexStatusFinished,
};

/// PSPDFLibrary implements a sqlite-based full-text-search engine.
/// You can register documents to be indexed in the background and then search for keywords within that collection.
/// There can be multiple libraries, although usually one is enough for the common use case.
/// @note PSPDFLibrary is not available in PSPDFKit Viewer.
/// @warning Processing PDFs takes quite some memory. We advise against running this in the background on an iPad 1, due to its hard memory limitations.
@interface PSPDFLibrary : NSObject

/// @name Initialization

/// There can be many libraries, but usually one is enough.
+ (instancetype)defaultLibrary;

/// Returns an library for this given path.
/// If no instance for this path exists yet, this method will create and return one. All subsequent calls will return the same method. Hence there will only be one instance per path.
/// This method will return nil for invalid paths.
+ (instancetype)libraryWithPath:(NSString *)path;

/// @name Properties

/// Path to the current database.
@property (nonatomic, copy, readonly) NSString *path;

/// This property customizes what tokenizer should be used. Defaults to the 'unicode61' tokenizer.
/// The UNICODE61 tokenizer allows searching inside text with diacritics. http://swwritings.com/post/2013-05-04-diacritics-and-fts
/// Sadly, Apple doesn't ship this tokenizer with their sqlite builds. PSPDFKit will detect custom versions of sqlite and use the 'unicode61' tokenizer whenever possible, falling back to the default ("simple") tokenizer if not. For the default tokenizer PSPDFKit will utilize CFStringTransform() to strip combining marks and improve searchability. This is slower and modifies the content, compared to the unicode61 tokenizer. If your content only contains English language, it might not make a difference what tokenizer you are using.
/// Read more about this at https://github.com/PSPDFKit/PSPDFKit-Demo/wiki/How-to-enable-the-unicode61-tokenizer
/// @warning Once the database is created, changing the `tokenizer` property won't have any effect.
@property (nonatomic, copy) NSString *tokenizer;

/// Will save fonts and glyph position data as well. Defaults to NO.
/// @note If enabled, the sqlite cache will be about 10x bigger than with simple text indexing, but subsequent searches will be faster.
@property (atomic, assign) BOOL saveGlyphPositions;

/// Will save a reversed copy of the original page text. Defaults to YES.
/// @note If enabled, the sqlite cache will be about 2x bigger, but ends-with matches will be enabled.
@property (atomic, assign) BOOL saveReversedPageText;

/// @name Library Operations

// Option key. Allows to limit the number of document results.
extern NSString *const PSPDFLibraryMaximumSearchResultsTotalKey;
extern NSString *const PSPDFLibraryMaximumSearchResultsPerDocumentKey;

/// Query the database for a match of `searchString`. Only direct matches, begins-with and ends-with matches are supported.
/// Returns a dictionary of UID->NSIndexSet of page numbers.
/// @note Ends-with matches are only possible if saveReversedPageText has been YES while the document was indexed.
- (void)documentUIDsMatchingString:(NSString *)searchString options:(NSDictionary *)options completionHandler:(void (^)(NSString *searchString, NSDictionary *resultSet))completionHandler;

/// @name Index Status

/// Returns indexing status. If status is 'PSPDFLibraryIndexStatusPartialAndIndexing' progress will be set as well.
- (PSPDFLibraryIndexStatus)indexStatusForUID:(NSString *)UID withProgress:(CGFloat *)outProgress;

/// Returns YES if library is currently indexing.
- (BOOL)isIndexing;

/// Returns all queued and indexing UIDs.
- (NSArray *)queuedUIDs;

/// @name Queue Operations

/// Queue `documents` for indexing.
- (void)enqueueDocuments:(NSArray *)documents;

/// Invalidates the search index for `UID`.
- (void)removeIndexForUID:(NSString *)UID;

/// Clear all database objects. Will clear ALL content in `path`.
- (void)clearAllIndexes;

@end
