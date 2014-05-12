//
//  PSPDFEmbeddedGoToAction.h
//  PSPDFKit
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <PSPDFKit/PSPDFKit.h>

typedef NS_ENUM(NSUInteger, PSPDFEmbeddedGoToActionTarget) {
    PSPDFEmbeddedGoToActionTargetParentOfCurrentDocument, // Not yet supported
    PSPDFEmbeddedGoToActionTargetChildOfCurrentDocument
};

/// An embedded go-to action (PDF 1.6) is similar to a remote go-to action but allows jumping to or from a PDF file that is embedded in another PDF file.
@interface PSPDFEmbeddedGoToAction : PSPDFGoToAction

- (id)initWithRemotePath:(NSString *)remotePath targetRelationship:(PSPDFEmbeddedGoToActionTarget)targetRelationship openInNewWindow:(BOOL)openInNewWindow pageIndex:(NSUInteger)pageIndex;

/// Target can either be parent or child of the current document.  (T.R)
@property (nonatomic, assign, readonly) PSPDFEmbeddedGoToActionTarget targetRelationship;

/// The relative path. Only valid for `PSPDFEmbeddedGoToActionTargetChildOfCurrentDocument`. (T.N)
@property (nonatomic, copy, readonly) NSString *relativePath;

/// If set to YES, the embedded action will be opened modally. (/NewWindow)
@property (nonatomic, assign, readonly) BOOL openInNewWindow;

// Also uses `pageIndex` from the `PSPDFGoToAction` parent.

@end
