//
//  PSCKioskPDFViewController.h
//  PSPDFCatalog
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

@class PSCMagazine;

/// Customized subclass of PSPDFViewController, adding more HUD buttons.
@interface PSCKioskPDFViewController : PSPDFViewController <PSPDFViewControllerDelegate>

/// Referenced magazine; just a cast to .document.
@property (nonatomic, strong, readonly) PSCMagazine *magazine;

@end
