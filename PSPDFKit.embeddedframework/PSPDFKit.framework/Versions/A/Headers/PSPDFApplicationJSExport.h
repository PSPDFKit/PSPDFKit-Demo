//
//  PSPDFApplicationJSExport.h
//  PSPDFKit
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@class PSPDFFormElement;

// `JSExport` is an empty protocol, we extend it and add methods we and exposed in Javascript for the application object
// (Usually, this will be the `PSPDFViewController`)
@protocol PSPDFApplicationJSExport <JSExport, NSObject>

/* There are three cases for methods we wish to export to JavaScript.

 1) The method exists for `PSPDFViewController` and the exported method name should be the same
 eg. `- (NSUInteger)displayingPage`

 In this case, it is not needed to add the method to the category implementing the protocol, since it's already implemented.
 This approach is avoided to promote a clear and controlled interface between JS and PSPDFKit.

 2) The method exists for `PSPDFViewController` but the name must change.

 In this case, we use the following macro: `JSExportAs(PropertyName, Selector)`
 eg.
 ```
 JSExportAs(doFoo,
 - (void)doFoo:(id)foo withBar:(id)bar
 );
 ```

 3) The method does no exist for `PSPDFViewController`

 In this case, we simply add the method both to the protocol and the category and finally implement the method.
 */

// doc

@property (nonatomic) NSUInteger pageNum;
- (PSPDFFormElement *)getField:(NSString *)name;
- (void)print:(id)params;
- (void)mailDoc:(id)params;

// app

- (void)alert:(id)params;

JSExportAs(buttonImportIcon, - (NSInteger)buttonImportIcon:(NSString *)cPath page:(NSNumber *)nPage sourceForm:(PSPDFFormElement *)formElement);
JSExportAs(launchURL, - (void)launchURL:(NSString *)cURL newFrame:(NSNumber *)bNewFrame);

@end
