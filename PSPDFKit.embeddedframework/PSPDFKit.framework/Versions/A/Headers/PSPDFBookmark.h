//
//  PSPDFBookmark.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFModel.h"

/**
 A bookmark is a simple object that encapsulates a page and a name.

 @warning: Bookmarks don't have any representation in the PDF standard, thus they are saved in an external file.
  */
@interface PSPDFBookmark : PSPDFModel

/// Designated initializer.
- (id)initWithPage:(NSUInteger)page;

/// The page this bookmark links to.
@property (nonatomic, assign) NSUInteger page;

/// Bookmark can have a name. This is optional and can be displayed on the PSPDFBookmarkViewController.
@property (nonatomic, copy) NSString *name;

/// Returns "Page X" or name.
- (NSString *)pageOrNameString;

@end
