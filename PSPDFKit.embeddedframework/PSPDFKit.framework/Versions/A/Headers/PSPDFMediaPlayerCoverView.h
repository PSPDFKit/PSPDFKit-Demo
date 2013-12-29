//
//  PSPDFMediaPlayerCoverView.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

/// If the cover option is set, this is showed until the play button is pressed.
@interface PSPDFMediaPlayerCoverView : UIView

/// The cover image (might be w/o actual image set)
@property (nonatomic, strong) UIImageView *coverImage;

/// The play button.
@property (nonatomic, strong) UIButton *playButton;

@end
