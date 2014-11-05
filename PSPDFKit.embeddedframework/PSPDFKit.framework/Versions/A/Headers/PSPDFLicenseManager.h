//
//  PSPDFLicenseManager.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

// PSPDFKit uses so-called "feature flags" to unlock certain features only for certain customers.
// The license key supplied to the customer is JSON with an array of so-called "feature names".
//
// Be aware, there is no 1:1 correspondence, some deprecated feature names unlock more than one
// feature flag, and for historical reasons the feature name sometimes is different from the name
// of the feature flag.
typedef NS_OPTIONS(NSUInteger, PSPDFFeatureMask) {
    PSPDFFeatureMaskNone = 0,

    // View PDFs without watermark. Automatically enabled by every valid license key.
    PSPDFFeatureMaskPDFViewer = 1 << 0,

    // Text Selection. Was included in PSPDFKit Basic.
    // unlocked by "text_selection" and "annotations" (legacy)
    PSPDFFeatureMaskTextSelection = 1 << 1,

    // Enables `PSPDFAESCryptoDataProvider` and the various other crypto related classes.
    // (`PSPDFCryptoInputStream`, `PSPDFCryptoOutputStream`, `PSPDFAESDecryptor`, `PSPDFAESEncryptor`)
    // unlocked by "strong_encryption" and "annotations" (legacy)
    PSPDFFeatureMaskStrongEncryption = 1 << 2,

    // Create PDF documents (`PSPDFProcessor` - except flattening). Was included in PSPDFKit Basic.
    // unlocked by "pdf_creation" and "annotations" (legacy)
    PSPDFFeatureMaskPDFCreation = 1 << 3,

    // Edit/Create annotations. Was included in PSPDFKit Basic.
    // unlocked by "annotation_editing" and "annotations" (legacy)
    PSPDFFeatureMaskAnnotationEditing = 1 << 4,

    // PDF Forms display/editing. Was included in PSPDFKit Complete.
    // unlocked by "acro_forms" and "acroforms" (legacy)
    PSPDFFeatureMaskAcroForms = 1 << 5,

    // Use the indexed full-text-search. (`PSPDFLibrary`)
    // unlocked by "indexed_fts" and "fts" (legacy)
    PSPDFFeatureMaskIndexedFTS = 1 << 6,

    // Digitally Sign PDF Forms. Was included in PSPDFKit Complete.
    // unlocked by "digital_signatures" and "acroforms" (legacy)
    PSPDFFeatureMaskDigitalSignatures = 1 << 7,

    PSPDFFeatureMaskAll = UINT_MAX,
};

PSPDFKIT_EXTERN_C_BEGIN

/// Should be set directly in `application:didFinishLaunchingWithOptions:` to enable PSPDFKit, or at latest before any PSPDF* classes are used. Call from the main thread.
/// @return feature mask available for the give license key.
extern PSPDFFeatureMask PSPDFSetLicenseKey(const char *licenseKey);

PSPDFKIT_EXTERN_C_END
