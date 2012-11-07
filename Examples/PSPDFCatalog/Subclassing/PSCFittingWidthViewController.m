//
//  PSCFittingWidthViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSCFittingWidthViewController.h"

@implementation PSCFittingWidthViewController

- (id)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithDocument:document])) {
        // pageMode is already smart (PSPDFPageModeAutomatic on iPad and PSPDFPageModeSingle on iPhone)
    }
    return self;
}

- (void)updateSettingsForRotation:(UIInterfaceOrientation)toInterfaceOrientation {
    // improves readability on iPhone.
    if(!PSIsIpad()) {
        self.fitToWidthEnabled = UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
    }
}

@end
