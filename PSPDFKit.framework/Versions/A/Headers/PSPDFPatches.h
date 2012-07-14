//
//  PSPDFPatches.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//
//  *** Compile this file without ARC! ***

// Helper to add a method and swizzle the selectors.
void pspdf_replaceMethod(Class aClass, SEL orig, SEL newSel, IMP impl);