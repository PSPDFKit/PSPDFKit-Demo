//
//  PSPDFApplication.h
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
#import "PSPDFNetworkActivityIndicatorManager.h"

@protocol PSPDFApplication <NSObject>

- (BOOL)canOpenURL:(NSURL *)url;
- (void)openURL:(NSURL *)URL completionHandler:(void (^)(BOOL success))completionHandler;

@property (nonatomic, readonly) id <PSPDFNetworkActivityIndicatorManager> networkIndicatorManager;

@end
