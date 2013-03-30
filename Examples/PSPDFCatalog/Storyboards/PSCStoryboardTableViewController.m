//
//  PSCStoryboardTableViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSCStoryboardTableViewController.h"

@implementation PSCStoryboardTableViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

// We don't have enough semantics to tell with just IB that we do want to use the content of the table cells, so we add some additional logic.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // only apply this if our destination is a PSPDFViewController.
    if ([segue.destinationViewController isKindOfClass:[PSPDFViewController class]]) {
        PSPDFViewController *pdfController = (PSPDFViewController *)segue.destinationViewController;

        if ([sender isKindOfClass:[UITableViewCell class]]) {
            UITableViewCell *cell = (UITableViewCell *)sender;

            // this works, because document also accepts NSString and does a conversion.
            // This allows setting document via keyPath directly in Interface Builder.
            pdfController.document = (PSPDFDocument *)[NSString stringWithFormat:@"Samples/%@", cell.textLabel.text];

            /*
            // ideally, you would do it like this:
            NSString *pdfPath = [[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Samples"] stringByAppendingPathComponent:cell.textLabel.text];
            pdfController.document = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:pdfPath]];
            */
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return PSIsIpad() ? YES : toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

@end
