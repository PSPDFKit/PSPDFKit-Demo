//
//  PSPDFQuickLookViewController.h
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/26/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <QuickLook/QuickLook.h>

// example controller that uses QuickLook to display a pdf (instead of the PSPDFKit engine)
@interface PSPDFQuickLookViewController : QLPreviewController<QLPreviewControllerDataSource, QLPreviewControllerDelegate> {
    PSPDFDocument *document_;
}

@property(nonatomic, strong, readonly) PSPDFDocument *document;

@end


@interface PSPDFQuickLookMagazineContainer: NSObject<QLPreviewItem> {
    __unsafe_unretained PSPDFDocument *document_;
}
@property(nonatomic, unsafe_unretained) PSPDFDocument *document;
@end
