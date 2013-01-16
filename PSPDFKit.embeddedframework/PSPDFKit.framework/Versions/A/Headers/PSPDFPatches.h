//
//  PSPDFPatches.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

// Helper to add a method and swizzle the selectors.
extern void PSPDFReplaceMethod(Class aClass, SEL orig, SEL newSel, IMP impl);


#ifdef DEBUG

#import "PSPDFBaseViewController.h"
// Helps to track down problems related to "The Deallocation Problem".
// http://developer.apple.com/library/ios/#technotes/tn2109/_index.html%23//apple_ref/doc/uid/DTS40010274-CH1-SUBSECTION11
@interface PSPDFRetainTracker : PSPDFBaseViewController @end

#endif
