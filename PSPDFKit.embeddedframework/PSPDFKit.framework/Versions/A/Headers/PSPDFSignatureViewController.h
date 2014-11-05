//
//  PSPDFSignatureViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFStyleable.h"
#import "PSPDFBaseViewController.h"
#import "PSPDFDrawView.h"
#import "PSPDFOverridable.h"

@class PSPDFDrawView;
@class PSPDFSignatureViewController;
@class PSPDFPopOutMenu;
@class PSPDFColorButton;
@class PSPDFSignatureBackgroundView;

// Constants are used in the delegate and saved in userInfo.
extern NSString *const PSPDFSignatureControllerShouldSaveKey;
// Can be treated as a point if width/height are 0, else will fit into the rect.
extern NSString *const PSPDFSignatureControllerTargetRectKey;

/// Delegate to be notified on signature actions.
@protocol PSPDFSignatureViewControllerDelegate <PSPDFOverridable>

@optional

/// Cancel button has been pressed.
- (void)signatureViewControllerDidCancel:(PSPDFSignatureViewController *)signatureController;

/// Save/Done button has been pressed.
- (void)signatureViewControllerDidSave:(PSPDFSignatureViewController *)signatureController;

@end

/// Allows adding signatures or drawings as ink annotations.
@interface PSPDFSignatureViewController : PSPDFBaseViewController <PSPDFStyleable>

/// Designated initializer.
- (instancetype)init NS_DESIGNATED_INITIALIZER;

/// Lines of the drawView.
@property (nonatomic, strong, readonly) NSArray *lines;

/// Natural drawing.
@property (nonatomic, assign) BOOL naturalDrawingEnabled;

/// Color options for the color picker (limit this to about 3 UIColor instances).
/// Defaults to black, blue and red.
@property (nonatomic, copy) NSArray *menuColors;

/// Signature controller delegate.
@property (nonatomic, weak) IBOutlet id<PSPDFSignatureViewControllerDelegate> delegate;

/// Save additional properties here. This will not be used by the signature controller.
@property (nonatomic, copy) NSDictionary *userInfo;

/// @name Views

/// @note All views are created after the main view has been loaded.

/// Internally used draw view. Use `lines` as a shortcut to get the drawn signature lines.
@property (nonatomic, strong, readonly) PSPDFDrawView *drawView;

/// Clear signature button. Clears out the draw view content.
@property (nonatomic, strong) UIButton *clearButton;

/// Color menu. Holds a set of `PSPDFColorButton` items by default.
/// @see menuColors
/// @see colorButtonForColor:
@property (nonatomic, strong) PSPDFPopOutMenu *colorMenu;

/// Signature area background view. Positioned directly underneath the `drawView`.
@property (nonatomic, strong) PSPDFSignatureBackgroundView *backgroundView;

/// @name Styling

/// Keeps the drawing area aspect ration regardless of the interface orientation.
/// Setting this to `NO` might produce unexpected results if the view bounds change.
/// Defaults to YES, except if the view is presented inside a form sheet on iPad.
@property (nonatomic, assign) BOOL keepLandscapeAspectRatio;

@end

@interface PSPDFSignatureViewController (SubclassingHooks)

// Actions for custom buttons.
- (void)cancel:(id)sender;
- (void)done:(id)sender;
- (void)clear:(id)sender;
- (void)color:(PSPDFColorButton *)sender;

// Customize the created color menu buttons.
- (PSPDFColorButton *)colorButtonForColor:(UIColor *)color;

@end

@interface PSPDFSignatureBackgroundView : UIView

/// Signature guide line.
@property (nonatomic, strong, readonly) UIView *signatureLine;

/// Signature text, positioned underneath the signature line.
@property (nonatomic, strong, readonly) UILabel *signatureLabel;

/// Positioned on the top edge of the content view. Draws a dashed line.
/// Only visible in portrait when keepLandscapeAspectRatio is set.
@property (nonatomic, strong, readonly) UIView *topSeparator;

/// Positioned on the bottom edge of the content view. Draws a dashed line.
/// Only visible in portrait when keepLandscapeAspectRatio is set.
@property (nonatomic, strong, readonly) UIView *bottomSeparator;

@end
