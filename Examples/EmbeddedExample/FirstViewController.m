//
//  FirstViewController.m
//  EmbeddedExample
//
//  Created by Peter Steinberger on 8/4/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "FirstViewController.h"
#import <PSPDFKit/PSPDFKit.h>

@implementation FirstViewController

@synthesize pdfController = pdfController_;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (NSString *)documentsFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);    
    return [paths objectAtIndex:0];
}

- (void)copySampleToDocumentsFolder:(NSString *)fileName {
    NSError *error = nil;
    NSString *path = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Samples"] stringByAppendingPathComponent:fileName];
    NSString *newPath = [[self documentsFolder] stringByAppendingPathComponent:fileName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (fileExists && ![[NSFileManager defaultManager] removeItemAtPath:newPath error:&error]) {
        NSLog(@"error while deleting: %@", [error localizedDescription]);
    }
    
    [[NSFileManager defaultManager] copyItemAtPath:path toPath:newPath error:nil];    
}


- (void)pushView {
    NSString *path = [[self documentsFolder] stringByAppendingPathComponent:@"PSPDFKit.pdf"];
    PSPDFDocument *document = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:path]];
    PSPDFViewController *pdfController = [[[PSPDFViewController alloc] initWithDocument:document] autorelease];
    pdfController.pageMode = PSPDFPageModeSingle;
    pdfController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pdfController animated:YES];
}

- (void)openModalView {
    NSString *path = [[self documentsFolder] stringByAppendingPathComponent:@"PSPDFKit.pdf"];
    PSPDFDocument *document = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:path]];
    PSPDFViewController *pdfController = [[[PSPDFViewController alloc] initWithDocument:document] autorelease];
    pdfController.pageMode = PSPDFPageModeSingle;
    UINavigationController *navCtrl = [[[UINavigationController alloc] initWithRootViewController:pdfController] autorelease];
    [self presentModalViewController:navCtrl animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil; {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.tabBarItem = [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:1] autorelease];
        
        // prepare document to display, copy it do docs folder
        // this is just for the replace copy example. You can display a document from anywhere within your app (e.g. bundle)
        [self copySampleToDocumentsFolder:@"PSPDFKit.pdf"];
        [self copySampleToDocumentsFolder:@"Developers_Guide_8th.pdf"];
        [self copySampleToDocumentsFolder:@"amazon-dynamo-sosp2007.pdf"];
        
        // add button to push view
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Open Stacked" style:UIBarButtonItemStylePlain target:self action:@selector(pushView)] autorelease];
        
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Open Modal" style:UIBarButtonItemStylePlain target:self action:@selector(openModalView)] autorelease];

    }
    return self;
}

- (void)dealloc {
    [pdfController_ release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // add pdf controller as subcontroller (iOS4 way, iOS5 has new, better methods for that)
    //NSString *path = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Samples"] stringByAppendingPathComponent:@"PSPDFKit.pdf"];
    NSString *path = [[self documentsFolder] stringByAppendingPathComponent:@"PSPDFKit.pdf"];
    PSPDFDocument *document = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:path]];
    self.pdfController = [[[PSPDFViewController alloc] initWithDocument:document] autorelease];
    self.pdfController.statusBarStyleSetting = PSPDFStatusBarInherit;
    
    //self.pdfController.scrobbleBarEnabled = NO;
    
    self.pdfController.view.frame = CGRectMake(80, 150, 600, 500);
    self.pdfController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.pdfController.view];
    
    // add a border
    self.pdfController.view.layer.borderColor = [UIColor blueColor].CGColor;
    self.pdfController.view.layer.borderWidth = 2.f;
    
    // hide after load (will animate later)
    self.pdfController.view.layer.opacity = 0.0f;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.pdfController viewWillAppear:NO];    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.pdfController viewDidAppear:NO];
    
    // show how controller can be animated
    self.pdfController.view.layer.opacity = 0.0f;
    [UIView animateWithDuration:1.f delay:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.pdfController.view.layer.opacity = 1.0f;
    } completion:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    // remove subcontroller
    [self.pdfController viewWillDisappear:NO];
    [self.pdfController.view removeFromSuperview];
    [self.pdfController viewDidDisappear:NO];
    self.pdfController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return PSIsIpad() ? YES : toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

// relay rotation events
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.pdfController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.pdfController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.pdfController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (IBAction)appendDocument {
    NSString *docName = @"Developers_Guide_8th.pdf";
    PSPDFDocument *document = self.pdfController.document;
    if (![document appendFile:docName]) {
        NSLog(@"Skipping operation: Document already appended.");
    }else {
        [self.pdfController reloadData];
    }
}

- (void)replaceFile {
    static BOOL replace = YES;
    if (replace) {
        NSError *error = nil;
        NSString *path = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Samples"] stringByAppendingPathComponent:@"amazon-dynamo-sosp2007.pdf"];
        NSString *newPath = [[self documentsFolder] stringByAppendingPathComponent:@"PSPDFKit.pdf"];
        if (![[NSFileManager defaultManager] removeItemAtPath:newPath error:&error]) {
            NSLog(@"error while deleting: %@", [error localizedDescription]);
        }
        if (![[NSFileManager defaultManager] copyItemAtPath:path toPath:newPath error:&error]) {
            NSLog(@"error while copying: %@", [error localizedDescription]);
        }
        replace = NO;
    }else {
        // first remove the document
        self.pdfController.document = nil;
        
        // there may be operations outstanding - wait until they're all finished up
        [NSThread sleepForTimeInterval:2.0];
        
        // now copy doc (deletes doc on position of currently there)
        [self copySampleToDocumentsFolder:@"PSPDFKit.pdf"];
        
        replace = YES;
    }
}

- (IBAction)replaceDocument {
    [self replaceFile];
    
    // although replacing a document *inline* is possible, it's not advised.
    // it's better to re-create the PSPDFDocument and set a new uid
    //[self.pdfController.document clearCacheForced:YES];
    //[[PSPDFCache sharedPSPDFCache] clearCache];
    //[self.pdfController reloadData];    
    
    // create new document
    NSString *path = [[self documentsFolder] stringByAppendingPathComponent:@"PSPDFKit.pdf"];
    PSPDFDocument *document = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:path]];
    
    // if we mix documents, they sure have different aspect ratios. This is a bit slower though.w
    document.aspectRatioEqual = NO;

    // we have to clear the cache, because we *replaced* a file, and there may be old images cached for it.
    [[PSPDFCache sharedPSPDFCache] clearCache];

    // set document on active controller
    self.pdfController.document = document;
}

@end
