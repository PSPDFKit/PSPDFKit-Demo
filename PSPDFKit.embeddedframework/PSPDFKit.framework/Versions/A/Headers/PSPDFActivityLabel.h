//
//  PSPDFActivityLabel.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

// Preconfigured label subclass that optionally shows an activity indicator.
@interface PSPDFActivityLabel : UILabel

// Convenience constructor.
+ (instancetype)labelWithText:(NSString *)text showActivity:(BOOL)showActivity;

// Enable spinning wheel next to text.
@property (nonatomic, assign) BOOL showActivity;

@end
