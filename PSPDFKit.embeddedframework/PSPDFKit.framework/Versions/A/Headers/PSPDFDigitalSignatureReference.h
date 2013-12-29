//
//  PSPDFDigitalSignatureReference.h
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
#import "PSPDFModel+NSCoding.h"

/** The different transform methods (see Section 8.7.1, “Transform Methods”).
    DocMDP — Used to detect modifications to a document relative to a signature field that is signed by the originator of a document; see “DocMDP” on page 731.
    UR — Used to detect modifications to a document that would invalidate a signature in a rights-enabled document; see “UR” on page 733.
    FieldMDP — Used to detect modifications to a list of form fields specified in TransformParams; see “FieldMDP” on page 736.
    Identity — Used when signing a single object, which is specified by the value of Data in the signature reference dictionary (see Table 8.103). This transform method supports signing of FDF files. See “Identity” on page 737 for details.
 */
typedef NS_ENUM(NSUInteger, PSPDFDigitalSignatureReferenceTransformMethod) {
    PSPDFDigitalSignatureReferenceTransformMethodDocMDP   = 1 << (1-1),
    PSPDFDigitalSignatureReferenceTransformMethodUR       = 1 << (2-1),
    PSPDFDigitalSignatureReferenceTransformMethodFieldMDP = 1 << (3-1),
    PSPDFDigitalSignatureReferenceTransformMethodIdentity = 1 << (4-1)
};

@interface PSPDFDigitalSignatureReference : PSPDFModel

- (id)initWithDictionary:(CGPDFDictionaryRef)dict;

/// (Required) The name of the transform method (see Section 8.7.1, “Transform Methods”) that guides the object digest computation or modification analysis that takes place when the signature is validated.
@property (nonatomic, assign) PSPDFDigitalSignatureReferenceTransformMethod transformMethod;

/// (Optional) A dictionary specifying transform parameters (variable data) for the transform method specified by TransformMethod. Each method except Identity takes its own set of parameters. See each of the sections specified above for details on the individual transform parameter dictionaries
@property (nonatomic, strong) NSDictionary *transformParams;

/// (Required when TransformMethod is FieldMDP or Identity) An indirect reference to the object in the document over which the digest was computed or upon which the object modification analysis should be performed. For transform methods other than FieldMDP and Identity, this object is implicitly defined.
@property (nonatomic, assign) CGPDFObjectRef data;

/// (Optional) A name identifying the algorithm to be used when computing the digest. Valid values are MD5 and SHA1. (See implementation note 144 in Appendix H.) Default value: MD5.
@property (nonatomic, strong) NSString *digestMethod;

/// (Required in some situations) When present, the computed value of the digest. See Section 8.7.1, “Transform Methods, for details on when this entry is required.
@property (nonatomic, strong) NSString *digestValue;

/// (Required when DigestValue is required and TransformMethod is FieldMDP or DocMDP) An array of two integers specifying the location in the PDF file of the DigestValue string. The integers represent the starting offset and length in bytes, respectively. This entry is required when DigestValue is written directly to the PDF file, bypassing any encryption that has been performed on the document. When specified, the values must be used to read DigestValue directly from the file during validation.
@property (nonatomic, assign) NSRange digestLocation;

@end
