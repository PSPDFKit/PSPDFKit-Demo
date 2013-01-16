//
//  PSPDFPrintBarButtonItem.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFBarButtonItem.h"

typedef NS_OPTIONS(NSUInteger, PSPDFPrintOptions) {
    PSPDFPrintOptionsDocumentOnly       = 1<<0,
    PSPDFPrintOptionsIncludeAnnotations = 1<<1
};

@interface PSPDFPrintBarButtonItem : PSPDFBarButtonItem <UIPrintInteractionControllerDelegate>

/// Defines what we are sending. If more than one option is set, user will get a dialog to choose.
/// Defaults to PSPDFPrintOptionsDocumentOnly | PSPDFPrintOptionsIncludeAnnotations.
@property (nonatomic, assign) PSPDFPrintOptions printOptions;

@end
