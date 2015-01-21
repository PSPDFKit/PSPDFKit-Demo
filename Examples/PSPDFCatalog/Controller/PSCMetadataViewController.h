//
//  PSCMetadataViewController.h
//  PSPDFKit
//
//  Copyright (c) 2014-2015 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

@interface PSCMetadataViewController : UITableViewController

- (instancetype)initWithDocument:(PSPDFDocument *)document NS_DESIGNATED_INITIALIZER;
@property (nonatomic, weak) PSPDFDocument *document;

@end
