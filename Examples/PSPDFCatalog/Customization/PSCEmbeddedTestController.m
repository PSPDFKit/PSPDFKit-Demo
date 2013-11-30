//
//  PSPDFEmbeddedTestController.m
//  PSPDFCatalog
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCEmbeddedTestController.h"
#import "PSCAppDelegate.h"
#import "PSCAssetLoader.h"

@interface PSCEmbeddedTestController ()
@property (nonatomic, strong) UITableViewController *testAnimationViewController;
@property (nonatomic, strong) PSPDFViewController *pdfController;
@end

@implementation PSCEmbeddedTestController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.navigationItem.leftItemsSupplementBackButton = YES;

        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Embedded" image:[UIImage imageNamed:@"medical"] tag:1];

        // Prepare document to display, copy it do docs folder.
        // This is just for the replace copy example. You can display a document from anywhere within your app (e.g. bundle)
        [self copySampleToDocumentsFolder:kDevelopersGuideFileName];
        [self copySampleToDocumentsFolder:kPaperExampleFileName];

        // Add button to push view.
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Open Stacked" style:UIBarButtonItemStylePlain target:self action:@selector(pushView)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Open Modal" style:UIBarButtonItemStylePlain target:self action:@selector(openModalView)];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a NIB.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.lightGrayColor;

    // Example to test CGDataProvider support.
    NSString *path = [[self documentsFolder] stringByAppendingPathComponent:@"PSPDFKit.pdf"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)(data));
    PSPDFDocument *document = [PSPDFDocument documentWithDataProvider:dataProvider];
    CGDataProviderRelease(dataProvider);

    self.pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    self.pdfController.view.frame = CGRectMake(120.f, 150.f, self.view.frame.size.width - 120*2.f, PSCIsIPad() ? 500.f : 200.f);
    self.pdfController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.pdfController.statusBarStyleSetting = PSPDFStatusBarStyleInherit;
    self.pdfController.linkAction = PSPDFLinkActionInlineBrowser;
    self.pdfController.scrollOnTapPageEndEnabled = NO;

    if (self.pdfController) {
        [self addChildViewController:self.pdfController];

        // Initially, add tableview then later animate to the PDF controller.
        _testAnimationViewController = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self addChildViewController:_testAnimationViewController];
        _testAnimationViewController.view.frame = self.pdfController.view.frame;
        _testAnimationViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:_testAnimationViewController.view];
        [_testAnimationViewController didMoveToParentViewController:self];
    }

    // Border.
    self.pdfController.view.layer.borderColor = UIColor.blackColor.CGColor;
    self.pdfController.view.layer.borderWidth = 2.f;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // initially hide view, as we want to animate on it!
    self.pdfController.view.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Show how controller can be animated.
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_testAnimationViewController.parentViewController) {
            self.pdfController.view.hidden = NO;
            self.pdfController.view.frame = _testAnimationViewController.view.frame;
            // example how to use transitionFromViewController. However, transitionWithView looks far better.
            [self transitionFromViewController:_testAnimationViewController toViewController:self.pdfController duration:0.5f options:UIViewAnimationOptionTransitionCurlDown animations:NULL completion:^(BOOL finished) {
                [self.pdfController didMoveToParentViewController:self];
                [_testAnimationViewController willMoveToParentViewController:nil];
                [_testAnimationViewController removeFromParentViewController];
            }];
        }else {
            [UIView transitionWithView:self.pdfController.view duration:0.5f options:UIViewAnimationOptionTransitionCurlDown animations:^{
                self.pdfController.view.hidden = NO;
            } completion:NULL];
        }
    });
}

///////////////////////////////////////////////////////////////////////////////////////////
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
        NSString *path = [[self samplesFolder] stringByAppendingPathComponent:kPaperExampleFileName];
        NSString *newPath = [[self documentsFolder] stringByAppendingPathComponent:@"PSPDFKit.pdf"];
        if (![[NSFileManager defaultManager] removeItemAtPath:newPath error:&error]) {
            NSLog(@"error while deleting: %@", error.localizedDescription);
        }
        if (![[NSFileManager defaultManager] copyItemAtPath:path toPath:newPath error:&error]) {
            NSLog(@"error while copying: %@", error.localizedDescription);
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

    // create new document
    NSString *path = [[self documentsFolder] stringByAppendingPathComponent:@"PSPDFKit.pdf"];
    PSPDFDocument *document = [PSPDFDocument documentWithURL:[NSURL fileURLWithPath:path]];

    // If we mix documents, they sure have different aspect ratios. This is a bit slower, though.
    document.aspectRatioEqual = NO;

    // We have to clear the cache, because we *replaced* a file, and there may be old images cached for it.
    [PSPDFCache.sharedCache clearCache];

    // Set document on active controller.
    self.pdfController.document = document;
}

- (IBAction)clearCache {
    [PSPDFCache.sharedCache clearCache];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (NSString *)documentsFolder {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

- (NSString *)samplesFolder {
    return [NSBundle.mainBundle.resourcePath stringByAppendingPathComponent:@"Samples"];
}

- (void)copySampleToDocumentsFolder:(NSString *)fileName {
    NSError *error = nil;
    NSString *path = [[self samplesFolder] stringByAppendingPathComponent:fileName];
    NSString *newPath = [[self documentsFolder] stringByAppendingPathComponent:fileName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (fileExists && ![[NSFileManager defaultManager] removeItemAtPath:newPath error:&error]) {
        NSLog(@"error while deleting: %@", error.localizedDescription);
    }
    [[NSFileManager defaultManager] copyItemAtPath:path toPath:newPath error:NULL];
}

- (void)pushView {
    NSString *path = [[self documentsFolder] stringByAppendingPathComponent:kHackerMagazineExample];
    PSPDFDocument *document = [PSPDFDocument documentWithURL:[NSURL fileURLWithPath:path]];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    pdfController.additionalBarButtonItems = @[pdfController.printButtonItem, pdfController.openInButtonItem, pdfController.emailButtonItem];
    [self.navigationController pushViewController:pdfController animated:YES];
}

- (void)openModalView {
    NSString *path = [[self documentsFolder] stringByAppendingPathComponent:kHackerMagazineExample];
    PSPDFDocument *document = [PSPDFDocument documentWithURL:[NSURL fileURLWithPath:path]];

    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    pdfController.pageMode = PSPDFPageModeSingle;
    pdfController.additionalBarButtonItems = @[pdfController.printButtonItem, pdfController.openInButtonItem, pdfController.emailButtonItem];
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:pdfController];

    if (!PSCIsIPad()) {
        navCtrl.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    }else {
        navCtrl.modalPresentationStyle = UIModalPresentationFormSheet;
        pdfController.statusBarStyleSetting = PSPDFStatusBarStyleInherit;
    }

    [self presentViewController:navCtrl animated:YES completion:NULL];
}

@end
