//
//  PSPDFPrintBarButtonItem.h
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

typedef NS_OPTIONS(NSUInteger, PSPDFPrintOptions) {
    PSPDFPrintOptionsDocumentOnly       = 1<<0,
    PSPDFPrintOptionsIncludeAnnotations = 1<<1
};

@interface PSPDFPrintBarButtonItem : PSPDFBarButtonItem <UIPrintInteractionControllerDelegate>

/// Defines what we are sending. If more than one option is set, user will get a dialog to choose.
/// Defaults to PSPDFPrintOptionsDocumentOnly | PSPDFPrintOptionsIncludeAnnotations.
@property (nonatomic, assign) PSPDFPrintOptions printOptions;

@end
