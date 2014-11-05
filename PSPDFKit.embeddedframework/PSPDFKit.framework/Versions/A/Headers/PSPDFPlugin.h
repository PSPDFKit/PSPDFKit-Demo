//
//  PSPDFPlugin.h
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

@protocol PSPDFPluginRegistry;

extern const NSUInteger PSPDFPluginProtocolVersion_1;

extern NSString * const PSPDFPluginIdentifierKey;
extern NSString * const PSPDFPluginNameKey;
extern NSString * const PSPDFPluginEnabledKey;
extern NSString * const PSPDFPluginPriorityKey;
extern NSString * const PSPDFPluginInitializeOnDiscoveryKey;
extern NSString * const PSPDFPluginSaveInstanceKey;
extern NSString * const PSPDFPluginProtocolVersionKey;

@protocol PSPDFPlugin <NSObject>

// Designated initializer. Will be called upon creation.
- (instancetype)initWithPluginRegistry:(id<PSPDFPluginRegistry>)pluginRegistry options:(NSDictionary *)options;

// Plugin details for auto-discovery.
+ (NSDictionary *)pluginInfo;

@end
