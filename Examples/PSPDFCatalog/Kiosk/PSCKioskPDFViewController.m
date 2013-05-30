//
//  PSCKioskPDFViewController.m
//  PSPDFCatalog
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCKioskPDFViewController.h"
#import "PSCMagazine.h"
#import "PSCSettingsController.h"
#import "PSCGridViewController.h"
#import "PSCSettingsBarButtonItem.h"

#ifdef PSPDFCatalog
#import "PSCGoToPageButtonItem.h"
#import "PSCMetadataBarButtonItem.h"
#endif

#if !__has_feature(objc_arc)
#error "Compile this file with ARC"
#endif

@interface PSCKioskPDFViewController () {
    BOOL _hasLoadedLastPage;
    UIBarButtonItem *_closeButtonItem;
    PSCSettingsBarButtonItem *_settingsButtomItem;
#ifdef PSPDFCatalog
    PSCMetadataBarButtonItem *_metadataButtonItem;
#endif
}
@end

@implementation PSCKioskPDFViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithDocument:document])) {
        self.delegate = self;

        // Initially update vars.
        [self globalVarChanged];

        // Register for global var change notifications from PSPDFCacheSettingsController.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(globalVarChanged) name:kGlobalVarChangeNotification object:nil];

        // Don't clip pages that have a high aspect ration variance. (for pageCurl, optional but useful check)
        // Use a dispatch thread because calculating the aspectRatioVariance is expensive.
        // Disabled by default, since this can be slow.
        /*
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            CGFloat variance = [document aspectRatioVariance];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.clipToPageBoundaries = variance < 0.2f;
            });
        });
         */

        // UI: Parse outline early, prevents possible toolbar update during the fade-in. (outline is lazily evaluated)
        //if (!PSPDFIsCrappyDevice()) [self.document.outlineParser outline];

        // Restore viewState.
        if ([self.document isKindOfClass:PSCMagazine.class]) {
            [self setViewState:((PSCMagazine *)self.document).lastViewState];
        }

        self.leftBarButtonItems = @[_closeButtonItem];

        // Change color.
        //self.tintColor = [UIColor colorWithRed:60.f/255.f green:100.f/255.f blue:160.f/255.f alpha:1.f];
        //self.statusBarStyleSetting = PSPDFStatusBarDefault;

        // Change statusbar setting to your preferred style.
        //self.statusBarStyleSetting = PSPDFStatusBarDisable;
        //self.statusBarStyleSetting = self.statusBarStyleSetting | PSPDFStatusBarIgnore;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (PSCMagazine *)magazine {
    return (PSCMagazine *)self.document;
}

- (void)close:(id)sender {
    // If parent is PSCGridController, we have a custom animation in place.
    BOOL animated = YES;
    NSUInteger controllerCount = [self.navigationController.viewControllers count];
    if (controllerCount > 1 && [self.navigationController.viewControllers[controllerCount-2] isKindOfClass:[PSCGridViewController class]]) {
        animated = NO;
    }
    // Support the case where we pop in the nav stack
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:animated];
    }else {
        // We might have opened a linked document modally.
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // Save current viewState.
    if ([self.document isKindOfClass:PSCMagazine.class]) {
        ((PSCMagazine *)self.document).lastViewState = self.viewState;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

#ifdef PSPDFCatalog
- (void)updateSettingsForRotation:(UIInterfaceOrientation)toInterfaceOrientation force:(BOOL)force {
    // Dynamically adapt toolbar (in landscape mode, we have a lot more space!)
    NSArray *leftToolbarItems = PSIsIpad() && UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? @[_closeButtonItem, _settingsButtomItem, _metadataButtonItem] : @[_closeButtonItem, _settingsButtomItem];

    // Simple performance optimization.
    if ([leftToolbarItems count] != [self.leftBarButtonItems count] || force) {
        self.leftBarButtonItems = leftToolbarItems;
    }
}

- (void)updateSettingsForRotation:(UIInterfaceOrientation)toInterfaceOrientation {
    [super updateSettingsForRotation:toInterfaceOrientation];
    [self updateSettingsForRotation:toInterfaceOrientation force:NO];
}
#endif

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

// This is to present the most common features of PSPDFKit.
// iOS is all about choosing the right options for the user. You really shouldn't ship that.
- (void)globalVarChanged {
    // Preserve viewState, but only page, not contentOffset. (since we can change fitToWidth etc here)
    PSPDFViewState *viewState = [self viewState];
    viewState.zoomScale = 1;
    viewState.contentOffset = CGPointMake(0, 0);

    NSMutableDictionary *renderOptions = [self.document.renderOptions mutableCopy] ?: [NSMutableDictionary dictionary];
    NSDictionary *settings = [PSCSettingsController settings];
    [settings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        // renderOptions need special treatment.
        if ([key isEqual:@"renderBackgroundColor"])     renderOptions[kPSPDFBackgroundFillColor] = obj;
        else if ([key isEqual:@"renderContentOpacity"]) renderOptions[kPSPDFContentOpacity] = obj;
        else if ([key isEqual:@"renderInvertEnabled"])  renderOptions[kPSPDFInvertRendering] = obj;

        else if (![key hasSuffix:@"ButtonItem"] && ![key hasPrefix:@"showTextBlocks"]) {
            [self setValue:obj forKey:[PSCSettingsController setterKeyForGetter:key]];
        }
    }];
    self.document.renderOptions = renderOptions;

    // Defaults to nil, this would show the back arrow (but we want a custom animation, thus our own button)
    NSString *closeTitle = PSIsIpad() ? NSLocalizedString(@"Documents", @"") : NSLocalizedString(@"Back", @"");
    _closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:closeTitle style:UIBarButtonItemStyleBordered target:self action:@selector(close:)];
    _settingsButtomItem = [[PSCSettingsBarButtonItem alloc] initWithPDFViewController:self];

#ifdef PSPDFCatalog
    _metadataButtonItem = [[PSCMetadataBarButtonItem alloc] initWithPDFViewController:self];
    [self updateSettingsForRotation:self.interfaceOrientation force:YES];
#endif

    self.barButtonItemsAlwaysEnabled = @[_closeButtonItem];

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
    if ([settings[NSStringFromSelector(@selector(brightnessButtonItem))] boolValue]) {
        [rightBarButtonItems addObject:self.brightnessButtonItem];
    }

    if ([settings[NSStringFromSelector(@selector(viewModeButtonItem))] boolValue]) {
        [rightBarButtonItems addObject:self.viewModeButtonItem];
    }
    self.rightBarButtonItems = rightBarButtonItems;

    // Define additional buttons with an action icon.
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
    if ([settings[NSStringFromSelector(@selector(activityButtonItem))] boolValue]) {
        [additionalRightBarButtonItems addObject:self.activityButtonItem];
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

#ifdef kPSPDFEnableAllBarButtonItems
    [rightBarButtonItems addObjectsFromArray:additionalRightBarButtonItems];
    self.rightBarButtonItems = rightBarButtonItems;
#endif

#ifdef PSPDFCatalog
    [additionalRightBarButtonItems addObject:[[PSCGoToPageButtonItem alloc] initWithPDFViewController:self]];
    self.additionalBarButtonItems = additionalRightBarButtonItems;
#endif

    // reload scroll view and restore viewState
    [self reloadData];
    [self setViewState:viewState animated:NO];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (void)pdfViewControllerWillDismiss:(PSPDFViewController *)pdfController {
    NSLog(@"Controller is about to be dismissed.");
}

- (void)pdfViewControllerDidDismiss:(PSPDFViewController *)pdfController {
    NSLog(@"Controller has been dismissed.");
}

// Allow control if a page should be scrolled to.
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController shouldScrollToPage:(NSUInteger)page {
    return YES;
}

// Time to adjust PSPDFViewController before a PSPDFDocument is displayed.
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

- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnAnnotation:(PSPDFAnnotation *)annotation annotationPoint:(CGPoint)annotationPoint annotationView:(UIView<PSPDFAnnotationViewProtocol> *)annotationView pageView:(PSPDFPageView *)pageView viewPoint:(CGPoint)viewPoint {
    PSCLog(@"didTapOnAnnotation:%@ annotationPoint:%@ annotationView:%@ pageView:%@ viewPoint:%@", annotation, NSStringFromCGPoint(annotationPoint), annotationView, pageView, NSStringFromCGPoint(viewPoint));
    BOOL handled = NO;
    return handled;
}

- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnPageView:(PSPDFPageView *)pageView atPoint:(CGPoint)viewPoint {
    CGPoint screenPoint = [self.view convertPoint:viewPoint fromView:pageView];
    CGPoint pdfPoint = [pageView convertViewPointToPDFPoint:viewPoint];
    PSCLog(@"Page %d tapped at %@ screenPoint:%@ PDFPoint%@ zoomScale:%.1f.", pageView.page, NSStringFromCGPoint(viewPoint), NSStringFromCGPoint(screenPoint), NSStringFromCGPoint(pdfPoint), pageView.scrollView.zoomScale);

    return NO; // touch not used.
}

static NSString *PSCGestureStateToString(UIGestureRecognizerState state) {
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
    // Only show log on start, prevents excessive log statements.
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint screenPoint = [self.view convertPoint:viewPoint fromView:pageView];
        CGPoint pdfPoint = [pageView convertViewPointToPDFPoint:viewPoint];
        PSCLog(@"Page %d long pressed at %@ screenPoint:%@ PDFPoint%@ zoomScale:%.1f. (state: %@)", pageView.page, NSStringFromCGPoint(viewPoint), NSStringFromCGPoint(screenPoint), NSStringFromCGPoint(pdfPoint), pageView.scrollView.zoomScale, PSCGestureStateToString(gestureRecognizer.state));
    }
    return NO; // Touch not used.
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didShowPageView:(PSPDFPageView *)pageView {
    //PSCLog(@"page %d displayed. (document: %@)", pageView.page, pageView.document.title);
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didRenderPageView:(PSPDFPageView *)pageView {
    //PSCLog(@"Page %d rendered. (document: %@)", pageView.page, pageView.document.title);
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didLoadPageView:(PSPDFPageView *)pageView {
    if ([[PSCSettingsController settings][@"showTextBlocks"] boolValue]) {
        if ([[PSCSettingsController settings][@"showTextBlocks"] boolValue]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                for (PSPDFPageView *visiblePageView in self.visiblePageViews) {
                    [self.document textParserForPage:visiblePageView.page];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (PSPDFPageView *visiblePageView in self.visiblePageViews) {
                        [visiblePageView.selectionView showTextFlowData:YES animated:NO];
                    }
                });
            });
        }else {
            for (PSPDFPageView *visiblePageView in self.visiblePageViews) {
                [visiblePageView.selectionView showTextFlowData:NO animated:NO];
            }
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
    // Example how to limit text selection.
    // return [text length] > 10;
    return YES;
}

- (NSArray *)pdfViewController:(PSPDFViewController *)pdfController shouldShowMenuItems:(NSArray *)menuItems atSuggestedTargetRect:(CGRect)rect forSelectedText:(NSString *)selectedText inRect:(CGRect)textRect onPageView:(PSPDFPageView *)pageView {
    // This is an example how to customize the text selection menu.
    // It helps for debugging text extraction issues. Don't ship this feature.
    NSMutableArray *newMenuItems = [menuItems mutableCopy];
    if (PSIsIpad()) { // looks bad on iPhone, no space
        PSPDFMenuItem *menuItem = [[PSPDFMenuItem alloc] initWithTitle:@"Show Text" block:^{
            [[[UIAlertView alloc] initWithTitle:@"Custom Show Text Feature" message:selectedText delegate:nil cancelButtonTitle:PSPDFLocalize(@"Ok") otherButtonTitles:nil] show];
        } identifier:@"Show Text"];
        [newMenuItems addObject:menuItem];
    }
    return newMenuItems;
}

// Annotations

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

    // Print highlight contents
    if ([annotation isKindOfClass:PSPDFHighlightAnnotation.class]) {
        NSString *highlightedString = [(PSPDFHighlightAnnotation *)annotation highlightedString];
        PSCLog(@"Highlighted value: %@", highlightedString);
    }

    // Example how to rename menu items.
    //for (PSPDFMenuItem *menuItem in menuItems) {
    //    menuItem.title = @"Test";
    //}

    return menuItems;
}

// Text Selection

- (void)pdfViewController:(PSPDFViewController *)pdfController didSelectText:(NSString *)text withGlyphs:(NSArray *)glyphs atRect:(CGRect)rect onPageView:(PSPDFPageView *)pageView {
    //NSLog(@"Selected: %@", text);
}

@end
