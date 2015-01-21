//
//  PSCDisallowCopyApplicationPolicy.m
//  PSPDFCatalog
//
//  Copyright (c) 2014-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCDisallowCopyApplicationPolicy.h"

@implementation PSCDisallowCopyApplicationPolicy

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFPlugin

+ (NSDictionary *)pluginInfo {
    return @{PSPDFPluginIdentifierKey: @"com.pspdfcatalog.policy.disable-copy",
             PSPDFPluginNameKey: @"Custom Application Policy",
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

- (BOOL)hasPermissionForEvent:(NSString *)event isUserAction:(BOOL)isUserAction {
    if ([event isEqualToString:PSPDFPolicyEventPasteboard]) {
        return NO;
    }
    return YES;
}

@end
