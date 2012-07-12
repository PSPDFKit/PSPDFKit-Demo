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
}
@end

typedef NS_ENUM(NSInteger, PSPDFSettings) {
    PSPDFOpenAPIButton,
    PSPDFShowConfigButton,
    PSPDFPageTransitionSettings,
    PSPDFScrollDirectionSettings,
    PSPDFPageModeSettings,
    PSPDFCoverSettings,
    PSPDFGeneralSettings,
    PSPDFToolbarSettings,
    PSPDFLinkActionSettings,
    PSPDFCacheSettings,
    PSPDFDebugSettings
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
        _settings[PSString(isFittingWidth)] = PSIsIpad() ? @(NO) : @(YES);
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
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        self.title = _(@"Options");
        _content = @[
        @[_(@"Open Documentation")], @[_(@"Show Current Configuration")],
        @[_(@"Scroll Per Page"), _(@"Scroll Continuous"), _(@"PageCurl (iBooks)"), _(@"Page Flip (Flipboard)")],
        @[_(@"Horizontal"), _(@"Vertical")],
        @[_(@"Single Page"), _(@"Double Pages"), _(@"Automatic on Rotation")],
        @[_(@"Single First Page"), _(@"No Cover Page")],
        @[_(@"Smart Zoom"), _(@"Allow Text Selection"), _(@"Zoom Small Files"), _(@"Zoom To Width"), _(@"Scroll On Tap Page"), _(@"Scrobblebar"), _(@"Page Position View")],
        @[_(@"Search"), _(@"Outline"), _(@"Print"), _(@"OpenIn"), _(@"Email"), _(@"View Mode")],
        @[_(@"Ignore Links"), _(@"Show Alert View"), _(@"Open Safari"), _(@"Open Internal Webview")],
        @[_(@"No Disk Cache"), _(@"Thumbnails & Near Pages"), _(@"Cache everything")],
        @[_(@"Show Text Blocks")],
        ];
        _contentSubtitle = @[@[@""], @[@""],
        @[_(@"PSPDFPageScrollPerPageTransition"), _(@"PSPDFPageScrollContinuousTransition"), _(@"PSPDFPageCurlTransition"), _(@"PSPDFPageFlipTransition")],
        @[_(@"PSPDFScrollDirectionHorizontal"), _(@"PSPDFScrollDirectionVertical")],
        @[_(@"PSPDFPageModeSingle"), _(@"PSPDFPageModeDouble"), _(@"PSPDFPageModeAutomatic")],
        @[_(@"doublePageModeOnFirstPage = YES"), _(@"doublePageModeOnFirstPage = NO")],
        @[_(@"smartZoomEnabled"), _(@"textSelectionEnabled"), _(@"zoomingSmallDocumentsEnabled"), _(@"fitWidth"), _(@"scrollOnTapPageEndEnabled"),  _(@"scrobbleBarEnabled"), _(@"positionViewEnabled")],
        @[_(@"searchButtonItem"), _(@"outlineButtonItem"), _(@"printButtonItem"), _(@"openInButtonItem"), _(@"emailButtonItem"), _(@"annotationButtonItem"), _(@"viewModeButtonItem")],
        @[_(@"PSPDFLinkActionNone"), _(@"PSPDFLinkActionAlertView"), _(@"PSPDFLinkActionOpenSafari"), _(@"PSPDFLinkActionInlineBrowser")],
        @[_(@"PSPDFCacheNothing"), _(@"PSPDFCacheOnlyThumbnailsAndNearPages"), _(@"PSPDFCacheOpportunistic")],
        @[_(@"(Feature of PSPDFSelectionView)")],
        ];
        _sectionTitle = @[@"", @"", _(@"Page Transition (pageTransition)"), _(@"Scroll Direction (pageScrolling)"), _(@"Dual Page Mode (pageMode)"), _(@"Cover"), _(@"Display"), _(@"Toolbar"), _(@"Link Action"), _(@"Cache"), _(@"Debug")];
        _sectionFooter = @[@"", @"", _(@"On iOS4, only the default transition (PSPDFPageScrollPerPageTransition) is available. Other settings will have no effect."),
        _(@"Scroll direction is only relevant for PSPDFPageScrollPerPageTransition or PSPDFPageScrollContinuousTransition."),
        _(@""), // dual page mode
        _(@"Relevant for dual page mode."),
        _(@"Zoom to width is not available with PSPDFPageCurlTransition. Smart Zoom tries to find a text block and zoom into that block. Falls back to regular zooming if no suited block was found."),
        _(@"PSPDFKit manages the toolbar for you. Don't directly change left/rightBarButtonItem(s) in the navigationController, use leftBarButtonItems, rightBarButtonItems and additionalRightBarButtonItems. There are some PSPDFBarButtonItem's prepared in PSPDFViewController. You can also add regular UIBarButtonItems."),
        _(@"Default is PSPDFLinkActionInlineBrowser."),
        _(@"Cache everything is usually the preferred choice. Cache settings are global."),
        _(@"See PSPDFKitGlobal.h for more debugging options.")];
    }
    return self;
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
                case 3: _settings[PSString(isFittingWidth)] = value; break;
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
    if (indexPath.section == PSPDFGeneralSettings || indexPath.section == PSPDFToolbarSettings || indexPath.section == PSPDFDebugSettings) {
        cellSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [cellSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = cellSwitch;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
                case 3: cellSwitch.on = [_settings[PSString(isFittingWidth)] boolValue]; break;
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
            cellSwitch.on = [_settings[@"showTextBlocks"] boolValue] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
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
            PSPDF_IF_SIMULATOR(system("open 'http://pspdfkit.com/documentation/'"); return;)
            UINavigationController *webController = [PSPDFWebViewController modalWebViewWithURL:[NSURL URLWithString:@"http://pspdfkit.com/documentation/"]];
            [self presentModalViewController:webController animated:YES];
        }break;
        case PSPDFShowConfigButton: [self showConfigButton]; break;
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

- (void)showConfigButton {
    NSString *pdfName = @"Document.pdf";
    if ([[(UINavigationController *)[[UIApplication sharedApplication] keyWindow].rootViewController topViewController] isKindOfClass:[PSPDFViewController class]]) {
        PSPDFViewController *pdfController = (PSPDFViewController *)[(UINavigationController *)[[UIApplication sharedApplication] keyWindow].rootViewController topViewController];
        pdfName = [pdfController.document.fileURL lastPathComponent];
    }

    UIViewController *configViewController = [PSPDFBaseViewController new];
    UITextView *configView = [UITextView new];
    configView.font = [UIFont fontWithName:@"Courier" size:14];
    NSMutableString *codeString = [NSMutableString string];
    [codeString appendFormat:@"PSPDFDocument *pdfDocument = [PSPDFDocument PDFDocumentWithURL:[NSURL fileURLWithPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@\"%@\"]]]\n\nPSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:pdfDocument];\n\n// Config properies. Use the enum values instead.\n// This is only for debugging.\n", pdfName];
    [_settings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key hasPrefix:@"is"]) {
            key = [key substringFromIndex:2];
            key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[key substringToIndex:1] lowercaseString]];
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

@end
