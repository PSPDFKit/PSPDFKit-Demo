//
//  PSPDFKit.h
//  PSPDFKit
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

// ARC is compatible with iOS 4.0 upwards, but you need at least Xcode 4.2 with Clang LLVM 3.0 to compile it.
#if !defined(__clang__) || __clang_major__ < 3
#error This project must be compiled with ARC (Xcode 4.2+ with LLVM 3.0 and above)
#endif

// general
#import <UIKit/UIKit.h>
#import "PSPDFKitGlobal.h"
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
#import "UIView+PSSizes.h"
#import "PSPDFPageRenderer.h"
#import "PSPDFPageInfo.h"
#import "PSPDFHUDView.h"
#import "PSPDFPositionView.h"

// search
#define kPSPDFSearchMinimumLength 3
#import "PSPDFDocumentSearcher.h"
#import "PSPDFSearchViewController.h"
#import "PSPDFSearchResult.h"
#import "PSPDFSearchHighlightView.h"
#import "PSPDFSimpleTextExtractor.h"

// thumbnails
#import "PSPDFScrobbleBar.h"
#import "PSPDFThumbnailGridViewCell.h"
#import "UIImage+PSPDFKitAdditions.h"
#import "GMGridView.h"
#import "GMGridViewLayoutStrategies.h"

// outline
#import "PSPDFOutlineParser.h"
#import "PSPDFOutlineElement.h"
#import "PSPDFOutlineViewController.h"

// annotations
#import "PSPDFAlertView.h"
#import "PSPDFTilingView+Annotations.h"
#import "PSPDFAnnotationParser.h"
#import "PSPDFAnnotation.h"
#import "PSPDFAnnotationView.h"
#import "PSPDFLinkAnnotationView.h"
#import "PSPDFHighlightAnnotationView.h"
#import "PSPDFVideoAnnotationView.h"
#import "PSPDFWebAnnotationView.h"
