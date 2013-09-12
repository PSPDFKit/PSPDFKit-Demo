//
//  PSPDFFormRequest.h
//  PSPDFKit
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

typedef NS_OPTIONS(NSUInteger, PSPDFSubmitFormActionFormat) {
    PSPDFSubmitFormActionFormatFDF,
    PSPDFSubmitFormActionFormatXFDF,
    PSPDFSubmitFormActionFormatHTML,
    PSPDFSubmitFormActionFormatPDF,
};

#import <Foundation/Foundation.h>

@interface PSPDFFormRequest : NSObject

- (id)initWithFormat:(PSPDFSubmitFormActionFormat)format values:(NSDictionary *)values request:(NSURLRequest *)request;

/// How the form data is to be encoded in the submission.
@property (nonatomic, readonly) PSPDFSubmitFormActionFormat submissionFormat;

/// Keys and values of the data to be submitted.
@property (nonatomic, readonly) NSDictionary *formValues;

/// The URL request that will be used to fulfill the submission.
@property (nonatomic, readonly) NSURLRequest *request;

@end
