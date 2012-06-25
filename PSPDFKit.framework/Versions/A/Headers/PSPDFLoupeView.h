//
//  PSPDFLoupeView.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PSPDFLoupeViewMode) {
	PSPDFLoupeViewModeCircular,
	PSPDFLoupeViewModeDetailTop,
	PSPDFLoupeViewModeDetailBottom
};

/// Represents a loupe, modeled like the loupe used in UIKit.
@interface PSPDFLoupeView : UIView

/// Designated initializer.
- (id)initWithReferenceView:(UIView *)referenceView;

/// Loupe detail mode.
@property (nonatomic, assign) PSPDFLoupeViewMode mode;

/// Target size.
@property (nonatomic, assign) CGSize targetSize;

@end
