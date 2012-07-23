//
//  PSPDFExampleViewController.m
//  PSPDFKitExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFExampleViewController.h"
#import "AppDelegate.h"
#import "PSPDFMagazine.h"
#import "PSPDFSettingsController.h"
#import "PSPDFGridController.h"
#import "PSPDFSettingsBarButtonItem.h"
#import "PSPDFMetadataBarButtonItem.h"

@interface PSPDFExampleViewController () {
    BOOL hasLoadedLastPage_;
}
@end

@implementation PSPDFExampleViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithDocument:document])) {
        self.delegate = self;
        
        // initally update vars
        [self globalVarChanged];
        
        // register for global var change notifications from PSPDFCacheSettingsController
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(globalVarChanged) name:kGlobalVarChangeNotification object:nil];
                        
        // don't clip pages that have a high aspect ration variance. (for pageCurl, optional but useful check)
        // use a dispatch thread because calculating the aspectRatioVariance is expensive.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            CGFloat variance = [document aspectRatioVariance];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.clipToPageBoundaries = variance < 0.2f;
            });
        });

        // defaults to nil, this would show the back arrow (but we want a custom animation, thus our own button)
        NSString *closeTitle = PSIsIpad() ? NSLocalizedString(@"Documents", @"") : NSLocalizedString(@"Back", @"");
        UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:closeTitle style:UIBarButtonItemStyleBordered target:self action:@selector(close:)];
        PSPDFSettingsBarButtonItem *settingsButtomItem = [[PSPDFSettingsBarButtonItem alloc] initWithPDFViewController:self];
        PSPDFMetadataBarButtonItem *metadataButtonItem = [[PSPDFMetadataBarButtonItem alloc] initWithPDFViewController:self];
        
        self.leftBarButtonItems = PSIsIpad() ? @[closeButtonItem, settingsButtomItem, metadataButtonItem] : @[closeButtonItem, settingsButtomItem];
        self.barButtonItemsAlwaysEnabled = @[closeButtonItem];

        // restore viewState
        if ([self.document isValid]) {
            NSData *viewStateData = [[NSUserDefaults standardUserDefaults] objectForKey:self.document.uid];
            @try {
                if (viewStateData) {
                    PSPDFViewState *viewState = [NSKeyedUnarchiver unarchiveObjectWithData:viewStateData];
                    [self setViewState:viewState animated:NO];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Failed to load saved viewState: %@", exception);
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.document.uid];
            }
        }

        // 1.9 feature
        //self.tintColor = [UIColor colorWithRed:60.f/255.f green:100.f/255.f blue:160.f/255.f alpha:1.f];
        //self.statusBarStyleSetting = PSPDFStatusBarDefault;
        
        // change statusbar setting to your preferred style
        //self.statusBarStyleSetting = PSPDFStatusBarDisable;
        //self.statusBarStyleSetting = self.statusBarStyleSetting | PSPDFStatusBarIgnore;
    }    
    return self;
}

- (void)dealloc {
    // save current viewState
    if ([self.document isValid]) {
        NSData *viewStateData = [NSKeyedArchiver archivedDataWithRootObject:[self viewState]];
        [[NSUserDefaults standardUserDefaults] setObject:viewStateData forKey:self.document.uid];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (PSPDFMagazine *)magazine {
    return (PSPDFMagazine *)self.document;
}

- (void)close:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    /*
     // Example how to customize the double page mode switching. 
     if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation) && !PSIsIpad()) {
     self.pageMode = PSPDFPageModeDouble;
     }else {
     self.pageMode = PSPDFPageModeAutomatic;
     }*/
    
    // toolbar will be recreated, so release popover after rotation (else CoreAnimation crashes on us)
    [self.popoverController dismissPopoverAnimated:YES];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

    // Example to show how to only allow pageCurl in landscape mode.
    // Don't change this property in willAnimate* or bad things will happen.
    // self.pageCurlEnabled = UIInterfaceOrientationIsLandscape(self.interfaceOrientation);

    if ([[PSPDFSettingsController settings][@"showTextBlocks"] boolValue]) {
    for(NSNumber *number in [self visiblePageNumbers]) {
        PSPDFPageView *pageView = [self pageViewForPage:[number unsignedIntegerValue]];
            [pageView.selectionView showTextFlowData:NO animated:NO];
            [pageView.selectionView showTextFlowData:YES animated:NO];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

// This is to present the most common features of PSPDFKit.
// iOS is all about choosing the right options for the user. You really shouldn't ship that.
- (void)globalVarChanged {
    PSPDFViewState *viewState = [self viewState];
    NSDictionary *settings = [PSPDFSettingsController settings];
    [settings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (![key hasSuffix:@"ButtonItem"] && ![key hasPrefix:@"showTextBlocks"]) {
            [self setValue:obj forKey:[PSPDFSettingsController setterKeyForGetter:key]];
        }
    }];

    NSMutableArray *rightBarButtonItems = [NSMutableArray array];
    if ([settings[NSStringFromSelector(@selector(annotationButtonItem))] boolValue]) {
        [rightBarButtonItems addObject:self.annotationButtonItem];
    }
    if (PSIsIpad()) {
        if ([settings[NSStringFromSelector(@selector(outlineButtonItem))] boolValue]) {
            [rightBarButtonItems addObject:self.outlineButtonItem];
        }
        if ([settings[NSStringFromSelector(@selector(searchButtonItem))] boolValue]) {
            [rightBarButtonItems addObject:self.searchButtonItem];
        }
        if ([settings[NSStringFromSelector(@selector(bookmarkButtonItem))] boolValue]) {
            [rightBarButtonItems addObject:self.bookmarkButtonItem];
        }
    }
    if ([settings[NSStringFromSelector(@selector(viewModeButtonItem))] boolValue]) {
        [rightBarButtonItems addObject:self.viewModeButtonItem];
    }
    self.rightBarButtonItems = rightBarButtonItems;

    // define additional buttons with an action icon
    NSMutableArray *additionalRightBarButtonItems = [NSMutableArray array];
    if ([settings[NSStringFromSelector(@selector(printButtonItem))] boolValue]) {
        [additionalRightBarButtonItems addObject:self.printButtonItem];
    }
    if ([settings[NSStringFromSelector(@selector(openInButtonItem))] boolValue]) {
        [additionalRightBarButtonItems addObject:self.openInButtonItem];
    }
    if ([settings[NSStringFromSelector(@selector(emailButtonItem))] boolValue]) {
        [additionalRightBarButtonItems addObject:self.emailButtonItem];
    }
    if (!PSIsIpad()) {
        if ([settings[NSStringFromSelector(@selector(outlineButtonItem))] boolValue]) {
            [additionalRightBarButtonItems addObject:self.outlineButtonItem];
        }
        if ([settings[NSStringFromSelector(@selector(searchButtonItem))] boolValue]) {
            [additionalRightBarButtonItems addObject:self.searchButtonItem];
        }
        if ([settings[NSStringFromSelector(@selector(bookmarkButtonItem))] boolValue]) {
            [additionalRightBarButtonItems addObject:self.bookmarkButtonItem];
        }
    }
    self.additionalRightBarButtonItems = additionalRightBarButtonItems;

    // reload scrollview and restore viewState
    [self reloadData];
    [self setViewState:viewState animated:NO];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

// Allow control if a page should be scrolled to.
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController shouldScrollToPage:(NSUInteger)page {
    return YES;
}

// time to adjust PSPDFViewController before a PSPDFDocument is displayed
- (void)pdfViewController:(PSPDFViewController *)pdfController willDisplayDocument:(PSPDFDocument *)document {
    pdfController.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"linen_texture_dark"]];

    // show pdf title and fileURL
    NSString *fileName = PSPDFStripPDFFileType([document.fileURL lastPathComponent]);
    if (PSIsIpad() && ![document.title isEqualToString:fileName]) {
        self.title = [NSString stringWithFormat:@"%@ (%@)", document.title, [document.fileURL lastPathComponent]];
    }
}

// if user tapped within page bounds, this will notify you.
// return YES if this touch was processed by you and need no further checking by PSPDFKit.
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnPageView:(PSPDFPageView *)pageView info:(PSPDFPageInfo *)pageInfo coordinates:(PSPDFPageCoordinates *)pageCoordinates {
    PSELog(@"Page %d tapped at %@.", pageView.page, pageCoordinates);
    
    // touch not used
    return NO;
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didShowPageView:(PSPDFPageView *)pageView {
    PSELog(@"page %d displayed. (document: %@)", pageView.page, pageView.document.title);

    if ([[PSPDFSettingsController settings][@"showTextBlocks"] boolValue]) {
        NSUInteger realPage = self.realPage;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [self.document textParserForPage:realPage];
            dispatch_async(dispatch_get_main_queue(), ^{
                [pageView.selectionView showTextFlowData:YES animated:NO];
            });
        });
    }
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didRenderPageView:(PSPDFPageView *)pageView {
    PSELog(@"page %d rendered. (document: %@)", pageView.page, pageView.document.title);
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didLoadPageView:(PSPDFPageView *)pageView {
    if ([[PSPDFSettingsController settings][@"showTextBlocks"] boolValue]) {
        [pageView.selectionView showTextFlowData:NO animated:NO];
    }
}

- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnAnnotation:(PSPDFAnnotation *)annotation page:(NSUInteger)page info:(PSPDFPageInfo *)pageInfo coordinates:(PSPDFPageCoordinates *)pageCoordinates {
    BOOL handled = NO;
    return handled;
}

- (void)pdfViewController:(PSPDFViewController *)pdfController willShowController:(id)viewController embeddedInController:(id)controller animated:(BOOL)animated {
    PSELog(@"willShowViewController: %@ embeddedIn:%@ animated: %d.", viewController, controller, animated);
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didShowController:(id)viewController embeddedInController:(id)controller animated:(BOOL)animated {
    PSELog(@"didShowViewController: %@ embeddedIn:%@ animated: %d.", viewController, controller, animated);
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didEndPageDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint targetOffsetPoint = targetContentOffset ? *targetContentOffset : CGPointZero;
    PSELog(@"didEndPageDraggingwillDecelerate:%@ velocity:%@ targetContentOffset:%@.", decelerate ? @"YES" : @"NO", NSStringFromCGPoint(velocity), NSStringFromCGPoint(targetOffsetPoint));
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didEndPageZooming:(UIScrollView *)scrollView atScale:(CGFloat)scale {
    PSELog(@"didEndPageDraggingAtScale: %f", scale);
}

@end
