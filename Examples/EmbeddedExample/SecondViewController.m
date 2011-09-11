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
        self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Custom" image:[UIImage imageNamed:@"114-balloon"] tag:2] autorelease];
        
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
    self.delegate = nil;
    [customViewModeSegment_ release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return PSIsIpad() ? YES : toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (void)pdfViewController:(PSPDFViewController *)pdfController didShowPage:(NSUInteger)page; {
    self.navigationItem.title = [NSString stringWithFormat:@"Custom always visible header bar. Page %d", page];    
}


- (void)pdfViewController:(PSPDFViewController *)pdfController didChangeViewMode:(PSPDFViewMode)viewMode; {
    [customViewModeSegment_ setSelectedSegmentIndex:(NSUInteger)viewMode];
}

// *** implemented just for your curiosity. you can use that to add custom views (e.g. videos) to the PSPDFScrollView ***

/// called before a pdf page will be loaded and added to the pagingScrollView
- (void)pdfViewController:(PSPDFViewController *)pdfController willLoadPage:(NSUInteger)page pdfScrollView:(PSPDFScrollView *)pdfScrollView; {
    NSLog(@"willLoadPage: %d", page);
}

/// called after pdf page has been loaded and added to the pagingScrollView
- (void)pdfViewController:(PSPDFViewController *)pdfController didLoadPage:(NSUInteger)page pdfScrollView:(PSPDFScrollView *)pdfScrollView; {
    NSLog(@"didLoadPage: %d", page);    
}

/// called before a pdf page will be unloaded and removed from the pagingScrollView
- (void)pdfViewController:(PSPDFViewController *)pdfController willUnloadPage:(NSUInteger)page pdfScrollView:(PSPDFScrollView *)pdfScrollView; {
    NSLog(@"willUnloadPage: %d", page);
}

/// called after pdf page has been unloaded and removed from the pagingScrollView
- (void)pdfViewController:(PSPDFViewController *)pdfController didUnloadPage:(NSUInteger)page pdfScrollView:(PSPDFScrollView *)pdfScrollView; {
    NSLog(@"didUnloadPage: %d", page);
}

@end
