//
//  PSPDFDigitalSignatureBuildProperties.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFModel.h"

@class PSPDFDigitalSignatureBuildData;

@interface PSPDFDigitalSignatureBuildProperties : PSPDFModel

/// (Optional; PDF 1.5) A build data dictionary (Table 2.2) for the signature handler that was used to create the parent signature. This entry is optional but highly recommended for all signatures.
@property (nonatomic, strong, readonly) PSPDFDigitalSignatureBuildData *filter;

/// (Optional; PDF 1.5) A build data dictionary (Table 2.2) for the PubSec software module that was used to create the parent signature.
@property (nonatomic, strong, readonly) PSPDFDigitalSignatureBuildData *pubSec;

/// (Optional; PDF 1.5) A build data dictionary (Table 2.2) for the PDF/SigQ Conformance Checker that was used to create the parent signature.
@property (nonatomic, strong, readonly) PSPDFDigitalSignatureBuildData *app;

/// (Optional; PDF 1.7) A build data dictionary (Table 2.2) for the PDF/SigQ Specification and Conformance Checker that was used to create the parent signature. This entry is present only if the document conforms to the version of the PDF/SigQ specification indicated by the upper 16 bits of the R entry in this dictionary
@property (nonatomic, strong, readonly) PSPDFDigitalSignatureBuildData *sigQ;

@end
