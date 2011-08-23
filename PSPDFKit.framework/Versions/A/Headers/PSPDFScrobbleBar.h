//
//  PSPFScrobbleBar.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 07.04.11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFCache.h"
#import "PSPDFMAZeroingWeakRef.h"

/// Scrobble bar like iBooks
@interface PSPDFScrobbleBar : UIToolbar <PSPDFCacheDelegate> {
    PSPDFMAZeroingWeakRef *pdfControllerRef_; // PSPDFViewController
    NSUInteger page_;
    NSInteger pageMarkerPage_;
    NSUInteger thumbCount_;
    NSInteger lastTouchedPage_;
    BOOL touchInProgress_;
    BOOL viewLocked_;
    
    UIImageView *positionImage_;
    UIImageView *positionImage2_;
    NSMutableDictionary *imageViews_;    // NSNumber (page) -> UIImageView
}

/// initialize
- (id)initWithPDFController:(PSPDFViewController *)pdfController;

/// updates toolbar, realigns page screenshots.
- (void)updateToolbar;

/// updates the page marker. call manually after alpha > 0 !
- (void)updatePageMarker;

/// current selected page
@property(nonatomic, assign) NSUInteger page;

/// locks view for animations
@property(nonatomic, assign, getter=isViewLocked) BOOL viewLocked;


@end
