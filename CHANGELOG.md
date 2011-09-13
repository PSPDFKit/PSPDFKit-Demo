# Changelog

__v1.6.2 - 13/Sept/2011__

*  fixed: HUD is now black again on disabled status bar

__v1.6.1 - 13/Sept/2011__

*  new: open email sheet per default when detecting mailto: annotation links. (You now need the MessageUI.framework!)
*  new: fileUrl property in PSPDFDocument
*  improve toolbar behavior when setting statusbar to default
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