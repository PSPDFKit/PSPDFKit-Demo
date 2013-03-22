//
//  PSPDFPatches.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

// Helper to add a method and swizzle the selectors.
extern void PSPDFReplaceMethod(Class aClass, SEL orig, SEL newSel, IMP impl);
