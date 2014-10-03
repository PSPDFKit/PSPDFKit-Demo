//
//  PSPDFBookmarkParser.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

@class PSPDFBookmark, PSPDFDocument;

/// Register to get notified by bookmark changes. Object is the `PSPDFBookmarkParser` object.
/// @warning Post only from the main thread!
extern NSString *const PSPDFBookmarksChangedNotification;

/**
 Manages bookmarks for a `PSPDFDocument`.

 There is no notion of "bookmarks" in a PDF.
 (PDF "bookmarks" are entries in the outline (Table Of Contents); which are parsed in PSPDFKit by the `PSPDFOutlineParser.class`)

 Bookmarks are saved in <APP>/Library/PrivateDocuments/<DocumentUID>/bookmark.plist

 All calls are thread safe.
 */
@interface PSPDFBookmarkParser : NSObject

/// Designated initializer.
- (instancetype)initWithDocument:(PSPDFDocument *)document NS_DESIGNATED_INITIALIZER;

/// Contains bookmarks (`PSPDFBookmark`) for the document. Access is thread safe.
@property (nonatomic, copy) NSArray *bookmarks;

/// Associated document.
@property (nonatomic, weak) PSPDFDocument *document;

/// Adds a bookmark for `page`.
/// @note Convenience method. Will return NO if page is invalid or bookmark doesn't exist.
/// If you manually add bookmarks, you might need to call createToolbarAnimated to update.
- (BOOL)addBookmarkForPage:(NSUInteger)page;

/// Removes a bookmark for `page`.
- (BOOL)removeBookmarkForPage:(NSUInteger)page;

/// Clears all bookmarks. Also deletes file.
- (BOOL)clearAllBookmarksWithError:(NSError *__autoreleasing*)error;

/// Returns the bookmark if page has a bookmark.
- (PSPDFBookmark *)bookmarkForPage:(NSUInteger)page;

@end


@interface PSPDFBookmarkParser (SubclassingHooks)

/// Internal queue to synchronize access to the mutable bookmark array.
/// The internal type of `bookmarks` is NSMutableArray and can be modified if synchronizing with this queue.
/// @note This is still accessible for legacy reasons, but might be replaced with more fine-grained hooks.
@property (nonatomic, readonly) dispatch_queue_t bookmarkQueue;

/// Defaults to cachePath/bookmarks.plist
- (NSString *)bookmarkPath;

/// Read bookmarks out of the plist in bookmarkPath.
- (NSArray *)loadBookmarksWithError:(NSError *__autoreleasing*)error;

/// Saves the bookmark into a plist file at bookmarkPath.
/// @note Saving is done async.
- (BOOL)saveBookmarksWithError:(NSError *__autoreleasing*)error;

@end
