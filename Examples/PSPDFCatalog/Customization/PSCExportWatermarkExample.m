//
//  PSCExportWatermarkExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"

@interface PSCExportWatermarkExample : PSCExample @end
@interface PSCWatermarkingDocumentSharingViewController : PSPDFDocumentSharingViewController
@end

@implementation PSCExportWatermarkExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Watermark exported pages (print, email, open in)";
        self.contentDescription = @"Adds a global handler to watermark documents when they are exported.";
        self.category = PSCExampleCategoryDocumentDataProvider;
        self.priority = 450;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];

    PSPDFRenderDrawBlock drawBlock = ^(CGContextRef context, NSUInteger page, CGRect cropBox, NSUInteger rotation, NSDictionary *options) {
        // Careful, this code is executed on background threads. Only use thread-safe drawing methods.
        NSString *text = @"PSPDFKit Live Watermark";
        if ([text respondsToSelector:@selector(drawWithRect:options:attributes:context:)]) { // iOS 7 only
            NSStringDrawingContext *stringDrawingContext = [NSStringDrawingContext new];
            stringDrawingContext.minimumScaleFactor = 0.1f;

            CGContextTranslateCTM(context, 0.f, cropBox.size.height/2.f);
            CGContextRotateCTM(context, -(CGFloat)M_PI / 4.f);
            [text drawWithRect:cropBox
                       options:NSStringDrawingUsesLineFragmentOrigin
                    attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:100],
                                 NSForegroundColorAttributeName : [UIColor.redColor colorWithAlphaComponent:0.5f]}
                       context:stringDrawingContext];
        }
    };
    document.renderOptions = @{PSPDFRenderDrawBlockKey : drawBlock};

    // To add a watermark, we can either subclass every object that implements the PSPDFDocumentSharingViewControllerDelegate
    // and customize `processorOptionsForDocumentSharingViewController:`, or we simply subclass the PSPDFDocumentSharingViewController
    // directly and override `delegateProcessorOptions` which is the method that queries the delegates.
    [pdfController overrideClass:PSPDFDocumentSharingViewController.class withClass:PSCWatermarkingDocumentSharingViewController.class];
    return pdfController;
}

@end

@implementation PSCWatermarkingDocumentSharingViewController

- (NSDictionary *)delegateProcessorOptions {
    // Create watermark drawing block. This will be called once per page on exporting, after the PDF and the annotations have been drawn.
    PSPDFRenderDrawBlock drawBlock = ^(CGContextRef context, NSUInteger page, CGRect cropBox, NSUInteger rotation, NSDictionary *options) {
        // Careful, this code is executed on background threads. Only use thread-safe drawing methods.
        NSString *text = @"PSPDFKit Example Watermark";
        if ([text respondsToSelector:@selector(drawWithRect:options:attributes:context:)]) { // iOS 7 only
            NSStringDrawingContext *stringDrawingContext = [NSStringDrawingContext new];
            stringDrawingContext.minimumScaleFactor = 0.1f;

            CGContextTranslateCTM(context, 0.f, cropBox.size.height/2.f);
            CGContextRotateCTM(context, -(CGFloat)M_PI / 4.f);
            [text drawWithRect:cropBox
                       options:NSStringDrawingUsesLineFragmentOrigin
                    attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:100],
                                 NSForegroundColorAttributeName : [UIColor.redColor colorWithAlphaComponent:0.5f]}
                       context:stringDrawingContext];
        }
    };

    // Fetch dictionary and add drawing block.
    NSMutableDictionary *processorOptions = [NSMutableDictionary dictionaryWithDictionary:[super delegateProcessorOptions]];
    processorOptions[PSPDFProcessorDrawRectBlock] = [drawBlock copy];
    return processorOptions;
}

@end
