//
//  PSPDFpngcrush.h
//  PSPDFKit
//
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//  Based on code by Dustin L. Howett. (dustin@howett.net)
//

#ifndef PSPDFKit_PSPDFpngcrush_h
#define PSPDFKit_PSPDFpngcrush_h

// custom png save method to crush the png (iOS native format)
// crushing may improve png rendering up to 50%. (if it's drawin into an opaque container)
void pspdf_crush_and_save_png(const void *pngData, const char *outfilename);

#endif
