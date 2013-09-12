//
//  PSPDFKit.h
//  PSPDFKit
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#if !defined(__clang__) || __clang_major__ < 4
#error This project must be compiled with ARC (Xcode 4.6.3+ with LLVM 4+)
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0
#error PSPDFKit supports iOS 5.0 upwards.
#endif

// common
#import <UIKit/UIKit.h>
#import "PSPDFKitGlobal.h"
#import "PSPDFConverter.h"
#import "PSPDFGlobalLock.h"
#import "PSPDFViewController.h"
#import "PSPDFViewControllerDelegate.h"
#import "PSPDFViewController+Delegates.h"
#import "PSPDFDocument.h"
#import "PSPDFDocumentDelegate.h"
#import "PSPDFPageView.h"
#import "PSPDFTextSelectionView.h"
#import "PSPDFScrollView.h"
#import "PSPDFDocumentProvider.h"
#import "PSPDFDocumentProviderDelegate.h"
#import "PSPDFCache.h"
#import "PSPDFTransparentToolbar.h"
#import "PSPDFPageRenderer.h"
#import "PSPDFPageInfo.h"
#import "PSPDFHUDView.h"
#import "PSPDFContentScrollView.h"
#import "PSPDFPageViewController.h"
#import "PSPDFSinglePageViewController.h"
#import "PSPDFPageScrollViewController.h"
#import "PSPDFMultiDocumentViewController.h"
#import "PSPDFViewState.h"
#import "PSPDFBookmark.h"
#import "PSPDFBookmarkParser.h"
#import "PSPDFBrightnessViewController.h"
#import "PSPDFLicenseManager.h"
#import "PSPDFRenderQueue.h"
#import "PSPDFStyleManager.h"

// actions
#import "PSPDFAction.h"
#import "PSPDFGoToAction.h"
#import "PSPDFRemoteGoToAction.h"
#import "PSPDFURLAction.h"
#import "PSPDFNamedAction.h"
#import "PSPDFJavaScriptAction.h"
#import "PSPDFRenditionAction.h"
#import "PSPDFRichMediaExecuteAction.h"
#import "PSPDFSubmitFormAction.h"
#import "PSPDFResetFormAction.h"
#import "PSPDFHideAction.h"

// views
#import "PSPDFPageLabelView.h"
#import "PSPDFDocumentLabelView.h"
#import "PSPDFRenderStatusView.h"
#import "PSPDFPasswordView.h"
#import "PSPDFActivityLabel.h"

// search
#import "PSPDFTextSearch.h"
#import "PSPDFTextParser.h"
#import "PSPDFGlyph.h"
#import "PSPDFWord.h"
#import "PSPDFTextBlock.h"
#import "PSPDFImageInfo.h"
#import "PSPDFSearchViewController.h"
#import "PSPDFSearchResult.h"
#import "PSPDFSearchHighlightView.h"

// thumbnails
#import "PSPDFThumbnailViewController.h"
#import "PSPDFMultiDocumentThumbnailViewController.h"
#import "PSPDFThumbnailGridViewCell.h"
#import "PSPDFScrobbleBar.h"
#import "PSPDFThumbnailBar.h"
#import "PSTCollectionView.h"
#import "PSTCollectionViewCell.h"
#import "PSTCollectionViewFlowLayout.h"

// outline
#import "PSPDFOutlineParser.h"
#import "PSPDFOutlineElement.h"
#import "PSPDFOutlineViewController.h"

// labels
#import "PSPDFLabelParser.h"

// annotations
#import "PSPDFAnnotationManager.h"
#import "PSPDFAnnotation.h"
#import "PSPDFAnnotationSet.h"
#import "PSPDFAnnotationProvider.h"
#import "PSPDFFileAnnotationProvider.h"
#import "PSPDFHighlightAnnotation.h"
#import "PSPDFUnderlineAnnotation.h"
#import "PSPDFStrikeOutAnnotation.h"
#import "PSPDFSquigglyAnnotation.h"
#import "PSPDFFreeTextAnnotation.h"
#import "PSPDFNoteAnnotation.h"
#import "PSPDFInkAnnotation.h"
#import "PSPDFLineAnnotation.h"
#import "PSPDFLinkAnnotation.h"
#import "PSPDFSquareAnnotation.h"
#import "PSPDFCircleAnnotation.h"
#import "PSPDFStampAnnotation.h"
#import "PSPDFCaretAnnotation.h"
#import "PSPDFPopupAnnotation.h"
#import "PSPDFWidgetAnnotation.h"
#import "PSPDFScreenAnnotation.h"
#import "PSPDFRichMediaAnnotation.h"
#import "PSPDFFileAnnotation.h"
#import "PSPDFSoundAnnotation.h"
#import "PSPDFPolygonAnnotation.h"
#import "PSPDFPolyLineAnnotation.h"
#import "PSPDFAnnotationViewProtocol.h"
#import "PSPDFLinkAnnotationView.h"
#import "PSPDFHighlightAnnotationView.h"
#import "PSPDFFreeTextAnnotationView.h"
#import "PSPDFVideoAnnotationView.h"
#import "PSPDFNoteAnnotationView.h"
#import "PSPDFWebAnnotationView.h"
#import "PSPDFWebViewController.h"
#import "PSPDFSelectionView.h"
#import "PSPDFDrawView.h"
#import "PSPDFAnnotationToolbar.h"
#import "PSPDFSignatureViewController.h"
#import "PSPDFStampViewController.h"
#import "PSPDFFontSelectorViewController.h"
#import "PSPDFColorSelectionViewController.h"
#import "PSPDFLineEndSelectionViewController.h"
#import "PSPDFNoteAnnotationViewController.h"
#import "PSPDFAnnotationTableViewController.h"
#import "PSPDFAnnotationCell.h"
#import "PSPDFSavedAnnotationsViewController.h"
#import "PSPDFContainerViewController.h"

// tab bar
#import "PSPDFTabbedViewController.h"
#import "PSPDFTabBarView.h"
#import "PSPDFTabBarButton.h"

// toolbar (subclass buttons to change image)
#import "PSPDFIconGenerator.h"
#import "PSPDFBarButtonItem.h"
#import "PSPDFCloseBarButtonItem.h"
#import "PSPDFEmailBarButtonItem.h"
#import "PSPDFOpenInBarButtonItem.h"
#import "PSPDFPrintBarButtonItem.h"
#import "PSPDFSearchBarButtonItem.h"
#import "PSPDFMoreBarButtonItem.h"
#import "PSPDFViewModeBarButtonItem.h"
#import "PSPDFAnnotationBarButtonItem.h"
#import "PSPDFBookmarkBarButtonItem.h"
#import "PSPDFBrightnessBarButtonItem.h"
#import "PSPDFOutlineBarButtonItem.h"
#import "PSPDFActivityBarButtonItem.h"

// helper
#import "PSPDFAlertView.h"
#import "PSPDFActionSheet.h"
#import "PSPDFMenuItem.h"
#import "PSPDFProcessor.h"
#import "PSPDFProgressHUD.h"
#import "PSPDFColorButton.h"
#import "PSPDFHSVColorPickerController.h"
#import "PSPDFNavigationController.h"

// model
#import "PSPDFModel.h"
#import "PSPDFValueTransformer.h"

// full-text search
#import "PSPDFLibrary.h"
#import "PSPDFDocumentPickerController.h"

// XFDF
#import "PSPDFXFDFParser.h"
#import "PSPDFXFDFWriter.h"
#import "PSPDFXFDFAnnotationProvider.h"

// encryption
#import "PSPDFAESCryptoDataProvider.h"
#import "PSPDFCryptor.h"

// forms
#import "PSPDFFormParser.h"
#import "PSPDFFormElement.h"
#import "PSPDFButtonFormElement.h"
#import "PSPDFChoiceFormElement.h"
#import "PSPDFSignatureFormElement.h"
#import "PSPDFTextFieldFormElement.h"
