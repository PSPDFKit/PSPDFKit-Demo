//
//  PSPDFPageInfo.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class PSPDFDocumentProvider;

typedef NS_ENUM(NSUInteger, PSPDFPageTriggerEvent) {
    PSPDFPageTriggerEventOpen, // O (0) Action to be performed when the page is opened.
    PSPDFPageTriggerEventClose // C (1) Action to be performed when the page is closed.
};

/// Represents PDF page data. Managed within `PSPDFDocumentProvider`.
@interface PSPDFPageInfo : NSObject <NSCopying, NSSecureCoding>

/// Init object with page and rotation.
- (instancetype)initWithPage:(NSUInteger)page rect:(CGRect)pageRect rotation:(NSInteger)rotation documentProvider:(PSPDFDocumentProvider *)documentProvider NS_DESIGNATED_INITIALIZER;

/// Referenced page, relative to the document provider.
@property (nonatomic, assign, readonly) NSUInteger page;

/// Referenced document provider.
@property (nonatomic, weak, readonly) PSPDFDocumentProvider *documentProvider;

/// Saved aspect ratio of current page.
@property (nonatomic, assign, readonly) CGRect rect;

/// Saved page rotation of current page. Value between 0 and 270.
/// Can be used to manually rotate pages (but needs a cache clearing and a reload)
/// On setting this, `rotationTransform` will be updated.
@property (nonatomic, assign, readonly) NSUInteger rotation;

/// Defines additional page actions.
/// Key is `PSPDFPageTriggerEvent`, value a `PSPDFAction` instance.
@property (nonatomic, copy, readonly) NSDictionary *additionalActions;

/// Returns corrected, rotated bounds of `rect`. Calculated.
@property (nonatomic, assign, readonly) CGRect rotatedRect;

/// Page transform matrix. Calculated.
@property (nonatomic, assign, readonly) CGAffineTransform rotationTransform;

/// Compare.
- (BOOL)isEqualToPageInfo:(PSPDFPageInfo *)otherPageInfo;

@end

/// Convert a view point to a pdf point. `bounds` is from the view. (usually `PSPDFPageView.bounds`)
extern CGPoint PSPDFConvertViewPointToPDFPoint(CGPoint viewPoint, CGRect cropBox, NSUInteger rotation, CGRect bounds);

/// Convert a pdf point to a view point.
extern CGPoint PSPDFConvertPDFPointToViewPoint(CGPoint pdfPoint, CGRect cropBox, NSUInteger rotation, CGRect bounds);

/// Convert a pdf rect to a normalized view rect.
extern CGRect PSPDFConvertPDFRectToViewRect(CGRect pdfRect, CGRect cropBox, NSUInteger rotation, CGRect bounds);

/// Convert a view rect to a normalized pdf rect.
extern CGRect PSPDFConvertViewRectToPDFRect(CGRect viewRect, CGRect cropBox, NSUInteger rotation, CGRect bounds);
