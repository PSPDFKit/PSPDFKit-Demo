//
//  PSPDFEmbeddedTestController.m
//  EmbeddedExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFEmbeddedTestController.h"
#import "AppDelegate.h"

@implementation PSPDFEmbeddedTestController

@synthesize pdfController = pdfController_;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (NSString *)documentsFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);    
    return [paths objectAtIndex:0];
}

- (NSString *)samplesFolder {
    NSString *samplesFolder = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Samples"];
    return samplesFolder;
}

- (void)copySampleToDocumentsFolder:(NSString *)fileName {
    NSError *error = nil;
    NSString *path = [[self samplesFolder] stringByAppendingPathComponent:fileName];
    NSString *newPath = [[self documentsFolder] stringByAppendingPathComponent:fileName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (fileExists && ![[NSFileManager defaultManager] removeItemAtPath:newPath error:&error]) {
        NSLog(@"error while deleting: %@", [error localizedDescription]);
    }
    
    [[NSFileManager defaultManager] copyItemAtPath:path toPath:newPath error:nil];    
}

- (void)pushView {
    NSString *path = [[self documentsFolder] stringByAppendingPathComponent:kPSPDFKitExample];
    PSPDFDocument *document = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:path]];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    pdfController.pageMode = PSPDFPageModeSingle;
    pdfController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pdfController animated:YES];
}

- (void)openModalView {
    NSString *path = [[self documentsFolder] stringByAppendingPathComponent:kPSPDFKitExample];
    PSPDFDocument *document = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:path]];
    
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    pdfController.pageMode = PSPDFPageModeSingle;
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:pdfController];
    
    if (!PSIsIpad()) {
        navCtrl.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    }else {
        navCtrl.modalPresentationStyle = UIModalPresentationFormSheet;
        pdfController.statusBarStyleSetting = PSPDFStatusBarInherit;
    }
    
    [self presentModalViewController:navCtrl animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil; {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Embedded" image:[UIImage imageNamed:@"10-medical"] tag:1];
        
        // prepare document to display, copy it do docs folder
        // this is just for the replace copy example. You can display a document from anywhere within your app (e.g. bundle)
        [self copySampleToDocumentsFolder:kPSPDFKitExample];
        [self copySampleToDocumentsFolder:kDevelopersGuideFileName];
        [self copySampleToDocumentsFolder:kPaperExampleFileName];
        
        // add button to push view
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Open Stacked" style:UIBarButtonItemStylePlain target:self action:@selector(pushView)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Open Modal" style:UIBarButtonItemStylePlain target:self action:@selector(openModalView)];
    }
    return self;
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
    self.pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    self.pdfController.statusBarStyleSetting = PSPDFStatusBarInherit;
    self.pdfController.pageMode = PSPDFPageModeSingle;
    
    /*
    self.pdfController.pageScrolling = PSPDFScrollingVertical;
    self.pdfController.pagePadding = 0.0f;
    self.pdfController.shadowEnabled = NO;
    self.pdfController.pageMode = PSPDFPageModeDouble;
    self.pdfController.doublePageModeOnFirstPage = YES;
    //self.pdfController.scrobbleBarEnabled = NO;
     */
    //self.pdfController.viewMode = PSPDFViewModeThumbnails;
    
    self.pdfController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
    // add a border
    self.pdfController.view.layer.borderColor = [UIColor blackColor].CGColor;
    self.pdfController.view.layer.borderWidth = 2.f;
    
    // hide after load (will animate later)
    self.pdfController.view.alpha = 0.0f;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.pdfController.view.frame = CGRectMake(120, 150, self.view.frame.size.width - 120*2, PSIsIpad() ? 500 : 200);
    [self.pdfController viewWillAppear:animated];
    
    if (!self.pdfController.view.superview) {
        [self.view addSubview:self.pdfController.view];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.pdfController viewDidAppear:animated];
    
    // show how controller can be animated
    self.pdfController.view.alpha = 0.0f;
    [UIView animateWithDuration:.25f delay:0.5f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.pdfController.view.alpha = 1.0f;
    } completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.pdfController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.pdfController viewDidDisappear:animated];
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
    NSString *docName = kDevelopersGuideFileName;
    PSPDFDocument *document = self.pdfController.document;
    [document appendFile:docName];
    [self.pdfController reloadData];
}

- (void)replaceFile {
    static BOOL replace = YES;
    if (replace) {
        NSError *error = nil;
        NSString *path = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Samples"] stringByAppendingPathComponent:kPaperExampleFileName];
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

- (void)clearCache {
    [[PSPDFCache sharedPSPDFCache] clearCache];
}

@end
