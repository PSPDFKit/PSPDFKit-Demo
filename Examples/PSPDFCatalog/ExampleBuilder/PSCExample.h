//
//  PSCExample.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PSCExampleCategory) {
    PSCExampleCategoryAnnotations,
    PSCExampleCategoryBarButtons,
    PSCExampleCategoryViewCustomization
};

typedef NS_OPTIONS(NSInteger, PSCExampleTargetDeviceMask) {
    PSCExampleTargetDeviceMaskPhone = 1 << 0,
    PSCExampleTargetDeviceMaskPad   = 1 << 1
};

extern NSString *PSPDFStringFromExampleCategory(PSCExampleCategory category);

// Base class for examples.
@interface PSCExample : NSObject

// The example title. Mandatory.
@property (nonatomic, copy) NSString *title;

// The example description. Optional.
@property (nonatomic, copy) NSString *description;

// The category for this example.
@property (nonatomic, assign) PSCExampleCategory category;

// Target device. Defaults to PSCExampleTargetDeviceMaskPhone|PSCExampleTargetDeviceMaskPad.
@property (nonatomic, assign) PSCExampleTargetDeviceMask targetDevice;

// Builds the sample and returns a new view controller that will then be pushed.
- (UIViewController *)invoke;

@end
