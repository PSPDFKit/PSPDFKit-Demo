//
//  FirstViewController.m
//  EmbeddedExample
//
//  Created by Peter Steinberger on 8/4/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "FirstViewController.h"

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
    
    self.pdfController.scrobbleBarEnabled = NO;
    
    self.pdfController.view.frame = CGRectMake(80, 450, 600, 500);
    self.pdfController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pdfController.view];
    
    // add a border
    self.pdfController.view.layer.borderColor = [UIColor blueColor].CGColor;
    self.pdfController.view.layer.borderWidth = 2.f;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.pdfController viewWillAppear:NO];    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.pdfController viewDidAppear:NO];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    // remove subcontroller
    [self.pdfController viewWillDisappear:NO];
    [self.pdfController.view removeFromSuperview];
    [self.pdfController viewDidDisappear:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
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
    PSPDFDocument *document = self.pdfController.document;
    [document appendFile:@"Developers_Guide_8th.pdf"];
    [self.pdfController reloadData];
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
        [self copySampleToDocumentsFolder:@"PSPDFKit.pdf"];
        replace = YES;
    }
}

- (IBAction)replaceDocument {
    
    // although replacing a document *inline* is possible, it's not advised.
    // it's better to re-create the PSPDFDocument and set a new uid
    //[self.pdfController.document clearCacheForced:YES];
    //[self.pdfController reloadData];    
    
    NSString *path = [[self documentsFolder] stringByAppendingPathComponent:@"PSPDFKit.pdf"];
    PSPDFDocument *document = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:path]];

    // we have to clear the cache, because we *replaced* a file, and there may be old images cached for it.
    [[PSPDFCache sharedPSPDFCache] clearCache];

    self.pdfController.document = document;

}

@end
