//
//  PSCVerticalAnnotationToolbar.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCVerticalAnnotationToolbar.h"

@interface PSCVerticalAnnotationToolbar() <PSPDFAnnotationStateManagerDelegate>
@property (nonatomic, strong) UIButton *drawButton;
@property (nonatomic, strong) UIButton *freeTextButton;
@end

@implementation PSCVerticalAnnotationToolbar

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithAnnotationStateManager:(PSPDFAnnotationStateManager *)annotationStateManager {
    if ((self = [super init])) {
        _annotationStateManager = annotationStateManager;
		annotationStateManager.stateDelegate = self;

		PSPDFViewController *pdfController = annotationStateManager.pdfController;
		self.backgroundColor = pdfController.navigationController.navigationBar.barTintColor;

        // draw button
        if ([pdfController.document.editableAnnotationTypes containsObject:PSPDFAnnotationStringInk]) {
            UIButton *drawButton = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *sketchImage = [PSPDFBundleImage(@"ink") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [drawButton setImage:sketchImage forState:UIControlStateNormal];
            [drawButton addTarget:self action:@selector(inkButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:drawButton];
            self.drawButton = drawButton;
        }

        // draw button
        if ([pdfController.document.editableAnnotationTypes containsObject:PSPDFAnnotationStringFreeText]) {
			UIButton *freetextButton = [UIButton buttonWithType:UIButtonTypeCustom];
			UIImage *freeTextImage = [PSPDFBundleImage(@"freetext") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			[freetextButton setImage:freeTextImage forState:UIControlStateNormal];
			[freetextButton addTarget:self action:@selector(freetextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:freetextButton];
			self.freeTextButton = freetextButton;
        }
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect rem = self.bounds, slice;
    CGRectDivide(rem, &slice, &rem, 44.f, CGRectMinYEdge);
    self.drawButton.frame = slice;
    self.freeTextButton.frame = rem;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Events

- (void)inkButtonPressed:(id)sender {
	[self.annotationStateManager toggleState:PSPDFAnnotationStringInk];
}

- (void)freetextButtonPressed:(id)sender {
	[self.annotationStateManager toggleState:PSPDFAnnotationStringFreeText];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFAnnotationStateManagerDelegate

- (void)annotationStateManager:(PSPDFAnnotationStateManager *)manager didChangeState:(NSString *)state to:(NSString *)newState variant:(NSString *)variant to:(NSString *)newVariant {

	UIColor *selectedColor = [UIColor colorWithWhite:0.f alpha:.2f];
	UIColor *deselectedColor = [UIColor clearColor];

	self.freeTextButton.backgroundColor = newState == PSPDFAnnotationStringFreeText ? selectedColor : deselectedColor;
	self.drawButton.backgroundColor = newState == PSPDFAnnotationStringInk ? selectedColor : deselectedColor;
}

@end
