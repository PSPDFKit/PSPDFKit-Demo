//
//  PSPDFDigitalSignatureBuildData.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFModel.h"

@interface PSPDFDigitalSignatureBuildData : PSPDFModel

/// (Optional; PDF 1.5) The name of the software module used to create the signature. When used as an entry in the data dictionary of the Filter attribute (Table 2.1), the value is the name of the signature handler. The value is normally equal to the value of the Filter attribute in the signature dictionary.
@property (nonatomic, copy, readonly) NSString *name;

/// (Optional; PDF 1.5) The software module build date. This string is normally produced by the compiler that is used to compile the software, for example using the Date and Time preprocessor flags. As such, this not likely to be in PDF Date format.
@property (nonatomic, copy, readonly) NSString *date;

/// (Optional; PDF 1.5) The software module revision number. It is important that signature handlers and other software modules specify a unique value for R for every publicly available build of the software. If the module or handler is ever found to have been defective, for signatures where the value of PreRelease is false, the value of this attribute is likely to be the only way to detect that the signature was created with the defective release. A sample value might be 0x00020014, for software module version 2, sub-build 0x14. Various software modules may use this entry differently. When present in the SigQ build data dictionary, the upper 16 bits of this value indicate the version of the PDF/SigQ Specification to which the viewing application’s PDF/SigQ Conformance Checker was written, and the lower 16 bits indicate the implementation version for the Conformance Checker.
@property (nonatomic, assign, readonly) NSUInteger revisionNumber;

/// (Optional; PDF 1.5) Indicates the operating system, such as Win98. Currently there is no specific string format defined for the value of this attribute.
@property (nonatomic, copy, readonly) NSArray *os;

// (Optional; PDF 1.5) A flag that can be used by the signature handler or software module to indicate that this signature was created with unreleased software. If true, this signature was created with pre-release or otherwise unreleased software. The default value is false.
@property (nonatomic, strong, readonly) NSNumber *preRelease;

/// (Optional; PDF 1.5) If there is a Legal dictionary in the catalog of the PDF file, and the NonEmbeddedFonts attribute (which specifies the                                               number of fonts not embedded) in that dictionary has a non-zero value, and the viewing application has a preference set to suppress the display of the warning about fonts not being embedded, then the value of this attribute will be set to true (meaning that no warning need be displayed).
@property (nonatomic, strong, readonly) NSNumber *nonEFontNoWarn;

/// (Optional; PDF 1.5) If the value is true, the application was in trusted mode when signing took place. The default value is false. A viewing application is in trusted mode when only reviewed code is executing, where reviewed code is code that does not affect the rendering of PDF files in ways that are not covered by the PDF Reference.
@property (nonatomic, strong, readonly) NSNumber *trustedMode;

/// (Optional; PDF 1.5; Deprecated for PDF 1.7) Indicates the minimum version number of the software required to process the signature. (This attribute introduced behavior that was not consistent with the PDF 1.7 requirement of being independent of software implementation. Use of this attribute is now deprecated.
@property (nonatomic, assign, readonly) NSUInteger versionMinimum;

/// Additional entry in the build data dictionary when used as the App dictionary in a build properties dictionary. (Optional; PDF 1.6) A text string indicating the version of the application implementation, as described by the Name attribute in this dictionary. When set by Adobe acobat, this entry is in the format: major.minor.micro (for example 7.0.7).
@property (nonatomic, copy, readonly) NSString *rEx;

@end
