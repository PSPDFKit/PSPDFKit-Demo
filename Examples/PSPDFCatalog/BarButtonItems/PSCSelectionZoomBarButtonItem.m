//
//  PSPDFSelectionZoomBarButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

//#import "PSCSelectionZoomBarButtonItem.h"
//
//@interface PSCSelectionZoomBarButtonItem() <PSPDFSelectionViewDelegate>
//@property (nonatomic, strong) PSPDFSelectionView *selectionView;
//
//@property (nonatomic, assign) BOOL savedRotationLock, savedViewLock;
//@end
//
//@implementation PSCSelectionZoomBarButtonItem
//
/////////////////////////////////////////////////////////////////////////////////////////////
//#pragma mark - PSPDFBarButtonitem
//
//- (BOOL)isAvailable {
//    return [super isAvailable] && self.pdfController.viewMode == PSPDFViewModeDocument;
//}
//
//- (UIImage *)image {
//     return self.selectionView ? [UIImage imageNamed:@"eye-deactivate"] : [UIImage imageNamed:@"eye"];
//}
//
//- (NSString *)actionName {
//    return PSPDFLocalize(@"Zoom to Area");
//}
//
//- (BOOL)cleanup {
//    if (self.selectionView) {
//        PSPDFViewController *pdfController = self.pdfController;
//        pdfController.rotationLockEnabled = self.savedRotationLock;
//        pdfController.viewLockEnabled = self.savedViewLock;
//        self.selectionView.delegate = nil;
//        [self.selectionView removeFromSuperview];
//        self.selectionView = nil;
//        return YES;
//    }
//    return NO;
//}
//
//// override default handler
//- (void)action:(id)sender {
//    [self.pdfController dismissViewControllerAnimated:YES class:nil completion:NULL];
//
//    if (![self cleanup]) {
//        // disable various features to lock UI
//        PSPDFViewController *pdfController = self.pdfController;
//        self.savedViewLock = pdfController.isViewLockEnabled;
//        self.savedRotationLock = pdfController.isRotationLockEnabled;
//        pdfController.viewLockEnabled = YES;
//        pdfController.rotationLockEnabled = YES;
//
//        PSPDFPageView *pageView = [pdfController pageViewForPage:pdfController.page];
//
//        self.selectionView = [[PSPDFSelectionView alloc] initWithFrame:pageView.bounds delegate:self];
//        [pageView addSubview:self.selectionView];
//    }
//#warning TODO
////    [self updateEyeButton];
//}
//
/////////////////////////////////////////////////////////////////////////////////////////////
//#pragma mark - PSPDFSelectionViewDelegate
//
//- (void)selectionView:(PSPDFSelectionView *)selectionView finishedWithSelectedRect:(CGRect)rect {
//    PSPDFViewController *pdfController = self.pdfController;
//    [pdfController zoomToRect:rect page:pdfController.page animated:YES];
//    [self cleanup];
//#warning TODO
////    [self updateEyeButton];
//}
//
//@end
