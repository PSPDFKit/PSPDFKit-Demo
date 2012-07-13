//
//  PSPDFCacheSettingsController.m
//  PSPDFKitExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFSettingsController.h"
#import <UIKit/UIKit.h>

#define _(string) NSLocalizedString(string, @"")
#define PSString(string) NSStringFromSelector(@selector(string))
@interface PSPDFSettingsController() {
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
    PSPDFOpenAPIButton,
    PSPDFShowConfigButton,
    PSPDFTextReflow,
    PSPDFDebugSettings,
    PSPDFDisplaySettings,
    PSPDFPaperColor,
    PSPDFPaperOpacity,
    PSPDFPageTransitionSettings,
    PSPDFScrollDirectionSettings,
    PSPDFPageModeSettings,
    PSPDFCoverSettings,
    PSPDFGeneralSettings,
    PSPDFToolbarSettings,
    PSPDFLinkActionSettings,
    PSPDFCacheSettings
};

@implementation PSPDFSettingsController

static NSMutableDictionary *_settings;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Static

+ (NSDictionary *)settings { return _settings; }

// perform a appropriate choice of defaults.
__attribute__((constructor)) static void setupDefaults(void) {
    @autoreleasepool {
        _settings = [NSMutableDictionary new];
        _settings[PSString(pageMode)] = @(PSIsIpad() ? PSPDFPageModeAutomatic : PSPDFPageModeSingle);
        _settings[PSString(isFitToWidthEnabled)] = PSIsIpad() ? @(NO) : @(YES);
        _settings[PSString(linkAction)] = @(PSPDFLinkActionInlineBrowser);
        _settings[PSString(pageTransition)] = @(PSPDFPageScrollPerPageTransition);
        _settings[PSString(isScrobbleBarEnabled)] = @(YES);
        _settings[PSString(isZoomingSmallDocumentsEnabled)] = @(YES);
        _settings[PSString(isPositionViewEnabled)] = @(YES);
        _settings[PSString(isScrobbleBarEnabled)] = @(YES);
        _settings[PSString(isTextSelectionEnabled)] = @(YES);
        _settings[PSString(isSmartZoomEnabled)] = @(YES);
        _settings[PSString(isScrollOnTapPageEndEnabled)] = @(YES);
        _settings[PSString(viewModeButtonItem)] = @(YES);
        _settings[PSString(searchButtonItem)] = @(YES);
        _settings[PSString(annotationButtonItem)] = @(YES);
        _settings[PSString(outlineButtonItem)] = @(YES);
        _settings[PSString(printButtonItem)] = @(YES);
        _settings[PSString(openInButtonItem)] = @(YES);
        _settings[PSString(emailButtonItem)] = @(YES);
        _settings[PSString(viewModeButtonItem)] = @(YES);
        _settings[PSString(renderBackgroundColor)] = [UIColor whiteColor];
        _settings[PSString(renderContentOpacity)] = @(1.f);
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        self.title = _(@"Options");
        _content = @[
        @[_(@"Open Documentation")], @[_(@"Show Current Configuration")], @[_(@"Extract Page Text")],
        @[_(@"Show Text Blocks")],
        @[_(@"Invert")], @[_(@"")], @[_(@"")],
        @[_(@"Scroll Per Page"), _(@"Scroll Continuous"), _(@"PageCurl (iBooks)"), _(@"Page Flip (Flipboard)")],
        @[_(@"Horizontal"), _(@"Vertical")],
        @[_(@"Single Page"), _(@"Double Pages"), _(@"Automatic on Rotation")],
        @[_(@"Single First Page"), _(@"No Cover Page")],
        @[_(@"Smart Zoom"), _(@"Allow Text Selection"), _(@"Zoom Small Files"), _(@"Zoom To Width"), _(@"Scroll On Tap Page"), _(@"Scrobblebar"), _(@"Page Position View")],
        @[_(@"Search"), _(@"Outline"), _(@"Print"), _(@"OpenIn"), _(@"Email"), _(@"View Mode")],
        @[_(@"Ignore Links"), _(@"Show Alert View"), _(@"Open Safari"), _(@"Open Internal Webview")],
        @[_(@"No Disk Cache"), _(@"Thumbnails & Near Pages"), _(@"Cache everything")],
        ];
        _contentSubtitle = @[@[@""], @[@""], @[@""],
        @[_(@"(See PSPDFSelectionView)")],
        @[@""], @[@""], @[@""],
        @[_(@"PSPDFPageScrollPerPageTransition"), _(@"PSPDFPageScrollContinuousTransition"), _(@"PSPDFPageCurlTransition"), _(@"PSPDFPageFlipTransition")],
        @[_(@"PSPDFScrollDirectionHorizontal"), _(@"PSPDFScrollDirectionVertical")],
        @[_(@"PSPDFPageModeSingle"), _(@"PSPDFPageModeDouble"), _(@"PSPDFPageModeAutomatic")],
        @[_(@"doublePageModeOnFirstPage = YES"), _(@"doublePageModeOnFirstPage = NO")],
        @[_(@"smartZoomEnabled"), _(@"textSelectionEnabled"), _(@"zoomingSmallDocumentsEnabled"), _(@"fitToWidthEnabled"), _(@"scrollOnTapPageEndEnabled"),  _(@"scrobbleBarEnabled"), _(@"positionViewEnabled")],
        @[_(@"searchButtonItem"), _(@"outlineButtonItem"), _(@"printButtonItem"), _(@"openInButtonItem"), _(@"emailButtonItem"), _(@"annotationButtonItem"), _(@"viewModeButtonItem")],
        @[_(@"PSPDFLinkActionNone"), _(@"PSPDFLinkActionAlertView"), _(@"PSPDFLinkActionOpenSafari"), _(@"PSPDFLinkActionInlineBrowser")],
        @[_(@"PSPDFCacheNothing"), _(@"PSPDFCacheOnlyThumbnailsAndNearPages"), _(@"PSPDFCacheOpportunistic")],
        ];
        _sectionTitle = @[@"", @"", @"", _(@"Debug"), _(@"Display Options"), @"", @"", _(@"Page Transition (pageTransition)"), _(@"Scroll Direction (pageScrolling)"), _(@"Dual Page Mode (pageMode)"), _(@"Cover"), _(@"Display"), _(@"Toolbar"), _(@"Link Action"), _(@"Cache")];
        _sectionFooter = @[@"", @"", @"", _(@"See PSPDFKitGlobal.h for more debugging options."),
        _(@"Useful to easy readability of white documents."),
        _(@"Paper Color"),
        _(@"Content Opacity"),
        _(@"On iOS4, only the default transition (PSPDFPageScrollPerPageTransition) is available. Other settings will have no effect."),
        _(@"Scroll direction is only relevant for PSPDFPageScrollPerPageTransition or PSPDFPageScrollContinuousTransition."),
        _(@""), // dual page mode
        _(@"Relevant for dual page mode."),
        _(@"Zoom to width is not available with PSPDFPageCurlTransition. Smart Zoom tries to find a text block and zoom into that block. Falls back to regular zooming if no suited block was found."),
        _(@"PSPDFKit manages the toolbar for you. Don't directly change left/rightBarButtonItem(s) in the navigationController, use leftBarButtonItems, rightBarButtonItems and additionalRightBarButtonItems. There are some PSPDFBarButtonItem's prepared in PSPDFViewController. You can also add regular UIBarButtonItems."),
        _(@"Default is PSPDFLinkActionInlineBrowser."),
        _(@"Cache everything is usually the preferred choice. Cache settings are global.")];

        _contentOpacityControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"100%", @"90%", @"80%", @"70%", @"60%", nil]];
		[_contentOpacityControl addTarget:self action:@selector(contentOpacityChanged:) forControlEvents:UIControlEventValueChanged];

        _paperColors = @[[UIColor whiteColor],
            // 1-4: sepia, light to dark
            [UIColor colorWithRed:0.980 green:0.976 blue:0.949 alpha:1.0],
            [UIColor colorWithRed:0.965 green:0.957 blue:0.906 alpha:1.0],
            [UIColor colorWithRed:0.953 green:0.941 blue:0.871 alpha:1.0],
            [UIColor colorWithRed:0.937 green:0.922 blue:0.831 alpha:1.0],
            // 5-7: gray, light to dark
            [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0],
            [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0],
            [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0]];

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

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView flashScrollIndicators];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return PSIsIpad() ? YES : interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)paperColorChanged:(id)sender {
	int paperColorIndex = [sender selectedSegmentIndex];
    _settings[PSString(renderBackgroundColor)] = _paperColors[paperColorIndex];
    [[NSNotificationCenter defaultCenter] postNotificationName:kGlobalVarChangeNotification object:nil];
}

- (void)contentOpacityChanged:(id)sender {
	int opacityIndex = [sender selectedSegmentIndex];
	float opacity = 1.0 - ((float)opacityIndex * 0.1);
    _settings[PSString(renderContentOpacity)] = @(opacity);
    [[NSNotificationCenter defaultCenter] postNotificationName:kGlobalVarChangeNotification object:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
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
                case 0: _settings[PSString(isSmartZoomEnabled)] = value; break;
                case 1: _settings[PSString(isTextSelectionEnabled)] = value; break;
                case 2: _settings[PSString(isZoomingSmallDocumentsEnabled)] = value; break;
                case 3: _settings[PSString(isFitToWidthEnabled)] = value; break;
                case 5: _settings[PSString(isScrobbleBarEnabled)] = value; break;
                case 6: _settings[PSString(isPositionViewEnabled)] = value; break;
                default: break;
            }break;
        case PSPDFToolbarSettings:
            switch (indexPath.row) {
                case 0: _settings[PSString(searchButtonItem)] = value; break;
                case 1: _settings[PSString(outlineButtonItem)] = value; break;
                case 2: _settings[PSString(printButtonItem)] = value; break;
                case 3: _settings[PSString(openInButtonItem)] = value; break;
                case 4: _settings[PSString(emailButtonItem)] = value; break;
                case 5: _settings[PSString(annotationButtonItem)] = value; break;
                case 6: _settings[PSString(viewModeButtonItem)] = value; break;
                default: break;
            }break;
        case PSPDFDebugSettings:
            switch (indexPath.row) {
                case 0: _settings[@"showTextBlocks"] = value; break;
                default: break;
            }break;
        case PSPDFDisplaySettings: {
            switch (indexPath.row) {
                case 0: _settings[PSString(renderInvertEnabled)] = value; break;
                default: break;
            }break;
        }break;
        default: break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kGlobalVarChangeNotification object:indexPath];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
        _paperColorControl.frame = CGRectMake(9, 0, 302, 46);
        UIColor *paperColor = _settings[PSString(renderBackgroundColor)];
        _paperColorControl.selectedSegmentIndex = [_paperColors indexOfObject:paperColor];
        [cell addSubview:_paperColorControl];
    }
    else if (indexPath.section == PSPDFPaperOpacity) {
        _contentOpacityControl.frame = CGRectMake(9, 0, 302, 46);
        NSUInteger index = roundf((1 - [_settings[PSString(renderContentOpacity)] floatValue]) * 10);
        _contentOpacityControl.selectedSegmentIndex = index;
        [cell addSubview:_contentOpacityControl];
    }

    switch (indexPath.section) {
        case PSPDFPageTransitionSettings: {
            PSPDFPageTransition pageTransition = [_settings[PSString(pageTransition)] integerValue];
            cell.accessoryType = (indexPath.row == pageTransition) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }break;
        case PSPDFScrollDirectionSettings: {
            PSPDFScrollDirection scrollDirection = [_settings[PSString(pageScrolling)] integerValue];
            cell.accessoryType = (indexPath.row == scrollDirection) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }break;
        case PSPDFPageModeSettings: {
            PSPDFPageMode pageMode = [_settings[PSString(pageMode)] integerValue];
            cell.accessoryType = (indexPath.row == pageMode) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }break;
        case PSPDFCoverSettings: {
            BOOL hasCoverPage = [_settings[PSString(isDoublePageModeOnFirstPage)] integerValue];
            cell.accessoryType = (indexPath.row == hasCoverPage) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }break;
        case PSPDFGeneralSettings: {
            switch (indexPath.row) {
                case 0: cellSwitch.on = [_settings[PSString(isSmartZoomEnabled)] boolValue]; break;
                case 1: cellSwitch.on = [_settings[PSString(isTextSelectionEnabled)] boolValue]; break;
                case 2: cellSwitch.on = [_settings[PSString(isZoomingSmallDocumentsEnabled)] boolValue]; break;
                case 3: cellSwitch.on = [_settings[PSString(isFitToWidthEnabled)] boolValue]; break;
                case 4: cellSwitch.on = [_settings[PSString(isScrollOnTapPageEndEnabled)] boolValue]; break;
                case 5: cellSwitch.on = [_settings[PSString(isScrobbleBarEnabled)] boolValue]; break;
                case 6: cellSwitch.on = [_settings[PSString(isPositionViewEnabled)] boolValue]; break;
                default: break;
            }break;
        }break;
        case PSPDFToolbarSettings: {
            switch (indexPath.row) {
                case 0: cellSwitch.on = [_settings[PSString(searchButtonItem)] boolValue]; break;
                case 1: cellSwitch.on = [_settings[PSString(outlineButtonItem)] boolValue]; break;
                case 2: cellSwitch.on = [_settings[PSString(printButtonItem)] boolValue]; break;
                case 3: cellSwitch.on = [_settings[PSString(openInButtonItem)] boolValue]; break;
                case 4: cellSwitch.on = [_settings[PSString(emailButtonItem)] boolValue]; break;
                case 5: cellSwitch.on = [_settings[PSString(annotationButtonItem)] boolValue]; break;
                case 6: cellSwitch.on = [_settings[PSString(viewModeButtonItem)] boolValue]; break;
                default: break;
            }break;
        }break;
        case PSPDFLinkActionSettings: {
            PSPDFLinkAction linkAction = [_settings[PSString(linkAction)] integerValue];
            cell.accessoryType = (indexPath.row == linkAction) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }break;
        case PSPDFCacheSettings: {
            PSPDFCacheStrategy cacheStrategy = [PSPDFCache sharedPSPDFCache].strategy;
            cell.accessoryType = (indexPath.row == cacheStrategy) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }break;
        case PSPDFDebugSettings: {
            switch (indexPath.row) {
                case 0: cellSwitch.on = [_settings[@"showTextBlocks"] boolValue]; break;
                default: break;
            }break;
        }break;
        case PSPDFDisplaySettings: {
            switch (indexPath.row) {
                case 0: cellSwitch.on = [_settings[PSString(renderInvertEnabled)] boolValue]; break;
                default: break;
            }break;
        }break;
        default:break;
    }
    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case PSPDFOpenAPIButton: {
            PSPDF_IF_SIMULATOR(system("open 'http://pspdfkit.com/documentation/'"); break;)
            UINavigationController *webController = [PSPDFWebViewController modalWebViewWithURL:[NSURL URLWithString:@"http://pspdfkit.com/documentation/"]];
            [self presentModalViewController:webController animated:YES];
        }break;
        case PSPDFShowConfigButton: [self showConfigButton]; break;
        case PSPDFTextReflow: [self showTextReflowController]; break;
        case PSPDFPageTransitionSettings: _settings[PSString(pageTransition)] = @(indexPath.row); break;
        case PSPDFScrollDirectionSettings: _settings[PSString(pageScrolling)] = @(indexPath.row); break;
        case PSPDFPageModeSettings: _settings[PSString(pageMode)] = @(indexPath.row); break;
        case PSPDFCoverSettings: _settings[PSString(isDoublePageModeOnFirstPage)] = @(indexPath.row == 1); break;
        case PSPDFLinkActionSettings: _settings[PSString(linkAction)] = @(indexPath.row); break;
        case PSPDFCacheSettings:
            [[PSPDFCache sharedPSPDFCache] clearCache];
            [PSPDFCache sharedPSPDFCache].strategy = indexPath.row;
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
    if ([[(UINavigationController *)[[UIApplication sharedApplication] keyWindow].rootViewController topViewController] isKindOfClass:[PSPDFViewController class]]) {
        pdfController = (PSPDFViewController *)[(UINavigationController *)[[UIApplication sharedApplication] keyWindow].rootViewController topViewController];
    }
    return pdfController;
}

- (void)showConfigButton {
    NSString *pdfName = @"Document.pdf";
    PSPDFViewController *pdfController = [self currentPDFController];
    if (pdfController.document.fileURL) {
        pdfName = [pdfController.document.fileURL lastPathComponent];
    }

    UIViewController *configViewController = [PSPDFBaseViewController new];
    UITextView *configView = [UITextView new];
    configView.font = [UIFont fontWithName:@"Courier" size:14];
    NSMutableString *codeString = [NSMutableString string];
    [codeString appendFormat:@"PSPDFDocument *pdfDocument = [PSPDFDocument PDFDocumentWithURL:[NSURL fileURLWithPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@\"%@\"]]]\n\nPSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:pdfDocument];\n\n// Config properies. Use the enum values instead.\n// This is only for debugging.\n", pdfName];
    [_settings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key hasPrefix:@"is"]) {
            key = [[self class] setterKeyForGetter:key];
            obj = [obj boolValue] ? @"YES" : @"NO";
        }
        [codeString appendFormat:@"pdfController.%@ = %@;\n", key, obj];
    }];
    [codeString appendString:@"\n// Presenting the controller\nUINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:pdfController];\n[self presentViewController:navController animated:YES completion:NULL];"];
    configView.text = codeString;
    configView.editable = NO;
    configViewController.view = configView;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:configViewController];
    configViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:_(@"Close") style:UIBarButtonItemStyleDone target:self action:@selector(closeModalView)];
    navController.title = _(@"Current ");
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:navController animated:YES];
}

- (void)closeModalView {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)showTextReflowController {
    PSPDFViewController *pdfController = [self currentPDFController];
    if (!pdfController.document) {
        return;
    }

    UIViewController *configViewController = [PSPDFBaseViewController new];
    UITextView *configView = [UITextView new];
    configView.text = [pdfController.document textParserForPage:pdfController.page].text;
    configView.editable = NO;
    configView.font = [UIFont systemFontOfSize:15];
    configViewController.view = configView;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:configViewController];
    configViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:_(@"Close") style:UIBarButtonItemStyleDone target:self action:@selector(closeModalView)];
    navController.title = [NSString stringWithFormat:_(@"Extracted text for page %d"), pdfController.page];
    [self presentModalViewController:navController animated:YES];
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
