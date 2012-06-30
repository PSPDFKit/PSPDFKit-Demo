//
//  PSPDFCacheSettingsController.m
//  PSPDFKitExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFSettingsController.h"
#import <UIKit/UIKit.h>

#define _(string) NSLocalizedString(string, @"")
@interface PSPDFSettingsController() {
    NSArray *_content;
    NSArray *_contentSubtitle;
    NSArray *_sectionTitle;
    NSArray *_sectionFooter;
}
@end

typedef NS_ENUM(NSInteger, PSPDFSettings) {
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

// perform a appropriate choice of defaults.
__attribute__((constructor)) static void setupDefaults(void) {
    @autoreleasepool {
        _settings = [NSMutableDictionary new];
        _settings[NSStringFromSelector(@selector(pageMode))] = @(PSIsIpad() ? PSPDFPageModeAutomatic : PSPDFPageModeSingle);
        _settings[NSStringFromSelector(@selector(isFittingWidth))] = PSIsIpad() ? @NO : @YES;
        _settings[NSStringFromSelector(@selector(linkAction))] = @(PSPDFLinkActionInlineBrowser);
        _settings[NSStringFromSelector(@selector(isScrobbleBarEnabled))] = @YES;
        _settings[NSStringFromSelector(@selector(isZoomingSmallDocumentsEnabled))] = @YES;
        _settings[NSStringFromSelector(@selector(isPositionViewEnabled))] = @YES;
        _settings[NSStringFromSelector(@selector(isScrobbleBarEnabled))] = @YES;
        _settings[NSStringFromSelector(@selector(isTextSelectionEnabled))] = @YES;
        _settings[NSStringFromSelector(@selector(isSmartZoomEnabled))] = @YES;
        _settings[NSStringFromSelector(@selector(isScrollOnTapPageEndEnabled))] = @YES;
        _settings[NSStringFromSelector(@selector(viewModeButtonItem))] = @YES;
        _settings[NSStringFromSelector(@selector(searchButtonItem))] = @YES;
        _settings[NSStringFromSelector(@selector(outlineButtonItem))] = @YES;
        _settings[NSStringFromSelector(@selector(printButtonItem))] = @YES;
        _settings[NSStringFromSelector(@selector(openInButtonItem))] = @YES;
        _settings[NSStringFromSelector(@selector(emailButtonItem))] = @YES;
        _settings[NSStringFromSelector(@selector(viewModeButtonItem))] = @YES;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        self.title = _(@"Options");

        _content = @[
        @[_(@"Scroll Per Page"), _(@"Scroll Continuous"), _(@"PageCurl (iBooks)"), _(@"Page Flip (Flipboard)")],
        @[_(@"Horizontal"), _(@"Vertical")],
        @[_(@"Single Page"), _(@"Double Pages"), _(@"Automatic on Rotation")],
        @[_(@"Single First Page"), _(@"No Cover Page")],
        @[_(@"Smart Zoom"), _(@"Allow Text Selection"), _(@"Zoom Small Files"), _(@"Zoom To Width"), _(@"Scroll On Tap Page"), _(@"Scrobblebar"), _(@"Page Position View")],
        @[_(@"Search"), _(@"Outline"), _(@"Print"), _(@"OpenIn"), _(@"Email"), _(@"View Mode")],
        @[_(@"Ignore Links"), _(@"Show Alert View"), _(@"Open Safari"), _(@"Open Internal Webview")],
        @[_(@"No Disk Cache"), _(@"Thumbnails & Near Pages"), _(@"Cache everything")],
        ];

        _contentSubtitle = @[
        @[_(@"PSPDFPageScrollPerPageTransition"), _(@"PSPDFPageScrollContinuousTransition"), _(@"PSPDFPageCurlTransition"), _(@"PSPDFPageFlipTransition")],
        @[_(@"PSPDFScrollDirectionHorizontal"), _(@"PSPDFScrollDirectionVertical")],
        @[_(@"PSPDFPageModeSingle"), _(@"PSPDFPageModeDouble"), _(@"PSPDFPageModeAutomatic")],
        @[_(@"doublePageModeOnFirstPage = YES"), _(@"doublePageModeOnFirstPage = NO")],
        @[_(@"smartZoomEnabled"), _(@"textSelectionEnabled"), _(@"zoomingSmallDocumentsEnabled"), _(@"fitWidth"), _(@"scrollOnTapPageEndEnabled"),  _(@"scrobbleBarEnabled"), _(@"positionViewEnabled")],
        @[_(@"searchButtonItem"), _(@"outlineButtonItem"), _(@"printButtonItem"), _(@"openInButtonItem"), _(@"emailButtonItem"), _(@"viewModeButtonItem")],
        @[_(@"PSPDFLinkActionNone"), _(@"PSPDFLinkActionAlertView"), _(@"PSPDFLinkActionOpenSafari"), _(@"PSPDFLinkActionInlineBrowser")],
        @[_(@"PSPDFCacheNothing"), _(@"PSPDFCacheOnlyThumbnailsAndNearPages"), _(@"PSPDFCacheOpportunistic")],
        ];

        _sectionTitle = @[_(@"Page Transition (pageTransition)"), _(@"Scroll Direction (pageScrolling)"), _(@"Dual Page Mode (pageMode)"), _(@"Cover"), _(@"Display"), _(@"Toolbar"), _(@"Link Action"), _(@"Cache")];

        _sectionFooter = @[_(@"On iOS4, only the default transition (PSPDFPageScrollPerPageTransition) is available. Other settings will have no effect."),
        _(@"Scroll direction is only relevant for PSPDFPageScrollPerPageTransition or PSPDFPageScrollContinuousTransition."),
        _(@""), // dual page mode
        _(@"Relevant for dual page mode."),
        _(@"Zoom to width is not available with PSPDFPageCurlTransition. Smart Zoom tries to find a text block and zoom into that block. Falls back to regular zooming if no suited block was found."),
        _(@"PSPDFKit manages the toolbar for you. Don't directly change left/rightBarButtonItem(s) in the navigationController, use leftBarButtonItems, rightBarButtonItems and additionalRightBarButtonItems. There are some PSPDFBarButtonItem's prepared in PSPDFViewController. You can also add regular UIBarButtonItems."),
        _(@"Default is PSPDFLinkActionInlineBrowser."),
        _(@"Cache everything is usually the preferred choice. Cache settings are global.")];
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
    UITableViewCell *cell = (UITableViewCell *)cellSwitch.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    switch (indexPath.section) {
        case PSPDFGeneralSettings:
            switch (indexPath.row) {
                case 0:
                    _settings[NSStringFromSelector(@selector(isSmartZoomEnabled))] = @(cellSwitch.on);
                    break;
                case 1:
                    _settings[NSStringFromSelector(@selector(isTextSelectionEnabled))] = @(cellSwitch.on);
                    break;
                case 2:
                    _settings[NSStringFromSelector(@selector(isZoomingSmallDocumentsEnabled))] = @(cellSwitch.on);
                    break;
                case 3:
                    _settings[NSStringFromSelector(@selector(isFittingWidth))] = @(cellSwitch.on);
                    break;
                case 4:
                    _settings[NSStringFromSelector(@selector(isScrollOnTapPageEndEnabled))] = @(cellSwitch.on);
                    break;
                case 5:
                    _settings[NSStringFromSelector(@selector(isScrobbleBarEnabled))] = @(cellSwitch.on);
                    break;
                case 6:
                    _settings[NSStringFromSelector(@selector(isPositionViewEnabled))] = @(cellSwitch.on);
                    break;
                default: break;
            }break;
        case PSPDFToolbarSettings:
            switch (indexPath.row) {
                case 0:
                    _settings[NSStringFromSelector(@selector(searchButtonItem))] = @(cellSwitch.on);
                    break;
                case 1:
                    _settings[NSStringFromSelector(@selector(outlineButtonItem))] = @(cellSwitch.on);
                    break;
                case 2:
                    _settings[NSStringFromSelector(@selector(printButtonItem))] = @(cellSwitch.on);
                    break;
                case 3:
                    _settings[NSStringFromSelector(@selector(openInButtonItem))] = @(cellSwitch.on);
                    break;
                case 4:
                    _settings[NSStringFromSelector(@selector(emailButtonItem))] = @(cellSwitch.on);
                    break;
                case 5:
                    _settings[NSStringFromSelector(@selector(viewModeButtonItem))] = @(cellSwitch.on);
                    break;
                default: break;
            }break;
        default:
            break;
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
    if (indexPath.section == PSPDFGeneralSettings || indexPath.section == PSPDFToolbarSettings) {
        cellSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [cellSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = cellSwitch;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    switch (indexPath.section) {
        case PSPDFPageTransitionSettings: {
            PSPDFPageTransition pageTransition = [_settings[NSStringFromSelector(@selector(pageTransition))] integerValue];
            cell.accessoryType = (indexPath.row == pageTransition) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }break;
        case PSPDFScrollDirectionSettings: {
            PSPDFScrollDirection scrollDirection = [_settings[NSStringFromSelector(@selector(scrollDirection))] integerValue];
            cell.accessoryType = (indexPath.row == scrollDirection) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }break;
        case PSPDFPageModeSettings: {
            PSPDFPageMode pageMode = [_settings[NSStringFromSelector(@selector(pageMode))] integerValue];
            cell.accessoryType = (indexPath.row == pageMode) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }break;
        case PSPDFCoverSettings: {
            BOOL hasCoverPage = [_settings[NSStringFromSelector(@selector(isDoublePageModeOnFirstPage))] integerValue];
            cell.accessoryType = (indexPath.row == hasCoverPage) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }break;
        case PSPDFGeneralSettings: {
            switch (indexPath.row) {
                case 0:
                    cellSwitch.on = [_settings[NSStringFromSelector(@selector(isSmartZoomEnabled))] boolValue];
                    break;
                case 1:
                    cellSwitch.on = [_settings[NSStringFromSelector(@selector(isTextSelectionEnabled))] boolValue];
                case 2:
                    cellSwitch.on = [_settings[NSStringFromSelector(@selector(isZoomingSmallDocumentsEnabled))] boolValue];
                    break;
                case 3:
                    cellSwitch.on = [_settings[NSStringFromSelector(@selector(isFittingWidth))] boolValue];
                    break;
                case 4:
                    cellSwitch.on = [_settings[NSStringFromSelector(@selector(isScrollOnTapPageEndEnabled))] boolValue];
                    break;
                case 5:
                    cellSwitch.on = [_settings[NSStringFromSelector(@selector(isScrobbleBarEnabled))] boolValue];
                    break;
                case 6:
                    cellSwitch.on = [_settings[NSStringFromSelector(@selector(isPositionViewEnabled))] boolValue];
                    break;
                default: break;
            }break;
        }break;
        case PSPDFToolbarSettings: {
            switch (indexPath.row) {
                case 0:
                    cellSwitch.on = [_settings[NSStringFromSelector(@selector(searchButtonItem))] boolValue];
                    break;
                case 1:
                    cellSwitch.on = [_settings[NSStringFromSelector(@selector(outlineButtonItem))] boolValue];
                    break;
                case 2:
                    cellSwitch.on = [_settings[NSStringFromSelector(@selector(printButtonItem))] boolValue];
                    break;
                case 3:
                    cellSwitch.on = [_settings[NSStringFromSelector(@selector(openInButtonItem))] boolValue];
                    break;
                case 4:
                    cellSwitch.on = [_settings[NSStringFromSelector(@selector(emailButtonItem))] boolValue];
                    break;
                case 5:
                    cellSwitch.on = [_settings[NSStringFromSelector(@selector(viewModeButtonItem))] boolValue];
                    break;
                default: break;
            }break;
        }break;
        case PSPDFLinkActionSettings: {
            PSPDFLinkAction linkAction = [_settings[NSStringFromSelector(@selector(linkAction))] integerValue];
            cell.accessoryType = (indexPath.row == linkAction) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }break;
        case PSPDFCacheSettings: {
            PSPDFCacheStrategy cacheStrategy = [PSPDFCache sharedPSPDFCache].strategy;
            cell.accessoryType = (indexPath.row == cacheStrategy) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }break;
        default:
            break;
    }
    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case PSPDFPageTransitionSettings:
            _settings[NSStringFromSelector(@selector(pageTransition))] = @(indexPath.row);
            break;
        case PSPDFScrollDirectionSettings:
            _settings[NSStringFromSelector(@selector(scrollDirection))] = @(indexPath.row);
            break;
        case PSPDFPageModeSettings:
            _settings[NSStringFromSelector(@selector(pageMode))] = @(indexPath.row);
            break;
        case PSPDFCoverSettings:
            _settings[NSStringFromSelector(@selector(isDoublePageModeOnFirstPage))] = @(indexPath.row == 1);
            break;
        case PSPDFLinkActionSettings:
            _settings[NSStringFromSelector(@selector(linkAction))] = @(indexPath.row);
            break;
        case PSPDFCacheSettings:
            [[PSPDFCache sharedPSPDFCache] clearCache];
            [PSPDFCache sharedPSPDFCache].strategy = indexPath.row;
            break;
        default:
            break;
    }

    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:kGlobalVarChangeNotification object:indexPath];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Static

+ (NSDictionary *)settings { return _settings; }

@end
