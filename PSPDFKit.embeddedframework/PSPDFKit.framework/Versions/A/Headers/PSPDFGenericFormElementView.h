//
//  PSPDFGenericFormElementView.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>
#import "PSPDFKitGlobal.h"
#import "PSPDFHostingAnnotationView.h"
#import "PSPDFFormInputAccessoryView.h"

@class PSPDFPageView, PSPDFFormElement;

@interface PSPDFGenericFormElementView : PSPDFHostingAnnotationView <PSPDFFormInputAccessoryViewDelegate>

/// Associated weak reference to then `PSPDFPageView`.
@property (nonatomic, weak) PSPDFPageView *pageView;

@end

@interface PSPDFGenericFormElementView (Private)

// Internal used accessory view.
@property (nonatomic, strong, readonly) PSPDFFormInputAccessoryView *inputAccessoryView;

// Same as `self.annotation` but properly casted.
@property (nonatomic, strong, readonly) PSPDFFormElement *formElement;

@end
