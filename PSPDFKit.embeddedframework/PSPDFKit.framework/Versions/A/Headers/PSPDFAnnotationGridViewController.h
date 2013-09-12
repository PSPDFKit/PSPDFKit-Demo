//
//  PSPDFAnnotationGridViewController.h
//  PSPDFKit
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBaseViewController.h"
#import "PSPDFStyleable.h"
#import "PSTCollectionView.h"
#import "PSPDFAnnotationSet.h"

@class PSPDFAnnotationGridViewController, PSPDFAnnotationSetCell;

/// Delegate to be notified on signature actions.
@protocol PSPDFAnnotationGridViewControllerDelegate <PSPDFOverridable>

@optional

/// Cancel button has been pressed.
/// @warning The popover can also disappear without any button pressed, in that case the delegate is not called.
- (void)annotationGridViewControllerDidCancel:(PSPDFAnnotationGridViewController *)annotationGridController;

/// Save/Done button has been pressed.
- (void)annotationGridViewController:(PSPDFAnnotationGridViewController *)annotationGridController didSelectAnnotationSet:(PSPDFAnnotationSet *)annotationSet;

@end

@protocol PSPDFAnnotationGridViewControllerDataSource <NSObject>

/// Returns number of sections.
- (NSInteger)numberOfSectionsInAnnotationGridViewController:(PSPDFAnnotationGridViewController *)annotationGridController;

/// Returns number of annotation sets per `section`.
- (NSInteger)annotationGridViewController:(PSPDFAnnotationGridViewController *)annotationGridController numberOfAnnotationsInSection:(NSInteger)section;

/// Returns the annotation set for `indexPath`.
- (PSPDFAnnotationSet *)annotationGridViewController:(PSPDFAnnotationGridViewController *)annotationGridController annotationSetForIndexPath:(NSIndexPath *)indexPath;

@end


/// Allows saving/loading of stored annotations.
/// Annotations are stored securely in the keychain.
@interface PSPDFAnnotationGridViewController : PSPDFBaseViewController <PSPDFStyleable>

/// Designated initializer.
- (id)initWithDelegate:(id<PSPDFAnnotationGridViewControllerDelegate>)delegate;

/// Delegate.
@property (nonatomic, weak) IBOutlet id<PSPDFAnnotationGridViewControllerDelegate> delegate;

/// Data Source.
@property (nonatomic, weak) IBOutlet id<PSPDFAnnotationGridViewControllerDataSource> dataSource;

/// Save additional properties here. This will not be used by PSPDFKit.
@property (nonatomic, copy) NSDictionary *userInfo;

/// Reloads from the dataSource.
- (void)reloadData;

@end


@interface PSPDFAnnotationGridViewController (SubclassingHooks) <PSUICollectionViewDelegate, PSUICollectionViewDataSource>

// To make custom buttons.
- (void)close:(id)sender;

// Customize cell configuration.
- (void)configureCell:(PSPDFAnnotationSetCell *)annotationSetCell forIndexPath:(NSIndexPath *)indexPath;

// Internally used grid view
@property (nonatomic, strong) PSUICollectionView *gridView;

@end


/// Annotation Set cell
@interface PSPDFAnnotationSetCell : PSUICollectionViewCell

/// The annotation set visible.
@property (nonatomic, strong) PSPDFAnnotationSet *annotationSet;

@end
