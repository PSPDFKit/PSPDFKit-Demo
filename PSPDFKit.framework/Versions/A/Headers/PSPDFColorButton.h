//
//  PSPDFColorButton.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

// Button that shows a selected color
@interface PSPDFColorButton : UIButton

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) BOOL displayAsEllipse;

@end
