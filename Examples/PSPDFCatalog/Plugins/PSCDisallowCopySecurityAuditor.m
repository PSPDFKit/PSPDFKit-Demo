//
//  PSCDisallowCopySecurityAuditor.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCDisallowCopySecurityAuditor.h"

@implementation PSCDisallowCopySecurityAuditor

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFPlugin

+ (NSDictionary *)pluginInfo {
    return @{PSPDFPluginIdentifierKey: @"com.pspdfcatalog.security.custom-auditor",
             PSPDFPluginNameKey: @"Custom Security Auditor",
             PSPDFPluginProtocolVersionKey : @(PSPDFPluginProtocolVersion_1),

             // *** Remove this key to actually enable the plugin. ***
             // PSPDFKit will discover this class automatically.
             PSPDFPluginEnabledKey: @NO
             };
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (instancetype)initWithPluginRegistry:(id<PSPDFPluginRegistry>)pluginRegistry options:(NSDictionary *)options {
    if ((self = [super init])) {
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFSecurityAuditor

- (BOOL)hasPermissionForEvent:(PSPDFSecurityEvent)event isUserAction:(BOOL)isUserAction {
    if (event == PSPDFSecurityEventCopyPaste) {
        return NO;
    }
    return YES;
}

@end
