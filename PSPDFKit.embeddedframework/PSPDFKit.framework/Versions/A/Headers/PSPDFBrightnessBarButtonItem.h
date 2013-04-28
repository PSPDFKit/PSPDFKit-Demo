//
//  PSPDFBrightnessBarButtonItem.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFBarButtonItem.h"

@class PSPDFBrightnessViewController;

/// Controls the system brightness.
@interface PSPDFBrightnessBarButtonItem : PSPDFBarButtonItem

/// Allows customization of the brightness controller before it's displayed. (e.g. set custom body text)
@property (nonatomic, copy) void (^brightnessControllerCustomizationBlock)(PSPDFBrightnessViewController *);

@end
