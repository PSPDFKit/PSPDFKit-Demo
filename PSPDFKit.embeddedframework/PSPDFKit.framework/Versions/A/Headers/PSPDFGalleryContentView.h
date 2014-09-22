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
#import "PSPDFGalleryContentViewProtocols.h"
#import "PSPDFModernizer.h"

@class PSPDFGalleryItem;

/// The (reusable) content view of a `PSPDFGalleryView`.
@interface PSPDFGalleryContentView : UIView

/// @name Initialization

/// Creates a new content view with a reuse identifier. It is highly recommended that you always
/// reuse content views to avoid performance issues. The API works exactly like `UITableView`.
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier NS_DESIGNATED_INITIALIZER;

/// @name Views

/// The content view.
@property (nonatomic, strong, readonly) UIView *contentView;

/// The loading view.
@property (nonatomic, strong, readonly) UIView<PSPDFGalleryContentViewLoading> *loadingView;

/// The caption view.
@property (nonatomic, strong, readonly) UIView<PSPDFGalleryContentViewCaption> *captionView;

/// The error view.
@property (nonatomic, strong, readonly) UIView<PSPDFGalleryContentViewError> *errorView;

/// @name State

/// The reuse identifier if the view was created with `initWithReuseIdentifier:`. You should always
/// reuse views to avoid performance issues.
@property (nonatomic, strong, readonly) NSString *reuseIdentifier;

/// The content item.
@property (nonatomic, strong) PSPDFGalleryItem *content;

/// Indicates if the caption should be visible. Defaults to `NO`.
/// @note This property is only a hint to the content view. The caption might still be hidden
/// even if this property is set to `NO`.
@property (nonatomic, assign) BOOL shouldHideCaption;

@end

@interface PSPDFGalleryContentView (SubclassingHooks)

/// Returns the class for `contentView`. Defaults to `Nil`.
/// @note The class must be a subclass of `UIView`.
/// @warning This is an abstract class. Your subclass must override this method!
+ (Class)contentViewClass;

/// Returns the class for `loadingView`. Defaults to `PSPDFGalleryContentLoadingView.class`.
/// @note The class must be a subclass of `UIView` and conform to the `PSPDFGalleryContentViewLoading` protocol.
+ (Class)loadingViewClass;

/// Returns the class for `captionView`. Defaults to `PSPDFGalleryContentCaptionView.class`.
/// @note The class must be a subclass of `UIView` and conform to the `PSPDFGalleryContentViewCaption` protocol.
+ (Class)captionViewClass;

/// Returns the class for `errorView`. Defaults to `PSPDFErrorView.class`.
/// @note The class must be a subclass of `UIView` and conform to the `PSPDFGalleryContentViewError` protocol.
+ (Class)errorViewClass;

/// The frame of the content view.
- (CGRect)contentViewFrame;

/// The frame of the loading view.
- (CGRect)loadingViewFrame;

/// The frame of the caption view.
- (CGRect)captionViewFrame;

/// The frame of the error view.
- (CGRect)errorViewFrame;

/// Updates the content view's contents.
/// @warning This is an abstract class. Your subclass must override this method!
- (void)updateContentView;

/// Updates the caption view's contents.
- (void)updateCaptionView NS_REQUIRES_SUPER;

/// Updates the error view's contents.
- (void)updateErrorView NS_REQUIRES_SUPER;

/// Updates the loading view's contents.
- (void)updateLoadingView NS_REQUIRES_SUPER;

/// Called before reusing the content view to give it a chance to restore its initial state.
- (void)prepareForReuse NS_REQUIRES_SUPER;

/// Use this method to update your content view.
- (void)contentDidChange NS_REQUIRES_SUPER;

/// Called when the view state of the content view has changed and subview visibility is likely
/// going to change.
- (void)updateSubviewVisibility NS_REQUIRES_SUPER;

@end
