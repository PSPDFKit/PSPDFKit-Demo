//
//  AMAsyncImageGridViewCell.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 7/20/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFKit.h"
#import "AQGridViewCell.h"

// if own thumbs are provided and they are larger than the cell, apply shrinking before setting
#define kPSPDFShrinkOwnImagesTresholdFactor 1.5

// animated thumb loading is pretty slow
//#define kPSPDFAnimateThumbnailLoading

@interface PSPDFThumbnailGridViewCell : AQGridViewCell <PSPDFCacheDelegate> {
    PSPDFDocument *document_;
    UIImageView *imageView_;
    UILabel *sideLabel_;
    NSUInteger page_;
    BOOL shadowEnabled_;
    BOOL showingSiteLabel_;
}

@property (nonatomic, retain) PSPDFDocument *document;
@property (nonatomic, retain) UILabel *sideLabel;
@property (nonatomic, assign) NSUInteger page;

// enables thumbnail shadow. defaults to YES
@property (nonatomic, assign, getter=isShadowEnabled) BOOL shadowEnabled;

// enable page label
@property (nonatomic, assign, getter=isShowingSiteLabel) BOOL showingSiteLabel;

@end
