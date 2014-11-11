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
    PSPDFLogLevelMaskNothing      = 0,

    /// Logs critical issues. Should never be disabled.
    PSPDFLogLevelMaskError        = 1 << 0,

    /// Logs issues that are not critical but log-worthy.
    PSPDFLogLevelMaskWarning      = 1 << 1,

    /// Logs important operations.
    PSPDFLogLevelMaskInfo         = 1 << 2,

    /// Will log almost everything and slow down the application flow.
    PSPDFLogLevelMaskVerbose      = 1 << 3,

    /// Might log security related details like signature points.
    /// Never enable this in release builds unless they are solely for testing.
    PSPDFLogLevelMaskExtraVerbose = 1 << 4,

    /// Enables all logging categories.
    PSPDFLogLevelMaskAll          = UINT_MAX
};

/// Set the global PSPDFKit log level. Defaults to `PSPDFLogLevelMaskError|PSPDFLogLevelMaskWarning`.
/// @warning Setting this to `PSPDFLogLevelMaskVerbose` will severely slow down your application.
extern PSPDFLogLevelMask PSPDFLogLevel;
