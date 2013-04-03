//
//  PSPDFKit.h
//  PSPDFKit
//
//  Copyright 2011-2013 Peter Steinberger. All rights reserved.
//

// PSPDFKit is compatible with iOS 5.0+, but needs a modern Xcode.
#if !defined(__clang__) || __clang_major__ < 4
#error This project must be compiled with ARC (Xcode 4.6+ with LLVM 4+)
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0
#error PSPDFKit supports iOS 5.0 upwards.
#endif

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
#import "PSPDFCache.h"
#import "PSPDFTransparentToolbar.h"
#import "PSPDFPageRenderer.h"
#import "PSPDFPageInfo.h"
#import "PSPDFHUDView.h"
#import "PSPDFPageLabelView.h"
#import "PSPDFContentScrollView.h"
#import "PSPDFPageViewController.h"
#import "PSPDFSinglePageViewController.h"
#import "PSPDFPageScrollViewController.h"
#import "PSPDFTabbedViewController.h"
#import "PSPDFMultiDocumentViewController.h"
#import "PSPDFViewState.h"
#import "PSPDFPasswordView.h"
#import "PSPDFBookmark.h"
#import "PSPDFBookmarkParser.h"
#import "PSPDFAESCryptoDataProvider.h"
#import "PSPDFBrightnessViewController.h"

// rendering
#import "PSPDFRenderQueue.h"

// views
#import "PSPDFPageLabelView.h"
#import "PSPDFDocumentLabelView.h"

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
#import "PSTCollectionView.h"
#import "PSTCollectionViewCell.h"
#import "PSTCollectionViewFlowLayout.h"

// outline
#import "PSPDFOutlineParser.h"
#import "PSPDFOutlineElement.h"
#import "PSPDFOutlineViewController.h"

// annotations
#import "PSPDFAnnotationParser.h"
#import "PSPDFDocumentParser.h"
#import "PSPDFAnnotation.h"
#import "PSPDFAnnotationProvider.h"
#import "PSPDFFileAnnotationProvider.h"
#import "PSPDFHighlightAnnotation.h"
#import "PSPDFFreeTextAnnotation.h"
#import "PSPDFNoteAnnotation.h"
#import "PSPDFInkAnnotation.h"
#import "PSPDFLineAnnotation.h"
#import "PSPDFLinkAnnotation.h"
#import "PSPDFShapeAnnotation.h"
#import "PSPDFStampAnnotation.h"
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
#import "PSPDFNoteAnnotationController.h"

// labels
#import "PSPDFLabelParser.h"

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

// categories
#import "UIImage+PSPDFKitAdditions.h"
#import "NSDate+PSPDFKitAdditions.h"
#import "UIColor+PSPDFKitAdditions.h"
#import "NSValueTransformer+PSPDFPredefinedTransformerAdditions.h"

// model
#import "PSPDFModel.h"
#import "PSPDFValueTransformer.h"
