//
//  PSCKioskPDFViewController.h
//  PSPDFCatalog
//
//  Copyright (c) 2011-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

@class PSCMagazine;

/// Customized subclass of PSPDFViewController, adding more HUD buttons.
@interface PSCKioskPDFViewController : PSPDFViewController <PSPDFViewControllerDelegate>

/// Referenced magazine; just a cast to .document.
@property (nonatomic, strong, readonly) PSCMagazine *magazine;

@end
