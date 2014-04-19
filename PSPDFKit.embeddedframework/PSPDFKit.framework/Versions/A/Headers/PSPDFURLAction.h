//
//  PSPDFURLAction.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAction.h"

@class PSPDFAnnotationManager, MFMailComposeViewController;

/// Opens a URL target.
/// This can be similar to a `PSPDFRemoteGoToAction` if a pspdfkit:// URL with a page target is used.
@interface PSPDFURLAction : PSPDFAction

/// Initializes with string, will convert to URL automatically.
- (id)initWithURLString:(NSString *)URLString;

/// Initializes with URL.
- (id)initWithURL:(NSURL *)URL;

/// The annotation URL target.
@property (nonatomic, copy) NSURL *URL;

/// The unmodified and unparsed URL.
@property (nonatomic, copy, readonly) NSURL *unmodifiedURL;

/// This will convert pspdfkit:// URLS or localhost-URLs that use path tokens  into their expanded form, and will override the options dictionary with any option found in the URL. If the URL has already been processed, this will not do anything.
/// @return YES if the URL has been updated.
- (BOOL)updateURLWithAnnotationManager:(PSPDFAnnotationManager *)annotationManager;

/// @name Options Helper

/// Returns YES if the `URLString` has been prefixed with pspdfkit:// or another defined prefix set in `PSPDFDocument`.
@property (nonatomic, assign, readonly) BOOL isPSPDFPrefixed;

/// The page index, if defined in the options dictionary.
@property (nonatomic, assign) NSUInteger pageIndex;

/// Indicator if "modal" is set in options. Will add "modal" to options if `setModal:` is used.
@property (nonatomic, assign, getter=isModal) BOOL modal;

/// Indicator if "popover" is set in options. Will add "popover" to options if `setPopover:` is used.
@property (nonatomic, assign, getter=isPopover) BOOL popover;

/// Indicator if "button" is set in options. Will add "button" to options if `setButton:` is used.
@property (nonatomic, assign, getter=isButton) BOOL button;

/// Tries to extract a size out of options "size". Returns `CGSizeZero` if conversion fails.
@property (nonatomic, assign) CGSize size;

/// Video offset.
@property (nonatomic, assign) CGFloat offset;

/// Regenerates a pspdfkit:// style sring IF `isPSPDFPrefixed` is set.
- (NSString *)prefixedURLStringWithAnnotationManager:(PSPDFAnnotationManager *)annotationManager;

// Helper to determine if the URL is an email and to configure the mail controller for email, subject, cc, bcc and body.
- (BOOL)isEmailURL;
- (BOOL)configureMailComposeViewController:(MFMailComposeViewController *)mailComposeViewController;

@end
