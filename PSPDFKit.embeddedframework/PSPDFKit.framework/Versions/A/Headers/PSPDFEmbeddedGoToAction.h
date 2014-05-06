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


/*
 F
 file specification
 (Optional) The root document of the target relative to the root document of the source. If this entry is absent, the source and target share the same root document.
 D
 name, 􏰀 byte string, 􏰀 or array
 (Required) The destination in the target to jump to (see 12.3.2, “Destinations”).
 NewWindow
 boolean
 (Optional) If true, the destination document should be opened in a new window; if false, the destination document should replace the current document in the same window. If this entry is absent, the conforming reader should act according to its preference.
 T
 dictionary
 (Optional if F is present; otherwise required) A target dictionary (see Table 202) specifying path information to the target document. Each target dictionary specifies one element in the full path to the target and may have nested target dictionaries specifying additional elements.



 Table 202 – Entries specific to a target dictionary
 Key
 Type
 Value
 R
 name
 (Required) Specifies the relationship between the current document and the target (which may be an intermediate target). Valid values are P (the target is the parent of the current document) and C (the target is a child of the current document).
 N
 byte string
 (Required if the value of R is C and the target is located in the EmbeddedFiles name tree; otherwise, it shall be absent) The name of the file in the EmbeddedFiles name tree.
 P
 integer or 􏰀 byte string
 (Required if the value of R is C and the target is associated with a file attachment annotation; otherwise, it shall be absent) If the value is an integer, it specifies the page number (zero-based) in the current document containing the file attachment annotation. If the value is a string, it specifies a named destination in the current document that provides the page number of the file attachment annotation.
 A
 integer or text string
 (Required if the value of R is C and the target is associated with a file attachment annotation; otherwise, it shall be absent) If the value is an integer, it specifies the index (zero-based) of the annotation in the Annots array (see Table 30) of the page specified by P. If the value is a text string, it specifies the value of NM in the annotation dictionary (see Table 164).
 T
 dictionary
 (Optional) A target dictionary specifying additional path information to the target document. If this entry is absent, the current document is the target file containing the destination.
 */

@end
