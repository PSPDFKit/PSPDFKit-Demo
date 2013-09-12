//
//  PSPDFURLAction.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAction.h"

@class PSPDFAnnotationManager;

/// Opens a URL target.
/// This can be similar to a PSPDFRemoteGoToAction if a pspdfkit:// URL with a page target is used.
@interface PSPDFURLAction : PSPDFAction

/// Initializes with string, will convert to URL automatically.
- (id)initWithURLString:(NSString *)URLString;

/// Initializes with URL.
- (id)initWithURL:(NSURL *)URL;

// PDF init.
- (id)initWithPDFDictionary:(CGPDFDictionaryRef)actionDictionary documentRef:(CGPDFDocumentRef)documentRef;

/// The annotation URL target.
@property (nonatomic, strong) NSURL *URL;

/// This will convert pspdfkit:// URLS or localhost-URLs that use path tokens  into their expanded form, and will override the options dictionary with any option found in the URL. If the URL has already been processed, this will not do anything.
/// @return YES if the URL has been updated.
- (BOOL)updateURLWithAnnotationManager:(PSPDFAnnotationManager *)annotationManager;

/// @name Options Helper

/// Returns YES if the urlString has been prefixed with pspdfkit:// or another defined prefix set in PSPDFDocument.
@property (nonatomic, assign, readonly) BOOL isPSPDFPrefixed;

/// PageIndex, if defined in the options dictionary.
@property (nonatomic, assign) NSUInteger pageIndex;

/// Indicator if "modal" is set in options. Will add "modal" to options if setModal is used.
@property (nonatomic, assign, getter=isModal) BOOL modal;

/// Indicator if "popover" is set in options. Will add "popover" to options if setPopover is used.
@property (nonatomic, assign, getter=isPopover) BOOL popover;

/// Tries to extract a size out of options "size". Returns CGSizeZero if conversion fails.
@property (nonatomic, assign) CGSize size;

/// Video offset.
@property (nonatomic, assign) CGFloat offset;

@end
