//
//  PSPDFBookmark.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

/**
 A Bookmark is a simple object that encapsulates a page.
 
 True, this could've been accomplished with NSNumber, but having a special object is more flexible in the long run.
 */
@interface PSPDFBookmark : NSObject <NSCopying, NSCoding>

/// Designated initializer.
- (id)initWithPage:(NSUInteger)page;

/// Page reference.
@property (nonatomic, assign) NSUInteger page;

/// Bookmark can have a name. This is optional and can be displayed on the PSPDFBookmarkViewController.
@property (nonatomic, copy) NSString *name;

/// Returns "Page X" or name.
- (NSString *)pageOrNameString;

/// Compare
- (BOOL)isEqualToBookmark:(PSPDFBookmark *)otherBookmark;

@end
