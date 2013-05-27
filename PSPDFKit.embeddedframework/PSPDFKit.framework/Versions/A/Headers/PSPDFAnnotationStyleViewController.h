//
//  PSPDFAnnotationStyleViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFColorSelectionViewController.h"
#import "PSPDFFontSelectorViewController.h"
#import "PSPDFFontStyleViewController.h"
#import "PSPDFStaticTableViewController.h"

@class PSPDFAnnotationStyleViewController, PSPDFAnnotation;

/// Delegate for PSPDFAnnotationStyleViewController.
@protocol PSPDFAnnotationStyleViewControllerDelegate <NSObject>

/// Called whenever a style property of PSPDFAnnotationStyleViewController changes.
- (void)annotationStyleController:(PSPDFAnnotationStyleViewController *)styleController didChangeProperty:(NSString *)propertyName;

@end


/// Allows to set/change the style of an annotation.
@interface PSPDFAnnotationStyleViewController : PSPDFStaticTableViewController <PSPDFColorSelectionViewControllerDelegate, PSPDFFontSelectorViewControllerDelegate, PSPDFFontStyleViewControllerDelegate>

/// Designated initializer.
- (id)initWithAnnotation:(PSPDFAnnotation *)annotation delegate:(id<PSPDFAnnotationStyleViewControllerDelegate>)delegate;

/// Controller delegate.
@property (nonatomic, weak) id<PSPDFAnnotationStyleViewControllerDelegate> delegate;

/// The current selected annotation
@property (nonatomic, strong) PSPDFAnnotation *annotation;

/// Shows a preview area on top. Defaults to NO.
@property (nonatomic, assign) BOOL showPreviewArea;

@end


// Cell that shows a slider with value text.
@interface PSPDFSliderCell : UITableViewCell

// Slider.
@property (nonatomic, strong, readonly) UISlider *slider;

// Slider value text (automatically updated)
@property (nonatomic, strong, readonly) UILabel *sliderLabel;

// Set a minimum text width to allow aligning of multiple slider cells. Defaults to 0.
@property (nonatomic, assign) CGFloat minimumTextWidth;

// Called whenever the slider changes to update the slider label.
@property (nonatomic, copy) void (^sliderLabelUpdateBlock)(PSPDFSliderCell *cell, UISlider *slider);

@end


// A cell that is one big segmented control.
@interface PSPDFSegmentedCell : UITableViewCell

// The segment visible.
@property (nonatomic, strong, readonly) UISegmentedControl *segmentedControl;

// Called when the segment changes.
@property (nonatomic, copy) void (^segmentedControlUpdateBlock)(PSPDFSegmentedCell *cell, UISegmentedControl *segmentedControl);

@end
