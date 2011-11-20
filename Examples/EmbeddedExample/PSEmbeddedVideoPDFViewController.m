//
//  PSEmbeddedVideoPDFViewController.m
//  EmbeddedExample
//
//  Created by Peter Steinberger on 9/11/11.
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

#import "PSEmbeddedVideoPDFViewController.h"

@implementation PSEmbeddedVideoPDFViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithDocument:document])) {
        self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"VideoEx" image:[UIImage imageNamed:@"45-movie-1"] tag:4] autorelease];
        self.delegate = self; // set PSPDFViewControllerDelegate to self        
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

// disable back button
- (UIBarButtonItem *)toolbarBackButton {
    return nil;
}

@end
