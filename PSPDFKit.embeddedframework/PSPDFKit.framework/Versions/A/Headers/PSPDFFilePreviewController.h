//
//  PSPDFFilePreviewController.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import <QuickLook/QuickLook.h>

/// Use QuickLook to preview an item.
@interface PSPDFFilePreviewController : QLPreviewController <QLPreviewControllerDataSource, QLPreviewControllerDelegate>

/// URL to then item that should be previewed.
@property (nonatomic, strong) NSURL *previewURL;

@end
