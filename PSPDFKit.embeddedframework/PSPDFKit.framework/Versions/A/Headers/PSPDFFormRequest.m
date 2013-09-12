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

#import "PSPDFFormRequest.h"

@implementation PSPDFFormRequest

- (id)initWithFormat:(PSPDFSubmitFormActionFormat)format values:(NSDictionary *)values request:(NSURLRequest *)request {
    if (self = [super init]) {
        _submissionFormat = format;
        _formValues = values;
        _request = request;
    }
    return self;
}

@end
