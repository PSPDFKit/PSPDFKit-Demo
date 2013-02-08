//
//  PSPDFPlayButtonItem.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#define kPSPDFSlideshowDuration 2.0f

// Adds a play/pause button that can enable a slideshow mode for pdf documents.
@interface PSCPlayBarButtonItem : PSPDFBarButtonItem

@property (nonatomic, assign, getter=isAutoplaying) BOOL autoplaying;

@end
