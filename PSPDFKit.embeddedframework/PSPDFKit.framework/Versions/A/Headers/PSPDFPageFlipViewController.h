//
//  PSPDFPageFlipViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFFlipViewController.h"
#import "PSPDFTransitionHelper.h"

@interface PSPDFPageFlipViewController : PSPDFFlipViewController<PSPDFTransitionProtocol>

- (id)initWithPDFController:(PSPDFViewController *)pdfController;

@end
