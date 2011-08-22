//
//  SecondViewController.m
//  EmbeddedExample
//
//  Created by Peter Steinberger on 8/4/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "SecondViewController.h"

@implementation SecondViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)viewModeSegmentChanged:(id)sender {
    UISegmentedControl *viewMode = (UISegmentedControl *)sender;
    NSUInteger selectedSegment = viewMode.selectedSegmentIndex;
    NSLog(@"selected segment index: %d", selectedSegment);
    self.viewMode = selectedSegment == 0 ? PSPDFViewModeDocument : PSPDFViewModeThumbnails;  
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithDocument:document])) {
        self.tabBarItem = [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:2] autorelease];
        
        // disable default toolbar
        [self setToolbarEnabled:NO];
        self.statusBarStyleSetting = PSPDFStatusBarInherit;
        
        // add custom controls to our toolbar
        customViewModeSegment_ = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"Page", @""), NSLocalizedString(@"Thumbnails", @""), nil]];
        customViewModeSegment_.selectedSegmentIndex = 0;
        customViewModeSegment_.segmentedControlStyle = UISegmentedControlStyleBar;
        [customViewModeSegment_ addTarget:self action:@selector(viewModeSegmentChanged:) forControlEvents:UIControlEventValueChanged];
        [customViewModeSegment_ sizeToFit];
        UIBarButtonItem *viewModeButton = [[[UIBarButtonItem alloc] initWithCustomView:customViewModeSegment_] autorelease];

        self.navigationItem.rightBarButtonItem = viewModeButton;
        
        self.delegate = self;
   }
    return self;
}

- (void)dealloc {
    [customViewModeSegment_ release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (void)pdfViewController:(PSPDFViewController *)pdfController willShowPage:(NSUInteger)page; {
    self.title = [NSString stringWithFormat:@"Custom always visible header bar. Page %d", page];    
}


- (void)pdfViewController:(PSPDFViewController *)pdfController didChangeViewMode:(PSPDFViewMode)viewMode; {
    [customViewModeSegment_ setSelectedSegmentIndex:(NSUInteger)viewMode];
}

@end
