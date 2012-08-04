//
//  PSPDFKit.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

// PSPDFKit is compatible with iOS 4.3+, but needs a modern Xcode.
#if !defined(__clang__) || __clang_major__ < 4
#error This project must be compiled with ARC (Xcode 4.4+ with LLVM 4+)
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_4_3
#error PSPDFKit supports iOS 4.3 upwards.
#endif

#import <UIKit/UIKit.h>
#import "PSPDFKitGlobal.h"
#import "PSPDFConverter.h"
#import "PSPDFGlobalLock.h"
#import "PSPDFViewController.h"
#import "PSPDFViewControllerDelegate.h"
#import "PSPDFDocument.h"
#import "PSPDFPageView.h"
#import "PSPDFTextSelectionView.h"
#import "PSPDFScrollView.h"
#import "PSPDFGlobalLock.h"
#import "PSPDFDocumentProvider.h"
#import "PSPDFCache.h"
#import "PSPDFTransparentToolbar.h"
#import "PSPDFPageRenderer.h"
#import "PSPDFPageInfo.h"
#import "PSPDFHUDView.h"
#import "PSPDFPositionView.h"
#import "PSPDFPagedScrollView.h"
#import "PSPDFPageViewController.h"
#import "PSPDFSinglePageViewController.h"
#import "PSPDFTabbedViewController.h"
#import "PSPDFViewState.h"
#import "PSPDFPasswordView.h"
#import "PSPDFAlertView.h"
#import "PSPDFActionSheet.h"
#import "PSPDFBookmark.h"

// search
#import "PSPDFTextSearch.h"
#import "PSPDFTextParser.h"
#import "PSPDFSearchViewController.h"
#import "PSPDFSearchResult.h"
#import "PSPDFSearchHighlightView.h"

// thumbnails
#import "PSPDFScrobbleBar.h"
#import "PSPDFThumbnailGridViewCell.h"
#import "UIImage+PSPDFKitAdditions.h"
#import "PSCollectionView.h"
#import "PSCollectionViewCell.h"
#import "PSCollectionViewFlowLayout.h"

// outline
#import "PSPDFOutlineParser.h"
#import "PSPDFOutlineElement.h"
#import "PSPDFOutlineViewController.h"

// annotations
#import "PSPDFAnnotationParser.h"
#import "PSPDFAnnotation.h"
#import "PSPDFHighlightAnnotation.h"
#import "PSPDFFreeTextAnnotation.h"
#import "PSPDFNoteAnnotation.h"
#import "PSPDFInkAnnotation.h"
#import "PSPDFLineAnnotation.h"
#import "PSPDFLinkAnnotation.h"
#import "PSPDFShapeAnnotation.h"
#import "PSPDFAnnotationView.h"
#import "PSPDFLinkAnnotationView.h"
#import "PSPDFHighlightAnnotationView.h"
#import "PSPDFVideoAnnotationView.h"
#import "PSPDFWebAnnotationView.h"
#import "PSPDFWebViewController.h"
#import "PSPDFSelectionView.h"

// toolbar
#import "PSPDFBarButtonItem.h"
