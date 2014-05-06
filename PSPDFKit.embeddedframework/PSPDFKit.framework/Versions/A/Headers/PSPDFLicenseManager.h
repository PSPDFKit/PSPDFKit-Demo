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

typedef NS_OPTIONS(NSUInteger, PSPDFFeatureMask) {
    PSPDFFeatureMaskNone              = 0,
    PSPDFFeatureMaskPDFViewer         = 1 << 0, // View PDFs without watermark. PSPDFKit Viewer.
    PSPDFFeatureMaskTextSelection     = 1 << 1, // Text Selection. Basic.
    PSPDFFeatureMaskStrongEncryption  = 1 << 2, // Not available in the demo. Basic.
    PSPDFFeatureMaskPDFCreation       = 1 << 3, // Create PDF documents. Basic.
    PSPDFFeatureMaskAnnotationEditing = 1 << 4, // Edit/Create annotations. Basic.
    PSPDFFeatureMaskAcroForms         = 1 << 5, // PDF Forms. PSPDFKit Complete.
    PSPDFFeatureMaskIndexedFTS        = 1 << 6, // Limited to 100 chars/page in the demo.
    PSPDFFeatureMaskAll               = UINT_MAX,
};

#ifdef __cplusplus
extern "C" {
#endif

/// Should be set directly in `application:didFinishLaunchingWithOptions:` to enable PSPDFKit, or at latest before any PSPDF* classes are used. Call from the main thread.
/// @return feature mask available for the give license key.
extern PSPDFFeatureMask PSPDFSetLicenseKey(const char *licenseKey);

#ifdef __cplusplus
}
#endif
