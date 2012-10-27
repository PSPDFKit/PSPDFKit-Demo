//
//  PSCKioskPDFViewController.m
//  PSPDFCatalog
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSCKioskPDFViewController.h"
#import "PSCMagazine.h"
#import "PSCSettingsController.h"
#import "PSCGridController.h"
#import "PSCSettingsBarButtonItem.h"
#import "PSCMetadataBarButtonItem.h"
#import "PSCAnnotationTableBarButtonItem.h"
#import "PSCGoToPageButtonItem.h"

#if !__has_feature(objc_arc)
#error "Compile this file with ARC"
#endif

NSString *const kPSPDFAspectRatioVarianceCalculated = @"kPSPDFAspectRatioVarianceCalculated";

@interface PSCKioskPDFViewController () {
    BOOL _hasLoadedLastPage;
    UIBarButtonItem *_closeButtonItem;
    PSCSettingsBarButtonItem *_settingsButtomItem;
    PSCMetadataBarButtonItem *_metadataButtonItem;
    PSCAnnotationTableBarButtonItem *_annotationListButtonItem;
}
@end

@implementation PSCKioskPDFViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithDocument:document])) {
        self.delegate = self;

        // initally update vars
        [self globalVarChanged];
        
        // register for global var change notifications from PSPDFCacheSettingsController
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(globalVarChanged) name:kGlobalVarChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aspectRatioVarianceCalculated:) name:kPSPDFAspectRatioVarianceCalculated object:nil];
                        
        // don't clip pages that have a high aspect ration variance. (for pageCurl, optional but useful check)
        // use a dispatch thread because calculating the aspectRatioVariance is expensive.
        // As of iOS5, this could be solved more elegant with __weak. (but we still support 4.3 here)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            CGFloat __unused variance = [document aspectRatioVariance];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kPSPDFAspectRatioVarianceCalculated object:document];
            });
        });

        // UI optimization: parse outline early, prevents possible toolbar update during the fade-in.
        // (the outline item is lazily evaluated)
        [self.document.outlineParser outline];

        // defaults to nil, this would show the back arrow (but we want a custom animation, thus our own button)
        NSString *closeTitle = PSIsIpad() ? NSLocalizedString(@"Documents", @"") : NSLocalizedString(@"Back", @"");
        _closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:closeTitle style:UIBarButtonItemStyleBordered target:self action:@selector(close:)];
        _settingsButtomItem = [[PSCSettingsBarButtonItem alloc] initWithPDFViewController:self];
        _metadataButtonItem = [[PSCMetadataBarButtonItem alloc] initWithPDFViewController:self];
        _annotationListButtonItem = [[PSCAnnotationTableBarButtonItem alloc] initWithPDFViewController:self];
        
        self.barButtonItemsAlwaysEnabled = @[_closeButtonItem];

        // restore viewState
        if ([self.document isValid]) {
            NSData *viewStateData = [[NSUserDefaults standardUserDefaults] objectForKey:self.document.UID];
            @try {
                if (viewStateData) {
                    PSPDFViewState *viewState = [NSKeyedUnarchiver unarchiveObjectWithData:viewStateData];
                    [self setViewState:viewState animated:NO];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Failed to load saved viewState: %@", exception);
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.document.UID];
            }
        }

        // change color
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
        [[NSUserDefaults standardUserDefaults] setObject:viewStateData forKey:self.document.UID];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (PSCMagazine *)magazine {
    return (PSCMagazine *)self.document;
}

- (void)close:(id)sender {
    // If parent is PSCGridController, we have a custom animation in place.
    BOOL animated = YES;
    NSUInteger controllerCount = [self.navigationController.viewControllers count];
    if (controllerCount > 1 && [self.navigationController.viewControllers[controllerCount-2] isKindOfClass:[PSCGridController class]]) {
        animated = NO;
    }
    [self.navigationController popViewControllerAnimated:animated];
}

- (void)aspectRatioVarianceCalculated:(NSNotification *)notification {
    if (notification.object == self.document) {
        self.clipToPageBoundaries = [self.document aspectRatioVariance] < 0.2f;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
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
    // Don't change this property in willAnimate* or updateSettingsForRotation or bad things will happen.
    // Also make sure to set the correct setting on the initial load (might already load up in landscape mode)
    //self.pageTransition = UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? PSPDFPageCurlTransition : PSPDFPageScrollPerPageTransition;

    if ([[PSCSettingsController settings][@"showTextBlocks"] boolValue]) {
        for (PSPDFPageView *pageView in [self visiblePageViews]) {
            [pageView.selectionView showTextFlowData:NO animated:NO];
            [pageView.selectionView showTextFlowData:YES animated:NO];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (void)updateSettingsForRotation:(UIInterfaceOrientation)toInterfaceOrientation {
    // dynamically adapt toolbar (in landscape mode, we have a lot more space!)
    NSArray *leftToolbarItems = PSIsIpad() && UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? @[_closeButtonItem, _settingsButtomItem, _metadataButtonItem, _annotationListButtonItem] : @[_closeButtonItem, _settingsButtomItem];

    // simple optimization, since changing the toolbar isn't cheap.
    if ([self.leftBarButtonItems count] != [leftToolbarItems count]) {
        self.leftBarButtonItems = leftToolbarItems;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

// This is to present the most common features of PSPDFKit.
// iOS is all about choosing the right options for the user. You really shouldn't ship that.
- (void)globalVarChanged {
    // preserve viewState, but only page, not contentOffset (since we can change fitToWidth etc here)
    PSPDFViewState *viewState = [self viewState];
    viewState.zoomScale = 1;
    viewState.contentOffset = CGPointMake(0, 0);

    NSDictionary *settings = [PSCSettingsController settings];
    [settings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (![key hasSuffix:@"ButtonItem"] && ![key hasPrefix:@"showTextBlocks"]) {
            [self setValue:obj forKey:[PSCSettingsController setterKeyForGetter:key]];
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
        if ([settings[NSStringFromSelector(@selector(brightnessButtonItem))] boolValue]) {
            [rightBarButtonItems addObject:self.brightnessButtonItem];
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
        if ([settings[NSStringFromSelector(@selector(brightnessButtonItem))] boolValue]) {
            [additionalRightBarButtonItems addObject:self.brightnessButtonItem];
        }
    }
    PSPDF_IF_IOS5_OR_GREATER([additionalRightBarButtonItems addObject:[[PSCGoToPageButtonItem alloc] initWithPDFViewController:self]];)
    self.additionalBarButtonItems = additionalRightBarButtonItems;

    // reload scrollview and restore viewState
    [self reloadData];
    [self setViewState:viewState animated:NO];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

// Allow control if a page should be scrolled to.
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController shouldScrollToPage:(NSUInteger)page {
    return YES;
}

// time to adjust PSPDFViewController before a PSPDFDocument is displayed
- (void)pdfViewController:(PSPDFViewController *)pdfController willDisplayDocument:(PSPDFDocument *)document {
    pdfController.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"linen_texture_dark"]];

    // show pdf title and fileURL
    if (document) {
        NSString *fileName = PSPDFStripPDFFileType([document.fileURL lastPathComponent]);
        if (PSIsIpad() && ![document.title isEqualToString:fileName]) {
            self.title = [NSString stringWithFormat:@"%@ (%@)", document.title, [document.fileURL lastPathComponent]];
        }
    }
}

- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnAnnotation:(PSPDFAnnotation *)annotation annotationPoint:(CGPoint)annotationPoint annotationView:(UIView<PSPDFAnnotationView> *)annotationView pageView:(PSPDFPageView *)pageView viewPoint:(CGPoint)viewPoint {
    NSLog(@"didTapOnAnnotation:%@ annotationPoint:%@ annotationView:%@ pageView:%@ viewPoint:%@", annotation, NSStringFromCGPoint(annotationPoint), annotationView, pageView, NSStringFromCGPoint(viewPoint));
    BOOL handled = NO;
    return handled;
}

- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnPageView:(PSPDFPageView *)pageView atPoint:(CGPoint)viewPoint {
    
    CGPoint screenPoint = [self.view convertPoint:viewPoint fromView:pageView];
    CGPoint pdfPoint = [pageView convertViewPointToPDFPoint:viewPoint];
    NSLog(@"Page %d tapped at %@ screenPoint:%@ PDFPoint%@ zoomScale:%.1f.", pageView.page, NSStringFromCGPoint(viewPoint), NSStringFromCGPoint(screenPoint), NSStringFromCGPoint(pdfPoint), pageView.scrollView.zoomScale);

    
    return NO; // touch not used.
}

static NSString *PSPDFGestureStateToString(UIGestureRecognizerState state) {
    switch (state) {
        case UIGestureRecognizerStateBegan:     return @"Began";
        case UIGestureRecognizerStateChanged:   return @"Changed";
        case UIGestureRecognizerStateEnded:     return @"Ended";
        case UIGestureRecognizerStateCancelled: return @"Cancelled";
        case UIGestureRecognizerStateFailed:    return @"Failed";
        case UIGestureRecognizerStatePossible:  return @"Possible";
        default: return @"";
    }
}

- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didLongPressOnPageView:(PSPDFPageView *)pageView atPoint:(CGPoint)viewPoint gestureRecognizer:(UILongPressGestureRecognizer *)gestureRecognizer {

    CGPoint screenPoint = [self.view convertPoint:viewPoint fromView:pageView];
    CGPoint pdfPoint = [pageView convertViewPointToPDFPoint:viewPoint];
    NSLog(@"Page %d long pressed at %@ screenPoint:%@ PDFPoint%@ zoomScale:%.1f. (state: %@)", pageView.page, NSStringFromCGPoint(viewPoint), NSStringFromCGPoint(screenPoint), NSStringFromCGPoint(pdfPoint), pageView.scrollView.zoomScale, PSPDFGestureStateToString(gestureRecognizer.state));

    return NO; // touch not used.
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didShowPageView:(PSPDFPageView *)pageView {
    //PSCLog(@"page %d displayed. (document: %@)", pageView.page, pageView.document.title);

    if ([[PSCSettingsController settings][@"showTextBlocks"] boolValue]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            for (PSPDFPageView *pageView in [self visiblePageViews]) {
                [self.document textParserForPage:pageView.page];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                for (PSPDFPageView *pageView in [self visiblePageViews]) {
                    [pageView.selectionView showTextFlowData:YES animated:NO];
                }
            });
        });
    }
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didRenderPageView:(PSPDFPageView *)pageView {
    PSCLog(@"page %d rendered. (document: %@)", pageView.page, pageView.document.title);
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didLoadPageView:(PSPDFPageView *)pageView {
    if ([[PSCSettingsController settings][@"showTextBlocks"] boolValue]) {
        for (PSPDFPageView *pageView in [self visiblePageViews]) {
            [pageView.selectionView showTextFlowData:NO animated:NO];
        }
    }
}

- (BOOL)pdfViewController:(PSPDFViewController *)pdfController shouldShowController:(id)viewController embeddedInController:(id)controller animated:(BOOL)animated {
    PSCLog(@"shouldShowViewController: %@ embeddedIn:%@ animated: %d.", viewController, controller, animated);
    return YES;
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didShowController:(id)viewController embeddedInController:(id)controller animated:(BOOL)animated {
    PSCLog(@"didShowViewController: %@ embeddedIn:%@ animated: %d.", viewController, controller, animated);
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didEndPageDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint targetOffsetPoint = targetContentOffset ? *targetContentOffset : CGPointZero;
    PSCLog(@"didEndPageDraggingwillDecelerate:%@ velocity:%@ targetContentOffset:%@.", decelerate ? @"YES" : @"NO", NSStringFromCGPoint(velocity), NSStringFromCGPoint(targetOffsetPoint));
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didEndPageZooming:(UIScrollView *)scrollView atScale:(CGFloat)scale {
    PSCLog(@"didEndPageDraggingAtScale: %f", scale);
}

- (BOOL)pdfViewController:(PSPDFViewController *)pdfController shouldSelectText:(NSString *)text withGlyphs:(NSArray *)glyphs atRect:(CGRect)rect onPageView:(PSPDFPageView *)pageView {
    // example how to limit text selection
    // return [text length] > 10;
    return YES;
}

- (NSArray *)pdfViewController:(PSPDFViewController *)pdfController shouldShowMenuItems:(NSArray *)menuItems atSuggestedTargetRect:(CGRect)rect forSelectedText:(NSString *)selectedText inRect:(CGRect)textRect onPageView:(PSPDFPageView *)pageView {
    NSMutableArray *newMenuItems = [menuItems mutableCopy];
    
    // This is an example how to customize the text selection menu.
    if (PSIsIpad()) { // looks bad on iPhone, no space
        PSPDFMenuItem *menuItem = [[PSPDFMenuItem alloc] initWithTitle:@"Show Text" block:^{
            [[[UIAlertView alloc] initWithTitle:@"Custom Show Text Feature" message:selectedText delegate:nil cancelButtonTitle:PSPDFLocalize(@"Ok") otherButtonTitles:nil] show];
        } identifier:@"Show Text"];
        [newMenuItems addObject:menuItem];
    }
    return newMenuItems;
}

// annotations

/// Called before an annotation will be selected. (but after didTapOnAnnotation)
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController shouldSelectAnnotation:(PSPDFAnnotation *)annotation onPageView:(PSPDFPageView *)pageView {
    PSCLog(@"should select %@?", annotation);
    return YES;
}

/// Called after an annotation has been selected.
- (void)pdfViewController:(PSPDFViewController *)pdfController didSelectAnnotation:(PSPDFAnnotation *)annotation onPageView:(PSPDFPageView *)pageView {
    PSCLog(@"did select %@.", annotation);
}

/// Called before we're showing the menu for an annotation.
- (NSArray *)pdfViewController:(PSPDFViewController *)pdfController shouldShowMenuItems:(NSArray *)menuItems atSuggestedTargetRect:(CGRect)rect forAnnotation:(PSPDFAnnotation *)annotation inRect:(CGRect)textRect onPageView:(PSPDFPageView *)pageView {
    PSCLog(@"showing menu %@ for %@", menuItems, annotation);
    return menuItems;
}

@end
