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

#import "PSPDFKitGlobal.h"

@class PSPDFAnnotationStateManager;

// Special type of "annotation" that will add an eraser feature to the toolbar.
extern NSString *const PSPDFAnnotationStringEraser;

// Special type that will add a selection tool to the toolbar.
extern NSString *const PSPDFAnnotationStringSelectionTool;

// Special type that will show a view controller with saved/pre-created annotations.
// Currently this will also require `PSPDFAnnotationStringStamp` to be displayed.
extern NSString *const PSPDFAnnotationStringSavedAnnotations;

@protocol PSPDFAnnotationStateManagerDelegate <NSObject>

@optional

/// Called after the manager's `state` attribute changes. As a convenience it also provides access the previous state for any state-related cleanup.
- (void)annotationStateManager:(PSPDFAnnotationStateManager *)manager didChangeState:(NSString *)state to:(NSString *)newState;

/// Called when the internal undo state changes (pdfController.undoManager state changes or uncommitted drawing related changes).
- (void)annotationStateManager:(PSPDFAnnotationStateManager *)manager didChangeUndoState:(BOOL)undoEnabled redoState:(BOOL)redoEnabled;

@end

/**
 `PSPDFAnnotationStateManager` holds the current annotation state and configures the associated `PSPDFViewController` to accept input related to the currently selected annotation state. The class also provides several convenience methods and user interface components required for annotation creation and configuration.
 
 Interested parties can register as the `stateDelegate` and / or use KVO to observer the manager's properties.
 
 `PSPDFAnnotationStateManager` is internally used by `PSPDFAnnotationToolbar` and can be re-used for any custom annotation related user interfaces.
*/
@interface PSPDFAnnotationStateManager : NSObject <PSPDFOverridable>

/// Designated initializer.
- (id)initWithPDFController:(PSPDFViewController *)pdfController;

/// Attached pdf controller.
@property (nonatomic, weak, readonly) PSPDFViewController *pdfController;

/// Annotation state delegate. Used by the annotation toolbar, when displayed.
@property (nonatomic, weak) id<PSPDFAnnotationStateManagerDelegate> stateDelegate;

/// Active annotation state. State is an annotation type, e.g. `PSPDFAnnotationStringHighlight`.
/// @note Setting a state will temporarily disable the long press gesture recognizer on the `PSPDFScrollView` to disable the new annotation menu.
@property (nonatomic, copy) NSString *state;

/// Sets the specified state, if it differs from the currently set `state`, otherwise sets the `state` to `nil`.
- (void)toggleState:(NSString *)state;

/// Default/current drawing color (`PSPDFAnnotationToolbarModeDraw, PSPDFAnnotationToolbarModeRectangle, PSPDFAnnotationToolbarModeEllipse, PSPDFAnnotationToolbarModeLine, PSPDFAnnotationToolbarModePolygon, PSPDFAnnotationToolbarModePolyLine`). KVO observable.
/// Defaults to `[UIColor colorWithRed:0.121f green:0.35f blue:1.f alpha:1.f]`
/// @note PSPDFKit will save the last used drawing color in the NSUserDefaults.
@property (nonatomic, strong) UIColor *drawColor;

/// Default/current fill color (`PSPDFAnnotationToolbarModeDraw, PSPDFAnnotationToolbarModeRectangle, PSPDFAnnotationToolbarModeEllipse, PSPDFAnnotationToolbarModeLine, PSPDFAnnotationToolbarModePolygon, PSPDFAnnotationToolbarModePolyLine`). KVO observable.
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

/// Advanced property that allows you to customize how ink annotations are created.
/// Set to NO to cause separate ink drawings in the same drawing session to result in separate ink annotations. Defaults to YES.
@property (nonatomic, assign) BOOL combineInk;

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
/// @param passThroughViews Pass through views for the popover controller.
- (void)showStylePickerFrom:(id)sender withPassThroughViews:(NSArray *)passThroughViews;

/// Displays a `PSPDFSignatureViewController` and toggles the state to `PSPDFAnnotationStringSignature`.
/// @param sender A `UIView` or `UIBarButtonItem` used as the anchor view for the popover controller (iPad only).
- (void)toggleSignatureControllerFrom:(id)sender;

/// Displays a `PSPDFStampViewController` and toggles the state to `PSPDFAnnotationStringStamp`.
/// @param sender A `UIView` or `UIBarButtonItem` used as the anchor view for the popover controller (iPad only).
- (void)toggleStampControllerFrom:(id)sender includeSavedAnnotations:(BOOL)includeSavedAnnotations;

/// Displays a `PSPDFStampViewController` and toggles the state to `PSPDFAnnotationStringImage`.
/// @param sender A `UIView` or `UIBarButtonItem` used as the anchor view for the popover controller (iPad only).
- (void)toggleImagePickerControllerFrom:(id)sender;

@end

@interface PSPDFAnnotationStateManager (SubclassingHooks)

// Only allowed in drawing state (ink, line, polyline, polygon, circle, ellipse)
- (void)cancelDrawingAnimated:(BOOL)animated;
- (void)doneDrawingAnimated:(BOOL)animated;
- (BOOL)undoDrawing;
- (BOOL)redoDrawing;
- (BOOL)canUndoDrawing; // YES if we can undo drawing
- (BOOL)canRedoDrawing; // YES if we can redo drawing

// Color management.
- (void)setLastUsedColor:(UIColor *)lastUsedDrawColor annotationString:(NSString *)annotationString;
- (UIColor *)lastUsedColorForAnnotationString:(NSString *)annotationString;

// Finish up drawing. Usually called by the drawing delegate.
- (void)finishDrawingAnimated:(BOOL)animated saveAnnotation:(BOOL)saveAnnotation;

// Allows to override and hook into to create custom annotations.
- (NSArray *)annotationsWithActionList:(NSArray *)actionList bounds:(CGRect)bounds page:(NSUInteger)page;

// If we're in drawing state, this dictionary contains the `PSPDFDrawView` classes that are overlaid on the `PSPDFPageView`.
// The key is the current page.
@property (nonatomic, strong, readonly) NSDictionary *drawViews;

@end
