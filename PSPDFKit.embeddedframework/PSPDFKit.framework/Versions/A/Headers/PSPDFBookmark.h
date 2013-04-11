//
//  PSPDFBookmark.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFModel.h"

@class PSPDFAction;

/// A bookmark is a encapsulates a PDF action and a name.
/// @warning: Bookmarks don't have any representation in the PDF standard, thus they are saved in an external file.
@interface PSPDFBookmark : PSPDFModel

/// Initialize with page. Convenience initialization that will create a PSPDFActionGoTo.
- (id)initWithPage:(NSUInteger)page;

/// Initalize with action.
- (id)initWithAction:(PSPDFAction *)action;

/// The PDF action. Usually this will be of type PSPDFActionGoTo, but all action types are possible.
/// @note A PSPDFActionGoTo might has a `namedDestination` set. If so, the target page hasn't yet been resolved, use PSPDFAction to resolve.
@property (nonatomic, strong) PSPDFAction *action;

/// Convenience shortcut for self.action.pageIndex (if action is of type PSPDFActionGoTo)
/// @return NSNotFound if action is nil or a different type.
@property (nonatomic, assign) NSUInteger page;

/// Bookmark can have a name. This is optional and can be displayed on the PSPDFBookmarkViewController.
@property (nonatomic, copy) NSString *name;

/// Returns "Page X" or name.
- (NSString *)pageOrNameString;

@end

