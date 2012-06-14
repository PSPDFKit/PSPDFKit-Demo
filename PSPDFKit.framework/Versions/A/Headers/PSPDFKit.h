//
//  PSPDFKit.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

// ARC is compatible with iOS 4.0 upwards, but you need a modern Xcode.
#if !defined(__clang__) || __clang_major__ < 3
#error This project must be compiled with ARC (Xcode 4.3.2+ with LLVM 3.1 and above)
#endif

#import <UIKit/UIKit.h>
#import "PSPDFKitGlobal.h"
#import "PSPDFConverter.h"
#import "PSPDFGlobalLock.h"
#import "PSPDFViewController.h"
#import "PSPDFViewControllerDelegate.h"
#import "PSPDFDocument.h"
#import "PSPDFPageView.h"
#import "PSPDFTilingView.h"
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

// search
#define kPSPDFSearchMinimumLength 3
#import "PSPDFTextSearch.h"
#import "PSPDFSearchViewController.h"
#import "PSPDFSearchResult.h"
#import "PSPDFSearchHighlightView.h"
#import "PSPDFSimpleTextExtractor.h"

// thumbnails
#import "PSPDFScrobbleBar.h"
#import "PSPDFThumbnailGridViewCell.h"
#import "PSPDFGridView.h"
#import "PSPDFGridViewLayoutStrategies.h"
#import "UIImage+PSPDFKitAdditions.h"

// outline
#import "PSPDFOutlineParser.h"
#import "PSPDFOutlineElement.h"
#import "PSPDFOutlineViewController.h"

// annotations
#import "PSPDFAnnotationParser.h"
#import "PSPDFAnnotation.h"
#import "PSPDFHighlightAnnotation.h"
#import "PSPDFFreeTextAnnotation.h"
#import "PSPDFTextAnnotation.h"
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

// toolbar
#import "PSPDFBarButtonItem.h"
