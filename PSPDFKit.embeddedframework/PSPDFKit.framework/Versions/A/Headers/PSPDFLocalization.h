//
//  PSPDFLocalization.h
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

// Returns the (localized) name of the current app.
extern NSString *PSPDFAppName(void);

/// Localizes strings.
/// Will first look up the string in the PSPDFKit.bundle
extern NSString *PSPDFLocalize(NSString *stringToken);

/// Same as `PSPDFLocalize()` but will add an ellipsis (...) at the end.
extern NSString *PSPDFLocalizeWithEllipsis(NSString *stringToken);

/// Allows to set a custom dictionary that contains dictionaries with language locales.
/// Will override localization found in the bundle, if a value is found.
/// Falls back to "en" if localization key is not found in dictionary.
extern void PSPDFSetLocalizationDictionary(NSDictionary *localizationDict);

/// Register a custom block that handles translation.
/// If this block is NULL or returns nil, the PSPDFKit.bundle + localizationDict will be used.
extern void PSPDFSetLocalizationBlock(NSString *(^localizationBlock)(NSString *stringToLocalize));

// Will load an image from the bundle. Will auto-manage legacy images and bundle directory.
extern UIImage *PSPDFBundleImage(NSString *imageName);

/// Register a custom block to return custom images.
/// If this block is NULL or returns nil, PSPDFKit.bundle will use for the lookup.
/// @note Images are cached, so don't return different images for the same `imageName` during an app session.
extern void PSPDFSetBundleImageBlock(UIImage *(^imageBlock)(NSString *imageName));
