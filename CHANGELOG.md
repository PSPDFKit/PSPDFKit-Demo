# Changelog

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