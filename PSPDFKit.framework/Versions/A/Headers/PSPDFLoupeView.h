//
//  PSPDFLoupeView.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum LoupeViewMode {
	PSPDFLoupeViewModeCircular,
	PSPDFLoupeViewModeDetailTop,
	PSPDFLoupeViewModeDetailBottom
} PSPDFLoupeViewMode;


@interface PSPDFLoupeView : UIView

- (id)initWithReferenceView:(UIView *)referenceView;

@property (nonatomic, assign) PSPDFLoupeViewMode mode;

@property (nonatomic, assign) CGSize targetSize;

@end
