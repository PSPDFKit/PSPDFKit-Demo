//
//  PSPDFOutlineViewController.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 8/2/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@interface PSPDFOutlineViewController : UITableViewController <PSPDFCacheDelegate> {
    PSPDFDocument *document_;
    PSPDFViewController *pdfController_; // weak
    NSArray *outline_;
}

- (id)initWithDocument:(PSPDFDocument *)document pdfController:(PSPDFViewController *)pdfController;

@property(nonatomic, retain) NSArray *outline;

@end
