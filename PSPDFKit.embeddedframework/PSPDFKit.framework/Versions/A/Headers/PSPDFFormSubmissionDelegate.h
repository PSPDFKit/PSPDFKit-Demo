//
//  PSPDFFormSubmissionDelegate.h
//  PSPDFKit
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFViewController.h"

@class PSPDFFormRequest;

/** Delegate for form submission actions. When a form submission action is run, the delegate will be queried in this order:
 * 1.  pdfViewController:shouldPresentWebViewForResponseData: -- should the view controller push a web view with the response data. If yes then the web view takes responsibility for the connection and call 4 is not made.
 * 2.  pdfViewController:shouldSubmitFormValues: -- if no then the operation is cancelled.
 * 3.  pdfViewController:willSubmitFormValues:   -- the submission is going ahead.
 * 4.a pdfViewController:didReceiveResponseData: -- the submission has completed successfully  OR
 * 4.b pdfViewController:didFailWithError:       -- the submission has failed
 */
@protocol PSPDFFormSubmissionDelegate <NSObject>

@optional

/// The user has activated a submission action, return to indicate whether it should be sent sent.
- (BOOL)pdfViewController:(PSPDFViewController *)viewController shouldSubmitFormRequest:(PSPDFFormRequest *)formRequest;

/// The user has activated a submission action, which will go ahead.
- (void)pdfViewController:(PSPDFViewController *)viewController willSubmitFormValues:(PSPDFFormRequest *)formRequest;

/// The submission connection has succeeded and the server has responded with the given data.
- (void)pdfViewController:(PSPDFViewController *)viewController didReceiveResponseData:(NSData *)responseData;

/// The submission has failed with an error.
- (void)pdfViewController:(PSPDFViewController *)viewController didFailWithError:(NSError *)error;

/// If YES is returned then a web view containing the response data will be shown.
- (BOOL)pdfViewControllerShouldPresentResponseInWebView:(PSPDFViewController *)viewController;

@end
