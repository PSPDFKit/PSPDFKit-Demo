//
//  PSPDFRemoteGoToAction.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAction.h"

@class PSPDFDocument;

/// Defines the action to go to a specific page from another PDF document (optionally also to a predefined page)
/// This covers both RemoteGoTo and Launch actions.
@interface PSPDFRemoteGoToAction : PSPDFAction

/// Will create a PSPDFActionTypeRemoteGoTo. (Link to another document)
- (id)initWithRemotePath:(NSString *)remotePath pageIndex:(NSUInteger)pageIndex;
- (id)initWithPDFDictionary:(CGPDFDictionaryRef)actionDictionary documentRef:(CGPDFDocumentRef)documentRef isLaunch:(BOOL)launch;

/// Path to the PDF.
@property (nonatomic, copy) NSString *relativePath;

/// Target page. Ignored if invalid or set to NSNotFound.
@property (nonatomic, assign) NSUInteger pageIndex;

@end
