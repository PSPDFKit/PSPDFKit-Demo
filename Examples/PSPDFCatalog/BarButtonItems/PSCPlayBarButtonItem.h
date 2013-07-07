//
//  PSPDFPlayButtonItem.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#define kPSPDFSlideshowDuration 2.0f

// Adds a play/pause button that can enable a slideshow mode for pdf documents.
@interface PSCPlayBarButtonItem : PSPDFBarButtonItem

@property (nonatomic, assign, getter=isAutoplaying) BOOL autoplaying;

@end
