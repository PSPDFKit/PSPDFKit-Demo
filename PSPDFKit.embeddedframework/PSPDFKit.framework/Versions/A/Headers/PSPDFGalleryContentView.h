//
//  PSPDFGalleryContentView.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

@class PSPDFGalleryItem, PSPDFGalleryContentLoadingView, PSPDFGalleryContentCaptionView, PSPDFGalleryErrorView;

/// The (reusable) content view of a `PSPDFGalleryView`.
@interface PSPDFGalleryContentView : UIView

/// Might return a specially configured instance of a given content view used for transitioning
/// from or to fullscreen mode. The default implementation returns self.
- (instancetype)transitionView;

/// Creates a new content view with a reuse identifier. It is highly recommended that you always
/// reuse content views to avoid performance issues. The API works exactly like `UITableView`.
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

/// The image view. Please use setContent: to change the value.
@property (nonatomic, strong, readonly) UIView *contentView;

/// The loading view.  Please use setLoading: to change the loading state.
@property (nonatomic, strong, readonly) PSPDFGalleryContentLoadingView *loadingView;

/// The caption view. Please setCaption: to change the caption.
@property (nonatomic, strong, readonly) PSPDFGalleryContentCaptionView *captionView;

/// The error view. Please use setError: to change the error.
@property (nonatomic, strong, readonly) PSPDFGalleryErrorView *errorView;

/// The reuse identifier if the view was created with `initWithReuseIdentifier:`. You should always
/// reuse views to avoid performance issues.
@property (nonatomic, strong, readonly) NSString *reuseIdentifier;

/// The caption. If this is set to nil, `captionView` is not visible.
@property (nonatomic, copy) NSString *caption;

/// The content. Only visible if loading = NO and error = nil.
@property (nonatomic, strong) id content;

/// Indicates that the content is loading. If this is set, the imageView will be invisible.
@property (nonatomic, assign, getter = isLoading) BOOL loading;

/// An error that might have occurred. If this is set, `imageView` and `loadingView` will be hidden.
@property (nonatomic, strong) NSError *error;

/// Called before reusing the content view to give it a chance to restore its initial state.
- (void)prepareForReuse;

@end

@interface PSPDFGalleryContentView (SubclassingHooks)

/// Defaults to `UIView.class`.
+ (Class)contentViewClass;

/// Defaults to `PSPDFGalleryContentLoadingView.class`.
+ (Class)loadingViewClass;

/// Defaults to `PSPDFGalleryContentCaptionView.class`.
+ (Class)captionViewClass;

/// Defaults to `PSPDFGalleryErrorView.class`.
+ (Class)errorViewClass;

/// Called when the view state of the content view has changed and subview visiblity is likely
/// going to change.
- (void)updateSubviewVisibility;

/// The frame of the content view.
- (CGRect)contentViewFrame;

/// The frame of the loading view.
- (CGRect)loadingViewFrame;

/// The frame of the caption view.
- (CGRect)captionViewFrame;

/// The frame of the error view.
- (CGRect)errorViewFrame;

@end
