//
//  PSPDFSecurityAuditor.h
//  PSPDFKit
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import "PSPDFPlugin.h"

typedef NS_ENUM(NSUInteger, PSPDFSecurityEvent) {
    PSPDFSecurityEventOpenIn,         // Allows Open In other apps.
    PSPDFSecurityEventPrint,          // Allows document or single page printing.
    PSPDFSecurityEventQuickLook,      // Allows QuickLook to view embedded files.
    PSPDFSecurityEventAudioRecording, // Allows audio recording.
    PSPDFSecurityEventCamera          // Allows the camera.
};

/// The security auditor protcol allows to define a custom set of overrides for various security related tasks.
@protocol PSPDFSecurityAuditor <PSPDFPlugin>

// Returns YES when the `PSPDFSecurityEvent` is allowed.
// `isUserAction` is a hint that indicates if we're in a user action or an automated test.
// If it's a user action, it is appropriate to present an alert explaining the lack of permissions.
- (BOOL)hasPermissionForEvent:(PSPDFSecurityEvent)event isUserAction:(BOOL)isUserAction;

@end

// The default security auditor simply returns YES for every request.
@interface PSPDFDefaultSecurityAuditor : NSObject <PSPDFSecurityAuditor>
@end
