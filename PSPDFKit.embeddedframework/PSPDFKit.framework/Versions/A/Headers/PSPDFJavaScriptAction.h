//
//  PSPDFJavaScriptAction.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAction.h"

@class PSPDFViewController;

@interface PSPDFJavaScriptAction : PSPDFAction

/// Designated initializer.
- (id)initWithScript:(NSString *)script;
- (id)initWithPDFDictionary:(CGPDFDictionaryRef)actionDictionary documentRef:(CGPDFDocumentRef)documentRef;

/// The javascript content.
@property (nonatomic, copy) NSString *script;

/// Tries to execute the JavaScript in the context of a view controller.
/// Execution is asynchronous and calls the passed completion block when complete
- (void)executeScriptAppliedToViewController:(PSPDFViewController *)viewController finished:(void (^)())done;

/// Tries to execute an arbirary script not attached to a specific action in the context of a view controller.
/// Execution is asynchronous and calls the passed completion block when complete
/// Used for testing purposes. Do not use for scripts that ref Event objects.
+ (void)executeScript:(NSString *)script appliedToViewController:(PSPDFViewController *)viewController finished:(void (^)())done;

@end
