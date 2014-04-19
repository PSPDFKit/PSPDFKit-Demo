//
//  PSPDFLogging.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PSPDFLogLevelMask) {
    PSPDFLogLevelMaskNothing  = 0,
    PSPDFLogLevelMaskError    = 1 << 0,
    PSPDFLogLevelMaskWarning  = 1 << 1,
    PSPDFLogLevelMaskInfo     = 1 << 2,
    PSPDFLogLevelMaskVerbose  = 1 << 3,
    PSPDFLogLevelMaskAll      = UINT_MAX
};

/// Set the global PSPDFKit log level. Defaults to `PSPDFLogLevelMaskError|PSPDFLogLevelMaskWarning`.
/// @warning Setting this to Verbose will severely slow down your application.
extern PSPDFLogLevelMask PSPDFLogLevel;
