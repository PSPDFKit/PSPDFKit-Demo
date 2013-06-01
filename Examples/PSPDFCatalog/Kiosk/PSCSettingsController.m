//
//  PSCSettingsController.m
//  PSPDFCatalog
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCSettingsController.h"
#import "PSCBasicViewController.h"

#if !__has_feature(objc_arc)
#error "Compile this file with ARC"
#endif

#define _(string) NSLocalizedString(string, @"")

@interface PSCSettingsController() {
    BOOL _isSettingUpCells;
    NSArray *_content;
    NSArray *_contentSubtitle;
    NSArray *_sectionTitle;
    NSArray *_sectionFooter;
    UISegmentedControl *_contentOpacityControl;
    UISegmentedControl *_paperColorControl;
    NSArray *_paperColors;
}
@end

typedef NS_ENUM(NSInteger, PSPDFSettings) {
    PSPDFClearCacheButton,
    PSPDFOpenAPIButton,
    PSPDFShowConfigButton,
    PSPDFTextReflow,
    PSPDFPageInfoButton,
    PSPDFDebugSettings,
    PSPDFDisplaySettings,
    PSPDFPaperColor,
    PSPDFPaperOpacity,
    PSPDFPageTransitionSettings,
    PSPDFScrollDirectionSettings,
    PSPDFPageModeSettings,
    PSPDFCoverSettings,
    PSPDFThumbnailModeSettings,
    PSPDFPageRenderingSettings,
    PSPDFGeneralSettings,
    PSPDFToolbarSettings,
    PSPDFLinkActionSettings,
    PSPDFCacheSettings
};

@implementation PSCSettingsController

static NSMutableDictionary *_settings;

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Static

+ (NSDictionary *)settings { return _settings; }

// perform a appropriate choice of defaults.
__attribute__((constructor)) static void setupDefaults(void) {
    @autoreleasepool {
        _settings = [NSMutableDictionary new];
        _settings[PROPERTY(pageMode)] = @(PSIsIpad() ? PSPDFPageModeAutomatic : PSPDFPageModeSingle);
        _settings[PROPERTY(isFitToWidthEnabled)] = @(!PSIsIpad());
        _settings[PROPERTY(linkAction)] = @(PSPDFLinkActionInlineBrowser);
        _settings[PROPERTY(pageTransition)] = @(PSPDFPageScrollPerPageTransition);
        _settings[PROPERTY(scrollDirection)] = @(PSPDFScrollDirectionHorizontal);
        _settings[PROPERTY(thumbnailBarMode)] = @(PSPDFThumbnailBarModeScrobbleBar);
        _settings[PROPERTY(isZoomingSmallDocumentsEnabled)] = @YES;
        _settings[PROPERTY(isPageLabelEnabled)] = @YES;
        _settings[PROPERTY(isTextSelectionEnabled)] = @YES;
        _settings[PROPERTY(isSmartZoomEnabled)] = @YES;
        _settings[PROPERTY(isScrollOnTapPageEndEnabled)] = @YES;
        _settings[PROPERTY(viewModeButtonItem)] = @YES;
        _settings[PROPERTY(searchButtonItem)] = @YES;
        _settings[PROPERTY(annotationButtonItem)] = @YES;
        _settings[PROPERTY(bookmarkButtonItem)] = @YES;
        _settings[PROPERTY(brightnessButtonItem)] = @YES;
        _settings[PROPERTY(outlineButtonItem)] = @YES;
        _settings[PROPERTY(printButtonItem)] = @YES;
        _settings[PROPERTY(openInButtonItem)] = @YES;
        _settings[PROPERTY(emailButtonItem)] = @YES;
        _settings[PROPERTY(viewModeButtonItem)] = @YES;
        _settings[PROPERTY(useBorderedToolbarStyle)] = @NO;
        _settings[@"renderBackgroundColor"] = [UIColor whiteColor];
        _settings[@"renderContentOpacity"] = @(1.f);
        _settings[PROPERTY(renderingMode)] = @(PSPDFPageRenderingModeThumbnailThenFullPage);
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        self.title = _(@"Options");
        _content = @[
        @[_(@"Clear Disk Cache")], @[_(@"Open Documentation")], @[_(@"Show Current Configuration")], @[_(@"Extract Page Text")], @[_(@"Show Page Rect & Rotation")],
        @[_(@"Show Text Blocks")],
        @[_(@"Invert")], @[_(@"")], @[_(@"")],
        @[_(@"Scroll Per Page"), _(@"Scroll Continuous"), _(@"PageCurl (iBooks)")],
        @[_(@"Horizontal"), _(@"Vertical")],
        @[_(@"Single Page"), _(@"Double Pages"), _(@"Automatic on Rotation")],
        @[_(@"Single First Page"), _(@"No Cover Page")],
        @[_(@"No thumbnail bar"), _(@"Scrobble Bar (iBooks)"), _(@"Scrollable Thumbnails")],
        @[_(@"Thumbnail, then Page"), _(@"Page (async)"), _(@"Page (blocking)"), _(@"Thumbnails, Render"), _(@"Render only")],
        @[_(@"Smart Zoom"), _(@"Allow Text Selection"), _(@"Zoom Small Files"), _(@"Zoom To Width"), _(@"Scroll On Tap Page"), _(@"Page Position View")],
        @[_(@"Search"), _(@"Outline"), _(@"Print"), _(@"OpenIn"), _(@"Email"), _(@"Brightness"), _(@"Annotations"), _(@"Bookmarks"), _(@"Activity"), _(@"View Mode"), _(@"Bordered Toolbar")],
        @[_(@"Ignore Links"), _(@"Show Alert View"), _(@"Open Safari"), _(@"Open Internal Webview")],
        @[_(@"No Disk Cache"), _(@"Thumbnails only"), _(@"Thumbnails & Near Pages"), _(@"Cache everything")],
        ];
        _contentSubtitle = @[@[@""], @[@""], @[@""], @[@""], @[@""],
        @[_(@"(See PSPDFSelectionView)")],
        @[@""], @[@""], @[@""],
        @[_(@"PSPDFPageScrollPerPageTransition"), _(@"PSPDFPageScrollContinuousTransition"), _(@"PSPDFPageCurlTransition")],
        @[_(@"PSPDFScrollDirectionHorizontal"), _(@"PSPDFScrollDirectionVertical")],
        @[_(@"PSPDFPageModeSingle"), _(@"PSPDFPageModeDouble"), _(@"PSPDFPageModeAutomatic")],
        @[_(@"doublePageModeOnFirstPage = YES"), _(@"doublePageModeOnFirstPage = NO")],
        @[_(@"PSPDFThumbnailBarModeNone"), _(@"PSPDFThumbnailBarModeScrobbleBar"), _(@"PSPDFThumbnailBarModeScrollable")],
        @[_(@"PSPDFPageRenderingModeThumbnailThenFullPage"), _(@"PSPDFPageRenderingModeFullPage"), _(@"PSPDFPageRenderingModeFullPageBlocking"), _(@"PSPDFPageRenderingModeThumbnailThenRender"), _(@"PSPDFPageRenderingModeRender")],
        @[_(@"smartZoomEnabled"), _(@"textSelectionEnabled"), _(@"zoomingSmallDocumentsEnabled"), _(@"fitToWidthEnabled"), _(@"scrollOnTapPageEndEnabled"), _(@"pageLabelEnabled")],
        @[_(@"searchButtonItem"), _(@"outlineButtonItem"), _(@"printButtonItem"), _(@"openInButtonItem"), _(@"emailButtonItem"), _(@"brightnessButtonItem"), _(@"annotationButtonItem"), _(@"bookmarkButtonItem"), _(@"activityButtonItem"), _(@"viewModeButtonItem"), _(@"useBorderedToolbarStyle")],
        @[_(@"PSPDFLinkActionNone"), _(@"PSPDFLinkActionAlertView"), _(@"PSPDFLinkActionOpenSafari"), _(@"PSPDFLinkActionInlineBrowser")],
        @[_(@"PSPDFDiskCacheStrategyNothing"), _(@"PSPDFDiskCacheStrategyThumbnails"), _(@"PSPDFDiskCacheStrategyNearPages"), _(@"PSPDFDiskCacheStrategyEverything")],
        ];
        _sectionTitle = @[@"", @"", @"", @"", @"", @"", _(@"Debug"), _(@"Display Options"), @"", _(@"Page Transition (pageTransition)"), _(@"Scroll Direction (scrollDirection)"), _(@"Double Page Mode (pageMode)"), _(@"Cover"), _(@"Thumbnail Bar"), _(@"Page Render Mode"), _(@"Display"), _(@"Toolbar"), _(@"Link Action"), _(@"Cache")];
        _sectionFooter = @[@"", @"", @"", @"", PSPDFVersionString(), _(@"See PSPDFKitGlobal.h for more debugging options."),
        _(@"Useful to easy readability of white documents."),
        _(@"Paper Color"),
        _(@"Content Opacity"),
        _(@""),
        _(@"Scroll direction is only relevant for PSPDFPageScrollPerPageTransition or PSPDFPageScrollContinuousTransition."),
        _(@""), // double page mode
        _(@""), // PSPDFThumbnailBarMode
        _(@"Relevant for double page mode."),
        _(@"Here, you can trade interface speed versus feeling. For certain content, upscaled thumbnails don't look well. PSPDFPageRenderingModeFullPageBlocking is a great option for magazine apps that use pageCurl."),
        _(@"Zoom to width is not available with PSPDFPageCurlTransition. Smart Zoom tries to find a text block and zoom into that block. Falls back to regular zooming if no suited block was found."),
        _(@"PSPDFKit manages the toolbar for you. Don't directly change left/rightBarButtonItem(s) in the navigationController, use leftBarButtonItems, rightBarButtonItems and additionalRightBarButtonItems. There are some PSPDFBarButtonItem's prepared in PSPDFViewController. You can also add regular UIBarButtonItems."),
        _(@"Default is PSPDFLinkActionInlineBrowser."),
        _(@"Cache everything is usually the preferred choice. Cache settings are global.")];

        _contentOpacityControl = [[UISegmentedControl alloc] initWithItems:@[@"100%", @"90%", @"80%", @"70%", @"60%"]];
    	[_contentOpacityControl addTarget:self action:@selector(contentOpacityChanged:) forControlEvents:UIControlEventValueChanged];

        _paperColors = @[[UIColor whiteColor],
            // 1-4: sepia, light to dark
            [UIColor colorWithRed:0.980f green:0.976f blue:0.949f alpha:1.0f],
            [UIColor colorWithRed:0.965f green:0.957f blue:0.906f alpha:1.0f],
            [UIColor colorWithRed:0.953f green:0.941f blue:0.871f alpha:1.0f],
            [UIColor colorWithRed:0.937f green:0.922f blue:0.831f alpha:1.0f],
            // 5-7: gray, light to dark
            [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.0f],
            [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f],
            [UIColor colorWithRed:0.85f green:0.85f blue:0.85f alpha:1.0f]];

        NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:[_paperColors count]];
        [_paperColors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [imageArray addObject:[self imageWithColor:obj]];
        }];
        _paperColorControl = [[UISegmentedControl alloc] initWithItems:imageArray];
        [_paperColorControl addTarget:self action:@selector(paperColorChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGSize imageSize = CGSizeMake(20, 20);
    UIImage *renderedImage = nil;
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    [[UIColor blackColor] setStroke];
    CGContextSetLineWidth(context, 1.f);
    CGContextFillRect(context, (CGRect){.size=imageSize});
    CGContextStrokeRect(context, (CGRect){.size=imageSize});
    renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return renderedImage;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

static CGFloat pscSettingsLastYOffset = 0;
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // restore last scroll state
    if (pscSettingsLastYOffset > 0) {
        self.tableView.contentOffset = CGPointMake(0, pscSettingsLastYOffset);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView flashScrollIndicators];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    pscSettingsLastYOffset = self.tableView.contentOffset.y;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return PSIsIpad() ? YES : interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)paperColorChanged:(id)sender {
    if (_isSettingUpCells) return;
    int paperColorIndex = [sender selectedSegmentIndex];
    _settings[@"renderBackgroundColor"] = _paperColors[paperColorIndex];
    [[NSNotificationCenter defaultCenter] postNotificationName:kGlobalVarChangeNotification object:nil];
}

- (void)contentOpacityChanged:(id)sender {
    if (_isSettingUpCells) return;
    int opacityIndex = [sender selectedSegmentIndex];
    float opacity = 1.f - ((float)opacityIndex * 0.1f);
    _settings[@"renderContentOpacity"] = @(opacity);
    [[NSNotificationCenter defaultCenter] postNotificationName:kGlobalVarChangeNotification object:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _sectionTitle[section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return _sectionFooter[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_content count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_content[section] count];
}

- (void)switchChanged:(UISwitch *)cellSwitch {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)cellSwitch.superview];
    NSValue *value = @(cellSwitch.on);
    switch (indexPath.section) {
        case PSPDFGeneralSettings:
            switch (indexPath.row) {
                case 0: _settings[PROPERTY(isSmartZoomEnabled)] = value; break;
                case 1: _settings[PROPERTY(isTextSelectionEnabled)] = value; break;
                case 2: _settings[PROPERTY(isZoomingSmallDocumentsEnabled)] = value; break;
                case 3: _settings[PROPERTY(isFitToWidthEnabled)] = value; break;
                case 4: _settings[PROPERTY(isScrollOnTapPageEndEnabled)] = value; break;
                case 5: _settings[PROPERTY(isPageLabelEnabled)] = value; break;
                default: break;
            }break;
        case PSPDFToolbarSettings:
            switch (indexPath.row) {
                case 0: _settings[PROPERTY(searchButtonItem)] = value; break;
                case 1: _settings[PROPERTY(outlineButtonItem)] = value; break;
                case 2: _settings[PROPERTY(printButtonItem)] = value; break;
                case 3: _settings[PROPERTY(openInButtonItem)] = value; break;
                case 4: _settings[PROPERTY(emailButtonItem)] = value; break;
                case 5: _settings[PROPERTY(brightnessButtonItem)] = value; break;
                case 6: _settings[PROPERTY(annotationButtonItem)] = value; break;
                case 7: _settings[PROPERTY(bookmarkButtonItem)] = value; break;
                case 8: _settings[PROPERTY(activityButtonItem)] = value; break;
                case 9: _settings[PROPERTY(viewModeButtonItem)] = value; break;
                case 10: _settings[PROPERTY(useBorderedToolbarStyle)] = value; break;
                default: break;
            }break;
        case PSPDFDebugSettings:
            switch (indexPath.row) {
                case 0: _settings[@"showTextBlocks"] = value; break;
                default: break;
            }break;
        case PSPDFDisplaySettings: {
            switch (indexPath.row) {
                case 0: _settings[@"renderInvertEnabled"] = value; break;
                default: break;
            }break;
        }break;
        default: break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kGlobalVarChangeNotification object:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _isSettingUpCells = YES;
    NSString *cellIdentifier = [NSString stringWithFormat:@"PSPDFCacheSettingsCell_%d", indexPath.section];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    cell.textLabel.text = _content[indexPath.section][indexPath.row];
    cell.detailTextLabel.text = _contentSubtitle[indexPath.section][indexPath.row];

    UISwitch *cellSwitch = nil;
    if (indexPath.section == PSPDFGeneralSettings || indexPath.section == PSPDFToolbarSettings || indexPath.section == PSPDFDebugSettings || (indexPath.section == PSPDFDisplaySettings && indexPath.row == 0)) {
        cellSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [cellSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = cellSwitch;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if (indexPath.section == PSPDFPaperColor) {
        _paperColorControl.frame = CGRectMake(9, 0, self.view.frame.size.width-18, 46);
        UIColor *paperColor = _settings[@"renderBackgroundColor"];
        _paperColorControl.selectedSegmentIndex = [_paperColors indexOfObject:paperColor];
        [cell addSubview:_paperColorControl];
    }
    else if (indexPath.section == PSPDFPaperOpacity) {
        _contentOpacityControl.frame = CGRectMake(9, 0, self.view.frame.size.width-18, 46);
        NSUInteger index = (NSUInteger)roundf((1 - [_settings[@"renderContentOpacity"] floatValue]) * 10.f);
        _contentOpacityControl.selectedSegmentIndex = index;
        [cell addSubview:_contentOpacityControl];
    }

    switch (indexPath.section) {
        case PSPDFPageTransitionSettings: {
            PSPDFPageTransition pageTransition = [_settings[PROPERTY(pageTransition)] integerValue];
            cell.accessoryType = (indexPath.row == pageTransition) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }break;
        case PSPDFScrollDirectionSettings: {
            PSPDFScrollDirection scrollDirection = [_settings[PROPERTY(scrollDirection)] integerValue];
            cell.accessoryType = (indexPath.row == scrollDirection) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }break;
        case PSPDFPageModeSettings: {
            PSPDFPageMode pageMode = [_settings[PROPERTY(pageMode)] integerValue];
            cell.accessoryType = (indexPath.row == pageMode) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }break;
        case PSPDFPageRenderingSettings: {
            PSPDFPageRenderingMode renderingMode = [_settings[PROPERTY(renderingMode)] integerValue];
            cell.accessoryType = (indexPath.row == renderingMode) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }break;
        case PSPDFCoverSettings: {
            BOOL hasCoverPage = [_settings[PROPERTY(isDoublePageModeOnFirstPage)] integerValue] == 1;
            cell.accessoryType = (indexPath.row == hasCoverPage) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }break;
        case PSPDFThumbnailModeSettings: {
            NSUInteger thumbnailBarMode = [_settings[PROPERTY(thumbnailBarMode)] integerValue];
            cell.accessoryType = (indexPath.row == thumbnailBarMode) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }break;

        case PSPDFGeneralSettings: {
            switch (indexPath.row) {
                case 0: cellSwitch.on = [_settings[PROPERTY(isSmartZoomEnabled)] boolValue]; break;
                case 1: cellSwitch.on = [_settings[PROPERTY(isTextSelectionEnabled)] boolValue]; break;
                case 2: cellSwitch.on = [_settings[PROPERTY(isZoomingSmallDocumentsEnabled)] boolValue]; break;
                case 3: cellSwitch.on = [_settings[PROPERTY(isFitToWidthEnabled)] boolValue]; break;
                case 4: cellSwitch.on = [_settings[PROPERTY(isScrollOnTapPageEndEnabled)] boolValue]; break;
                case 5: cellSwitch.on = [_settings[PROPERTY(isPageLabelEnabled)] boolValue]; break;
                default: break;
            }
        }break;
        case PSPDFToolbarSettings: {
            switch (indexPath.row) {
                case 0: cellSwitch.on = [_settings[PROPERTY(searchButtonItem)] boolValue]; break;
                case 1: cellSwitch.on = [_settings[PROPERTY(outlineButtonItem)] boolValue]; break;
                case 2: cellSwitch.on = [_settings[PROPERTY(printButtonItem)] boolValue]; break;
                case 3: cellSwitch.on = [_settings[PROPERTY(openInButtonItem)] boolValue]; break;
                case 4: cellSwitch.on = [_settings[PROPERTY(emailButtonItem)] boolValue]; break;
                case 5: cellSwitch.on = [_settings[PROPERTY(brightnessButtonItem)] boolValue]; break;
                case 6: cellSwitch.on = [_settings[PROPERTY(annotationButtonItem)] boolValue]; break;
                case 7: cellSwitch.on = [_settings[PROPERTY(bookmarkButtonItem)] boolValue]; break;
                case 8: cellSwitch.on = [_settings[PROPERTY(activityButtonItem)] boolValue]; break;
                case 9: cellSwitch.on = [_settings[PROPERTY(viewModeButtonItem)] boolValue]; break;
                case 10: cellSwitch.on = [_settings[PROPERTY(useBorderedToolbarStyle)] boolValue]; break;
                default: break;
            }
        }break;
        case PSPDFLinkActionSettings: {
            PSPDFLinkAction linkAction = [_settings[PROPERTY(linkAction)] integerValue];
            cell.accessoryType = (indexPath.row == linkAction) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }break;
        case PSPDFCacheSettings: {
            PSPDFDiskCacheStrategy cacheStrategy = PSPDFCache.sharedCache.diskCacheStrategy;
            cell.accessoryType = (indexPath.row == cacheStrategy) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }break;
        case PSPDFDebugSettings: {
            switch (indexPath.row) {
                case 0: cellSwitch.on = [_settings[@"showTextBlocks"] boolValue]; break;
                default: break;
            }
        }break;
        case PSPDFDisplaySettings: {
            switch (indexPath.row) {
                case 0: cellSwitch.on = [_settings[@"renderInvertEnabled"] boolValue]; break;
                default: break;
            }
        }break;
        default:break;
    }
    _isSettingUpCells = NO;
    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

// allow both iPhone (self) and iPad use. (iPad will crash if we push from self in a popover)
- (UIViewController *)masterViewController {
    UIViewController *owningViewController = self.owningViewController;
    return owningViewController.view.window ? owningViewController : self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case PSPDFClearCacheButton: [[PSPDFCache sharedCache] clearCache]; break;
        case PSPDFOpenAPIButton: {
            PSPDF_IF_SIMULATOR(system("open 'http://pspdfkit.com/documentation/'"); break;)
            UINavigationController *webController = [PSPDFWebViewController modalWebViewWithURL:[NSURL URLWithString:@"http://pspdfkit.com/documentation/"]];
            [self.masterViewController presentViewController:webController animated:YES completion:NULL];
        }break;
        case PSPDFShowConfigButton: [self showConfigButton]; break;
        case PSPDFPageInfoButton: [self showPageInfoButton]; break;
        case PSPDFTextReflow: [self showTextReflowController]; break;
        case PSPDFPageTransitionSettings: {
            PSPDFPageTransition pageTransition = indexPath.row;
            _settings[PROPERTY(pageTransition)] = @(pageTransition);
            // set recommended render mode for pageCurl.
            if (pageTransition == PSPDFPageCurlTransition) {
                _settings[PROPERTY(renderingMode)] = @(PSPDFPageRenderingModeFullPageBlocking);
            }
        }break;
        case PSPDFScrollDirectionSettings: _settings[PROPERTY(scrollDirection)] = @(indexPath.row); break;
        case PSPDFPageModeSettings: _settings[PROPERTY(pageMode)] = @(indexPath.row); break;
        case PSPDFPageRenderingSettings: _settings[PROPERTY(renderingMode)] = @(indexPath.row); break;
        case PSPDFCoverSettings: _settings[PROPERTY(isDoublePageModeOnFirstPage)] = @(indexPath.row == 1); break;
        case PSPDFThumbnailModeSettings: _settings[PROPERTY(thumbnailBarMode)] = @(indexPath.row); break;
        case PSPDFLinkActionSettings: _settings[PROPERTY(linkAction)] = @(indexPath.row); break;
        case PSPDFCacheSettings:
            [[PSPDFCache sharedCache] clearCache];
            [PSPDFCache sharedCache].diskCacheStrategy = indexPath.row;
            break;
        default: break;
    }
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:kGlobalVarChangeNotification object:indexPath];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Show Config Button

- (PSPDFViewController *)currentPDFController {
    PSPDFViewController *pdfController = nil;
    if ([[(UINavigationController *)[UIApplication.sharedApplication keyWindow].rootViewController topViewController] isKindOfClass:[PSPDFViewController class]]) {
        pdfController = (PSPDFViewController *)[(UINavigationController *)[UIApplication.sharedApplication keyWindow].rootViewController topViewController];
    }
    return pdfController;
}

- (void)showConfigButton {
    NSString *pdfName = @"Document.pdf";
    PSPDFViewController *pdfController = [self currentPDFController];
    if (pdfController.document.fileURL) {
        pdfName = [pdfController.document.fileURL lastPathComponent];
    }

    UIViewController *configViewController = [PSCBasicViewController new];
    configViewController.title = @"Configuration";
    UITextView *configView = [UITextView new];
    configView.font = [UIFont fontWithName:@"Courier" size:14];
    NSMutableString *codeString = [NSMutableString string];
    [codeString appendFormat:@"PSPDFDocument *pdfDocument = [PSPDFDocument documentWithURL:[NSURL fileURLWithPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@\"%@\"]]]\n\nPSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:pdfDocument];\n\n// Config properties. Use the enum values instead.\n// This is only for debugging.\n", pdfName];
    [_settings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key hasPrefix:@"is"]) {
            key = [self.class setterKeyForGetter:key];
            obj = [obj boolValue] ? @"YES" : @"NO";
        }
        [codeString appendFormat:@"pdfController.%@ = %@;\n", key, obj];
    }];
    [codeString appendString:@"\n// Presenting the controller\nUINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:pdfController];\n[self presentViewController:navController animated:YES completion:NULL];"];
    configView.text = codeString;
    configView.editable = NO;
    configViewController.view = configView;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:configViewController];
    configViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:_(@"Close") style:UIBarButtonItemStyleDone target:configViewController action:@selector(closeModalView)];
    navController.title = _(@"Current ");
    navController.modalPresentationStyle = UIModalPresentationFormSheet;

    [self.masterViewController presentViewController:navController animated:YES completion:NULL];
}

- (void)showPageInfoButton {
    PSPDFDocument *document = self.currentPDFController.document;
    if (!document) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Open a PDF to see the page info." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    };
    NSString *description = [[document pageInfoForPage:[[self currentPDFController] page]] description];
    description = [description stringByAppendingFormat:@"\n%@", [[document textParserForPage:0] description]];
    NSLog(@"%@", description);
    [[[UIAlertView alloc] initWithTitle:_(@"Page Info") message:description delegate:nil cancelButtonTitle:_(@"OK") otherButtonTitles:nil] show];
}

- (void)showTextReflowController {
    PSPDFViewController *pdfController = [self currentPDFController];
    if (!pdfController.document) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Open a PDF to see the extracted text." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    };

    UIViewController *configViewController = [PSPDFBaseViewController new];
    configViewController.title = [NSString stringWithFormat:_(@"Extracted text for page %d"), pdfController.page+1];
    UITextView *configView = [UITextView new];

    NSMutableString *text = [NSMutableString string];
    NSArray *visiblePageNumbers = [pdfController visiblePageNumbers];
    for (NSNumber *pageNumber in visiblePageNumbers) {
        NSUInteger page = [pageNumber unsignedIntegerValue];
        if ([visiblePageNumbers count] > 1) [text appendFormat:@"Page %d:\n\n", page+1];
        [text appendString:[pdfController.document textParserForPage:page].text];
        if ([visiblePageNumbers count] > 1) [text appendString:@"\n-------------------------------------------------------\n\n"];
    }
    configView.text = text;
    configView.editable = NO;
    configView.font = [UIFont systemFontOfSize:15];
    configViewController.view = configView;

    [pdfController presentViewControllerModalOrPopover:configViewController embeddedInNavigationController:YES withCloseButton:YES animated:YES sender:nil options:@{PSPDFPresentOptionAlwaysModal : @YES}];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Static

+ (NSString *)setterKeyForGetter:(NSString *)getter {
    if ([getter hasPrefix:@"is"]) {
        getter = [getter substringFromIndex:2];
        getter = [getter stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[getter substringToIndex:1] lowercaseString]];
    }
    return getter;
}

@end
