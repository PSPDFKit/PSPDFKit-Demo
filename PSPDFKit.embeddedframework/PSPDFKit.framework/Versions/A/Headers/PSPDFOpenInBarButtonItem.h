//
//  PSPDFOpenInBarButtonItem.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFBarButtonItem.h"

/// Checking if any apps support PDF can be done, but this is slow (~300 ms on an iPad 3). Thus it's disabled by default.
/// In case there is no app and this check is disabled, a alert will be showed to the user.
/// Defaults to NO.
extern BOOL kPSPDFCheckIfCompatibleAppsAreInstalled;

/**
 Open in is only possible if the PSPDFDocument is backed by exactly one file-based PDF.
 Before sending it to another application, annotations will be saved.
 */
@interface PSPDFOpenInBarButtonItem : PSPDFBarButtonItem <UIDocumentInteractionControllerDelegate>

/// Allow content-processing to merge multiple PDF pages into one PDF, and allow saving of NSData-based documents to a temp directory?
/// Defaults to YES.
@property (nonatomic, assign) BOOL allowFileMergingAndTempFiles;

@end
