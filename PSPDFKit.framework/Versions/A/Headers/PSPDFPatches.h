//
//  PSPDFPatches.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//
//  Compile this file without ARC!

// needs to be called early. 
void pspdf_patchUIKit(void);

void pspdf_swizzle(Class c, SEL orig, SEL new);

#ifndef _PSPDFKIT_DONT_USE_OBFUSCATED_PRIVATE_API_
void pspdf_endDisableIfcAutorotation(id this, SEL this_cmd);
#endif
