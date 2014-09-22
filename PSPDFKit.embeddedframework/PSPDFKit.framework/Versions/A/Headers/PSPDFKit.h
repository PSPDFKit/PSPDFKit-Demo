//
//  PSPDFKit.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Availability.h>
#import <AVFoundation/AVFoundation.h>
#import "PSPDFLicenseManager.h"

// Workaround for Apple's bug. __IPHONE_OS_VERSION_MIN_REQUIRED is set to 20000
// when the debugger tries to convert ObjC module headers to Swift.
#if __IPHONE_OS_VERSION_MIN_REQUIRED != 20000 && __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
#   error PSPDFKit supports iOS 7.0 upwards.
#endif

// Xcode 6 is required for PSPDFKit v4.
#ifndef __IPHONE_8_0
#warning PSPDFKit v4 has been designed for Xcode 6 with SDK 8. Other combinations are not supported.
#endif

#define __PSPDFKIT_IOS__
#define __PSPDFKIT_3_0_0 3000
#define __PSPDFKIT_3_1_0 3100
#define __PSPDFKIT_3_2_0 3200 // 3.2.x is the last version supporting iOS 5.
#define __PSPDFKIT_3_3_0 3300
#define __PSPDFKIT_3_4_0 3400
#define __PSPDFKIT_3_5_0 3500
#define __PSPDFKIT_3_6_0 3600
#define __PSPDFKIT_3_7_0 3700 // 3.7.x is the last version supporting iOS 6.
#define __PSPDFKIT_4_0_0 4000

/// X-Callback URL, see http://x-callback-url.com
/// @note This is used for the Chrome activity in `PSPDFWebViewController`.
extern NSString *const PSPDFXCallbackURLString;

/// The identifier for the render class, evaluated in `PSPDFRenderManager`.
extern NSString *const PSPDFRenderIdentifierKey;

/// The identifier for the multimedia class, evulated in `PSPDFMultimediaAnnotationView`.
extern NSString *const PSPDFMultimediaIdentifierKey;

/// Set to `@ YES` to disable the use of `WKWebView` when available.
extern NSString *const PSPDFWebKitLegacyModeKey;


/// Configuration object for various framework-global settings.
/// @note The PSPDFKit singleton is a global, thread-safe key/value store.
/// Use `setValue:forKey:` and `valueForKey:` or the subscripted variants to set/get properties.
@interface PSPDFKit : NSObject

/// The shared PSPDFKit configuration instance.
+ (instancetype)sharedInstance;

/// Allow direct dictionary-like access. The `key` must be of type `NSString`.
- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

/// Activate PSPDFKit with your license key from https://customers.pspdfkit.com
+ (void)setLicenseKey:(NSString *)licenseKey;

/// Returns the PSPDFKit version string.
@property (nonatomic, copy, readonly) NSString *version;

/// Returns the PSPDFKit version date.
@property (nonatomic, copy, readonly) NSDate *compiledAt;

/// Allows to test against specific features. Can test multiple features at once via the bitmask.
+ (BOOL)isFeatureEnabled:(PSPDFFeatureMask)feature;

@end

#define PSPDF_DEPRECATED(version, msg) __attribute__((deprecated("Deprecated in PSPDFKit " #version ". " msg)))

#ifdef __cplusplus
extern "C" {
#endif

// common
#import "PSPDFLogging.h"
#import "PSPDFLocalization.h"
#import "PSPDFError.h"
#import "PSPDFConverter.h"
#import "PSPDFConfiguration.h"
#import "PSPDFControlDelegate.h"
#import "PSPDFViewController.h"
#import "PSPDFViewControllerDelegate.h"
#import "PSPDFDocument.h"
#import "PSPDFDocument+DataDetection.h"
#import "PSPDFDocumentDelegate.h"
#import "PSPDFPageView.h"
#import "PSPDFPageView+AnnotationMenu.h"
#import "PSPDFTextSelectionView.h"
#import "PSPDFScrollView.h"
#import "PSPDFDocumentProvider.h"
#import "PSPDFDocumentProviderDelegate.h"
#import "PSPDFCache.h"
#import "PSPDFTransparentToolbar.h"
#import "PSPDFTranslucentToolbar.h"
#import "PSPDFRenderManager.h"
#import "PSPDFPageInfo.h"
#import "PSPDFRelayTouchesView.h"
#import "PSPDFContentScrollView.h"
#import "PSPDFPageViewController.h"
#import "PSPDFViewState.h"
#import "PSPDFBookmark.h"
#import "PSPDFBookmarkParser.h"
#import "PSPDFLicenseManager.h"
#import "PSPDFRenderQueue.h"
#import "PSPDFStyleManager.h"
#import "PSPDFUndoController.h"
#import "PSPDFDownloadManager.h"
#import "PSPDFRemoteFileObject.h"
#import "PSPDFSearchHighlightViewManager.h"
#import "PSPDFSpinnerCell.h"
#import "PSPDFAnnotationViewCache.h"
#import "PSPDFPopOutMenu.h"

// controller
#import "PSPDFSinglePageViewController.h"
#import "PSPDFPageScrollViewController.h"
#import "PSPDFMultiDocumentViewController.h"
#import "PSPDFFilePreviewController.h"
#import "PSPDFBrightnessViewController.h"
#import "PSPDFStampViewController.h"
#import "PSPDFSignatureViewController.h"
#import "PSPDFFontPickerViewController.h"
#import "PSPDFColorSelectionViewController.h"
#import "PSPDFNoteAnnotationViewController.h"
#import "PSPDFAnnotationTableViewController.h"
#import "PSPDFSavedAnnotationsViewController.h"
#import "PSPDFContainerViewController.h"
#import "PSPDFWebViewController.h"
#import "PSPDFSoundAnnotationController.h"
#import "PSPDFNavigationController.h"
#import "PSPDFHSVColorPickerController.h"
#import "PSPDFImagePickerController.h"

// actions
#import "PSPDFAction.h"
#import "PSPDFGoToAction.h"
#import "PSPDFRemoteGoToAction.h"
#import "PSPDFEmbeddedGoToAction.h"
#import "PSPDFURLAction.h"
#import "PSPDFNamedAction.h"
#import "PSPDFJavaScriptAction.h"
#import "PSPDFRenditionAction.h"
#import "PSPDFRichMediaExecuteAction.h"
#import "PSPDFSubmitFormAction.h"
#import "PSPDFResetFormAction.h"
#import "PSPDFHideAction.h"

// views
#import "PSPDFPageLabelView.h"
#import "PSPDFPasswordView.h"
#import "PSPDFActivityLabel.h"
#import "PSPDFHUDView.h"
#import "PSPDFRenderStatusView.h"
#import "PSPDFBaseView.h"

// search
#import "PSPDFTextSearch.h"
#import "PSPDFTextParser.h"
#import "PSPDFGlyph.h"
#import "PSPDFWord.h"
#import "PSPDFTextLine.h"
#import "PSPDFTextBlock.h"
#import "PSPDFImageInfo.h"
#import "PSPDFFontInfo.h"
#import "PSPDFSearchViewController.h"
#import "PSPDFSearchResult.h"
#import "PSPDFSearchResultCell.h"
#import "PSPDFSearchStatusCell.h"
#import "PSPDFSearchHighlightView.h"
#import "PSPDFInlineSearchManager.h"

// full-text search
#import "PSPDFLibrary.h"
#import "PSPDFDocumentPickerController.h"
#import "PSPDFDocumentPickerCell.h"
#import "PSPDFDocumentPickerIndexStatusCell.h"

// thumbnails
#import "PSPDFThumbnailViewController.h"
#import "PSPDFMultiDocumentThumbnailViewController.h"
#import "PSPDFThumbnailGridViewCell.h"
#import "PSPDFScrobbleBar.h"
#import "PSPDFThumbnailBar.h"

// outline
#import "PSPDFOutlineParser.h"
#import "PSPDFOutlineElement.h"
#import "PSPDFOutlineViewController.h"
#import "PSPDFOutlineCell.h"

// labels
#import "PSPDFLabelParser.h"

// tab bar
#import "PSPDFTabbedViewController.h"
#import "PSPDFTabBarView.h"
#import "PSPDFTabBarButton.h"

// annotations
#import "PSPDFAnnotationManager.h"
#import "PSPDFAnnotation.h"
#import "PSPDFAnnotationSet.h"
#import "PSPDFAnnotationProvider.h"
#import "PSPDFContainerAnnotationProvider.h"
#import "PSPDFFileAnnotationProvider.h"
#import "PSPDFHighlightAnnotation.h"
#import "PSPDFUnderlineAnnotation.h"
#import "PSPDFStrikeOutAnnotation.h"
#import "PSPDFSquigglyAnnotation.h"
#import "PSPDFFreeTextAnnotation.h"
#import "PSPDFNoteAnnotation.h"
#import "PSPDFInkAnnotation.h"
#import "PSPDFLineAnnotation.h"
#import "PSPDFLinkAnnotation.h"
#import "PSPDFSquareAnnotation.h"
#import "PSPDFCircleAnnotation.h"
#import "PSPDFStampAnnotation.h"
#import "PSPDFCaretAnnotation.h"
#import "PSPDFPopupAnnotation.h"
#import "PSPDFWidgetAnnotation.h"
#import "PSPDFScreenAnnotation.h"
#import "PSPDFRichMediaAnnotation.h"
#import "PSPDFFileAnnotation.h"
#import "PSPDFSoundAnnotation.h"
#import "PSPDFPolygonAnnotation.h"
#import "PSPDFPolyLineAnnotation.h"
#import "PSPDFAppearanceCharacteristics.h"
#import "PSPDFIconFit.h"
#import "PSPDFImageFile.h"
#import "PSPDFStream.h"
#import "PSPDFAnnotationStateManager.h"
#import "PSPDFAnnotationCell.h"
#import "PSPDFSignatureStore.h"
#import "PSPDFAnnotationSetCell.h"
#import "PSPDFAnnotationViewProtocol.h"
#import "PSPDFWebAnnotationView.h"
#import "PSPDFLinkAnnotationView.h"
#import "PSPDFNoteAnnotationView.h"
#import "PSPDFSoundAnnotationView.h"
#import "PSPDFFreeTextAnnotationView.h"
#import "PSPDFAnnotationViewCache.h"
#import "PSPDFFreeTextAccessoryView.h"
#import "PSPDFSelectionView.h"
#import "PSPDFDrawView.h"
#import "PSPDFSignatureCell.h"

// embedded files
#import "PSPDFEmbeddedFile.h"
#import "PSPDFEmbeddedFilesParser.h"
#import "PSPDFEmbeddedFilesViewController.h"
#import "PSPDFEmbeddedFileCell.h"
#import "PSPDFViewController+EmbeddedFileSupport.h"

// toolbar
#import "PSPDFBarButtonItem.h"
#import "PSPDFCloseBarButtonItem.h"
#import "PSPDFEmailBarButtonItem.h"
#import "PSPDFMessageBarButtonItem.h"
#import "PSPDFOpenInBarButtonItem.h"
#import "PSPDFPrintBarButtonItem.h"
#import "PSPDFSearchBarButtonItem.h"
#import "PSPDFMoreBarButtonItem.h"
#import "PSPDFViewModeBarButtonItem.h"
#import "PSPDFAnnotationBarButtonItem.h"
#import "PSPDFBookmarkBarButtonItem.h"
#import "PSPDFBrightnessBarButtonItem.h"
#import "PSPDFOutlineBarButtonItem.h"
#import "PSPDFActivityBarButtonItem.h"
#import "PSPDFFlexibleToolbar.h"
#import "PSPDFAnnotationToolbar.h"
#import "PSPDFFlexibleToolbarContainer.h"

// view model
#import "PSPDFAnnotationGroup.h"
#import "PSPDFAnnotationGroupItem.h"

// helper
#import "PSPDFModel.h"
#import "PSPDFValueTransformer.h"
#import "PSPDFCacheInfo.h"
#import "PSPDFAlertView.h"
#import "PSPDFActionSheet.h"
#import "PSPDFMenuItem.h"
#import "PSPDFProcessor.h"
#import "PSPDFStatusHUD.h"
#import "PSPDFColorButton.h"
#import "PSPDFSpeechSynthesizer.h"

// XFDF
#import "PSPDFXFDFParser.h"
#import "PSPDFXFDFWriter.h"
#import "PSPDFXFDFAnnotationProvider.h"

// encryption
#import "PSPDFCryptor.h"
#import "PSPDFAESCryptoDataProvider.h"
#import "PSPDFAESCryptoInputStream.h"
#import "PSPDFAESCryptoOutputStream.h"

// forms
#import "PSPDFFormParser.h"
#import "PSPDFFormElement.h"
#import "PSPDFFormRequest.h"
#import "PSPDFFormSubmissionDelegate.h"
#import "PSPDFButtonFormElement.h"
#import "PSPDFChoiceFormElement.h"
#import "PSPDFSignatureFormElement.h"
#import "PSPDFTextFieldFormElement.h"
#import "PSPDFButtonFormElementView.h"
#import "PSPDFChoiceEditorCell.h"
#import "PSPDFChoiceFormElementController.h"
#import "PSPDFTextFieldFormElementView.h"

// signatures
#import "PSPDFPKCS12.h"
#import "PSPDFPKCS12Signer.h"
#import "PSPDFRSAKey.h"
#import "PSPDFSignatureDigest.h"
#import "PSPDFSignatureManager.h"
#import "PSPDFSignedFormElementViewController.h"
#import "PSPDFSigner.h"
#import "PSPDFUnsignedFormElementViewController.h"
#import "PSPDFX509.h"
#import "PSPDFSignatureStatus.h"
#import "PSPDFDigitalSignatureReference.h"

// gallery
#import "PSPDFGalleryConfiguration.h"
#import "PSPDFGalleryView.h"
#import "PSPDFGalleryViewController.h"
#import "PSPDFGalleryContentView.h"
#import "PSPDFGalleryImageContentView.h"
#import "PSPDFGalleryVideoContentView.h"
#import "PSPDFGalleryContentCaptionView.h"
#import "PSPDFMultimediaAnnotationView.h"
#import "PSPDFGalleryContainerView.h"
#import "PSPDFGalleryContentLoadingView.h"
#import "PSPDFGalleryLoadingView.h"
#import "PSPDFGalleryManifest.h"
#import "PSPDFGalleryVideoItem.h"
#import "PSPDFMediaPlayerView.h"
#import "PSPDFMediaPlayerController.h"
#import "PSPDFRemoteContentObject.h"
#import "PSPDFMultimediaViewController.h"

// Stylus Feature
#import "PSPDFStylusManager.h"
#import "PSPDFAnnotationStateManager+StylusSupport.h"

// Plugin
#import "PSPDFPlugin.h"

#ifdef __cplusplus
}
#endif
