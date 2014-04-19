//
//  PSPDFDigitalSignatureDictionary.h
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
#import "PSPDFStream.h"
#import "PSPDFByteRange.h"
#import "PSPDFDigitalSignatureBuildProperties.h"

// Only available for PSPDFKit Complete with OpenSSL.
@interface PSPDFDigitalSignatureDictionary : PSPDFModel

/// (Required; inheritable) The name of the preferred signature handler to use when validating this signature. If the Prop_Build entry is not present, it is also the name of the signature handler that was used to create the signature. If Prop_Build is present, it can be used to determine the name of the handler that created the signature (which is typically the same as Filter but is not re- quired to be). An application may substitute a different handler when verify- ing the signature, as long as it supports the specified SubFilter format. Example signature handlers are Adobe.PPKLite, Entrust.PPKEF, CICI.SignIt, and VeriSign.PPKVS.
@property (nonatomic, copy, readonly) NSString *filter;

/// (Optional) A name that describes the encoding of the signature value and key information in the signature dictionary. An application may use any handler that supports this format to validate the signature. PDF 1.6 defines the following values for public-key cryptographic signatures: adbe.x509.rsa_sha1, adbe.pkcs7.detached, and adbe.pkcs7.sha1 (see Section 8.7.2, “Signature Interoperability”). Other values can be defined by third par- ty developers, subject to the restriction that all names beginning with the adbe. prefix be reserved for future versions of PDF.
@property (nonatomic, copy, readonly) NSString *subFilter;

/// (Required) The signature value. When ByteRange is present, the value is a hexadecimal string (see “Hexadecimal Strings” on page 56) representing the value of the byte range digest. If ByteRange is not present, the value is an object digest of the signature dictionary, excluding the Contents entry. For public-key signatures, Contents is commonly either a DER-encoded PKCS#1 binary data object or a DER-encoded PKCS#7 binary data object.
@property (nonatomic, copy, readonly) NSData *contents;

/// (Required when SubFilter is adbe.x509.rsa_sha1) An array of byte strings representing the X.509 certificate chain used when signing and verifying signatures that use public-key cryptography, or a byte string if the chain has only one entry. The signing certificate must appear first in the array; it is used to verify the signature value in Contents, and the other certificates are used to verify the authenticity of the signing certificate. If SubFilter is adbe.pkcs7.detached or adbe.pkcs7.sha1, this entry is not used, and the certificate chain must be put in the PKCS#7 envelope in Contents.
@property (nonatomic, copy, readonly) NSArray *certs;

/** (Required for all signatures that are part of a signature field and usage rights signatures referenced from the UR3 entry in the permissions dictionary) An array of pairs of integers (starting byte offset, length in bytes) describing the exact byte range for the digest calculation. Multiple discontiguous byte ranges are used to describe a digest that does not include the signature value (the Contents entry) itself.
 
    Representated as an array of `NSRanges`.
 */
@property (nonatomic, strong, readonly) PSPDFByteRange *byteRange;

/// (Optional; PDF 1.5) An array of signature reference dictionaries.
@property (nonatomic, copy, readonly) NSArray *references;

@property (nonatomic, assign, readonly) long changesPagesAltered;
@property (nonatomic, assign, readonly) long changesFieldsAltered;
@property (nonatomic, assign, readonly) long changesFieldsFilled;

/// (Optional) The name of the person or authority signing the document. This value should be used only when it is not possible to extract the name from the signature; for example, from the certificate of the signer.
@property (nonatomic, copy, readonly) NSString *name;

/// (Optional) The time of signing. Depending on the signature handler, this may be a normal unverified computer time or a time generated in a verifiable way from a secure time server. This value should be used only when the time of signing is not available in the signature; for example, a time stamp can be embedded in a PKCS#7 binary data object.
@property (nonatomic, strong, readonly) NSDate *timeSigned;

/// (Optional) The CPU host name or physical location of the signing.
@property (nonatomic, copy, readonly) NSString *location;

/// (Optional) The reason for the signing, such as (I agree...).
@property (nonatomic, copy, readonly) NSString *reason;

/// (Optional) Information provided by the signer to enable a recipient to contact the signer to verify the signature; for example, a phone number.
@property (nonatomic, copy, readonly) NSString *contactInfo;

/// (Optional) The version of the signature handler that was used to create the signature. Beginning with PDF 1.5, this entry is deprecated, and the information should be stored in the Prop_Build dictionary.
@property (nonatomic, assign, readonly) NSInteger versionR;

/// (Optional; PDF 1.5) The version of the signature dictionary format. It corresponds to the usage of the signature dictionary in the context of the value of SubFilter. The value is 1 if the Reference dictionary is considered critical to the validation of the signature. Default value: 0.
@property (nonatomic, assign, readonly) NSInteger versionV;

/// (Optional; PDF 1.5) A dictionary that can be used by a signature handler to record information that captures the state of the computer environment used for signing, such as the name of the handler used to create the signature, soft- ware build date, version, and operating system. Adobe publishes a separate specification, the PDF Signature Build Dictionary Specification for Acrobat 6.0 that provides implementation guidelines for the use of this dictionary.
@property (nonatomic, strong, readonly) PSPDFDigitalSignatureBuildProperties *propBuild;

@end
