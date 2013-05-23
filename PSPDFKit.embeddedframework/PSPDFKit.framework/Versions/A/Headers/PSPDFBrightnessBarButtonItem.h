//
//  PSPDFBrightnessBarButtonItem.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBarButtonItem.h"

@class PSPDFBrightnessViewController;

/// Controls the system brightness.
@interface PSPDFBrightnessBarButtonItem : PSPDFBarButtonItem

/// Allows customization of the brightness controller before it's displayed. (e.g. set custom body text)
@property (nonatomic, copy) void (^brightnessControllerCustomizationBlock)(PSPDFBrightnessViewController *);

@end
