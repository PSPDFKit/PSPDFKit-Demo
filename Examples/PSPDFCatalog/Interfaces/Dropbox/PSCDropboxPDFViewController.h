//
//  PSCDropboxPDFViewController.h
//  PSPDFCatalog
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCDropboxFloatingToolbar.h"

/// Shows how to change the UI in a way like Dropbox did.
@interface PSCDropboxPDFViewController : PSPDFViewController

/// Conntected floating toolbar.
@property (nonatomic, strong) PSCDropboxFloatingToolbar *floatingToolbar;

@end
