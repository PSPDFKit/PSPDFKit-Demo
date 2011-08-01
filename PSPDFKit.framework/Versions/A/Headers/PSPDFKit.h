//
//  PSPDFKit.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 7/20/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

// PDFKit features can be disabled - only compile what you use.
#define kPSPDFKitSearchFeature
#define kPSPDFKitThumbnailFeature

// for the demo page. if you purchased it, you most likely want to disable it.
//#define kPSPDFKitDemoMode

// general
#import <UIKit/UIKit.h>
#import "PSPDFKitGlobal.h"
#import "PSPDFViewController.h"
#import "PSPDFViewControllerDelegate.h"
#import "PSPDFDocument.h"
#import "PSPDFPage.h"
#import "PSPDFTilingView.h"
#import "PSPDFScrollView.h"
#import "PSPDFGlobalLock.h"
#import "PSPDFCache.h"
#import "PSPDFGlobalLock.h"
#import "PSPDFTransparentToolbar.h"
#import "UIView+PSSizes.h"

// search
#ifdef kPSPDFKitSearchFeature

#define kPSPDFSearchMinimumLength 1

#import "PSPDFDocumentSearcher.h"
#import "PSPDFSearchViewController.h"
#import "PSPDFSearchResult.h"

#endif


#ifdef kPSPDFKitThumbnailFeature
#import "PSPDFScrobbleBar.h"
#import "PSPDFThumbnailGridViewCell.h"
#import "UIImage+PSPDFKitAdditions.h"
#endif