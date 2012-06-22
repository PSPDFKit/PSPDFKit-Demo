# Changelog

__v2.0.0 - 1/August/2012__

*  Text selection.
*  Smart Zoom.
*  Adobe DRM detection.
*  API changes. Lots of things got renamed or changes (Url -> URL)
*  navigationBar title is no longer set on every page change.

__v1.10.3 - 22/Jun/2012__

*  New property in PSPDFCache: downscaleInterpolationQuality (to control the thumbnail quality)
*  Add some improvements to caching algorithm, adds cacheThumbnailsForDocument to preload a document.
*  Ensures that email attachments will end with ".pdf".
*  Clear annotation cache in low memory situations. Helps for documents with lots of embedded videos.
*  Fixes a UI issue where the transition between content and thumbnails was sometimes incorrect on zoomed-in content.
*  Fixes a bug where the the pageIndex on thumbnails are off-by-one.
*  Fixes a bug where annotationEnabled wasn't correctly restored when using NSCoding on PSPDFDocument.
*  Fixed a problem where delegates where called too often for the initial reloadData event.
*  Fixes a potential crash on low-memory situations.
*  Fixes a potential crash with pageCurl mode and device rotations.
*  Fixes a crash when using a NSData-provided PSPDFDocument with no metadata title and using the sendViaEmail feature.
*  Fixes a issue with MPMoviePlayer disappearing during fullscreen-animation.

__v1.10.2 - 5/Jun/2012__

*  New controller delegates: willShowViewController:animated: and didShowViewController:animated:.
*  New HUD visibility delegates: shouldShowHUD/shouldHideHUD/willShowHUD:/didShowHUD:/willHideHUD:/didHideHUD:
*  PageLabel on thumbnails is now width-limited to the maximal image size.
*  The default linkAction is now PSPDFLinkActionInlineBrowser (changed from PSPDFLinkActionAlertView).
*  The openIn action is now displayed in the iOS Simulator, but a UIAlertView shows that this feature only works on a real device.
*  PSPDFOutlineElement now implements NSCopying and NSCoding.
*  Page labels now work with documents containing multiple files.
*  Removed the searchClassName property in PSPDFSearchViewController. Use the overrideClassNames in PSPDFViewController to change this.
*  Renamed showCancel to showsCancelButton in PSPDFSearchViewController.
*  searchBar in PSPDFSearchViewController is now created in init, not viewDidLoad (so you can easily customize it)
*  Added new API items for PSPDFTabbedViewController and changed the API to initialize the controller. (You can also just use init)
*  On PSPDFDocument.title, the ".pdf" ending is now automatically removed.
*  New property in PSPDFViewController: loadThumbnailsOnMainThread. (Moved from PSPDFPageView, new default is YES)
*  Fixes a short black gap when loading the document under certain conditions w/o pageCurl-mode.
*  Fixes a bug where the new pdf path resolving function sometimes returned invalid strings.
*  Fixes a bug where changing left/rightBarButtonItems needed an additional call to updateToolbar to work. This is now implicit.
*  Fixes a bug where nilling out left/rightBarButtonItems after the controller has been displayed didm't correctly update the navigationBar.
*  Fixes a bug where the position of the initial page view could be smaller than the view in landscape mode.
*  Fixes a bug where the the titleView wasn't used to calculate the toolbarWidths.
*  Fixes a bug where the TabbedViewController's selected tab wasn't correctly updated when setting visibleDocument.
 * Fixes a bug where the TabbedViewController-preference enableAutomaticStatePersistance wasn't always honored.

__v1.10.1 - 29/May/2012__

*  Improvement: Better handle toolbar buttons when a too long title is set. (now exposing minLeftToolbarWidth, minRightToolbarWidth)
*  Improvement: sometimes the NavigationBar was restored even if it wasn't needed.
*  Improvement: Don't reload frame if we're in the middle of view disappearing.
*  Improvement: Use default white statusBar with inline browser on iPhone.
*  Improves the document<->thumbnail transition with certain non-uniformed sized documents and pageCurl mode.
*  Fixes a case where the PSPDFPositionView wasn't correctly laid out. 
*  Fixes a problem where the close button was disabled when no document was set.
*  Fixes a regression regarding pageCurl mode and activated isFittingWidth.
*  Fixes a regression regarding the viewModeButtonItem not being displayed correctly on appcelerator.
*  Fixes a problem where under certain conditions a landscape->portrait rotation
   in pageCurl mode on the last page performed a scroll to the first page.
*  Fixes a leak in PSPDFActionSheet.

__v1.10.0 - 25/May/2012__

This will probably be the last major release in the 1.x branch.
Work on 2.x is already underway, with a focus on text selection and annotations.

This release has some API-breaking changes:

* New toolbar handling (breaking API change)
  The properties searchEnabled, outlineEnabled, printEnabled, openInEnabled, viewModeControlVisible
  have been replaced by a much more flexible system based on the PSPDFBarButtonItem class.

  For example, to add those features under the "action" icon as a menu, use this:
  self.additionalRightBarButtonItems = [NSArray arrayWithObjects:self.printButtonItem, self.openInButtonItem, self.emailButtonItem, nil];
  If you're looking to e.g. remove the search feature, set a new rightBarButtonItems array that excludes the searchButtonItem.

  Likewise, the functions additionalLeftToolbarButtons, magazineButton and toolbarBackButton have been unified to self.leftBarButtonItems.
  If you want to replace the default closeButton with your own, just create your own UIBarButtonItem
  and set it to self.leftBarButtonItems = [NSArray arrayWithObject:customCloseBarButtonItem];

* Resolving pdf link paths has changed. (breaking API change)
  Previously, if no marker like "Documents" or "Bundle" was found, we resolved to the bundle.
  This version changes resolving the link to the actual position of the pdf file.
  If you need the old behavior, you can set PSPDFResolvePathNamesEnableLegacyBehavior to YES or use a custom subclass of the PSPDFAnnotationParser.

*  New class PSPDFTabbedViewController, to show multiple PSPDFDocuments with a top tab bar. iOS5 only. (includes new TabbedExample)
*  New feature: PDF page labels are parsed. (e.g. roman letters or custom names; displayed in the PSPDFPositionView and the thumbnail label)
*  New feature: send via Email: allows sending the pdf as an attachment. (see emailButtonItem in PSPDFViewController)
*  New feature: PSPDFViewState allows persisting/restoring of a certain document position (including page, position, zoom level).
   See documentViewState and restoreDocumentViewState:animated: in PSPDFViewController.
*  Add support for puny code characters in pdf URLs (like http://➡.ws/鞰齒). This uses the IDNSDK.
*  New property: useParentNavigationBar, if you embed the PSPDFViewController using iOS5 containment and still want to populate the navigationBar.
*  New property: pageCurlDirectionLeftToRight to allow a backwards pagination. (for LTR oriented documents)
*  New delegate: delegateDidEndZooming:atScale to detect user/animated zooming.
*  UI Improvement: Show URL in embedded browser title bar, until page is loaded with the real title.
*  General: Add french localization in PSPDFKit.bundle.
*  Core: PSPDFDocument now implements NSCopying and NSCoding protocols.
*  Fixes a problem where links with hash bangs (like https://twitter.com/#!/) where incorrectly escaped.
*  Fixes opening certain password protected files.
*  Fixes unlockWithPassword always returning YES, even with an incorrect password.
*  Fixes a crash regarding pageCurl and UpsideDown orientation on the iPhone.
*  Fixes a problem where the search delegates where called after canceling the operation.
*  Fixes a problem where the page wasn't re-rendered if it was changed while zoom was active.
*  Fixes a problem where the tile wasn't updated after setting document to nil.
*  Fixes a problem where under rare conditions a spinlock wasn't released in PSPDFGlobalLock.
*  Adds support for Xcode 4.4 DP4. Due to an already acknowledged Apple linker bug. Xcode 4.4 DP5 is currently broken. (Xcode 4.3.2 is still recommended)
*  Titanium: New min SDK is 2.0.1.GA2.

__v1.9.15 - 20/Apr/2012__

*  New delegate: pdfViewController:didEndPageScrollingAnimation: to detect if a scroll animation has been finished.
   This will only be called if scrollToPage:animated: is used with animated:YES. (not for manual user scrolling)
*  Additional safeguards have been put in place so that videos don't start playing in the background while scrolling quickly.

__v1.9.14 - 20/Apr/2012__

*  Adds support for Xcode 4.4 DP3.
*  Show document back button even if PSPDFViewController is embedded in a childViewController.
*  Doesn't try to restore the navigation bar if we're the only view on the navigation stack.
*  Allow PSPDFSearchHighlightView to be compatible with overrideClassNames-subclassing.
*  Works around some broken annotations that don't have "http" as protocol listed (just www.google.com)
*  PSPDFPageView now has convertViewPointToPDFPoint / convertPDFPointToViewPoint for easier annotation calculation.
*  There are also some new PSPDFConvert* methods in PSPDFKitGlobal that replace the PSPDFTiledView+ categories. (API change)
*  YouTube embeds finally support the autostart option. (Note: This might be flaky on very slow connections)
*  Fixes a big where some documents would "shiver" due to a 1-pixel rounding bug.
*  Fixes a regression with KVO-observing viewMode.
*  Fixes a UI glitch with animated pageScrolling on pageCurl if invoked very early in the view build hierarchy.
*  Fixes a problem where video was playing while in thumbnail mode.

__v1.9.13 - 7/Apr/2012__

*  Zooming out (triple tap) doesn't scroll down the document anymore, only moves the zoom level to 1.0.
*  Better handling of light/dark tintColors.
*  ScrobbleBar is now colored like the navigationBar. (check for HUD changes/regressions in your app!)
*  The status bar now moves to the default color on the iPhone for ToC/Search views.
*  Fixes an alignment problem with the thumbnail animation.
*  Disable user interaction for very small links, that are not shown anyway.
*  YouTube videos now rotate and resize correctly.

__v1.9.12 - 2/Apr/2012__

*  Thumbnails now smoothy animate to fullscreen and back. (new setViewMode animation instead of the classic fade)
*  Fullscreen video is now properly supported with pageCurl. (with the exception of YouTube)
*  Annotation views are now reused -> better performance.
*  The outline controller now remembers the last position and doesn't scroll back to top on re-opening.
*  Hide HUD when switching to fullscreen-mode with videos.
*  Don't allow touching multiple links at the same time.
*  Transition between view modes are now less expensive and don't need view reloading. Also, zoom value is kept.
*  The pageInfo view now animates. (Page x of y)
*  The grid now properly honors minEdgeInsets on scrolling.
*  Thumbnail page info is now a nice rounded label.
*  Fixes partly missing search highlighting on the iPhone.
*  Fixes a few calculation errors regarding didTapOnPageView & the PSPDFPageCoordinates variable.
*  Fixes a problem where caching sometimes was suspended and got stuck on old devices.
*  Free more memory if PSPDFViewController is not visible.

__v1.9.11 - 28/Mar/2012__

*  Add more control for pageCurl, allows disabling the page clipping. (better for variable sized documents)
*  New method on PSPDFDocument: aspectRatioVariance. Allows easy checks if the document is uniformly sized or not (might be a mixture of portrait/landscape pages)
   There is example code in PSPDFExampleViewController.m that shows how this can be combined for dynamic view adaption.
*  Support for Storyboarding! You can create a segway to a PSPDFViewController and even pre-set the document within Interface Builder.
   There now is a new example called "StoryboardExample" that shows how this can be used. (iOS5 only)
*  Note: if you use IB to create the document, you just use a String. Supported path expansions are Documents, Cache, Bundle. Leave blank for Bundle.
*  Changes to navigationBar property restoration - now animates and also restores alpha/hidden/tintColor. Let me know if this breaks something in your app!
*  Fixes a potential crash with a controller deallocation on a background thread.
*  Fixes a potential crash when searching the last page in double page mode.
*  Fixes a regression introduced in 1.9.10 regarding a KVO deallocation warning.

__v1.9.10 - 26/Mar/2012__

*  Greatly improved performance on zooming with the new iPad (and the iPhone4).
*  Add support for printing! It's disabled by default. Use printEnabled in PSPDFViewController. (thanks to Cédric Luthi)
*  Add support for Open In...! It's disabled by default. Use openInEnabled in PSPDFViewController.
*  Improved, collapsable outline view. (Minor API changes for PSPDFOutlineParser)
*  Improved speed with using libjpeg-turbo. Enabled by default.
*  PSPDFStatusBarIgnore is now a flag, so the status bar style (which infers the navigation bar style) can now been set and then marked as ignore.
*  New property viewModeControlVisible, that shows/hides the toolbar view toggle.
*  Removes the UIView+Sizes category, that was not prefixed.
*  Remove custom PNG compression, performance wasn't good enough.
*  Internal GMGridView is now prefixed.
*  Disable implicit shadow animation when grid cell size changes.
*  Fixes a bug regarding slow rotation on the new iPad.
*  Fixes a bug where sometimes a pdf document wasn't unlocked correctly.
*  Fixes a potential problem where search/table of contents doesn't actually change the page on the iPhone.
*  Fixes some problems with Type2 Fonts on search.
*  Fixes a rare crash when rotating while a video is being displayed.

__v1.9.9 - 15/Mar/2012__

*  Icons! (changed outline icon, and replaced "Page" and "Grid" with icons)
*  Outline controller now has a title on the iPad.
*  Fixes a regression where the toolbar color was not correctly restored on the iPhone when modal controller were used.

__v1.9.8 - 14/Mar/2012__

*  Fixed a minor regression regarding scrobble bar updating.
*  Fixed issue where frame could be non-centered in pageCurl mode with some landscape documents when the app starts up in landscape mode.

__v1.9.7 - 14/Mar/2012__

*  PSPDFKit is now compiled with Xcode 4.3.1 and iOS SDK 5.1. Please upgrade. (It is still backwards compatible down to iOS 4.0.)
*  Allow adding the same file multiple times to PSPDFDocument.
*  Links are now blue and have a higher alpha factor. (old color was yellow and more obtrusive)
*  The animation duration of annotations is now customizable. See annotationAnimationDuration property in PSPDFViewController.
*  Link elements are not shown with exact metrics, and touches are tested for over-span area. Also, over-span area is now 15pixel per default. (old was 5)
*  Link elements now don't interfere with double/triple taps and only fire if those gestures failed.
*  Link elements no longer use an internal UIButton. (they are now handled by a global UITapGestureRecognizer)
*  Annotations are not size-limited to the actual document, no more "bleeding-out" of links.
*  Minimum size for embedded browser is now 200x200. (fixes missing Done button)
*  Inline browser can now also be displayed within a popover, using pspdfkit://[popover:YES,size:500x500]apple.com
*  Text highlighting is still disabled by default, but can be enabled with the new property createTextHighlightAnnotations in PSPDFAnnotationParser.
*  Fixes an issue where the navigation bar was restored too soon. Let me know if this change breaks behavior on your app.
   (The navigationBar is now restored in viewDidDisappear instead of viewWillDisappear, and also will be set in viewWillAppear)
*  Support tintColor property for inline browser.
*  Better support for invalid documents (that have no pages.) HUD can't be hidden while a document is invalid. UI buttons are disabled.
*  Fixes problem where link taps were not recognized on the site edges, advancing to the next/prev page instead in pageCurl mode.
*  Fixes issue where scrollOnTapPageEndEnabled setting was not honored in pageCurl mode.
*  Fixes a problem where the embedded mail sheet sometimes couldn't be closed.
*  Fixes a problem where touch coordinates on annotations where always in the frame center instead of the actual tap position.
*  Fixes a problem where adding items to the cache would sometimes spawn too much threads.
*  Fixes a potential crash in the inline browser.
*  Fixes a potential crash with accessing invalid memory on pageCurl deallocation.
*  Fixes a issue where certain URLs within pdf annotations were not correctly escaped.
*  Fixes a situation where the thumbnail grid could become invisible when rapidly switched while scrolling.
*  Fixes an issue where the HUD was hidden after a page rotate (which should not be the case)
*  Fixes weird animation with the navigationController toolbar when opening the inline browser modally.

__v1.9.6 - 6/Mar/2012__

*  New Inline Browser: PSPDFWebViewController. Annotations can be styled like pspdfkit://[modal:YES,size:500x500]apple.com or pspdfkit://[modal:YES]https://gmail.com.
*  New property in PSPDFViewController: linkAction. Decides the default action for PDF links (alert, safari, inline browser)
*  Add PSPDFStatusBarIgnore to completely disable any changes to the status bar.
*  Automatically close the Table of Contents controller when the user tapped on a cell.
*  Fixes sometimes missing data in the pageView didShowPage-delegate when using pageCurl mode.
*  Fixes (another) issue where status bar style was not restored after dismissing while in landscape orientation.
*  Fixes a severe memory leak with pageCurl mode.

__v1.9.5 - 5/Mar/2012__

*  Further tweaks on the scrobbleBar, improves handler in landscape mode. (thanks to @0xced)
*  Fixes a problem with pageCurl and the animation on the first page (thanks to Randy Becker)
*  Fixes an issue where double-tapping would zoom beyond maximum zoom scale. (thanks to Randy Becker)
*  Fixes issue where status bar style was not restored after dismissing while in landscape orientation. (thanks to Randy Becker)
*  Fixes some remote image display issues in the PSPDFKit Kiosk Example.
*  Fixes a regression with opening password protected pdf's.

__v1.9.4 - 4/Mar/2012__

*  Fixes a regression from 1.9.3 on single page documents.

__v1.9.3 - 1/Mar/2012__

*  Improves precision and stepping of the scrobbleBar. Now it's guaranteed that the first&last page are shown, and the matching between finger and page position is better.
*  Fixes a problem where sometimes page 1 should be displayed, but isn't in pageCurl mode.
*  Hide warnings for rotation overflow that UIPageViewController sometimes emits.

__v1.9.2 - 1/Mar/2012__

*  pageCurl can now be invoked from the edge of the device, even if the file is smaller. Previously, the gesture was not recognized when it wasn't started within the page view.
*  The incomplete support for text highlighting has been disabled.
*  removeCacheForDocument now has an additional parameter waitUntilDone. The previous behavior was NO,
   so just set NO if you use this and upgrade from an earlier release.
*  Fixes a potential cache-loop, where the device would constantly try to load new images.
*  Adds a sanity check for loading images, fixes a rare issue with images not showing up.

__v1.9.1 - 17/Feb/2012__

*  Allow scrolling to a specific rect and zooming:
   see scrollRectToVisible:(CGRect)rect animated:(BOOL)animated and (void)zoomToRect:(CGRect)rect animated:(BOOL)animated;
*  PSPDFAnnotationParser now allows setting custom annotations. (to complement or override pdf annotations)
*  New annotation type: Image. (jpg, png, tiff and all other formats supported by UIImage)
*  Better handling of situations with nil documents or documents where the actual file is missing.
*  Better alignment of the scrobble bar position image.
*  Add "mp4" as supported audio filetype.
*  Fixes ignored scrollingEnabled on PSPDFPageViewController.
*  Fixes event delegation in the Titanium module.
*  Fixes the method isFirstPage (checked for page = 1, but we start at page 0).
*  Renamed kPSPDFKitDebugLogLevel -> kPSPDFLogLevel.

__v1.9.0 - 13/Feb/2012__

*  PageCurl mode. Enable via setting "pageCurlEnabled" to YES. iOS5 only, falls back to scrolling on iOS4.
*  It's now possible to create a PSPDFDocument with initWithData! (thanks to @0xced)
*  Add support for pdf passwords! (Thanks to Steven Woolgar, Avatron Software)
*  Adds support for setting a custom tintColor on the toolbars.
*  Fixes a problem with PSPDFPageModeAutomatic and portrait/landscape page combinations.
*  Fixes various problems with __weak when the development target is set to iOS5 only.
*  Adds additional error checking when a context can't be created due to low memory.
*  Fixes flaky animations on the Simulator on the grid view.
*  Improves usage of PSPDFViewController within a SplitViewController (thanks to @0xced).
*  Removes a leftover NSLog.
*  Fixes a UID clashing problem with equal file names. Warning! Clear your cache, items will be re-generated in 1.9 (cache directories changed)
*  Fixes a bug with replacing local directory path with Documents/Cache/Bundle. (thanks to Peter)
*  Fixes a retain cycle in PSPDFAnnotationParser (thanks to @0xced).
*  Fixes a retain cycle on UINavigationController (thanks to Chan Kruse).
*  Fixes a problem where the scrobble bar tracking images were sometimes not updated.
*  Fixes a rare race condition where rendering could get stuck.
*  Improves handling of improper PSPDFDocument's that don't have a uid set.
*  Allow adding of UIButtons to gridview cells.
*  Added "Cancel" and "Open" to the localization bundle. (mailto: links)
*  Setting the files array is now possible in PSPDFDocument.
*  The cache now uses MD5 to avoid conflicts with files of the same name. (or multiple concatenated files)
*  Better handling of rendering errors (error objects are returned)
*  Search controller is now auto-dismissed when tapped on a search result.
*  PSPDFPositionView more closely resembles iBooks. (thanks to Chan)
*  PDF cache generation is no no longer stopped in the viewWillDisappear event (only on dealloc, or when document is changed)
*  Titanium: Add ability to hide the close button.

Note: For pageCurl, Apple's UIPageViewController is used. This class is pretty new and still buggy.
I had to apply some private API fixes to make it work. Those calls are obfuscated and AppStore-safe.

If you have any reasons to absolutely don't use those workarounds, you can add 
_PSPDFKIT_DONT_USE_OBFUSCATED_PRIVATE_API_ in the preprocessor defines.  (only in the source code variant)
This will also disable the pageCurl feature as the controller will crash pretty fast when my patches are not applied.

Don't worry about this, I have several apps in the store that use such workarounds where needed, it never was a problem.
Also, I reported those bugs to Apple and will keep track of the fixes,
and remove my workarounds for newer iOS versions if they fix the problem.


__v1.8.4 - 27/Dec/2011__

*  Fixes a problem where search highlights were not displayed.
*  Updated git version scripts to better work with branches. (git rev-list instead of git log)

__v1.8.3 - 26/Dec/2011__

*  Update internally used TTTAttributedString to PSPDFAttributedString; prevent naming conflicts.
*  Fallback to pdf filename if pdf title is set but empty.
*  pageMode can now be set while willAnimateRotationToInterfaceOrientation to customize single/double side switching.
*  Fixes a problem with the document disappearing in certain low memory situations.

__v1.8.2 - 25/Dec/2011__

*  Uses better image pre-caching code; now optimizes for RGB screen alignment; smoother scrolling!
*  Fixes a regression with scrobble bar hiding after animation.
*  Fixes wrong toolbar offset calculation on iPad in landscape mode.
*  Various performance optimizations regarding CGPDFDocument, HUD updates, thumbnails, cache creation.
*  Lazy loading of thumbnails.

__v1.8.1 - 23/Dec/2011__

*  UINavigationBar style is now restored when PSPDFViewController is popped back.
*  Annotation page cache is reset when protocol is changed.
*  Fixes Xcode Archive problem because of public header files in PSPDFKit-lib.xcodeproj
*  Fixes a regression with the Web-AlertView-action not working.

__v1.8.0 - 21/Dec/2011__

*  Search Highlighting! This feature is still in BETA, but already works with many documents. If it doesn't work for you, you can disable it with changing the searchMode-property in PSPDFDocumentSearcher. We're working hard to improve this, it just will take some more time until it works on every document. As a bonus, search is now fully async and no longer blocks the main thread.

*  ARC! PSPDFKit now internally uses ARC, which gives a nice performance boost and makes the codebase a lot cleaner. PSPDFKit is still fully compatible with iOS4 upwards. You need to manually include libarclite.so if you are not using ARC and need compatibility with iOS4. Check the MinimalExample.xcodeproj to see how it's done. (You can drag the two libarclite-libraries directly in your project). If you use the PSPDFKit-lib.xcodeproj as a submodule, you don't have to think about this, Xcode is clever enough to not expose this bug here. See more about this at http://pspdfkit.com/documentation.html.

*  New default shadow for pages. More square, iBooks-like. The previous shadow is available when changing shadowStyle in PSPDFScrollView. The shadow override function has been renamed to pathShadowForView.
*  New: PSPDFDocument now uses the title set in the pdf as default. Use setTitle to set your own title. Title is now also thread-safe.
*  New Thumbnail-Framework (removed AQGridView). Faster, better animations, allows more options. Thumbnails are now centered. You can override this behavior with subclassing gridView in PSPDFViewController.
*  New: HUD-elements are now within hudView, hudView is now a PSPDFHUDView, lazily created.
*  New: Page position is now displayed like in iBooks at the bottom page (title is now just title)
*  Changed: Videos don't auto play per default. Change the url to pspdfkit[autoplay:true]://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8 to restore the old behavior (or use delegates).
*  Changed: viewMode does not longer animate per default. Use the new setViewMode:animated: to change it with animation.
*  Changed: the left section of the toolbar now uses iOS5-style leftToolBarButtons if available; falls back to custom UIToolBar in iOS4.
*  Shortly pressed link targets are now highlighted with a minimum duration.
*  Alert is no longer displayed for URLs that can't be opened by the system.
*  Support detection of "m4v" as video annotation.
*  Improves performance when caching very large documents.
*  Expose the borderColor of PSPDFLinkAnnotationView; set in one of the delegates.
*  Removes a lot of glue code and switches to KVO for many view-related classes (Scrobble Bar)
*  Add methods to check if PSPDFPageInfo is already available, improves thumbnail speed.
*  Add generic support to override classes. See the property "overrideClassNames" for details. This replaces "scrollViewClass" and "scrobbleBarClass" and is much more flexible. Just use a key/value pair of NSStrings with default/new class names and your custom subclass will be loaded.
*  setScrobbleBarEnabled is now animatable.
*  The protocolString for the multimedia link annotation additions can now be set in PSPDFAnnotationParser (defaults to pspdfkit://).
*  didTapOnPage is now didTapOnPageView, the former is deprecated.
*  PSPDFPageCoordinates now show a nice description when printed.
*  Many deprecated delegate calls have been removed. Check your calls.
*  Version number is now directly written from the git repository. (PSPDFVersionString() is now more accurate)
*  When a link annotation is tapped, the HUD no longer shows/hides itself.
*  HUD show/hide is now instant, as soon as scrolling is started. No more delays.
*  Scrollbar is now only changed if controller is displayed in full-screen (non-embedded).
*  Fixes a issue where PSPDFKit would never release an object if annotations were disabled.
*  Fixes a bug where the outline was calculated too often.
*  Fixes an issue where the title was re-set when changing the file of a pdf.
*  Fixes problems with syntax highlighting of some files. Xcode 4.3 works even better; use the beta if you can.
*  Fixes a bug with video player when auto play is not enabled.
*  Fixes encoding for mailto: URL handler (%20 spaces and other encoded characters are now properly decoded)
*  Fixes potential crash with recursive calls to scrollViewDidScroll.
*  Fixes a rare crash when delegates are changed while being enumerated.
*  Lots of other small improvements.

__v1.7.5 - 01/Dec/2011__

*  Fixes calling the deprecated delegate didShowPage when didShowPageView is not implemented. (thanks Albin)

__v1.7.4 - 29/Nov/2011__

*  Custom lookup for parent viewcontroller - allows more setups of embedded views.
*  Fixes a crash related to parsing table of contents.

__v1.7.3 - 29/Nov/2011__

*  Add a log warning that the movie/audio example can crash in the Simulator. Known Apple bug. Doesn't happen on the device.
*  PSPDFCache can now be subclassed. Use kPSPDFCacheClassName to set the name of your custom subclass.
*  Fixes a bug where scrollingEnabled was re-enabled after a zoom operation.

__v1.7.2 - 29/Nov/2011__

*  Changes delegates to return PSPDFView instead of the page: didShowPageView, didRenderPageView.
*  Improve zoom sharpness. (kPSPDFKitZoomLevels is now set to 5 per default from 4; set back if you experience any memory problems on really big documents.)
*  Increase tiling size on iPad1/older devices to render faster.
*  Reduce loading of unneeded pages. Previously happened sometimes after fast scrolling. This also helps when working with delegates.
*  Fixes a locking race condition when using PSPDFDocument.twoStepRenderingEnabled.

__v1.7.1 - 29/Nov/2011__

*  Fixes a rare crash when encountering non-standardized elements while parsing the Table of Contents.

__v1.7.0 - 28/Nov/2011__

*  PSPDFKit now needs at least Xcode 4.2/Clang 3.0 to compile.
*  Following new frameworks are required: libz.dylib, ImageIO.framework, CoreMedia.framework, MediaPlayer.framework, AVFoundation.framework.
*  Images are now compressed with JPG. (which is usually faster) If you upgrade, add an initial call to [[PSPDFCache sharedPSPDFCache] clearCache] to remove the png cache. You can control this new behavior or switch back to PNGs with PSPDFCache's useJPGFormat property.
*  Optionally, when using PNG as cache format, crushing can be enabled, which is slower at writing, but faster at reading later on. (usually a good idea!)

*  New multimedia features! Video can now be easily embedded with a custom pspdfkit:// url in link annotations. Those can be created with Mac Preview.app or Adobe Acrobat. Try for example "pspdfkit://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8" to get the HTTP Live streaming test video.

*  Link annotations are now UIButtons. This allows more interactivity (feedback on touch down), and also changes the default implementation of PSPDFDocument's drawAnnotations function to be empty. Clear the cache after updating, or else you get two borders. You can also return to the old behavior if you return NO on shouldDisplayAnnotation (PSPDFViewControllerDelegate) anytime an annotation of type PSPDFAnnotationTypeLink is sent.

*  Localization is now handled via the PSPDFKit.bundle. You can either change this, or use PSPDFSetLocalizationDictionary to add custom localization.

*  PSPDFLinkAnnotation is renamed to PSPDFAnnotation and adds a new helper function to get the annotation rect.
*  PSPDFPage is refactored to PSPDFPageView and is now the per-page container for a document page. The delegate methods have been changed to return the corresponding PSPDFPageView. Within PSPDFPageView, you can get the parent scrollview PSPDFScrollView.
*  PSPDFPageModeAutomatic is now more intelligent and only uses dual page mode if it actually improves reading (e.g. no more dual pages on a landscape-oriented document)
*  PSPDFKitExample: fixes delete-image positioning in long scroll lists.
*  new: use PSPDFPageInfo everywhere to allow custom rotation override. (- (PSPDFPageInfo *)pageInfoForPage:(NSUInteger)page pageRef:(CGPDFPageRef)pageRef)
*  new delegate options to allow dynamic annotation creation.
*  Better size calculation for the toolbar, allows changing titles to longer/shorter words and resizing automatically.
*  PSPDFDocument now uses the title of the pdf document (if available). You can override this with manually setting a title.
*  New option "scrollingEnabled" to be able to lock scrolling. (e.g. when remote controlling the pdf)
*  Improves speed on image pre-caching.
*  Improves documentation.
*  Fixes a rotation problem with the last magazine page.
*  Fixes a bug where scrollPage w/o animation didn't show the page until the user scrolled.
*  Fixes a potential crash when view was deallocated while popover was opened.
*  Fixes a deadlock with clearCache.

__v1.6.20 - 18/Nov/2011__

*  fixes possible cache-reload loop with page-preload if non-odd values are chosen.
*  fixes a memory leak (regression in 1.6.18)

__v1.6.19 - 16/Nov/2011__

*  further small rotation improvement.

__v1.6.18 - 16/Nov/2011__

*  New: Much, much improved rotation. Now smooth as butter. Enjoy!

__v1.6.17 - 12/Nov/2011__

*  In search results, "Site" was renamed to "Page" to be consistent with the toolbar. If you use custom localization, you have to rename the entry "Site %d" to "Page %d".
*  add API call to allow basic text extraction from the search module (magazine.documentSearcher)

__v1.6.16 - 12/Nov/2011__

*  fixes a bug with invalid caching entries when a deleted document is re-downloaded in the same application session (pages suddenly went black)
*  add a custom lib-project for PSPDFKit; it's now easier than ever to integrate it. Note: you really should use that one - I'll switch over to ARC soon, so a library makes things easier.

__v1.6.15 - 05/Nov/2011__

*  thumbnails are now displayed under the transparent bar, not overlapping
*  only enable outline if it's enabled and there actually is an outline (no more empty popovers)
*  mail links are now presented in a form sheet on the iPad
*  allow show/hide of navigation bar even when zoomed in

__v1.6.14 - 22/Oct/2011__

*  fixes bug where delete method of PSPDFCache (removeCacheForDocument) was deleting the whole directory of the pdf instead of just the related files

__v1.6.13 - 22/Oct/2011__

*  removed the zeroing weak reference helper. If you use custom delegates for PSPDFCache, you now need to manually deregister them. Upside: better management of delegates. 

__v1.6.12 - 19/Oct/2011__

*  changed: turns out, when compiling with Xcode 4.2/Clang, you'll loose binary compatibility with objects linked from 4.1. Thus, the framework crashed with EXC_ILLEGAL_INSTRUCTION when compiled within an older Xcode. I will use 4.1 some more time to give everyone the change to upgrade, but due to some *great* improvements in Clang 3.0 compiler that ships with Xcode 4.2 (e.g. nilling out of structs accessed from a nil object) it's highly advised that you use Xcode 4.2. If you use the source code directly, this is not an issue at all.

__v1.6.11 - 14/Oct/2011__

*  new: PSPDFKit is now compiled with Xcode 4.2/iOS Base SDK 5.0 (still works with 4.x)
*  improves compatibility for outline parser; now able to handle rare array/dict destination variants (fixes all destinations = page 1 error)
*  fixes a rare stack overflow when re-using zoomed scrollviews while scrolling.
*  fixes a compile problem on older Xcode versions. (It's not officially supported though - use Xcode 4.2 for the best experience!)
*  fixes a memory problem where iPad1 rarely tries to repaint a page forever

__v1.6.10 - 25/Sept/2011__

*  aspectRatioEqual now defaults to NO. Many customers oversee this and then send me (false) bug reports. Set this to YES for maximum speed if your document has one single aspect ratio (like most magazines should).
*  scroll to active page in grid view
*  fixes small offset-error in the scrobble bar

__v1.6.9 - 22/Sept/2011__

*  add option do debug memory usage (Instruments isn't always great)
*  improves memory efficiency on tile drawing, animations
*  improves performance, lazily creates gridView when first accessed
*  improves scrobble bar update performance
*  fixes memory problems on older devices like iPad 1, iPhone 3GS
*  fixes a problem with unicode files
*  fixes auto-switch to fitWidth on iPhone when location is default view

__v1.6.8 - 15/Sept/2011__

*  update thumbnail grid when document is changed via property

__v1.6.7 - 15/Sept/2011__

*  improves outline parser, now handles even more pdf variants

__v1.6.6 - 15/Sept/2011__

*  potential bug fix for concurrent disk operations (NSFileManager is not thread safe!)
*  fixes positioning problem using the (unsupported) combination of PSPDFScrollingVertical and fitWidth

__v1.6.5 - 15/Sept/2011__

*  fixes a bug where scroll position was remembered between pages when using fitWidth

__v1.6.4 - 15/Sept/2011__

*  new: didRenderPage-delegate
*  fixes: crash bug with NaN when started in landscape

__v1.6.3 - 14/Sept/2011__

*  new: maximumZoomScale-property is exposed in PSPDFViewController
*  changed: *realPage* is now remembered, not the page used in the UIScrollView. This fixes some problems with wrong page numbers.
*  fixes situation where page was changed to wrong value after view disappeared, rotated, and reappeared.
*  fixes option button in example is now touchable again
*  fixes a bug where HUD was never displayed again when rotating while a popover controller was visible
*  fixes potential crash where frame get calculated to NaN, leading to a crash on view rotation
*  fixes problems when compiling with GCC. You really should use LLVM/Clang though.

__v1.6.2 - 13/Sept/2011__

*  fixed: HUD is now black again on disabled status bar

__v1.6.1 - 13/Sept/2011__

*  new: open email sheet per default when detecting mailto: annotation links. (You now need the MessageUI.framework!)
*  new: fileUrl property in PSPDFDocument
*  improve toolbar behavior when setting status bar to default
*  fixes memory related crash on older devices
*  fixes crash when toolbarBackButton is nil
*  greatly improved KioskExample


__v1.6.0 - 12/Sept/2011__

*  changed: willShowPage is now deprecated, use didShowPage. Both now change page when page is 51% visible. Former behavior was leftIndex
*  changed: pageCount is now only calculated once. If it's 0, you need to call clearCacheForced:YES to reset internal state of PSPDFDocument
*  changed: iPhone no longer uses dualPage display in landscape, now zooms current page to fullWidth
*  new: property fitWidth in PSPDFViewController lets you enable document fitting to width instead of largest element (usually height). Only works with horizontal scrolling
*  new: thumbnails in Grid, ScrobbleBar, KioskExample are now faded in
*  new: pdf view fades in. Duration is changeable in global var kPSPDFKitPDFAnimationDuration.
*  new: new property preloadedPagesPerSide in PSPDFViewController, controls pre-caching of pages
*  new: add delegates for page creation (willLoadPage/didLoadPage/willUnloadPage/didUnloadPage) with access to PSPDFScrollView
*  new: pdf cache handle is cleared on view controller destruction
*  new: exposes pagingScrollView in PSPDFViewController
*  new: HUD transparency is now a setting (see PSPDFKitGlobal)
*  new: scrobble bar class can be overridden and set in PSPDFViewController
*  new: directionalLock is enabled for PSPDFScrollView. This is to better match iBooks and aid scrolling
*  new: kPSPDFKitZoomLevels is now a global setting. It's set to a sensible default, so editing is not advised.
*  new: thumbnailSize is now changeable in PSPDFViewController
*  improve: faster locking in PSPDFCache, no longer freezes main thread on first access of pageCount
*  improve: split view example code now correctly relays view events
*  improve: cache writes are now atomically
*  improve: no more log warnings when initializing PSPDFViewController w/o document (e.g. when using Storyboard)
*  improve: faster speed for documents with high page count (better caching within PSPDFDocument)
*  improve: keyboard on searchController popover is now hidden within the same animation as popover alpha disappear
*  improve: grid/site animation no longer blocks interface
*  fixes touch handling to previous/next page for zoomed pages
*  fixes rasterizationScale for retina display (thumbnails)
*  fixes non-localizable text (Document-Name Page)
*  fixes inefficiency creating the pagedScrollView multiple times on controller startup/rotation events
*  fixes search text alignment, now synced to textLabel
*  fixes issue where documents may be scrollable on initial zoomRatio due to wrong rounding
*  fixes issue where caching was not stopped sometimes due to running background threads
*  fixes bug where alpha of navigationBar was set even if toolbarEnabled was set to NO
*  fixes bug where initial page delegation event was not sent when switching documents
*  fixes crash related to too high memory pressure on older devices

__v1.5.3 - 23/Aug/2011__

*  add correct aspect ratio for thumbnails
*  improve thumbnail switch animation
*  improve memory use during thumbnail display
*  improve thumbnail scrolling speed

__v1.5.2 - 23/Aug/2011__

*  add basic compatibility with GCC (LLVM is advised)
*  renamed button "Single" to "Page"
*  fixes page navigation for search/outline view
*  fixes a rare deadlock on PSPDFViewController initialization
*  fixes a race condition when changing documents while annotations are still parsed
*  fixes a crash when removing the view while a scrolling action is still active
*  possible bug fix for a "no autorelease pool in place"

__v1.5.1 - 23/Aug/2011__

*  fixes setting of back button when view is pushed non-modally

__v1.5.0 - 23/Aug/2011__

*  add advanced page preload - fully preloads pages in memory for even faster display
*  API change: PSPDFDocument now has a displayingPdfController attached if displayed. isDisplayed is removed.
*  improves animation between thumbnails and page view
*  improves scrolling performance
*  fixes crash when caching pages on iOS 4.0/iPhone
*  fixes crashes related to fast allocating/deallocating PSPDFViewControllers.
*  fixes issue where tap at rightmost border would not be translated to a next page event
*  fixes assertion when viewDidDisappear was not called

__v1.4.3 - 22/Aug/2011__

*  enables page bouncing (allow zooming < 1, bounces back)
*  add setting for status bar management (leave alone, black, etc)
*  fixes issue where page index was incremented on first page after multiple rotations
*  fixes issue where pdf text is rendered slightly blurry on initial zoom level
*  fixes issue where status bar was not taken into account on cache creation
*  fixes issue where pages were sometimes misaligned by 0.5-1 pixel
*  fixes issue where page shadow was not animated on zoomIn/zoomOut

__v1.4.2 - 17/Aug/2011__

*  remove queued cache requests when document cache stop is requested
*  fixes an assertion "main thread" when rapidly allocating/deallocating PSPDFViewController. Tip: Use the .document property to change documents instead if creating new controllers, it's much less expensive.
*  fixes incorrect tile setting in scrobble bar

__v1.4.1 - 13/Aug/2011__

*  add optional two-step rendering for more quality
*  improve scrobble bar marker
*  fixes annotation handling on first page
*  fixes page orientation loading on landscape & iPhone

__v1.4.0 - 13/Aug/2011__

*  greatly improves PDF rendering speed!
*  improves responsiveness of page scrolling while rendering
*  improves cache timings
*  improves full page cache
*  improve scrobble bar default thumb size
*  API change: PSPDFDocument.aspectRatioEqual now defaults to YES.
*  fixes rounding errors, resulting in a small border around the pages
*  fixes a potential deadlock while parsing page annotations
*  fixes bug where right thumbnail in scrobble bar is not always loaded
*  other minor bugfixes and improvements

__v1.3.2 - 11/Aug/2011__

*  Add example to append/replace a document
*  allow changing the document
*  improve clearCache

__v1.3.1 - 09/Aug/2011__

*  Add optional vertical scrolling (pageScrolling property)
*  Adds animation for iOS Simulator 
*  improve thumbnail loading speed
*  fixes memory pressure when using big preprocessed external thumbnails
*  fixes a regression with zoomScale introduced in 1.3

__v1.3 - 08/Aug/2011__

*  Major Update!
*  add support for pdf link annotations (site links and external links)
*  add delegate when viewMode is changed
*  add reloadData to PSPDFViewController
*  add scrollOnTapPageEndEnabled property to control prev/next tap
*  add animations for page change
*  improve kiosk example to show download progress
*  improve scrobblebar; now has correct aspect ratio + double page mode
*  improve scrollbar page changing
*  improve outline parsing speed
*  improve support for rotated PDFs
*  improve thumbnail display
*  fixes some analyzer warnings
*  fixes a timing problem when PSPDFCache was accessed from a background thread
*  fixes various other potential crashes
*  fixes a rare deadlock

__v1.2.3 - 05/Aug/2011__

*  properly rotate pdfs if they have the /rotated property set
*  add option to disable outline in document
*  outline will be cached for faster access 
*  outline element has now a level property
*  fixes a bug with single-page pdfs
*  fixes a bug with caching and invalid page numbers

__v1.2.2 - 05/Aug/2011__

*  fixes a crash with < iOS 4.3

__v1.2.1 - 04/Aug/2011__

*  detect rotation changes when offscreen

__v1.2 - 04/Aug/2011__

*  add EmbeddedExample
*  allow embedding PSPDFViewController inside other viewControllers
*  add property to control toolbar settings
*  made delegate protocol @optional
*  fixes potential crash on rotate

__v1.1 - 03/Aug/2011__

*  add PDF outline parser. If it doesn't work for you, please send me the pdf.
*  add verbose log level
*  improve search animation
*  fixes a warning log message when no external thumbs are used
*  fixes some potential crashes in PSPDFCache

__v1.0 - 01/Aug/2011__  

*  First public release