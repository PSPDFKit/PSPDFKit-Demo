//
//  PSPDFResetFormAction.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAbstractFormAction.h"

typedef NS_OPTIONS(NSUInteger, PSPDFResetFormActionFlag) {
    PSPDFResetFormActionFlagIncludeExclude = 1 << (1-1),
};

/// Reset Form Action
@interface PSPDFResetFormAction : PSPDFAbstractFormAction

/// Designated initializers.
- (id)init;
- (id)initWithPDFDictionary:(CGPDFDictionaryRef)actionDictionary documentRef:(CGPDFDocumentRef)documentRef;

/// The reset form action flags.
@property (nonatomic, assign) PSPDFResetFormActionFlag flags;

@end
