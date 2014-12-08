//
//  PSCDropboxPDFViewController.h
//  PSPDFCatalog
//
//  Copyright (c) 2013-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCDropboxFloatingToolbar.h"

/// Shows how to change the UI in a way like Dropbox did.
@interface PSCDropboxPDFViewController : PSPDFViewController

/// Conntected floating toolbar.
@property (nonatomic, strong) PSCDropboxFloatingToolbar *floatingToolbar;

@end
