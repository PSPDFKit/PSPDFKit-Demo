//
//  PSPDFImagePickerController.h
//  PSPDFKit
//
//  Copyright 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

/// Allows to subclass the image picker controller, for example if you need to block portrait:
/// http://stackoverflow.com/questions/11467361/taking-a-photo-in-an-ios-landscape-only-app
///
/// Sets `allowsEditing` in init. Subclass to change this property.
@interface PSPDFImagePickerController : UIImagePickerController

@end
