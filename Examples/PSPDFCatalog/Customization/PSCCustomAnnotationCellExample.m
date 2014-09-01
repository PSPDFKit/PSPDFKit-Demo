//
//  PSCCustomAnnotationCellExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"

@interface PSCCustomAnnotationCell : PSPDFAnnotationCell
@property (nonatomic, strong) UIButton *shareButton;
- (void)updateShareButton;
@end

@interface PSCCustomAnnotationTableViewController : PSPDFAnnotationTableViewController
+ (BOOL)isAnnotationShared:(PSPDFAnnotation *)annotation;
+ (void)toggleAnnotationSharingStatus:(PSPDFAnnotation *)annotation;
@end

@interface PSCCustomFlexibleAnnotationToolbar : PSPDFFlexibleAnnotationToolbar @end
@interface PSCCustomAnnotationStateManager : PSPDFAnnotationStateManager @end

@interface PSCCustomAnnotationCellExample : PSCExample @end
@implementation PSCCustomAnnotationCellExample

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"Subclassing PSPDFAnnotationCell";
        self.contentDescription = @"Customize the annotation cell in the PSPDFAnnotationTableViewController";
        self.category = PSCExampleCategoryViewCustomization;
        self.priority = 70;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kPSPDFQuickStart];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document configuration:[PSPDFConfiguration configurationWithBuilder:^(PSPDFConfigurationBuilder *builder) {
        // Register the class overrides.
        [builder overrideClass:PSPDFAnnotationCell.class withClass:PSCCustomAnnotationCell.class];
        [builder overrideClass:PSPDFAnnotationTableViewController.class withClass:PSCCustomAnnotationTableViewController.class];

        [builder overrideClass:PSPDFFlexibleAnnotationToolbar.class withClass:PSCCustomFlexibleAnnotationToolbar.class];
        [builder overrideClass:PSPDFAnnotationStateManager.class withClass:PSCCustomAnnotationStateManager.class];
    }]];
    pdfController.outlineButtonItem.availableControllerOptions = [NSOrderedSet orderedSetWithObject:@(PSPDFOutlineBarButtonItemOptionAnnotations)];

    // Automate pressing the outline button.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [pdfController.outlineButtonItem action:pdfController.outlineButtonItem];
    });

    return pdfController;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCCustomAnnotationCell

// Note: The UI here isn't great. I would recommend a smaller sharing *indicator* and using a "More" button to actually enable/disable sharing, but I wanted to present both ways (including how to add a button to the cell) to make the example more interesting.
@implementation PSCCustomAnnotationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Add sharing button
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setTitleColor:[UIColor colorWithRed:0.9f green:0.f blue:0.f alpha:1.f] forState:UIControlStateNormal];
        [_shareButton setTitleColor:[UIColor colorWithRed:0.7f green:0.f blue:0.f alpha:1.f] forState:UIControlStateHighlighted];
        [self.contentView addSubview:_shareButton];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFAnnotationCell

+ (CGFloat)heightForAnnotation:(PSPDFAnnotation *)annotation constrainedToSize:(CGSize)constrainedToSize {
    // This shouldn't be hardcoded, but it's good enough for an example.
    BOOL isShared = [PSCCustomAnnotationTableViewController isAnnotationShared:annotation];
    constrainedToSize.width -= isShared ? 50 : 70;
    return [super heightForAnnotation:annotation constrainedToSize:constrainedToSize];
}

- (void)setAnnotation:(PSPDFAnnotation *)annotation {
    [super setAnnotation:annotation];
    [self updateShareButton];
}

- (void)prepareForReuse {
    [super prepareForReuse];

    // Clear all targets.
    [self.shareButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];

    // There's no implicit animation block, so we have to animate manually.
    [UIView animateWithDuration:animated ? 0.3f : 0.f animations:^{
        self.shareButton.alpha = editing ? 0.f : 1.f;
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateShareButton];

    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.size.width = CGRectGetWidth(self.contentView.frame) - CGRectGetWidth(self.imageView.frame) - 50.f - CGRectGetWidth(self.shareButton.frame);
    self.textLabel.frame = textLabelFrame;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Share Button Update Logic

- (void)updateShareButton {
    BOOL isShared = [PSCCustomAnnotationTableViewController isAnnotationShared:self.annotation];
    [self.shareButton setTitle:NSLocalizedString(isShared ? @"Unshare" : @"Share", @"") forState:UIControlStateNormal];

    // Update frame
    [self.shareButton sizeToFit];
    CGRect bounds = self.contentView.bounds;
    CGSize buttonSize = self.shareButton.frame.size;
    self.shareButton.frame = CGRectIntegral((CGRect){{bounds.size.width-buttonSize.width-10.f, (bounds.size.height-buttonSize.height)/2}, buttonSize});
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCCustomAnnotationTableViewController

@implementation PSCCustomAnnotationTableViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Sharing Helper

// Obviously, it's not a good idea to use `userInfo` for this, but it works for this example to show class override.
+ (BOOL)isAnnotationShared:(PSPDFAnnotation *)annotation {
    return [annotation.userInfo[@"shared"] boolValue];
}

+ (void)setAnnotationShared:(PSPDFAnnotation *)annotation sharingStatus:(BOOL)sharingStatus {
    annotation.userInfo = @{@"shared" : @(sharingStatus)};
}

+ (void)toggleAnnotationSharingStatus:(PSPDFAnnotation *)annotation {
    BOOL isShared = [self isAnnotationShared:annotation];
    [self setAnnotationShared:annotation sharingStatus:!isShared];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate/DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PSCCustomAnnotationCell *cell = (PSCCustomAnnotationCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];

    // Configure cell, connect the button.
    [cell.shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

// NOTE: For the sake of a short and clear example, we're using a shortcut here with API that is not documented.
// See https://gist.github.com/steipete/10541433 for more details and possible better solutions.
- (NSString *)tableView:(UITableView *)tableView titleForSwipeAccessoryButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    PSPDFAnnotation *annotation = [self annotationForIndexPath:indexPath];
    BOOL isShared = [self.class isAnnotationShared:annotation];
    return NSLocalizedString(isShared ? @"Unshare" : @"Share", @"");
}

- (void)tableView:(UITableView *)tableView swipeAccessoryButtonPushedForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Invert the share property.
    PSPDFAnnotation *annotation = [self annotationForIndexPath:indexPath];
    [self.class toggleAnnotationSharingStatus:annotation];

    // Trigger update of the share indicator.
    PSCCustomAnnotationCell *cell = (PSCCustomAnnotationCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell updateShareButton];

    // Hide the Share/Delete menu.
    [self setEditing:NO animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Button Action

- (void)shareButtonPressed:(id)sender {
    // Crawl up the hierarchy to find the cell.
    PSCCustomAnnotationCell *cell = sender;
    while (![cell isKindOfClass:PSCCustomAnnotationCell.class]) {
        cell = (PSCCustomAnnotationCell *)cell.superview;
    }

    // Toggle the state.
    PSPDFAnnotation *annotation = cell.annotation;
    if (annotation) {
        [PSCCustomAnnotationTableViewController toggleAnnotationSharingStatus:annotation];
        [cell updateShareButton];

        // Just in case, end editing.
        [self setEditing:NO animated:YES];
    }
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCCustomFlexibleAnnotationToolbar

@implementation PSCCustomFlexibleAnnotationToolbar

- (instancetype)initWithAnnotationStateManager:(PSPDFAnnotationStateManager *)annotationStateManager {
    return [super initWithAnnotationStateManager:annotationStateManager];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCCustomAnnotationStateManager

@implementation PSCCustomAnnotationStateManager

- (BOOL)stateShowsStylePicker:(NSString *)state {
    return NO;
}

@end
