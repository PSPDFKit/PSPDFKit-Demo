//
//  PSPDFPatches.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

// Helper to add a method and swizzle the selectors.
void PSPDFReplaceMethod(Class aClass, SEL orig, SEL newSel, IMP impl);

#ifdef DEBUG
// Print all ivars of a class
// use from the debugger like this:  po (void)PSPDFPrintIvars(flowLayout, 0)
void PSPDFPrintIvars(id obj, BOOL printRecursive);
#endif