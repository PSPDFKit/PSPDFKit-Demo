//
//  main.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAppDelegate.h"

int main(int argc, char *argv[]) {
    @autoreleasepool {
        NSClassFromString(@"PSCLicenseKey"); // internal license initialization (ignore)
        return UIApplicationMain(argc, argv, nil, NSStringFromClass(PSCAppDelegate.class));
    }
}
