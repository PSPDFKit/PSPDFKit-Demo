//
//  PSPDFAnnotationStateManager.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import "PSPDFViewController.h"
#import "PSPDFLineHelper.h"
#import "PSPDFDrawView.h"

/// Allows to customize what image quality options we offer for adding image annotations.
typedef NS_OPTIONS(NSUInteger, PSPDFImageQuality) {
    PSPDFImageQualityLow     = 1 << 0,
    PSPDFImageQualityMedium  = 1 << 1,
    PSPDFImageQualityHigh    = 1 << 2,
    PSPDFImageQualityAll     = NSUIntegerMax,
};

@class PSPDFAnnotationStateManager, PSPDFFlexibleToolbarButton;

// Special type of "annotation" that will add an eraser feature to the toolbar.
extern NSString *const PSPDFAnnotationStringEraser;

// Special type that will add a selection tool to the toolbar.
extern NSString *const PSPDFAnnotationStringSelectionTool;

// Special type that will show a view controller with saved/pre-created annotations.
// Currently this will also require `PSPDFAnnotationStringStamp` to be displayed.
extern NSString *const PSPDFAnnotationStringSavedAnnotations;

@protocol PSPDFAnnotationStateManagerDelegate <NSObject>

@optional

/// Called after the manager's `state` and or `variant` attribute changes.
/// As a convenience it also provides access the previous `state` and `variant` for any state-related cleanup.
- (void)annotationStateManager:(PSPDFAnnotationStateManager *)manager didChangeState:(NSString *)state to:(NSString *)newState variant:(NSString *)variant to:(NSString *)newVariant;

/// Called when the internal undo state changes (pdfController.undoManager state changes or uncommitted drawing related changes).
- (void)annotationStateManager:(PSPDFAnnotationStateManager *)manager didChangeUndoState:(BOOL)undoEnabled redoState:(BOOL)redoEnabled;

@end

/**
 `PSPDFAnnotationStateManager` holds the current annotation state and configures the associated `PSPDFViewController` to accept input related to the currently selected annotation state. The class also provides several convenience methods and user interface components required for annotation creation and configuration.

 Interested parties can register as the `stateDelegate` and / or use KVO to observer the manager's properties.

 You should never use more than one `PSPDFAnnotationStateManager` for any given `PSPDFViewController`. It's recommended to use `-[PSPDFViewController annotationStateManager]` instead of creating your own one in order to make sure this requirement is always met.

 `PSPDFAnnotationStateManager` is internally used by `PSPDFAnnotationToolbar` and can be re-used for any custom annotation related user interfaces.

 @note Do not create this class yourself. Use the existing class that is exposed in the `PSPDFViewController.`
*/
@interface PSPDFAnnotationStateManager : NSObject <PSPDFOverridable>

/// Attached pdf controller.
@property (nonatomic, weak, readonly) PSPDFViewController *pdfController;

/// Annotation state delegate. Used by the annotation toolbar, when displayed.
@property (nonatomic, weak) id<PSPDFAnnotationStateManagerDelegate> stateDelegate;

/// Active annotation state. State is an annotation type, e.g. `PSPDFAnnotationStringHighlight`.
/// @note Setting a state will temporarily disable the long press gesture recognizer on the `PSPDFScrollView` to disable the new annotation menu. Setting the state on it's own resets the variant to nil.
@property (nonatomic, copy) NSString *state;

/// Sets the specified state, if it differs from the currently set `state`, otherwise sets the `state` to `nil`.
/// @note This will load the previous used color into `drawColor` and set all other options like `lineWidth`.
/// Set these value AFTER setting the state if you want to customize them, or set the default in `PSPDFStyleManager`
- (void)toggleState:(NSString *)state;

/// Sets the annotation variant for the current state.
/// States with different variants uniquely preserve the annotation style settings.
/// This is handy for defining multiple tools of the same annotation type, each with different style settings.
@property (nonatomic, copy) NSString *variant;

/// Sets the state and variant at the same time.
/// @see state, variant
- (void)setState:(NSString *)state variant:(NSString *)variant;

/// Toggles the and variant at the same time.
/// If the state and variant both match the currently set values, it sets both to `nil`.
/// Convenient for selectable toolbar buttons.
- (void)toggleState:(NSString *)state variant:(NSString *)variant;

/// String identifier used as the persistence key for the current state - variant combination.
@property (nonatomic, copy, readonly) NSString *stateVariantIdentifier;

/// Input mode (draw or erase) for `PSPDFDrawView` instances. Defaults to `PSPDFDrawViewInputModeDraw`.
@property (nonatomic, assign) PSPDFDrawViewInputMode drawingInputMode;

/// Default/current drawing color. KVO observable.
/// Defaults to `[UIColor colorWithRed:0.121f green:0.35f blue:1.f alpha:1.f]`
/// @note PSPDFKit will save the last used drawing color in the NSUserDefaults.
@property (nonatomic, strong) UIColor *drawColor;

/// Default/current fill color. KVO observable.
/// Defaults to nil.
/// @note PSPDFKit will save the last used fill color in the NSUserDefaults.
@property (nonatomic, strong) UIColor *fillColor;

/// Current drawing line width. Defaults to 3.f. KVO observable.
/// @note PSPDFKit will save the last used line width in the NSUserDefaults.
@property (nonatomic, assign) CGFloat lineWidth;

/// Starting line end type for lines and polylines. KVO observable.
/// @note PSPDFKit will save the last used line end in the NSUserDefaults.
@property (nonatomic, assign) PSPDFLineEndType lineEnd1;

/// Ending line end type for lines and polylines. KVO observable.
/// @note PSPDFKit will save the last used line end in the NSUserDefaults.
@property (nonatomic, assign) PSPDFLineEndType lineEnd2;

/// Font name for free text annotations. KVO observable.
/// @note PSPDFKit will save the last used font name in the NSUserDefaults.
@property (nonatomic, copy) NSString *fontName;

/// Font size for free text annotations. KVO observable.
/// @note PSPDFKit will save the last used font size in the NSUserDefaults.
@property (nonatomic, assign) CGFloat fontSize;

/// Text alignment for free text annotations. KVO observable.
/// @note PSPDFKit will save the last used text alignment in the NSUserDefaults.
@property (nonatomic, assign) NSTextAlignment textAlignment;

/// Allows to customize the offered image qualities.
/// Defaults to `PSPDFImageQualityAll`.
@property (nonatomic, assign) PSPDFImageQuality allowedImageQualities;

/// Undoes the last operation (drawing or other)
- (void)undo;

/// Undoes the last operation (drawing or other)
- (void)redo;

/// YES if we can undo
/// @see undo
- (BOOL)canUndo;

/// YES if we can redo
/// @see redo
- (BOOL)canRedo;

/// Shows the style picker for the current annotation class and configures it with annotation state manager style attributes.
/// @param sender A `UIView` or `UIBarButtonItem` used as the anchor view for the popover controller (iPad only).
/// @param options A dictionary of presentation options. See PSPDFViewController.h (Presentation category) for possible values.
- (void)showStylePickerFrom:(id)sender presentationOptions:(NSDictionary *)options;

/// Displays a `PSPDFSignatureViewController` and toggles the state to `PSPDFAnnotationStringSignature`.
/// @param sender A `UIView` or `UIBarButtonItem` used as the anchor view for the popover controller (iPad only).
/// @param options A dictionary of presentation options. See PSPDFViewController.h (Presentation category) for possible values.
- (void)toggleSignatureControllerFrom:(id)sender presentationOptions:(NSDictionary *)options;

/// Displays a `PSPDFStampViewController` and toggles the state to `PSPDFAnnotationStringStamp`.
/// @see toggleStampControllerFrom:includeSavedAnnotations:presentationOptions:
- (void)toggleStampControllerFrom:(id)sender includeSavedAnnotations:(BOOL)includeSavedAnnotations;

/// Displays a `PSPDFStampViewController` and toggles the state to `PSPDFAnnotationStringStamp`.
/// @param sender A `UIView` or `UIBarButtonItem` used as the anchor view for the popover controller (iPad only).
/// @param includeSavedAnnotations Whether to include saved annotation using PSPDFSavedAnnotationsViewController or not.
/// @param options A dictionary of presentation options. See PSPDFViewController.h (Presentation category) for possible values.
- (void)toggleStampControllerFrom:(id)sender includeSavedAnnotations:(BOOL)includeSavedAnnotations presentationOptions:(NSDictionary *)options;

/// Displays a `PSPDFStampViewController` and toggles the state to `PSPDFAnnotationStringImage`.
/// @param sender A `UIView` or `UIBarButtonItem` used as the anchor view for the popover controller (iPad only).
/// @param options A dictionary of presentation options. See PSPDFViewController.h (Presentation category) for possible values.
- (void)toggleImagePickerControllerFrom:(id)sender presentationOptions:(NSDictionary *)options;

/// Selects a location on the pageView and triggers the corresponding selection action at that point.
/// Only relevant for states that use selection view (PSPDFAnnotationStringFreeText, PSPDFAnnotationStringNote,
/// PSPDFAnnotationStringSignature, PSPDFAnnotationStringImage, PSPDFAnnotationStringSound,
/// PSPDFAnnotationStringSelectionTool).
/// @param pageView The page view on which the selection should be perfomed.
/// @param point A loaction in the pageView coordinate system.
- (void)performSelectionOnPageView:(PSPDFPageView *)pageView at:(CGPoint)point;

@end

@interface PSPDFAnnotationStateManager (StateHelper)

- (BOOL)isDrawingState:(NSString *)state;
- (BOOL)isHighlightAnnotationState:(NSString *)state;

@end


@interface PSPDFAnnotationStateManager (SubclassingHooks)

// Only allowed in drawing state (ink, line, polyline, polygon, circle, ellipse)
- (void)cancelDrawingAnimated:(BOOL)animated;
- (void)doneDrawingAnimated:(BOOL)animated;

// Color management.
- (void)setLastUsedColor:(UIColor *)lastUsedDrawColor annotationString:(NSString *)annotationString;
- (UIColor *)lastUsedColorForAnnotationString:(NSString *)annotationString;

// Finish up drawing. Usually called by the drawing delegate.
- (void)finishDrawingAnimated:(BOOL)animated saveAnnotation:(BOOL)saveAnnotation;

// Subclass to control if the state supports a style picker.
- (BOOL)stateShowsStylePicker:(NSString *)state;

// If we're in drawing state, this dictionary contains the `PSPDFDrawView` classes that are overlaid on the `PSPDFPageView`.
// The key is the current page.
@property (nonatomic, strong, readonly) NSDictionary *drawViews;

@end
