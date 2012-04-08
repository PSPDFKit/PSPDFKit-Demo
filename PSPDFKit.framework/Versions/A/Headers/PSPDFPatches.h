//
//  PSPDFPatches.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//
//  *** Compile this file without ARC! ***

// Applies patches so that UIPageViewController doesn't crash. Needs to be called early. 
void pspdf_patchUIKit(void);

// Helper to swizzle things.
void pspdf_swizzle(Class c, SEL orig, SEL new);

#ifndef _PSPDFKIT_DONT_USE_OBFUSCATED_PRIVATE_API_
// Ends global disabling of autorotation.
// Used incorrectly within UIPageViewController, so we need this to fix Apple's stuff.
void pspdf_endDisableIfcAutorotation(id this, SEL this_cmd);
#endif
