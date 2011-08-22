//
//  PSPDFImageGridViewCell.m
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/22/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFMagazine.h"
#import "PSPDFMagazineFolder.h"
#import "PSPDFImageGridViewCell.h"
#import "PSPDFDownload.h"
#import "PSPDFStoreManager.h"

@interface PSPDFImageGridViewCell()
- (void)setProgress:(float)theProgress animated:(BOOL)animated;
- (void)updateProgressAnimated:(BOOL)animated;
@end

@implementation PSPDFImageGridViewCell

@synthesize magazineCount = magazineCount_;
@synthesize magazine = magazine_;
@synthesize magazineFolder = magazineFolder_;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)checkMagazineAndObserveIfDownloading:(PSPDFMagazine *)magazine {
    if (magazine.isDownloading) {
        PSPDFDownload *download = [[PSPDFStoreManager sharedPSPDFStoreManager] downloadObjectForMagazine:magazine];
        [observedMagazineDownloads_ addObject:download];
        [download addObserver:self forKeyPath:@"downloadProgress" options:0 context:nil];
        [self updateProgressAnimated:NO];
    }
}

- (void)clearObservers {
    // clear all observed magazines
    for (PSPDFDownload *download in observedMagazineDownloads_) {
        [download removeObserver:self forKeyPath:@"downloadProgress"];            
    }
    [observedMagazineDownloads_ removeAllObjects];    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSObject

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)aReuseIdentifier {
    if ((self = [super initWithFrame:frame reuseIdentifier:aReuseIdentifier])) {
        self.selectionStyle = AQGridViewCellSelectionStyleGlow;
        self.selectionGlowColor = [UIColor blueColor];
        
        // incomplete downloads stay here
        observedMagazineDownloads_ = [[NSMutableSet alloc] init];
        
        // uncomment to hide label
        //showingSiteLabel_ = NO;
    }
    
    return self;
}

- (void)dealloc {
    [self clearObservers];
    [[PSPDFCache sharedPSPDFCache] removeDelegate:self];
    [observedMagazineDownloads_ release];
    [magazine_ release];
    [magazineFolder_ release];
    [magazineCounter_ release];
    [progressView_ release];
    [progressViewBackground_ release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark KVO

- (void)updateProgressAnimated:(BOOL)animated {
    float progressTotal = 1.0;
    
    if ([observedMagazineDownloads_ count]) {
        progressTotal = [[observedMagazineDownloads_ valueForKeyPath:@"@avg.downloadProgress"] floatValue];
    }
    
    [self setProgress:progressTotal animated:animated];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context; {
    if ([keyPath isEqualToString:@"downloadProgress"]) {
        [self updateProgressAnimated:YES];
    }
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
            // add kvo
            [self checkMagazineAndObserveIfDownloading:magazine];

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
        [self clearObservers];
        [magazineFolder_ release];
        magazineFolder_ = [magazineFolder retain];
        
        for (PSPDFMagazine *aMagazine in magazineFolder_.magazines) {
            [self checkMagazineAndObserveIfDownloading:aMagazine];
        }
        
        // setup for folder
        if (magazineFolder) {
            NSUInteger magazineCount = [magazineFolder.magazines count];
            self.magazineCount = magazineCount;
            
            PSPDFMagazine *coverMagazine = [magazineFolder firstMagazine];
            for (PSPDFMagazine *aMagazine in magazineFolder.magazines) {
                if (aMagazine.isDownloading) {
                    coverMagazine = aMagazine;
                    break;
                }
            }
            self.image = [coverMagazine coverImage];
        }
    }
}

#define kiPhoneReductionFactor 0.588
#define kMagazineCountLabelTag 32443
- (void)setMagazineCount:(NSUInteger)newMagazineCount {
    if (!magazineCounter_) { // lazy creation
        magazineCounterBadgeImage_= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"badge"]];
        magazineCounterBadgeImage_.opaque = NO;
        magazineCounterBadgeImage_.alpha = 0.9f;
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
#pragma mark - Progress

#define kProgressBarTag 32553
#define kProgressBarWidth 110
- (UIProgressView *)progressView {
    if (!progressView_) {
        progressView_ = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];    
        CGRect contentFrame = self.contentView.frame;
        CGFloat progressViewWidth = PSIsIpad() ? kProgressBarWidth : roundf(kProgressBarWidth * kiPhoneReductionFactor*1.1f);
        progressView_.frame = CGRectMake(0, 0, progressViewWidth, 21);
        progressView_.center = CGPointMake(roundf(contentFrame.size.width/2), roundf(contentFrame.size.height*10/11));
        [self.contentView addSubview:progressView_];
    }
    return progressView_;
}


- (void)darkenView:(BOOL)darken animated:(BOOL)animated {
    if(darken && !progressViewBackground_) {
        progressViewBackground_ = [[UIView alloc] initWithFrame:self.contentView.frame];
        progressViewBackground_.backgroundColor = [UIColor blackColor];
        progressViewBackground_.alpha = 0.5;
    }
    
    if (darken && !progressViewBackground_.superview) {
        progressViewBackground_.alpha = 0.0;
        [self.contentView addSubview:progressViewBackground_];
        [self.contentView bringSubviewToFront:[self progressView]];
        if (animated) {
            [UIView animateWithDuration:0.25 animations:^{
                progressViewBackground_.alpha = 0.5;                        
            }];
        }else {
            progressViewBackground_.alpha = 0.5;                                    
        }
    }else if(!darken && progressViewBackground_.superview) {
        if (animated) {
            [UIView animateWithDuration:0.25 animations:^{
                progressViewBackground_.alpha = 0.0;                                    
            } completion:^(BOOL finished) {
                if (finished) {
                    [progressViewBackground_ removeFromSuperview];
                }
            }];
        }else {
            [progressViewBackground_ removeFromSuperview];            
        }
    }
}

- (void)setProgress:(float)theProgress animated:(BOOL)animated {
    [[self progressView] setProgress:theProgress];
    BOOL shouldDarkenView = theProgress < 1.0;
    [self darkenView:shouldDarkenView animated:animated];
    
    // remove progressView
    if (!shouldDarkenView && progressView_.superview) {
        if (animated) {
            [UIView animateWithDuration:0.25 animations:^(void) {
                self.progressView.alpha = 0.0;
            } completion:^(BOOL finished) {
                MCReleaseViewNil(progressView_);
            }];
        }else {
            MCReleaseViewNil(progressView_);
        }
        
        // get magazine and refresh
        PSPDFMagazine *magazine = self.magazine;
        if (!magazine) {
            magazine = [self.magazineFolder firstMagazine];
            for (PSPDFMagazine *aMagazine in self.magazineFolder.magazines) {
                if (aMagazine.isDownloading) {
                    magazine = aMagazine;
                    break;
                }
            }
        }
        
        // refresh image
        self.image = [magazine coverImage];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark AQGridViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    [self clearObservers];
    [self darkenView:NO animated:NO];
    self.magazine = nil;
    self.magazineFolder = nil;
    MCReleaseViewNil(progressView_);
    MCReleaseViewNil(progressView_);
    MCReleaseViewNil(magazineCounter_);   
    MCReleaseViewNil(magazineCounterBadgeImage_);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFCacheDelegate

- (void)didCachePageForDocument:(PSPDFDocument *)document page:(NSUInteger)page image:(UIImage *)cachedImage size:(PSPDFSize)size; {
    PSPDFMagazine *magazine = self.magazine;
    if (!magazine) {
        magazine = [self.magazineFolder firstMagazine];
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
