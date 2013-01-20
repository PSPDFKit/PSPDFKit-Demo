//
//  PSPDFOutlineBarButtonItem.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFBarButtonItem.h"

@interface PSPDFOutlineBarButtonItem : PSPDFBarButtonItem

/// Some PSPDFBarButtonItem are designed for performance, they will perform check on a background thread and update later.
/// The evaluation IF we can actually show a outline is done async, so initially isAvailable will be YES always.
/// Use this blocking check to make a synchronous check for the availability.
- (BOOL)isAvailableBlocking;

@end
