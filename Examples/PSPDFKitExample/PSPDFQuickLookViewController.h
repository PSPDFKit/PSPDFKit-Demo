//
//  PSPDFQuickLookViewController.h
//  PSPDFKitExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import <QuickLook/QuickLook.h>

// example controller that uses QuickLook to display a pdf (instead of the PSPDFKit engine)
@interface PSPDFQuickLookViewController : QLPreviewController<QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property(nonatomic, strong, readonly) PSPDFDocument *document;

@end


@interface PSPDFQuickLookMagazineContainer: NSObject<QLPreviewItem> {
    __ps_weak PSPDFDocument *_document;
}
@property(nonatomic, ps_weak) PSPDFDocument *document;
@end
