//
//  PSPDFImageGridViewCell.m
//  PSPDFCatalog
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
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
    NSOperation *_imageLoadOperation;
    UIImage *_magazineOperationImage;
    CGRect _defaultFrame;

    UIView *_progressViewBackground;
    UILabel *_magazineCounter;
    NSMutableSet *_observedMagazineDownloads;
}
@property (nonatomic, strong) UIImageView *magazineCounterBadgeImage;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) PSPDFRoundedLabel *pageLabel;
@property (nonatomic, copy) NSString *magazineTitle;
@end

@implementation PSCImageGridViewCell

static char kPSPDFKVOToken;
static void PSPDFDispatchIfNotOnMainThread(dispatch_block_t block) {
    if (block) { [NSThread isMainThread] ? block() : dispatch_async(dispatch_get_main_queue(), block); }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        _defaultFrame = frame;

        // incomplete downloads stay here
        _observedMagazineDownloads = [[NSMutableSet alloc] init];

        self.imageView.clipsToBounds = YES;
        self.showingPageLabel = YES;
        self.edgeInsets = UIEdgeInsetsMake(0.f, 0.f, 10.f, 0.f);

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
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Static

// Custom queue for thumbnail parsing.
+ (NSOperationQueue *)thumbnailQueue {
    static NSOperationQueue *_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 2;
        _queue.name = @"PSPDFThumbnailQueue";
    });
    return _queue;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.deleteButton.frame = CGRectMake(self.imageView.frame.origin.x-10, self.imageView.frame.origin.y-10, self.deleteButton.frame.size.width, self.deleteButton.frame.size.height);
    [self.contentView bringSubviewToFront:_deleteButton];

    // image darkener.
    _progressViewBackground.frame = self.imageView.bounds;

    // Progress bar.
    if (!_progressView.hidden) {
        _progressView.frame = CGRectMake(0.f, 0.f, self.imageView.frame.size.width*0.8, 21.f);
        CGFloat pageLabelHeight = 0.f;//self.isShowingPageLabel ? self.pageLabel.frame.size.width : 0.f;
        _progressView.center = CGPointMake(roundf(CGRectGetMaxX(self.imageView.frame)/2.f), roundf(CGRectGetMaxY(self.imageView.frame)*9.f/10.f - pageLabelHeight));
    }

    self.selectedBackgroundView.frame = CGRectInset(self.imageView.frame, -4.f, -4.f);
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _defaultFrame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFThumbnailGridViewCell

// Override to change label (default is within the image, has rounded borders)
- (void)updatePageLabel {
    if (self.isShowingPageLabel && !self.pageLabel.superview) {
        UILabel *pageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        pageLabel.backgroundColor = [UIColor clearColor];
        pageLabel.textColor = [UIColor colorWithWhite:1.f alpha:1.f];
        pageLabel.shadowColor = [UIColor blackColor];
        pageLabel.shadowOffset = CGSizeMake(0.f, 1.f);
        pageLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        pageLabel.textAlignment = NSTextAlignmentCenter;
        pageLabel.font = [UIFont boldSystemFontOfSize:PSIsIpad() ? 16.f : 12.f];
        self.pageLabel = (PSPDFRoundedLabel *)pageLabel;
        [self.contentView addSubview:pageLabel];
    }else if (!self.isShowingPageLabel && self.pageLabel.superview) {
        [self.pageLabel removeFromSuperview];
    }

    // Calculate new frame and position correct.
    self.pageLabel.frame = CGRectIntegral(CGRectMake(0.f, self.imageView.frame.origin.y+self.imageView.frame.size.height, self.frame.size.width, 20.f));

    if (self.pageLabel.superview) {
        [self.contentView bringSubviewToFront:self.pageLabel];
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
        if ([keyPath isEqualToString:PROPERTY(downloadProgress)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateProgressAnimated:YES];
            });
        }else if ([keyPath isEqualToString:kPSPDFKitDownloadingKey]) {
            // Check if magazine needs to be observed. (if download progress is active)
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

static NSString *PSCStripPDFFileType(NSString *pdfFileName) {
    if (pdfFileName) {
        pdfFileName = [pdfFileName stringByReplacingOccurrencesOfString:@".pdf" withString:@"" options:NSCaseInsensitiveSearch|NSBackwardsSearch range:NSMakeRange(0, pdfFileName.length)];
    }
    return pdfFileName;
}

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

            // First, check memory.
            UIImage *memoryImage = [PSPDFCache.sharedCache imageFromDocument:magazine andPage:0 withSize:self.frame.size options:PSPDFCacheOptionDiskLoadSync|PSPDFCacheOptionRenderSkip];
            [self setImage:memoryImage animated:NO];
            if (magazine.isTitleLoaded) self.magazineTitle = magazine.title;

            // If memory doesn't return anything, queue up here.
            if (!memoryImage) {
                NSBlockOperation *imageLoadOperation = [NSBlockOperation new];
                __weak NSBlockOperation *weakImageLoadOperation = imageLoadOperation;
                [imageLoadOperation addExecutionBlock:^{
                    NSBlockOperation *strongImageLoadOperation = weakImageLoadOperation;
                    if (!strongImageLoadOperation.isCancelled) {
                        _magazineOperationImage = [magazine coverImageForSize:self.frame.size];
                    }
                    // Also may be slow, parsing the title from PDF metadata.
                    self.magazineTitle = magazine.title;

                    BOOL imageLoadedFromWeb = NO;
                    if (!_magazineOperationImage && !strongImageLoadOperation.isCancelled) {
                        // try to download image
                        if (!self.image && magazine.imageURL) {
                            imageLoadedFromWeb = YES;
                            PSPDFDispatchIfNotOnMainThread(^{
                                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:magazine.imageURL];
                                [request setHTTPShouldHandleCookies:NO];
                                [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];

                                __weak typeof(self) weakSelf = self;
                                [self.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request_, NSHTTPURLResponse *response, UIImage *image) {
                                    __strong typeof(self) strongSelf = weakSelf;
                                    [strongSelf setNeedsLayout];
                                    strongSelf.imageView.image = image;
                                } failure:^(NSURLRequest *aRequest, NSHTTPURLResponse *aResponse, NSError *error) {
                                    PSCLog(@"Failed to download image: %@", error.localizedDescription);
                                }];
                            });
                        }
                    }

                    if (!strongImageLoadOperation.isCancelled && !imageLoadedFromWeb) {
                        PSPDFDispatchIfNotOnMainThread(^{
                            if (!strongImageLoadOperation.isCancelled) {
                                // animating this is too expensive.
                                [self setImage:_magazineOperationImage animated:YES];
                                self.pageLabel.text = _magazineTitle;
                            }
                        });
                    }
                }];

                if (self.immediatelyLoadCellImages) {
                    [imageLoadOperation start]; // start directly.
                }else {
                    [[self.class thumbnailQueue] addOperation:imageLoadOperation];
                    _imageLoadOperation = imageLoadOperation;
                }
            }

            // dark out view if it needs to be downloaded
            [self darkenView:!magazine.isAvailable animated:NO];
        }

        NSString *pageLabelText = PSCStripPDFFileType([magazine.files lastObject]);
        [self updatePageLabel]; // create lazily
        self.pageLabel.text = [pageLabelText length] ? pageLabelText : magazine.title;
        [self updatePageLabel];
        self.accessibilityLabel = self.pageLabel.text;
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
    _magazineCounterBadgeImage.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, 50.f, 50.f);
}

#define kMagazineCountLabelTag 32443
- (void)setMagazineCount:(NSUInteger)newMagazineCount {
    if (!_magazineCounter && newMagazineCount > 1) { // lazy creation
        self.magazineCounterBadgeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"badge"]];
        _magazineCounterBadgeImage.opaque = NO;
        _magazineCounterBadgeImage.alpha = 0.9f;
        [self.contentView addSubview:_magazineCounterBadgeImage];

        _magazineCounter = [[UILabel alloc] init];
        _magazineCounter.font = [UIFont boldSystemFontOfSize:20.f];
        _magazineCounter.textColor = [UIColor whiteColor];
        _magazineCounter.shadowColor = [UIColor blackColor];
        _magazineCounter.shadowOffset = CGSizeMake(1.f, 1.f);
        _magazineCounter.backgroundColor = [UIColor clearColor];
        _magazineCounter.frame = CGRectMake(1.f, 1.f, 25.f, 25.f);
        _magazineCounter.textAlignment = NSTextAlignmentCenter;
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
        _progressViewBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _progressViewBackground.backgroundColor = [UIColor blackColor];
        _progressViewBackground.alpha = 0.5f;
    }

    if (darken && !_progressViewBackground.superview) {
        _progressViewBackground.alpha = 0.f;
        [self.imageView addSubview:_progressViewBackground];
        [self.contentView bringSubviewToFront:_progressView];
        if (animated) {
            [UIView animateWithDuration:0.25f animations:^{
                _progressViewBackground.alpha = 0.5f;
            }];
        }else {
            _progressViewBackground.alpha = 0.5f;
        }
    }else if (!darken && _progressViewBackground.superview) {
        if (animated) {
            [UIView animateWithDuration:0.25f animations:^{
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

        // ensure visibility.
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

    // ensure magazineCounter is at top.
    [self bringSubviewToFront:_magazineCounterBadgeImage];

    // recalculate edit button position.
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
    [_imageLoadOperation cancel];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)checkMagazineAndObserveProgressIfDownloading:(PSCMagazine *)magazine {
    if (magazine.isDownloading) {
        PSCDownload *download = [[PSCStoreManager sharedStoreManager] downloadObjectForMagazine:magazine];
        if (!download) {
            NSLog(@"failed to find associated download object for %@", magazine); return;
        }
        [_observedMagazineDownloads addObject:download];
        [download addObserver:self forKeyPath:PROPERTY(downloadProgress) options:NSKeyValueObservingOptionInitial context:&kPSPDFKVOToken];
        [self updateProgressAnimated:NO];
    }
}

- (void)clearProgressObservers {
    // clear all observed magazines
    for (PSCDownload *download in _observedMagazineDownloads) {
        [download removeObserver:self forKeyPath:PROPERTY(downloadProgress) context:&kPSPDFKVOToken];
    }
    [_observedMagazineDownloads removeAllObjects];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFCacheDelegate

- (void)didCacheImage:(UIImage *)image fromDocument:(PSPDFDocument *)document andPage:(NSUInteger)page withSize:(CGSize)size {
    PSCMagazine *magazine = self.magazine ?: self.magazineFolder.firstMagazine;

    if (magazine == document && page == 0 && PSPDFSizeAspectRatioEqualToSize(self.frame.size, size)) {
        [self setImage:image animated:YES];

        if (magazine.isTitleLoaded) {
            _magazineTitle = magazine.title;
            self.pageLabel.text = _magazineTitle;
        }
    }
}

@end
