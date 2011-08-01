//
//  PSPDFExampleViewController.m
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/22/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFExampleViewController.h"
#import "AppDelegate.h"
#import "PSPDFMagazine.h"

@implementation PSPDFExampleViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDocument:(PSPDFDocument *)magazine {
    if ((self = [super initWithDocument:magazine])) {
        self.delegate = self;
    }
    
    return self;
}

- (PSPDFMagazine *)magazine {
    return (PSPDFMagazine *)self.document;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

// time to adjust PSPDFViewController before a PSPDFDocument is displayed
- (void)pdfViewController:(PSPDFViewController *)pdfController willDisplayDocument:(PSPDFDocument *)document; {
    pdfController.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"linen_texture_dark"]];
}

- (void)pdfViewController:(PSPDFViewController *)pdfController willShowPage:(NSUInteger)page {
    //PSELog(@"showing page %d", page);
    
    // update title!
    if (PSIsIpad()) {
        NSUInteger actualPage = [self landscapePage:page] + 1;
        NSString *title = [NSString stringWithFormat:@"%@ %d/%d", self.magazine.title, actualPage, [self.magazine pageCount]];
        pdfController.title = title;
    }
}

// if user tapped within page bounds, this will notify you.
// return YES if this touch was processed by you and need no further checking by PSPDFKit.
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnPage:(NSUInteger)page atPoint:(CGPoint)point pageSize:(CGSize)pageSize; {
    PSELog(@"Page %@ tapped at %@.", NSStringFromCGSize(pageSize), NSStringFromCGPoint(point));
    
    // touch not used
    return NO;
}

@end