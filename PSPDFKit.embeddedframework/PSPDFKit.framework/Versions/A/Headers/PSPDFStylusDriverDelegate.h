//
//  PSPDFStylusDriverDelegate.h
//  PSPDFKit
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

// Called on stylus events.
@protocol PSPDFStylusDriverDelegate <NSObject>

// Connection changed.
- (void)connectionStatusChanged;

@optional

// Button with `buttonNumber` has been pressed.
- (void)buttonFired:(NSUInteger)buttonNumber;

// Called when a button classification changes.
- (void)classificationsDidChangeForTouches:(NSSet *)touches;

// If the driver has his own touch dispension mechanism, this returns object that implement the `PSPDFStylusTouch` protocol.
// Some drivers might instead require a manual call to `touchInfoForTouch:`.
- (void)stylusTouchBegan:(NSSet *)touches;
- (void)stylusTouchMoved:(NSSet *)touches;
- (void)stylusTouchEnded:(NSSet *)touches;
- (void)stylusTouchCancelled:(NSSet *)touches;

// Some SDKs use a pen detection system that suggest gesture blocking.
- (void)stylusSuggestsToDisableGestures;
- (void)stylusSuggestsToEnableGestures;

@end
