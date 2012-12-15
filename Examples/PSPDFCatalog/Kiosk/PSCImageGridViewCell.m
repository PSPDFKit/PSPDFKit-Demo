//
//  PSPDFImageGridViewCell.m
//  PSPDFCatalog
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSCMagazine.h"
#import "PSCMagazineFolder.h"
#import "PSCImageGridViewCell.h"
#import "PSCDownload.h"
#import "PSCStoreManager.h"
#import "UIImageView+AFNetworking.h"

#if !__has_feature(objc_arc)
#error "Compile this file with ARC"
#endif

#define kPSPDFKitDownloadingKey @"downloading"
#define kPSPDFCellAnimationDuration 0.25f

#define kiPhoneReductionFactor 0.588

@interface PSCImageGridViewCell() {
    NSOperation *_imageLoadOperation;
    UIImage *_magazineOperationImage;
    NSString *_magazineTitle;
    CGRect _defaultFrame;

    UIView *_progressViewBackground;
    UILabel *_magazineCounter;
    NSMutableSet *_observedMagazineDownloads;
}
@property (nonatomic, strong) UIImageView *magazineCounterBadgeImage;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation PSCImageGridViewCell

static char kPSPDFKVOToken;
static void PSPDFDispatchIfNotOnMainThread(dispatch_block_t block) {
    if (block) { [NSThread isMainThread] ? block() : dispatch_async(dispatch_get_main_queue(), block); }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)checkMagazineAndObserveProgressIfDownloading:(PSCMagazine *)magazine {
    if (magazine.isDownloading) {
        PSCDownload *download = [[PSCStoreManager sharedStoreManager] downloadObjectForMagazine:magazine];
        if (!download) {
            PSPDFLogError(@"failed to find associated download object for %@", magazine); return;
        }
        [_observedMagazineDownloads addObject:download];
        [download addObserver:self forKeyPath:NSStringFromSelector(@selector(downloadProgress)) options:NSKeyValueObservingOptionInitial context:&kPSPDFKVOToken];
        [self updateProgressAnimated:NO];
    }
}

- (void)clearProgressObservers {
    // clear all observed magazines
    for (PSCDownload *download in _observedMagazineDownloads) {
        [download removeObserver:self forKeyPath:NSStringFromSelector(@selector(downloadProgress)) context:&kPSPDFKVOToken];
    }
    [_observedMagazineDownloads removeAllObjects];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        _defaultFrame = frame;

        // incomplete downloads stay here
        _observedMagazineDownloads = [[NSMutableSet alloc] init];

        self.showingSiteLabel = YES;
        self.edgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);

        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [_deleteButton sizeToFit];
        [self.contentView addSubview:_deleteButton];
        _deleteButton.hidden = YES;
    }

    return self;
}

- (void)dealloc {
    [_magazine removeObserver:self forKeyPath:kPSPDFKitDownloadingKey context:&kPSPDFKVOToken];
    [self clearProgressObservers];
    [[PSPDFCache sharedCache] removeDelegate:self];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.deleteButton.frame = CGRectMake(self.imageView.frame.origin.x-10, self.imageView.frame.origin.y-10, self.deleteButton.frame.size.width, self.deleteButton.frame.size.height);
    [self.contentView bringSubviewToFront:_deleteButton];

    // image darkener
    _progressViewBackground.frame = self.imageView.bounds;

    // progress bar
    if (!_progressView.hidden) {
        _progressView.frame = CGRectMake(0.f, 0.f, self.imageView.frame.size.width*0.8, 21.f);
        CGFloat siteLabelHeight = 0;//self.isShowingSiteLabel ? self.siteLabel.frame.size.width : 0.f;
        _progressView.center = CGPointMake(roundf(CGRectGetMaxX(self.imageView.frame)/2.f), roundf(CGRectGetMaxY(self.imageView.frame)*9.f/10.f - siteLabelHeight));
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _defaultFrame = frame;
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
    }else if (!self.isShowingSiteLabel && self.siteLabel.superview) {
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

    if ([_observedMagazineDownloads count]) {
        progressTotal = [[_observedMagazineDownloads valueForKeyPath:@"@avg.downloadProgress"] floatValue];
    }

    [self setProgress:progressTotal animated:animated];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &kPSPDFKVOToken) {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(downloadProgress))]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateProgressAnimated:YES];
            });
        }else if ([keyPath isEqualToString:kPSPDFKitDownloadingKey]) {
            // check if magazine needs to be observed (if download progress is active)
            if (self.magazine.isDownloading && ![_observedMagazineDownloads containsObject:self.magazine]) {
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
        [_magazine removeObserver:self forKeyPath:kPSPDFKitDownloadingKey context:&kPSPDFKVOToken];
        _magazine = magazine;

        // setup for magazine
        if (magazine) {

            // add KVO for download property
            [magazine addObserver:self forKeyPath:kPSPDFKitDownloadingKey options:0 context:&kPSPDFKVOToken];

            // add KVO
            [self checkMagazineAndObserveProgressIfDownloading:magazine];

            self.magazineCount = 0;

            NSBlockOperation *imageLoadOperation = [NSBlockOperation new];
            __weak NSBlockOperation *weakImageLoadOperation = imageLoadOperation;
            [imageLoadOperation addExecutionBlock:^{
                NSBlockOperation *strongImageLoadOperation = weakImageLoadOperation;
                if (!strongImageLoadOperation.isCancelled) {
                    _magazineOperationImage = [magazine coverImageForSize:self.frame.size];
                }
                BOOL imageLoadedFromWeb = NO;
                if (!_magazineOperationImage && !strongImageLoadOperation.isCancelled) {
                    // try to download image
                    if (!self.image && magazine.imageURL) {
                        imageLoadedFromWeb = YES;
                        PSPDFDispatchIfNotOnMainThread(^{
                            [self.imageView setImageWithURL:magazine.imageURL];
                        });
                    }
                }

                // also may be slow, parsing the title from PDF metadata.
                _magazineTitle = magazine.title;

                if (!strongImageLoadOperation.isCancelled && !imageLoadedFromWeb) {
                    PSPDFDispatchIfNotOnMainThread(^{
                        if (!strongImageLoadOperation.isCancelled) {
                            // animating this is too expensive.
                            [self setImage:_magazineOperationImage animated:NO];
                            self.siteLabel.text = _magazineTitle;
                        }
                    });
                }
            }];

            if (self.immediatelyLoadCellImages) {
                [imageLoadOperation start]; // start directly.
            }else {
                [[[self class] thumbnailQueue] addOperation:imageLoadOperation];
                _imageLoadOperation = imageLoadOperation;
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

#define kMagazineCountLabelTag 32443
- (void)setMagazineCount:(NSUInteger)newMagazineCount {
    if (!_magazineCounter && newMagazineCount > 1) { // lazy creation
        self.magazineCounterBadgeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"badge"]];
        _magazineCounterBadgeImage.opaque = NO;
        _magazineCounterBadgeImage.alpha = 0.9f;
        [self.contentView addSubview:_magazineCounterBadgeImage];

        _magazineCounter = [[UILabel alloc] init];
        _magazineCounter.font = [UIFont boldSystemFontOfSize:20];
        _magazineCounter.textColor = [UIColor whiteColor];
        _magazineCounter.shadowColor = [UIColor blackColor];
        _magazineCounter.shadowOffset = CGSizeMake(1, 1);
        _magazineCounter.backgroundColor = [UIColor clearColor];
        _magazineCounter.frame = CGRectMake(1, 1, 25, 25);
        _magazineCounter.textAlignment = UITextAlignmentCenter;
        [_magazineCounterBadgeImage addSubview:_magazineCounter];
    }

    _magazineCounter.text = [NSString stringWithFormat:@"%d", newMagazineCount];
    _magazineCounter.hidden = newMagazineCount < 2;
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

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progressView.alpha = 0.f;
        [self.contentView addSubview:_progressView];
        [self setNeedsLayout];
    }
    return _progressView;
}

- (void)darkenView:(BOOL)darken animated:(BOOL)animated {
    if (darken && !_progressViewBackground) {
        _progressViewBackground = [[UIView alloc] initWithFrame:self.imageView.bounds];
        _progressViewBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _progressViewBackground.backgroundColor = [UIColor blackColor];
        _progressViewBackground.alpha = 0.5f;
    }

    if (darken && !_progressViewBackground.superview) {
        _progressViewBackground.alpha = 0.f;
        [self.imageView addSubview:_progressViewBackground];
        [self.contentView bringSubviewToFront:_progressView];
        if (animated) {
            [UIView animateWithDuration:0.25 animations:^{
                _progressViewBackground.alpha = 0.5f;
            }];
        }else {
            _progressViewBackground.alpha = 0.5f;
        }
    }else if (!darken && _progressViewBackground.superview) {
        if (animated) {
            [UIView animateWithDuration:0.25 animations:^{
                _progressViewBackground.alpha = 0.f;
            } completion:^(BOOL finished) {
                if (finished) {
                    [_progressViewBackground removeFromSuperview];
                }
            }];
        }else {
            [_progressViewBackground removeFromSuperview];
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
    }else if (shouldShowProgress) {
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
    [self bringSubviewToFront:_magazineCounterBadgeImage];

    // recalculate edit button position
    [self setNeedsLayout];
}

- (void)setShowDeleteImage:(BOOL)showDeleteImage {
    _showDeleteImage = showDeleteImage;
    _deleteButton.hidden = !_showDeleteImage;
    [self layoutSubviews];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFGridViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    [self clearProgressObservers];
    [_imageLoadOperation cancel];
    [self.imageView cancelImageRequestOperation];
    self.imageView.image = nil;
    [self setImageSize:_defaultFrame.size];
    [self darkenView:NO animated:NO];
    self.magazine = nil;
    self.magazineFolder = nil;
    [_progressView removeFromSuperview];
    _progressView = nil;
    [_magazineCounter removeFromSuperview];
    _magazineCounter = nil;
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
