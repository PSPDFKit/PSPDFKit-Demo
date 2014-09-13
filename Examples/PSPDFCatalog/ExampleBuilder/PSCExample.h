//
//  PSCExample.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

@import Foundation;

@protocol PSCExampleRunnerDelegate <NSObject>

- (UIViewController *)currentViewController;

@end

typedef NS_ENUM(NSInteger, PSCExampleCategory) {
    PSCExampleCategoryMultimedia,
    PSCExampleCategoryAnnotations,
    PSCExampleCategoryAnnotationProviders,
    PSCExampleCategoryForms,
    PSCExampleCategoryBarButtons,
    PSCExampleCategoryViewCustomization,
    PSCExampleCategoryStoryboards,
    PSCExampleCategoryTextExtraction,
    PSCExampleCategoryControllerCustomization,
    PSCExampleCategoryPageRange,
    PSCExampleCategoryDocumentDataProvider,
    PSCExampleCategoryTests
};

typedef NS_OPTIONS(NSInteger, PSCExampleTargetDeviceMask) {
    PSCExampleTargetDeviceMaskPhone = 1 << 0,
    PSCExampleTargetDeviceMaskPad   = 1 << 1
};

extern NSString *PSPDFHeaderFromExampleCategory(PSCExampleCategory category);
extern NSString *PSPDFFooterFromExampleCategory(PSCExampleCategory category);

// Base class for examples.
@interface PSCExample : NSObject

// The example title. Mandatory.
@property (nonatomic, copy) NSString *title;

// The example description. Optional.
@property (nonatomic, copy) NSString *contentDescription;

// The category for this example.
@property (nonatomic, assign) PSCExampleCategory category;

// Target device. Defaults to PSCExampleTargetDeviceMaskPhone|PSCExampleTargetDeviceMaskPad.
@property (nonatomic, assign) PSCExampleTargetDeviceMask targetDevice;

// The priority of this example.
@property (nonatomic, assign) NSInteger priority;

// Builds the sample and returns a new view controller that will then be pushed.
- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate;

@end
