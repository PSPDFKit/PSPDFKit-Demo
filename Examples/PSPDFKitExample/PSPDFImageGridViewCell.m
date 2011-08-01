//
//  AMImageGridViewCell.m
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/22/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFMagazine.h"
#import "PSPDFMagazineFolder.h"
#import "PSPDFImageGridViewCell.h"

@implementation PSPDFImageGridViewCell

@synthesize magazineCount = magazineCount_;
@synthesize magazine = magazine_;
@synthesize magazineFolder = magazineFolder_;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSObject

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)aReuseIdentifier {
    if ((self = [super initWithFrame:frame reuseIdentifier:aReuseIdentifier])) {
        self.selectionStyle = AQGridViewCellSelectionStyleGlow;
        self.selectionGlowColor = [UIColor blueColor];
        
        // uncomment to hide label
        //showingSiteLabel_ = NO;
    }
    
    return self;
}

- (void)dealloc {
    [[PSPDFCache sharedPSPDFCache] removeDelegate:self];
    [magazine_ release];
    [magazineFolder_ release];
    [magazineCounter_ release];
    [progressView_ release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Public

- (void)setMagazine:(PSPDFMagazine *)magazine {
    if (self.magazineFolder) {
        self.magazineFolder = nil;
    }
    
    if (magazine_ != magazine) {
        [magazine_ release];
        magazine_ = [magazine retain];
        
        // setup for magazine
        if (magazine) {
            self.magazineCount = 0;
            self.image = [magazine coverImage];
        }
        
        self.sideLabel.text = magazine.title;
    }
}

- (void)setMagazineFolder:(PSPDFMagazineFolder *)magazineFolder {
    if (self.magazine) {
        self.magazine = nil;
    }
    
    if (magazineFolder_ != magazineFolder) {
        [magazineFolder_ release];
        magazineFolder_ = [magazineFolder retain];
                
        // setup for folder
        if (magazineFolder) {
            NSUInteger magazineCount = [magazineFolder.magazines count];
            self.magazineCount = magazineCount;
            
            PSPDFMagazine *coverMagazine = [magazineFolder firstMagazine];
            self.image = [coverMagazine coverImage];
        }
        self.sideLabel.text = magazineFolder_.title;
    }
}

#define kMagazineCountLabelTag 32443
- (void)setMagazineCount:(NSUInteger)newMagazineCount {
    if (!magazineCounter_) { // lazy creation
        magazineCounterBadgeImage_= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"badge"]];
        magazineCounterBadgeImage_.opaque = NO;
        magazineCounterBadgeImage_.alpha = 0.9;
        magazineCounterBadgeImage_.frame = CGRectMake(0, 0, 50, 50);
        [self.contentView addSubview:magazineCounterBadgeImage_];
        
        magazineCounter_ = [[UILabel alloc] init];
        magazineCounter_.font = [UIFont boldSystemFontOfSize:20];
        magazineCounter_.textColor = [UIColor whiteColor];
        magazineCounter_.shadowColor = [UIColor blackColor];
        magazineCounter_.shadowOffset = CGSizeMake(1, 1);
        magazineCounter_.backgroundColor = [UIColor clearColor];
        magazineCounter_.frame = CGRectMake(1, 1, 25, 25);
        magazineCounter_.textAlignment = UITextAlignmentCenter;
        [self.contentView addSubview:magazineCounter_];
    }
    
    magazineCounter_.text = [NSString stringWithFormat:@"%d", newMagazineCount];
    magazineCounter_.hidden = newMagazineCount < 2;
    magazineCounterBadgeImage_.hidden = newMagazineCount < 2;
}

- (CALayer *)glowSelectionLayer {
    return imageView_.layer;
}

- (UIImage *)image {
    return imageView_.image;
}

- (void)setImage:(UIImage *)anImage {
    imageView_.image = anImage;
    [self setNeedsLayout];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark AQGridViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.magazine = nil;
    self.magazineFolder = nil;
    MCReleaseViewNil(progressView_);
    MCReleaseViewNil(magazineCounter_);   
    MCReleaseViewNil(magazineCounterBadgeImage_);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFCacheDelegate

- (void)didCachePageForDocument:(PSPDFDocument *)document page:(NSUInteger)page image:(UIImage *)cachedImage size:(PSPDFSize)size; {
    PSPDFMagazine *magazine = self.magazine;
    if (!magazine && [self.magazineFolder.magazines count]) {
        magazine = [self.magazineFolder.magazines objectAtIndex:0];
    }
    
    if (magazine == document && page == 0 && size == PSPDFSizeThumbnail) {
        self.image = cachedImage;
        imageView_.alpha = 0.0;
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            imageView_.alpha = 1.0;
        } completion:nil];
    }    
}

@end
