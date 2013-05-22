//
//  PSPDFPlayButtonItem.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#define kPSPDFSlideshowDuration 2.0f

// Adds a play/pause button that can enable a slideshow mode for pdf documents.
@interface PSCPlayBarButtonItem : PSPDFBarButtonItem

@property (nonatomic, assign, getter=isAutoplaying) BOOL autoplaying;

@end
