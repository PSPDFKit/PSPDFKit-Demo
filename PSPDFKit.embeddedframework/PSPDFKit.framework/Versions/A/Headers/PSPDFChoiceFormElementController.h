//
//  PSPDFChoiceFormElementController.h
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
#import "PSPDFChoiceEditorViewController.h"

@class PSPDFChoiceFormElementController, PSPDFChoiceFormElement;

@protocol PSPDFChoiceFormElementControllerDelegate <NSObject>

- (void)choiceFormElementController:(PSPDFChoiceFormElementController *)choiceFormElementController dismissPopoverAnimated:(BOOL)animated;

@end

// Manages the interaction with the choice editor view controller.
@interface PSPDFChoiceFormElementController : NSObject <PSPDFChoiceEditorViewControllerDataSource, PSPDFChoiceEditorViewControllerDelegate>

- (instancetype)initWithChoiceFormElement:(PSPDFChoiceFormElement *)choiceFormElement
                                 delegate:(id<PSPDFChoiceFormElementControllerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

// The choice form element that is managed.
@property (nonatomic, strong, readonly) PSPDFChoiceFormElement *choiceFormElement;

// The attached delegate.
@property (nonatomic, weak, readonly) id <PSPDFChoiceFormElementControllerDelegate> delegate;

@end
