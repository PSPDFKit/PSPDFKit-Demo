//
//  PSPDFControlDelegate.h
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

@class PSPDFAction;

@protocol PSPDFPresentationControls <NSObject>

- (id)presentViewController:(UIViewController *)controller options:(NSDictionary *)options animated:(BOOL)animated sender:(id)sender completion:(void (^)(void))completion;

- (void)dismissViewControllerAnimated:(BOOL)animated class:(Class)controllerClass completion:(void (^)(void))completion;

- (BOOL)dismissPopoverAnimated:(BOOL)animated class:(Class)popoverClass completion:(void (^)(void))completion;

@end

@protocol PSPDFPageControls <NSObject>

- (BOOL)setPage:(NSUInteger)page animated:(BOOL)animated;
- (BOOL)scrollToNextPageAnimated:(BOOL)animated;
- (BOOL)scrollToPreviousPageAnimated:(BOOL)animated;

- (void)setViewMode:(PSPDFViewMode)viewMode animated:(BOOL)animated;

- (BOOL)executePDFAction:(PSPDFAction *)action inTargetRect:(CGRect)targetRect forPage:(NSUInteger)page animated:(BOOL)animated actionContainer:(id)actionContainer;

- (void)searchForString:(NSString *)searchText options:(NSDictionary *)options animated:(BOOL)animated;

- (void)reloadData;

@end

@protocol PSPDFHUDControls <NSObject>

- (BOOL)hideControlsAnimated:(BOOL)animated;
- (BOOL)hideControlsForUserScrollActionAnimated:(BOOL)animated;
- (BOOL)hideControlsAndPageElementsAnimated:(BOOL)animated;
- (BOOL)toggleControlsAnimated:(BOOL)animated;
- (BOOL)shouldShowControls;
- (BOOL)showControlsAnimated:(BOOL)animated;
- (void)showMenuIfSelectedAnimated:(BOOL)animated allowPopovers:(BOOL)allowPopovers;

@end

@protocol PSPDFControlDelegate <PSPDFPresentationControls, PSPDFPageControls, PSPDFHUDControls>
@end
