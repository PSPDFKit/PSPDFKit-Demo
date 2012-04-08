//
//  PSPDFHUDView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>

// The HUD will relay touches of subviews, but won't react on touches on this actual view.
// This is achieved with overriding pointInside:withEvent:.
@interface PSPDFHUDView : UIView

@end
