//
//  PSPDFPrintBarButtonItem.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBarButtonItem.h"
#import "PSPDFDocumentSharingViewController.h"

@interface PSPDFPrintBarButtonItem : PSPDFBarButtonItem <PSPDFDocumentSharingViewControllerDelegate, UIPrintInteractionControllerDelegate>

/// Control what data is printed. If more than one option is set, user will get a dialog to choose.
/// Defaults to `PSPDFDocumentSharingOptionCurrentPageOnly|PSPDFDocumentSharingOptionAllPages|PSPDFDocumentSharingOptionEmbedAnnotations|PSPDFDocumentSharingOptionFlattenAnnotations|PSPDFDocumentSharingOptionAnnotationsSummary`.
@property (nonatomic, assign) PSPDFDocumentSharingOptions printOptions;

@end
