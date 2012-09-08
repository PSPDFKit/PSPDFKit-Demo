//
//  PSPDFImageGridViewCell.m
//  PSPDFKitExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSCMagazine.h"
#import "PSCMagazineFolder.h"
#import "PSCImageGridViewCell.h"
#import "PSCDownload.h"
#import "PSCStoreManager.h"
#import "UIImageView+AFNetworking.h"

#define kPSPDFKitDownloadingKey @"downloading"
#define kPSPDFCellAnimationDuration 0.25f

@interface PSCImageGridViewCell() {
    __block NSOperation *imageLoadOperation_;
    UIImage *magazineOperationImage_;
    NSString *magazineTitle_;
    CGRect defaultFrame_;

    UIView *progressViewBackground_;
    UILabel *magazineCounter_;
    UIImageView *_magazineCounterBadgeImage;
    NSMutableSet *observedMagazineDownloads_;
}
@property(nonatomic, strong) UIImageView *magazineCounterBadgeImage;
@property(nonatomic, strong) UIProgressView *progressView;
- (void)setProgress:(float)theProgress animated:(BOOL)animated;
- (void)darkenView:(BOOL)darken animated:(BOOL)animated;
- (void)updateProgressAnimated:(BOOL)animated;
@end

@implementation PSCImageGridViewCell

static void *kPSPDFKVOToken;

void PSPDFDispatchIfNotOnMainThread(dispatch_block_t block);
void PSPDFDispatchIfNotOnMainThread(dispatch_block_t block) {
    if (block) {
        if ([NSThread isMainThread]) {
            block();
        }else {
            dispatch_async(dispatch_get_main_queue(), block);
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)checkMagazineAndObserveProgressIfDownloading:(PSCMagazine *)magazine {
    if (magazine.isDownloading) {
        PSCDownload *download = [[PSCStoreManager sharedStoreManager] downloadObjectForMagazine:magazine];
        if (!download) {
            PSPDFLogError(@"failed to find associated download object for %@", magazine);
            return;
        }
        [observedMagazineDownloads_ addObject:download];
        [download addObserver:self forKeyPath:NSStringFromSelector(@selector(downloadProgress)) options:NSKeyValueObservingOptionInitial context:kPSPDFKVOToken];
        [self updateProgressAnimated:NO];
    }
}

- (void)clearProgressObservers {
    // clear all observed magazines
    for (PSCDownload *download in observedMagazineDownloads_) {
        [download removeObserver:self forKeyPath:NSStringFromSelector(@selector(downloadProgress)) context:kPSPDFKVOToken];
    }
    [observedMagazineDownloads_ removeAllObjects];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        defaultFrame_ = frame;
        //self.deleteButtonIcon = [UIImage imageNamed:@"delete"];

        // incomplete downloads stay here
        observedMagazineDownloads_ = [[NSMutableSet alloc] init];

        self.showingSiteLabel = YES;
        self.edgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
    }

    return self;
}

- (void)dealloc {
    [_magazine removeObserver:self forKeyPath:kPSPDFKitDownloadingKey context:kPSPDFKVOToken];
    [self clearProgressObservers];
    [[PSPDFCache sharedCache] removeDelegate:self];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    //self.deleteButtonOffset = CGPointMake(self.imageView.frame.origin.x-10, self.imageView.frame.origin.y-10);
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    defaultFrame_ = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFThumbnailGridViewCell

// override to change label (default is within the image, has rounded borders)
- (void)updateSiteLabel {
    if (self.isShowingSiteLabel && !self.siteLabel.superview) {
        UILabel *siteLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        siteLabel.backgroundColor = [UIColor clearColor];
        siteLabel.textColor = [UIColor colorWithWhite:1.f alpha:1.f];
        siteLabel.shadowColor = [UIColor blackColor];
        siteLabel.shadowOffset = CGSizeMake(0, 1);
        siteLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
        siteLabel.textAlignment = UITextAlignmentCenter;
        siteLabel.font = [UIFont boldSystemFontOfSize:PSIsIpad() ? 16 : 12];
        self.siteLabel = siteLabel;
        [self.contentView addSubview:siteLabel];
    }else if(!self.isShowingSiteLabel && self.siteLabel.superview) {
        [self.siteLabel removeFromSuperview];
    }

    // calculate new frame and position correct
    self.siteLabel.frame = CGRectIntegral(CGRectMake(0, self.imageView.frame.origin.y+self.imageView.frame.size.height, self.frame.size.width, 20));

    if (self.siteLabel.superview) {
        [self.contentView bringSubviewToFront:self.siteLabel];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - KVO

- (void)updateProgressAnimated:(BOOL)animated {
    float progressTotal = 1.f;

    if ([observedMagazineDownloads_ count]) {
        progressTotal = [[observedMagazineDownloads_ valueForKeyPath:@"@avg.downloadProgress"] floatValue];
    }

    [self setProgress:progressTotal animated:animated];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == kPSPDFKVOToken) {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(downloadProgress))]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateProgressAnimated:YES];
            });
        }else if([keyPath isEqualToString:kPSPDFKitDownloadingKey]) {
            // check if magazine needs to be observed (if download progress is active)
            if (self.magazine.isDownloading && ![observedMagazineDownloads_ containsObject:self.magazine]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self checkMagazineAndObserveProgressIfDownloading:self.magazine];
                });
            }
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)setMagazine:(PSCMagazine *)magazine {
    if (self.magazineFolder) {
        self.magazineFolder = nil;
    }

    if (_magazine != magazine) {
        [_magazine removeObserver:self forKeyPath:kPSPDFKitDownloadingKey context:kPSPDFKVOToken];
        _magazine = magazine;

        // setup for magazine
        if (magazine) {

            // add KVO for download property
            [magazine addObserver:self forKeyPath:kPSPDFKitDownloadingKey options:0 context:kPSPDFKVOToken];

            // add KVO
            [self checkMagazineAndObserveProgressIfDownloading:magazine];

            self.magazineCount = 0;

            NSBlockOperation *imageLoadOperation = [NSBlockOperation new];
            __ps_weak NSBlockOperation *weakImageLoadOperation = imageLoadOperation;
            [imageLoadOperation addExecutionBlock:^{
                NSBlockOperation *strongImageLoadOperation = weakImageLoadOperation;
                if (!strongImageLoadOperation.isCancelled) {
                    magazineOperationImage_ = [magazine coverImageForSize:self.frame.size];
                }
                BOOL imageLoadedFromWeb = NO;
                if (!magazineOperationImage_ && !strongImageLoadOperation.isCancelled) {
                    // try to download image
                    if (!self.image && magazine.imageURL) {
                        imageLoadedFromWeb = YES;
                        PSPDFDispatchIfNotOnMainThread(^{
                            [self.imageView setImageWithURL:magazine.imageURL];
                        });
                    }
                }

                // also may be slow, parsing the title from PDF metadata.
                magazineTitle_ = magazine.title;

                if (!strongImageLoadOperation.isCancelled && !imageLoadedFromWeb) {
                    PSPDFDispatchIfNotOnMainThread(^{
                        if(!strongImageLoadOperation.isCancelled) {
                            // animating this is too expensive.
                            [self setImage:magazineOperationImage_ animated:NO];
                            self.siteLabel.text = magazineTitle_;
                        }
                    });
                }
            }];

            if (self.immediatelyLoadCellImages) {
                [imageLoadOperation start]; // start directly.
            }else {
                [[[self class] thumbnailQueue] addOperation:imageLoadOperation];
                imageLoadOperation_ = imageLoadOperation;
            }

            // dark out view if it needs to be downloaded
            [self darkenView:!magazine.isAvailable animated:NO];
        }

        NSString *siteLabelText = PSPDFStripPDFFileType([magazine.files ps_firstObject]);
        [self updateSiteLabel]; // create lazily
        self.siteLabel.text = [siteLabelText length] ? siteLabelText : magazine.title;
        [self updateSiteLabel];
        self.accessibilityLabel = self.siteLabel.text;
    }
}

- (void)setMagazineFolder:(PSCMagazineFolder *)magazineFolder {
    if (self.magazine) {
        self.magazine = nil;
    }

    if (_magazineFolder != magazineFolder) {
        [self clearProgressObservers];
        _magazineFolder = magazineFolder;

        for (PSCMagazine *aMagazine in _magazineFolder.magazines) {
            [self checkMagazineAndObserveProgressIfDownloading:aMagazine];
        }

        // setup for folder
        if (magazineFolder) {
            NSUInteger magazineCount = [magazineFolder.magazines count];
            self.magazineCount = magazineCount;

            PSCMagazine *coverMagazine = [magazineFolder firstMagazine];
            for (PSCMagazine *aMagazine in magazineFolder.magazines) {
                if (aMagazine.isDownloading) {
                    coverMagazine = aMagazine;
                    break;
                }
            }
            self.image = [coverMagazine coverImageForSize:self.frame.size];
        }
        self.accessibilityLabel = self.magazineFolder.title;
    }
}

- (void)updateMagazineBadgeFrame {
    _magazineCounterBadgeImage.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, 50, 50);
}

#define kiPhoneReductionFactor 0.588
#define kMagazineCountLabelTag 32443
- (void)setMagazineCount:(NSUInteger)newMagazineCount {
    if (!magazineCounter_ && newMagazineCount > 1) { // lazy creation
        self.magazineCounterBadgeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"badge"]];
        _magazineCounterBadgeImage.opaque = NO;
        _magazineCounterBadgeImage.alpha = 0.9f;
        [self.contentView addSubview:_magazineCounterBadgeImage];

        magazineCounter_ = [[UILabel alloc] init];
        magazineCounter_.font = [UIFont boldSystemFontOfSize:20];
        magazineCounter_.textColor = [UIColor whiteColor];
        magazineCounter_.shadowColor = [UIColor blackColor];
        magazineCounter_.shadowOffset = CGSizeMake(1, 1);
        magazineCounter_.backgroundColor = [UIColor clearColor];
        magazineCounter_.frame = CGRectMake(1, 1, 25, 25);
        magazineCounter_.textAlignment = UITextAlignmentCenter;
        [_magazineCounterBadgeImage addSubview:magazineCounter_];
    }

    magazineCounter_.text = [NSString stringWithFormat:@"%d", newMagazineCount];
    magazineCounter_.hidden = newMagazineCount < 2;
    _magazineCounterBadgeImage.hidden = newMagazineCount < 2;
    [self updateMagazineBadgeFrame];
}

- (UIImage *)image {
    return self.imageView.image;
}

- (void)setImage:(UIImage *)anImage {
    [self setImage:anImage animated:NO];
}

- (void)setImageSize:(CGSize)imageSize {
    [super setImageSize:imageSize];
    [self updateMagazineBadgeFrame];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Progress

#define kProgressBarTag 32553
#define kProgressBarWidth 110
- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        CGFloat progressViewWidth = PSIsIpad() ? kProgressBarWidth : roundf(kProgressBarWidth * kiPhoneReductionFactor*1.1f);
        _progressView.frame = CGRectMake(0.f, 0.f, progressViewWidth, 21.f);
        CGFloat siteLabelHeight = self.isShowingSiteLabel ? self.siteLabel.frame.size.width : 0.f;
        _progressView.center = CGPointMake(roundf(self.imageView.frame.size.width/2.f), roundf(self.imageView.frame.size.height*9.f/10.f - siteLabelHeight));
        _progressView.alpha = 0.f;
        [self.contentView addSubview:_progressView];
    }
    return _progressView;
}

- (void)darkenView:(BOOL)darken animated:(BOOL)animated {
    if(darken && !progressViewBackground_) {
        progressViewBackground_ = [[UIView alloc] initWithFrame:self.imageView.bounds];
        progressViewBackground_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        progressViewBackground_.backgroundColor = [UIColor blackColor];
        progressViewBackground_.alpha = 0.5f;
    }

    if (darken && !progressViewBackground_.superview) {
        progressViewBackground_.alpha = 0.f;
        [self.imageView addSubview:progressViewBackground_];
        [self.contentView bringSubviewToFront:_progressView];
        if (animated) {
            [UIView animateWithDuration:0.25 animations:^{
                progressViewBackground_.alpha = 0.5f;
            }];
        }else {
            progressViewBackground_.alpha = 0.5f;
        }
    }else if(!darken && progressViewBackground_.superview) {
        if (animated) {
            [UIView animateWithDuration:0.25 animations:^{
                progressViewBackground_.alpha = 0.f;
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
    BOOL shouldDarkenView = theProgress < 1.f;
    BOOL shouldShowProgress = shouldDarkenView && theProgress > 0.f;
    [self darkenView:shouldDarkenView animated:animated];

    // remove progressView
    if (!shouldShowProgress && self.progressView.superview) {
        [UIView animateWithDuration:animated ? kPSPDFCellAnimationDuration : 0.f animations:^{
            self.progressView.alpha = 0.f;
        } completion:^(BOOL finished) {
            [self.progressView removeFromSuperview];
            self.progressView = nil;
        }];
    }else if(shouldShowProgress) {
        [self.contentView bringSubviewToFront:self.progressView];

        // ensure visibility
        if (self.progressView.alpha == 0.f || !self.progressView.superview) {
            self.progressView.alpha = 0.f;
            [self.contentView addSubview:self.progressView];
            [UIView animateWithDuration:animated ? kPSPDFCellAnimationDuration : 0.f animations:^{
                self.progressView.alpha = 1.f;
            }];
        }
    }
}

- (void)setImage:(UIImage *)image animated:(BOOL)animated {
    [super setImage:image animated:animated];

    // ensure magazineCounter is at top
    [self.contentView bringSubviewToFront:_magazineCounterBadgeImage];

    // recalculate edit button position
    [self setNeedsLayout];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFGridViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    [self clearProgressObservers];
    [imageLoadOperation_ cancel];
    [self.imageView cancelImageRequestOperation];
    self.imageView.image = nil;
    [self setImageSize:defaultFrame_.size];
    [self darkenView:NO animated:NO];
    self.magazine = nil;
    self.magazineFolder = nil;
    [_progressView removeFromSuperview];
    _progressView = nil;
    [magazineCounter_ removeFromSuperview];
    magazineCounter_ = nil;
    [_magazineCounterBadgeImage removeFromSuperview];
    _magazineCounterBadgeImage = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFCacheDelegate

- (void)didCachePageForDocument:(PSPDFDocument *)document page:(NSUInteger)page image:(UIImage *)cachedImage size:(PSPDFSize)size{
    PSCMagazine *magazine = self.magazine;
    if (!magazine) {
        magazine = [self.magazineFolder firstMagazine];
    }

    if (magazine == document && page == 0 && size == PSPDFSizeThumbnail) {
        [self setImage:cachedImage animated:YES];
    }
}

@end
