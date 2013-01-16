//
//  PSPDFHUDView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

/// The HUD will relay touches of subviews, but won't react on touches on this actual view.
/// This is achieved with overriding pointInside:withEvent:.
@interface PSPDFHUDView : UIView

@end
