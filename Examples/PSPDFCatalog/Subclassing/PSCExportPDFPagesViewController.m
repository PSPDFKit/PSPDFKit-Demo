//
//  PSCExportPDFPagesViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExportPDFPagesViewController.h"

@interface PSCExportThumbnailsViewController : PSPDFThumbnailViewController <MFMailComposeViewControllerDelegate> @end
@interface PSCExportPDFPagesViewController () <PSPDFViewControllerDelegate> @end

@implementation PSCExportPDFPagesViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document configuration:(PSPDFConfiguration *)configuration {
    [super commonInitWithDocument:document configuration:[configuration configurationUpdatedWithBuilder:^(PSPDFConfigurationBuilder *builder) {
        [builder overrideClass:PSPDFThumbnailViewController.class withClass:PSCExportThumbnailsViewController.class];
    }]];
    [self updateToolbarButtons];
    self.delegate = self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

// Show the edit button only when we're in thumbnail mode.
- (void)updateToolbarButtons {
    if (self.viewMode == PSPDFViewModeDocument) {
        self.rightBarButtonItems = @[self.searchButtonItem, self.outlineButtonItem, self.viewModeButtonItem];
    } else {
        self.rightBarButtonItems = @[self.thumbnailController.editButtonItem, self.viewModeButtonItem];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (void)pdfViewController:(PSPDFViewController *)pdfController didChangeViewMode:(PSPDFViewMode)viewMode {
    [self updateToolbarButtons];
}

@end

@interface PSCActionContainerView : UICollectionReusableView @end
@implementation PSCExportThumbnailsViewController {
    UIButton *_actionBar;
}

static NSString *const PSPDFActionBar = @"PSPDFActionBar";

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFThumbnailViewController

- (instancetype)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithDocument:document])) {
        // Register class
        [self.collectionView registerClass:PSCActionContainerView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:PSPDFActionBar];

        // Create action button
        _actionBar = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_actionBar setTitle:@"Send Pages via Email" forState:UIControlStateNormal];
        [_actionBar addTarget:self action:@selector(sendSelectedPagesViaEmail:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];

    // Enable multiple selection
    self.collectionView.allowsMultipleSelection = editing;

    // Remove filter bar, add action bar instead
    [self.collectionView reloadData];
    [self updateActionButtonEnabledState];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)updateActionButtonEnabledState {
    _actionBar.enabled = self.collectionView.indexPathsForSelectedItems.count > 0;
}

// Shows the popover to flatten/not flatten.
- (void)sendSelectedPagesViaEmail:(id)sender {
    PSPDFActionSheet *actionSheet = [[PSPDFActionSheet alloc] initWithTitle:nil];
    [actionSheet addButtonWithTitle:@"Pages with Annotations" block:^(NSInteger buttonIndex) {
        [self createTemporaryPDFAndOpenEmailControllerWithAnnotationsFlattened:NO];
    }];
    [actionSheet addButtonWithTitle:@"Flattened Pages" block:^(NSInteger buttonIndex) {
        [self createTemporaryPDFAndOpenEmailControllerWithAnnotationsFlattened:YES];
    }];
    [actionSheet setCancelButtonWithTitle:@"Cancel" block:nil]; // iPhone support
    [actionSheet showWithSender:sender fallbackView:self.view animated:YES];
}

- (void)createTemporaryPDFAndOpenEmailControllerWithAnnotationsFlattened:(BOOL)flattened {
    // Prepare the email sheet
    MFMailComposeViewController *mailViewController = [MFMailComposeViewController new];
    [mailViewController setSubject:self.document.title];
    mailViewController.mailComposeDelegate = self;
    mailViewController.modalPresentationStyle = UIModalPresentationFormSheet;

    // Create an indexSet out of all selected pages
    NSMutableIndexSet *selectedPages = [NSMutableIndexSet new];
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
        [selectedPages addIndex:indexPath.row];
    }

    // Crunch the PDF
    if (selectedPages.count) {
		PSPDFStatusHUDItem *status = [PSPDFStatusHUDItem progressWithText:[PSPDFLocalize(@"Preparing") stringByAppendingString:@"…"]];
		[status pushAnimated:YES];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *options = flattened ? @{PSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeAll&~PSPDFAnnotationTypeLink)} : @{PSPDFProcessorAnnotationAsDictionary : @YES};
            // TODO: use file-based version to support larger PDFs.
            NSError *error = nil;
            NSData *data = [PSPDFProcessor.defaultProcessor generatePDFFromDocument:self.document pageRanges:@[selectedPages] options:options progressBlock:^(NSUInteger currentPage, NSUInteger numberOfProcessedPages, NSUInteger totalPages) {
				dispatch_async(dispatch_get_main_queue(), ^{
					status.progress = (numberOfProcessedPages + 1) / (float)totalPages;
				});
            } error:&error];

            dispatch_async(dispatch_get_main_queue(), ^{
				[status popAnimated:YES];
                if (data) {
                    [mailViewController addAttachmentData:data mimeType:@"application/pdf" fileName:@"SelectedPages.pdf"];
                    [((PSPDFViewController *)self.parentViewController) presentViewController:mailViewController options:@{PSPDFPresentationStyleKey : @(PSPDFPresentationStyleModal)} animated:YES sender:nil completion:NULL];
                } else {
                    // Handle error state
                    [[[PSPDFAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Failed to extract pages: %@", error.localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
                }
            });
        });
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UICollectionViewDataSource

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    // Return regular filter bar OR our custon action bar if we're editing.
    if (!self.isEditing) {
        return (UICollectionReusableView *)[super collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    } else {
        UICollectionReusableView *headerView = nil;
        if ([kind isEqualToString:UICollectionElementKindSectionHeader] && indexPath.section == 0) {
            headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:PSPDFActionBar forIndexPath:indexPath];
            [headerView addSubview:_actionBar];

            // Just being lazy here, this could be size differently.
            headerView.userInteractionEnabled = YES;
            CGFloat segmentBarWidth = self.filterSegment.frame.size.width;
            _actionBar.frame = CGRectIntegral(CGRectMake((self.view.bounds.size.width - segmentBarWidth) / 2, ((UICollectionViewFlowLayout *)self.layout).sectionInset.top, segmentBarWidth, 32.f));
        }
        return headerView;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UICollectionViewDelegate

// Ignore tap if we're in edit mode.
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isEditing) {
        [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    } else {
        [self updateActionButtonEnabledState];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self updateActionButtonEnabledState];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // Be lazy, the parent PSPDFViewController already handles this properly.
    [((PSPDFViewController *)self.parentViewController) mailComposeController:controller didFinishWithResult:result error:error];
}

@end

@implementation PSCActionContainerView

// Allow using the section even though it's outside of the parent's bounds.
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.subviews.count && CGRectContainsPoint([self.subviews[0] frame], point)) {
        return YES;
    }
    return [super pointInside:point withEvent:event];
}

@end
