//
//  PSPDFAnnotationStyleViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFColorSelectionViewController.h"
#import "PSPDFStaticTableViewController.h"

@class PSPDFAnnotationStyleViewController;

/// Delegate for PSPDFAnnotationStyleViewController.
@protocol PSPDFAnnotationStyleViewControllerDelegate <NSObject>

/// Called whenever a style property of PSPDFAnnotationStyleViewController changes.
- (void)annotationStyleControllerDidChangeStyle:(PSPDFAnnotationStyleViewController *)styleController;

@end


/// Allows to set/change the style of an annotation.
@interface PSPDFAnnotationStyleViewController : PSPDFStaticTableViewController <PSPDFColorSelectionViewControllerDelegate>

/// Controller delegate.
@property (nonatomic, weak) id <PSPDFAnnotationStyleViewControllerDelegate> delegate;

/// Selected color.
@property (nonatomic, strong) UIColor *color;

/// Selected line width.
@property (nonatomic, assign) CGFloat lineWidth;

@end


// Cell that shows a slider with value text.
@interface PSPDFSliderCell : UITableViewCell

// Slider.
@property (nonatomic, strong, readonly) UISlider *slider;

// Slider value text (automatically updated)
@property (nonatomic, strong, readonly) UILabel  *sliderLabel;

// Set a minimum text width to allow aligning of multiple slider cells. Defaults to 0.
@property (nonatomic, assign) CGFloat minimumTextWidth;

// Called whenever the slider changes to update the slider label.
@property (nonatomic, copy) void (^sliderLabelUpdateBlock)(UITableViewCell *cell);

@end
