//
//  PSPDFPatches.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//
//  *** Compile this file without ARC! ***

// Applies patches so that UIPageViewController doesn't crash. Needs to be called early.
// Also adds removeObserver:forKeyPath:context on iOS 4.3
void pspdf_applyRuntimePatches(void);

// Helper to swizzle things.
void pspdf_swizzle(Class c, SEL orig, SEL new);