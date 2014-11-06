# PSPDFKit Changelog

Subscribe to updates: [RSS](https://github.com/PSPDFKit/PSPDFKit-Demo/commits/master.atom) | [Twitter](http://twitter.com/PSPDFKit)

We have a blog that highlights the best new features and changes: [http://blog.pspdfkit.com](http://blog.pspdfkit.com)

__v4.1.0 - 5/November/2014__

PSPDFKit now requires Xcode 6.1 with SDK 8.1. (iOS 7.0 is still supported)

If you use HockeyApp, Crashlytics or a similar crash reporting tool, we would love to hear from you.
We're working hard to further reduce our already very low issue rate and apprechiate your feedback. (support+crashreports@pspdfkit.com)

PSPDFKit will now assert if you change annotation properties on threads other than the main thread.
This behavior was unsupported before and was a cause for issues that were very hard to track down.
Read more about the annotation object model at https://github.com/PSPDFKit/PSPDFKit-Demo/wiki/The-annotation-object-model.

*  Natural Drawing! You'll love this new default. Your drawings will look much more realistic, and are still fully backwards compatible to 3rd-party apps.
*  Various optimizations and improvements for iOS 8.1
*  API: `PSPDFSpeechSynthesizer` has been renamed to `PSPDFSpeechController`.
*  API: `PSPDFActivityBarButtonItem` now forwards the iOS 8-style completionHandler.
*  API: `wantsSelectionBorder` is now an instance method to customize this per object.
*  API: The `PSPDFPresentationStylePopover` has been removed in favor of the iOS 8 variant `UIModalPresentationPopover`.
*  API: The interface around `PSPDFStream` and `PSPDFStampAnnotation` has been modernized.
*  API: The `PSPDFSignatureStore` is now a protcol with a default implementation that can be changed via configuring `PSPDFConfiguration`.
*  API: Various annotation classes have gained a convenience initializer.
*  API: The gallery is now configurable via `PSPDFGalleryConfiguration` in `PSPDFConfiguration`.
*  API: Various annotation enum values now have appropriate transformer objects for better JSON export.
   (`PSPDFBorderStyleTransformerName`, `PSPDFBorderEffectTransformerName`, `PSPDFFreeTextAnnotationIntentTransformerName`)
*  API: Many singletons have been moved to the global `PSPDFKit` object and various smaller class refinements.
*  Writing documents now uses `NSFileCoordinator` for better compatibility with iCloud Drive and Extensions.
*  If the size class on iOS 8 is `UIUserInterfaceSizeClassCompact`, the status bar will now be hidden.
*  The inline search manager now automatically focusses the first search result.
*  The inline search manager now shows the current search status with a slight delay to be more visually pleasing.
*  Absolute paths, while discouraged, are now properly detected in the gallery on iOS 8.
*  The gallery now automatically resolves URL endpoints that have no pre-set type. (video/image/etc)
*  Works around an issue where `UIDocumentInteractionController` sometimes would print extremely long log statements.
*  Makes sure the `PSPDFViewController` always correctly reloads, even when the document is changed while the controller is off-screen.
*  Various stylus drivers have been updated to be compatible with their API changes.
*  Search previews generated via `PSPDFLibrary` now also support text containing diactritics.
*  Adds support for bended arrows created in Yosemite's Preview.app.
*  Public C functions are now wrapped so they don't get name mangled if ObjC++ is used.
*  The annotation user name is now requested as soon as a annotation style mode is entered, not when the annotation is committed.
*  The interactive pop gesture is now disabled when the HUD is hidden to not accidentially invoke it during scrolling.
*  Improves robustness when `PSPDFLibrary` is called from multiple threads.
*  Improves reliability of sound annotations, especially on iOS 8 and 64 bit.
*  Improves code paths around setting a default line width when a border is set.
*  Improves compatibility with a certain set of annotations with appearance streams that uses custom transforms.
*  Improves reported frame when calling the shouldShowMenuItems: delegate in annotation sub-menus. (e.g. Highlight->Color)
*  Improves menu placement for annotations that can't be resized or moved.
*  Improves gallery error handling while the manifest is loaded.
*  Various improvements and better error detection/logging for the digital signing process.
*  Reduces memory pressure for older devices such as the iPad 2, the iPhone 4S and older iPod Touch devices.
*  The `creationDate` is now set for new user-created annotations and `lastModified` is updated on every change.
*  The text editing for bookmark names is now committed before a cell reorder is started, to ensure the changed text gets saved to the correct item.
*  When the device switches to single/double page mode due to rotation, we now will restore the last page instead of the left page from the double page mode.
*  Works around a potential deadlock in the Apple PDF renderer when called during the application did load event. (rdar://problem/18778790)
*  Ensures all popover dismissal code paths go through the workaround for rdar://problem/18500786 on iOS 8.
*  Complex ink annotations are now processed much faster.
*  The delete button no longer overlaps the signature display in the `PSPDFSignatureSelectorViewController`.
*  Ensures the signature creation buttons in `PSPDFSignatureViewController` are pixel-aligned.
*  Various improvements to digital signature handling. `PSPDFPKCS12Signer` now exposes `signFormElement` for non-interactive signing.
*  Various functional and performance improvements when parsing forms with JavaScript.
*  PSPDFKit now uses various iOS 8 QoS classes where appropriate to better deal with important/background related tasks.
*  Updates OpenSSL to 1.0.1j and SQLite to 3.8.7.1 (optional)
*  Fixes an issue with certain missing headers in the OpenSSL-free build.
*  Fixes an issue where drawings created during one operation in multiple pages could be collected to a single page on commit.
*  Fixes a small UI issue where on iOS 8 the current page of the color inspector could be wrong.
*  Fixes a set of crashes that could happen on more complex views when they were layouted with a `CGRectNull`.
*  Fixes an issue when the `activeFilter of the `PSPDFThumbnailViewController` is set manually.
*  Fixes a potential deadlock when `PSPDFPerformBlockWithoutUndo` was used manually in a large-scale way.
*  Fixes an issue related to the `pageRange` feature and HUD scrollable thumbnail updating.
*  Fixes a potential stack overflow if extremely complex PDF forms were saved using `NSCoder`.
*  Fixes an issue where tapping the annotation button quickly could result in a incorrect selection.
*  Many of the more obscure bugs and crashes have been squashed.
*  Various localization updates and improvements. PSPDFKit now uses the [stringsdict file format](https://developer.apple.com/library/ios/documentation/MacOSX/Conceptual/BPInternational/StringsdictFileFormat/StringsdictFileFormat.html) to define language plural rules.

__v4.0.3 - 3/October/2014__

*  Add API on `PSPDFViewController` to check if a search is running `isSearchActive` and to cancel a running search `cancelSearchAnimated:`.
*  Improves various animation effects under iOS 8.
*  Updates the optional SQLite library to 3.8.6.
*  Reduced the default speak rate in `PSPDFSpeechSynthesizer` from fast to normal.
*  Enables many new warnings to improve code quality and keeps our headers warning free in -Weverything environments.
*  Adds support for loading the PSPDFKit.bundle from unusual locations which improves compatibility with dynamic framworks.
*  Improves annotation moving/resizing logic to be more pixel accurate.
*  The `PSPDFInlineSearchManager` instance is now exposed inside the `PSPDFViewController`, when used.
*  The `PSPDFViewController` now shows page labels if set for search results cells.
*  The play button in the gallery component will no longer zoom in but always stay at the optimal size.
*  PSPDFKit now emits a log warning if `UIViewControllerBasedStatusBarAppearance` is set to NO.
*  PSPDFKit will now assert if the license is set on a background thread. This is a very fast operation and needs to be done on the main thread.
*  `PSPDFEraseOverlayLayer` has been refactored to `PSPDFEraseOverlay` to allow property customization via `UIAppearance`.
*  The navigation bar will no longer be modified if PSPDFKit is embedded via child view controller containment and `useParentNavigationBar` is set to NO.
*  Free text annotations are now always rendered aspect ratio correct.
*  Various improvements to the undo/redo feature.
*  Trying to show the print or open in sheet now no longer throws a popover exception if the `PSPDFViewController` is not visible.
*  Works around a regression in iOS 8.1b1 related to UIAppearance with  (rdar://problem/18501844)
*  Works around a regression in iOS 8 where dismissing a popover controller could result in accessing a deallocated object on iOS 8. (rdar://problem/18500786)
*  Works around a regression in iOS 8 where dismissing a popover could dismiss the parent modal controller. (rdar://problem/18512973)
*  Works around an issue where UIKit throws an unexpected exception when accessing the image in the general pasteboard. (rdar://problem/18537933)
*  Works around an issue where UIKit forwards `_UIPhysicalButton` objects when we expect `UITouch` objects. (rdar://problem/18537814)
*  Fixes an issue with a non-standard-conforming PDF not defining "Subtype" in the font dictionary.
*  Fixes an issue where the `PSPDFPopoverController` could be presented rotated on landscape under iOS 8.
*  Fixes an issue that would indicate "No page text" on the whole document after a search if the last document page contained no text.
*  Fixes an issue where in some cases RichMedia/Screen annotation video content was cached but not re-fetched if the cache was deleted by the system.

__v4.0.2 - 26/September/2014__

*  The UID generation in `PSPDFDocument` now works better with new app container locations in iOS 8. (See https://developer.apple.com/library/ios/technotes/tn2406/_index.html)
*  Improves video scrubbing behavior and the animation when the gallery is displayed in fullscreen.
*  FreeText Callout annotations now support dashed borders and better deal with different border/text colors.
*  Various smaller improvements related to the HUD visibility and thumbnail grid on the iPhone 6 Plus.
*  License is now validated later to allow setting the `PSPDFViewController` via Storyboards.
*  Improvements to the search animation in `PSPDFOutlineViewController`.
*  Digital Signatures now support up to 10k of payload data.
*  Works around an issue with extremely large image tiling on 64-bit devices.
*  API: Rename `searchStyle` to `searchMode` to keep it consistent with the enum name.
*  API: `searchForString:options:animated:` in `PSPDFViewController` now has an additional `sender` parameter to control popover placement.
*  Fixes an issue where `fitToWidth` didn't work as expected.
*  Fixes an issue where the software brightness dimming would not fill the whole screen on iOS 8 in landscape.
*  Fixes an issue where the stylus selection controller would hide other stylus options after one stylus has been chosen.
*  Fixes a small issue with calculating the content scroll view offset.
*  Fixes an issue where reordering apps in the “Open In” menu did not work. (iOS 8 only)
*  Fixes an issue where the actions in the `moreBarButtonItem` sometimes wouldn’t invoke under iOS 8 because they were committed while the action sheet was still dismissing.
*  Fixes an array overflow issue when a certain (corrupt) PDF was parsed.

__v4.0.1 - 23/September/2014__

*  Various improvements to the PSPDFCatalog examples.
*  The `PSPDFSearchViewController` now always rememberse the last used search string.
*  Fixes a minor rendering artifact on the iPhone 6 Plus.
*  Fixes an issue in the gallery image tiler that is specific to the iPhone 6.
*  Fixes an issue with detecting gallery URLs that are scaled (@2x, @3x)
*  Fixes an issue with link annotation options that contain an URL parsed from an XFDF.

__v4.0.0 - 22/September/2014__

PSPDFKit 4 is a major new release. Please study the migration guide:
https://github.com/PSPDFKit/PSPDFKit-Demo/wiki/PSPDFKit-4.0-Migration-Guide

Important: For your own security, invalid licenses now abort the app immediately, instead of silently showing a watermark.
PSPDFKit now requires a demo license for evaluation in your own app. Download it from the website and we'll automatically deliver the demo key via email.

Core Viewer:
*  PSPDFKit 4 is now fully compatible with iOS 8 and requires Xcode 6 with SDK 8.
*  Resources and loading support for @3x resources required for the iPhone 6 Plus have been added and various image resources have been refreshed for iOS 8.
*  The binary ships with armv7, arm64, i386 and x86_64. Following Apple's new defaults, we removed the slice for armv7s (which brought little benefits anyway).
*  All headers have been updated to use Modules for faster compile times.
*  Several properties that were no longer in line with iOS 7 have been removed: `tintColor`, `shouldTintPopovers` and `minLeft/RightToolbarWidth`. Use `UIAppearance` to customize colors and tint throughout PSPDFKit instead.
*  Adds a new `shouldHideStatusBar` property to globally control the status bar setting from the `PSPDFViewController`.
*  We no longer support the legacy `UIViewControllerBasedStatusBarAppearance` setting. Use view controller based status bar appearance.
*  The `PSPDFViewController` is now configured via an immutable `PSPDFConfiguration` object. See the migration guide for details.
*  Clear the web view state between `PSPDFWebAnnotationView` reuse.
*  Many classes, including `PSPDFTabBarButton` and `PSPDFScrobbleBar` have been enabled for `UIAppearance`.
*  Greatly improved and faster JavaScript Form support, using `JavaScriptCore` instead of `UIWebView`.
*  The embedded `PSPDFWebViewController` now uses the faster `WKWebView` when available on iOS 8.
*  Various improvements to the caching and rendering infrastructure. The limitation for super long/wide PDFs has been removed. PSPDFKit can now render documents no matter how long they are - we tested documents up to 5000px long/500px wide.
*  The thumbnail bar and the thumbnail controller now support a new layout that will group pages together for double-page layouts. (see `thumbnailGrouping`)
*  Many improvements to the multimedia gallery (`PSPDFGallery`), including better fullscreen-support and error handling.
*  `PSPDFAESDecryptor` now checks the HMAC for additional security.
*  The `PSPDFAESCryptoDataProvider` now returns an autoreleased object when accessing `dataProvider`. 
*  Open/Close page triggers are now supported (see `PSPDFPageInfo`).
*  The new `PSPDFMessageBarButtonItem` allows sharing content via iMessage/SMS.
*  Various UI widgets now better deal with keyboards that change the frame after being displayed (especially relevant for iOS 8)
*  Annotation action URL parsing is now smarter and will trim the string and replaces inline spaces with %20, instead of just filtering them all.
*  Adds various view optimizations that lead to faster page display and less internal reloads.
*  Color/Text attributes for outlines are now supported and parsed in `PSPDFOutline` and properly displayed in `PSPDFOutlineViewController`.
*  Form text is now always auto-sized to match Adobe Acrobat's behavior.
*  Thew new, faster `UIVisualEffectsView` is used for blur whenever available on iOS 8.
*  OpenSSL has been updated to OpenSSL 1.0.1i.
*  API: Various keys for `PSDPFObjects*` have been renamed and are now better organized.
*  API: Pushing view controllers via `presentModalOrInPopover:embeddedInNavigationController:withCloseButton:animated:sender:options:` has been improved and renamed. The new method is called `presentViewController:options:animated:sender:completion:`.
*  API: `PSPDFImageInfo` is now immutable and works correctly when the `PSPDFDocument` contains multiple `PSPDFDocumentProvider` objects.
*  API: `PSPDFAction` now resolves named destinations and page labels via `localizedDescriptionWithDocumentProvider:`.
*  API: `PSPDFLabelParser` interface has been simplified and this object can now be created with a predefined set of labels.
*  Fixes an issue where the modal search controller could place itself above the status bar on iPhone.

Indexed Full-Text-Search:
*  `PSPDFLibrary` now allows to preview text based on the FTS index.
*  Fixes a potential threading issue when indexes were added/removed quickly from the `PSPDFLibrary`.

Annotations and Digital Signatures:
*  Annotation hit testing now works on paths directly, which allows better selection in cases where multiple annotations are overlaid.
*  The first time an annotation is created by the user, we now ask for the user name and also offer a sensible default based on the device name.
*  The drawing eraser has been completely redesigned. Erasing and drawing is now a lot faster and features such as the eraser top of the FiftyThree Pencil are fully supported without exiting draw mode.
*  The old `PSPDFAnnotationToolbar` has been fully replaced by the `PSPDFFlexibleAnnotationToolbar` introduced in 3.6, and thus renamed back to `PSPDFAnnotationToolbar`. 
*  Cloud annotation borders are now fully supported.
*  Callout FreeText annotations can be parsed and edited.
*  Rich Media and Screen annotations are now lazily evaluated, improving general parsing speed.
*  Add support for various Rich Media Activation Context settings. (autostart)
*  `PSPDFURLConnection` has been replaced in favor of vanilla `NSURLSession` objects, which the additional benefit that remote content supporting SPDY will now load faster on iOS 8.
*  When fetching annotations via the document object finder, we now optionally support annotation grouping via the `PSPDFObjectsAnnotationIncludedGroupedKey` key.
*  Improved the signing architecture to allow signing using PKI hardware and remove signatures.
*  Annotation selection handling has been greatly improved and now uses a customizable margin for easier handling.
*  Annotations now have a common `fontAttributes` property that allows any key/value pair that `NSAttributedString` understands - so free text and forms can be customized even further. (Note: Not all values can be exported)
*  Free Text annotation handling now understands more PDF-based properties and will render more accurate.
*  Many improvements to stylus management and driver handling, especially for FiftyThree's Pencil.
*  PSPDFKit's model objects now mostly comply to `NSSecureCoding`.
*  The inspector has been modernized and offers a better display for poly/line and free text annotations.
*  Appearance stream parsing support has been improved.
*  The password view has been completely redesigned to fit into iOS 7 and 8.
*  The `PSPDFSignatureViewController` has been completely redesigned and now allows to select colors during signing.
*  `PSPDFViewController` now fully respects `isAutosaveEnabled` and will no longer save the document on view did appear when this is set to NO.
*  `PSPDFFontDescriptor` has been removed in favor of the new `UIFontDescriptor` introduced in iOS 7.
*  Various code is now faster thanks to the toll-free-bridging of `UIFont` and `CTFontRef`.
*  Support for the old, legacy PSPDFKit v2 annotation save format has been removed.
*  Image annotations now have better support for EXIF rotations when clipped via the internal editor.
*  Fixes an issue where the inspector could re-use the wrong cells and mixing up sliders or other control items.
*  Fixes an issue that would sometimes not allow to draw at the very borders of the screen on iPhone.
*  Fixes an issue where the annotation menu would not show up after scrolling the page.
*  Fixes an issue with very large animated gifs.
*  Includes all bug fixes and improvements made in the PSPDFKit 3.7.x branch.
*  Fixes an issue related to search highlighting and annotation moving. The highlights are now cleared before objects can be moved.
*  Fixes an issue where the popover wasn't correctly moved when a new `PSPDFNoteAnnotation` is created via the `PSPDFNoteAnnotationViewController`.

__v3.7.14 - 16/September/2014__

PSPDFKit 4.0 will be released on Monday, September 22, 2014 with full support for Xcode 6 with iOS 8 while also supporting iOS 7.
The PSPDFKit 3.7.x branch will remain compatible with Xcode 5.1.1 and iOS 6+.

*  Fixes an issue where the Camera/Image Picker UI sometimes wouldn’t show up on iPad/iOS 8.

__v3.7.13 - 11/September/2014__

*  Works around a rare PDF rendering crash in iOS 8.
*  Using `fillColor` on `PSPDFButtonFormElement` now respects the `alpha` property.
*  Fixes an issue in the text extraction logic when converting the contents of glyphs from unknown/not loadable fonts.
*  Fixes an issue where entering erase mode could hide the annotation toolbar.
*  Fixes an issue where the progress HUD would sometimes not correctly reposition when the keyboard appears in landscape.
*  Fixes an issue where the note annotation popover could become visible when deleting multiple annotations (including a note) at the same time.
*  Fixes an issue where the signature view controller failed to display on iPhone/iOS 8.

__v3.7.12 - 1/September/2014__

*  The predefined stamps now use the system locale instead of `en_US`.
*  Fixes an issue where the scrollable thumbnail bar could get into a state where it is not correctly displayed.
*  Fixes an issue with creating custom stamp annotations on iPad.
*  Fixes an issue with writing annotations into files that have unusual and non-standard compliant object headers.
*  Fixes a caching issue with extremely long file names.

__v3.7.11 - 20/August/2014__

*  Improves user name guessing for the annotation creation user.
*  Fixes an issue where saving notes multiple times within the same session could cause a duplication.
*  Fixes an issue with handling umlauts during a save in certain text field form elements.
*  Fixes a minor logging issue where in rare cases `NSScanner` could complain about nil string arguments.

__v3.7.10 - 17/August/2014__

*  Rendering the audio annotation preview no longer pauses background music.
*  Makes sure the signature image in the signature view controller is the same regardless of the device orientation.
*  Fixes an issue with rendering right-aligned free text annotations in too small bounding boxes.
*  Fixes a few minor issues when exporting/importing from/to XFDF for stamp and ink annotations.
*  Fixes an issue where alert view actions could be executed twice under iOS 8.

__v3.7.9 - 6/August/2014__

*  Fixes handling of nested form check boxes that are used as radio boxes.
*  Fixes an issue that could truncate text from a choice form element.
*  Fixes a rare UI issue with duplicated ink elements during erasing.
*  Fixes an issue where in landscape the keyboard could appear unexpectedly when using radio button form elements.
*  Fixes an issue where the page indicator in the scrobble bar sometimes was not correctly updated.
*  Fixes an issue on iOS 6 when showing the signature selector view controller.

__v3.7.8 - 1/August/2014__

*  Popup annotations, when written, now by default have the same bounding box as the parent annotation.
*  Improves handling of link annotations with an empty URL.
*  Continuous scroll mode now chooses the current pages based on the largest visible page, not the first visible page.
*  Path resolving now also resolves "Caches" instead of just "Cache".
*  Improves protection against manually calling `commonInitWithDocument:`.
*  Improves placement of free text annotations that are close to the right page border.
*  API: The interface for the `PSPDFXFDFAnnotationProvider` changed to reflect the possibility of stream recreation.
   Instead of setting the `inputStream` and `outputStream` directly, use `createInputStreamBlock` and `createOutputStreamBlock`.
*  Fixes a UI issue where the separators for the signature chooser could end up not visible on iOS 7.
*  Fixes an issue where cropping images could end up in black bars on parts of the image.
*  Fixes an issue where the text selection knobs could be slightly offset after a device rotation.
*  Fixes an issue with the fullscreen gallery transition on an iPhone.
*  Fixes a rare condition where a selected annotation would not hide the un-selected one, leaving two copies on the screen until the page changed.
*  Fixes a race condition that could result in rendering issues for form objects with auto-resizing text.
*  Fixes an issue where PSPDFKit would print a warning for KVO'ing weak properties that was not actually declared as weak.
*  Fixes an issue where the scrobble bar would not properly update itself after a rotation change.

__v3.7.7 - 21/July/2014__

*  Videos in the gallery are now reset if they are played till the end and the page changes.
*  The 'hidden' flag for annotation objects is now also honored for the gallery. (including audio)
*  Fixes an issue when the device is being rotated while in erase mode.
*  Fixes an issue where the pen tool can't draw up to the edge for certain configurations on an iPhone.
*  Fixes an issue where quickly destroying/recreating libraries for indexed search could result in partial indexes.
*  Fixes an issue in `PSPDFResizableView` related to unusual view controller configurations where the view could overlap the parent view and subsequently no longer correctly responding to touch events.
*  Fixes an issue related to rotation when the gallery is moved to fullscreen from within a popover.
*  Fixes an issue where missing fields in the digital signature validation code could result in a (null) output.
*  Fixes an issue related to multiple saving via the same XFDF annotation provider.
*  Fixes an issue related to early-reloading of the thumbnail bar that could result in missing bar button items for special configurations.
*  Fixes an issue where the navigation bar could disappear after the annotation toolbar has been moved to a different position.

__v3.7.6 - 4/July/2014__

*  Simplifies usage of `PSPDFMediaPlayerCoverModeClear` in the gallery.
*  Updates the Vimeo integration to use the new API endpoint.
*  Improves efficiency and memory usage for parsing large outlines with invalid named destination tables.
*  When using the text selection tool, we want to make sure no annotation is selected anymore.
*  The state of the `PSPDFWebAnnotationView` is now cleared upon reuse to prevent flashes of previous used content.
*  Fixes an issue related to the scrobble bar and `PSPDFThumbnailBarModeScrollable` on iOS 6.
*  Fixes a potential issue where the HUD layouting code could loop.
*  Fixes a potential crash related to the Wacom stylus driver.

__v3.7.5 - 16/June/2014__

*  New Localizations: Indonesian, Malaysian, Polish, Chinese Traditional, Thai, Turkish and Ukrainian.
*  Updates the WACOM stylus driver to no longer eagerly initialize, which could present a bluetooth disabled alert view.
*  Annotations added to a `PSPDFDocument` programmatically now always get the `isDirty` flag set to ensure that they are being saved.
*  `PSPDFResizableView` now correctly deals with `UIAppearance` and makes it easier to customize individual knobs. See `PSCCustomSelectionKnobsExample` for details.
*  Adds resilience / asserts form missing views in unusual (child view controller) configurations for the annotation toolbar.
*  Improved JavaScript-calculation-support, adds `AFMakeNumber` to the list of supported JS functions and improves hide action annotation resolving.
*  Improves compatibility to parse image stamps from 3rd-party software.
*  Outlines where the page reference is missing are now displayed to be consistent with Adobe Acrobat.
*  `PSPDFLibrary` learned exact sentence matching via the `PSPDFLibraryMatchExactPhrasesOnlyKey` option.
*  Improves support for named hide actions that are bound to form elements.
*  Allow to hook into `PSPDFMenuItem` action for analytics.
*  Scrolling or zooming will no longer re-show the note popover. Moving the annotation while the popover being open will still re-show the popover. This behavior change does not effect other annotations that use a `UIMenuController` or note on iPhone.
*  The annotation toolbar will now be hidden automatically if the last tab on the tabbed view controller is closed.
*  The font picker blacklist now uses regular expressions for matching, to allow more special cases like blocking “Courier” but still allowing “Courier New”. The old behavior was a simple prefix check.
*  The tables in `PSPDFLibrary` is now lazily created on first use, improving speed and delaying the unicode61 tokenizer check until the library is actually used.
*  API: Removes the `thumbnailSize` property on `PSPDFCache`. This should be set in the `PSPDFViewController` instead.
*  API: Hide `thumbnailCellClass` in `PSPDFThumbnailBar`. Use the standard class override mechanism instead.
*  API: Removes the `skipMenuForNoteAnnotationsOnIPad` property on `PSPDFViewController`. Use the new `shouldInvokeAutomatically` on `PSPDFMenuItem` instead. (See `PSCOpenNoteOnPhoneWithSingleTapExample`)
*  Fixes an issue related to copying sound annotations.
*  Fixes an issue where `UIImagePickerController` would sometimes not cancel correctly on iOS 7.0.
*  Fixes an crash related to accessibility support and page reading.
*  Fixes an issue where a picked image was added after pressing “Cancel” on the size popover.
*  Fixes an issue where the thumbnail bar wouldn’t update correctly the first time it is displayed when it was hidden initially.
*  Fixes an issue related to annotation fetching when the `pageRange` feature is enabled.
*  Fixes a potential issue related to cancelling index requests in `PSPDFLibrary`.
*  Fixes a potential issue in the vector separation code of the ink eraser.
*  Fixes an incompatibility with the NewRelic framework.

__v3.7.4 - 26/May/2014__

Note: With WWDC imminent and the upcoming release of iOS 8, we plan to finally drop support for iOS 6. Let us know your thoughts about this change: support@pspdfkit.com.

*  Clip drawings to bounds. Improves experience when drawing in double page mode.
*  The `metadata` dictionary of `PSPDFDocument` now also contains PDF Portfolio data, if detected.
*  Add new option to the `PSPDFAnnotationTableViewController` to show/hide the clear all button. `showDeleteAllOption`.
*  Allow initialization of sound annotations from custom URL.
*  Don’t allow to copy the contents of text markup annotations if the document disallows copying.
*  Document parser: Add support for direct AcroForm dictionaries.
*  Improves compatibility with certain rich text formats for free text annotations in 3rd-party XFDF files.
*  Extremely complex ink annotations will now render much faster with only minimal reduced quality.
*  We no longer manually draw a border if the free text annotation is backed by an AP stream.
*  Adds support for the `mailDoc` and `launchURL` JS functions to invoke the email/browser controller via JavaScript.
*  `PSPDFProcessor`: `PSPDFProcessorStripEmptyPages` now also works for regular document rendering and performs a more sophisticated page analysis.
*  API: The `PSPDFPageRenderer` can now be replaced at runtime, there's a new `setSharedPageRenderer:` instead of the class setter.
*  Various localization improvements.
*  Fixes an issue where certain JavaScript calculations could end up as NaN's.
*  Fixes an issue where the “Reset Form” feature would sometimes not clear all form elements.
*  Fixes an issue where the `pageRange` property could be calculated incorrectly for password protected files.
*  Fixes an issue where adding/removing the same overlay annotations within the same runloop could lead to an incorrect view representation.
*  Fixes an issue where the bookmark indicator was not always correctly displayed when pages are filtered using the pageRange feature.
*  Fixes an issue where persisting choice form elements that were split in child/parent relationships could sometimes result in only the initial index value being set.

__v3.7.3 - 12/May/2014__

*  The search preview text is now stripped of control characters like carriage return or newlines, which improves preview for various documents.
*  Improves error handling for inline PDF videos that can't be played. (most likely because they are in .flv flash video format)
*  The cover image capture time for the video now defaults to second 2 instead of 0 to give a more meaningful default, and is also configurable via JSON.
*  `PSPDFStampViewController`: Adds `dateStampsEnabled` property to control if date stamps are added or not.
*  Improves handling around flexible toolbar dragging and the half modal sheet on the iPhone.
*  Improves compatibility when the 'Spark Inspector' framework is linked with PSPDFKit.
*  Add `selectedOptions` to `PSPDFDocumentSharingViewController` to allow easier changing of the defaults.
*  Changes the selected default for the print sheet to `print with annotations` if this is allowed.
*  Add new option to `PSPDFAnnotationStateManager` to allow setting the allowed image qualities `allowedImageQualities` for image annotations. Fixes #989.
*  API: Make `PSPDFOutlineElement` immutable. Use the initializer to create.
*  Various localization improvements.
*  Fixes a potential issue with manually creating `PSPDFLineAnnotation` objects without properly initializing the points array.
*  Fixes a potential formatting issue when writing sound annotations into the PDF.

__v3.7.2 - 6/May/2014__

*  Add support for actions that are invoked on entering/exiting annotation focus.
*  Add support for GoToE embedded actions. This allows linking to PDFs that are saved inside the PDF.
*  Add support for relatively linked files without file handler. Will open QuickLook for such files.
*  `PSPDFDocument` now automatically detects and converts PDF-Date-Strings (D:...) to NSDate objects when accessing the `metadata` property.
*  Note annotations will now always get the correct style applied. (which includes alpha, if set)
*  The method `updatePage:animated:` now also discards any current selection to make sure everything is updated.
*  `PSPDFWebViewController`: add new property `shouldUpdateTitleFromWebContent` to control if the title should be updated dynamically.
*  Improved security handling based on Veracode static analyzer feedback.
*  An embedded file with the 'pdf' filetype will now be previewed using a new `PSPDFViewController` instead of the generic QuickLook. QuickLook will still be used for all other file types.
*  Various improvements to Form-JavaScript validation, actions and handling.
*  Various smaller improvements to the flexible annotation toolbar related to `tintColor` handling.
*  A new render option named `PSPDFRenderDrawBlockKey` allows to add a global drawing handler above the page renderer.
*  Improves performance of the internal download manager with moving some Apple-API that is potentially slow to a background thread.
*  The `allowBackgroundSaving` property of the `PSDPFViewController` now defaults to YES. Make sure you can deal with async saving or revert this to NO.
*  Single-page documents no longer allow bouncing, unless `alwaysBouncePages` is enabled.
*  API: The watermark drawing block has been changed and now includes more types. See `PSPDFRenderDrawBlock` for the new type.
*  API: The X-Callback-URL registration is now handled by the PSPDFKit global configuration object.
*  API: Removes the `mailComposeViewControllerCustomizationBlock`. Use the `pdfViewController:shouldShowController:embeddedInController:options:` delegate.
*  API: executePDFAction:inTargetRect:forPage:actionContainer now has an additional animated: property.
*  API: Some logic from `PSPDFSoundAnnotation` has been extracted into `PSPDFSoundAnnotationController`.
*  Fixes a regression when adding images via the annotation toolbar on an iPad.
*  Fixes a regression that could reduce ink annotation width to 1.
*  Fixes an issue where PSPDFStatusHUD would not always correctly update when a new title was set while it was already visible.
*  Fixes an issue where sound annotation data was sometimes not correctly loaded and wasn't properly exported as JSON.
*  Fixes a very rare potential for a deadlock when the JavaScript runtime is being initialized from a background thread.

__v3.7.1 - 25/Apr/2014__

*  Adds Dutch translation.
*  The `PSPDFGallery` now supports parsing and embedding Vimeo URLs, next to YouTube.
*  Improvements for the flexible annotation toolbar on the iPhone.
*  Calling undo/redo will now scroll to the page where the annotation is being changed.
*  Small visual tweaks for the ink preview icon in the flexible annotation toolbar.
*  Allow to subclass `PSPDFFreeTextAccessoryView`, `PSPDFFormInputAccessoryView` and expose the bar button items.
*  Additional improvements and checks to better guard against low-memory situations and to improve the Veracode score.
*  Performance improvements when a large amount of updates are being processed for undo/redo.
*  The document label is no longer displayed on iPhone when the document doesn't has a label.
*  The `PSPDFDrawView` is now reused when possible and state aware. (improves drawing polylines/polygons)
*  The XFDF parser now correctly parses the `lastModified` property of annotations.
*  Improve palm detection when using a stylus.
*  Fixes an issue when converting line annotations to JSON.
*  Fixes various issues when using updateAnnotations:animated: from the `PSPDFAnnotationManager`.
*  Fixes an issue related to search in the font picker controller.
*  Fixes an issue when using the streaming encryption/decryption with empty XFDF files.

__v3.7.0 - 19/Apr/2014__

PSPDFKit now requires Xcode 5.1.1 or higher to compile if you're using the source code variant. (we still support all iOS versions down to 6.0)

*  Stylus support for ink annotation drawing with drivers for Adonit, Pogo, HEX3 and Wacom. The framework is designed in a way where new drivers can be added easily. To enable this, see the "Stylus" example in the PSPDFCatalog. (The SDKs need to be downloaded separately. Drivers are currently only available for customers with a license.)
*  The annotation toolbar now has a second drawing style (thick, yellow, transparent) and improved color defaults for the other tools.
*  Search now detects if the document has no content and shows a different "no page text" message.
*  We now have a command line tool that works on Mac, Windows and Linux/Unix that can encrypt/decrypt files to be used with the `PSPDFAESCryptoDataProvider` (see `Extras` folder)
*  PSPDFKit now has support for transparent reading/writing with encrypted streams in the `PSPDFXFDFAnnotationProvider` with the new `PSPDFAESCryptoOutputStream` and `PSPDFAESCryptoInputStream`. This allows secure storage of annotations.
*  The gallery has improved handling for fullscreen transition and properly tears down when the `PSPDFViewController` is popped while it is in full screen mode.
*  The gallery learned different cover modes, including a transparent one: https://github.com/PSPDFKit/PSPDFKit-Demo/wiki/adding-a-gallery-to-your-document
*  Multimedia links can now be activated via button and the gallery can be displayed as popover or modally: https://github.com/PSPDFKit/PSPDFKit-Demo/wiki/adding-a-gallery-to-your-document
*  The gallery will now correctly scale @2x images from remote servers.
*  The gallery now automatically pauses other instances when play is pressed.
*  The gallery now allows UIAppearance for blur and background colors.
*  The blur algorithm used for the gallery are now over 4x faster and also support live fullscreen blur.
*  The speech synthesizer (`PSPDFSpeechSynthesizer`) now auto-detects the best language by parsing the current document page.
*  Greatly improved AcroForm JavaScript validation support.
*  Improves support for custom controllers that don't define a preferred content size when used with `PSPDFContainerViewController`.
*  Empty ink signatures are no longer saved.
*  Add confirmation sheet for the "Clear All" button in the annotation table view controller.
*  It's now possible to correctly override `PSPDFAnnotationCell` from `PSPDFAnnotationTableViewController`.
*  The `PSPDFAnnotationTableViewController` now automatically reloads the content if the `visibleAnnotationTypes` property has been changed.
*  The `PSPDFLibrary` now optionally allows exact word matching with supplying the `PSPDFLibraryMatchExactWordsOnlyKey` parameter.
*  The XSigner attribute is now parsed and displayed as the signer name if no other name is defined in the digital signature. (PSPDFKit Complete feature)
*  Adds support for orphaned form elements that are not referenced in the AcroForm dictionary.
*  Reloading a document while the keyboard is up will no longer lead to the page animating back to center.
*  Add some additional saveguards/asserts and developer warnings that help to detect wrong use of certain methods.
*  Improve support for custom `PSPDFFlexibleAnnotationToolbar` configuration or when used manually without an `UINavigationController`.
*  PSPDFKit has been tested with Veracode (http://www.veracode.com/) and we've improved and hardened several code paths.
*  Add `PSPDFThumbnailFilterSegmentedControl` to enable UIAppearance rules on the thumbnail overview filter segment.
*  Add basic support for URL actions that are actually JavaScript actions.
*  Support loading images from asset catalogs via the pspdfkit:// image loading system.
*  The flexible annotation toolbar now better adapts to status bar changes on iOS 7.
*  Allow to manually force-load all annotations from the `PSPDFXFDFAnnotationProvider`.
*  Add support for embedded CMap streams for the text parsing engine.
*  API: The `PSPDFAction` objects and the `PSPDFPageInfo` objects are now immutable.
*  API: The toolbar now longer auto-hides when invoked via the context menu. This also removes the `hideAfterDrawingDidFinish` property.
*  API: Removed `setTextViewCustomizationBlock:` as it is inconsistent with what we do everywhere else in the framework. Use `overrideClass:withClass:` or the `pdfViewController:shouldShowController:embeddedInController:options:animated` delegate instead. To change the font, instead of `textViewFont`, simply change it in `updateTextView`.
*  API: The `bookmarkQueue` is now exposed via a property and not via an ivar in `PSPDFBookmarkParser`.
*  API: A few methods in the digital signature code have been renamed to be more clear about their intent.
*  API: Adds a new `pageTextFound` parameter to `didFinishSearch:` and now shows "Document has no content" if a document without text content is being searched.
*  API: `setGlobalBorderColor` on `PSPDFLinkAnnotationView` has been removed. The recommended API is to use `UIAppearance` on `borderColor` instead.
*  API: Remove explicit close button management inside `PSPDFContainerViewController` as the `PSPDFViewController` (via `PSPDFPresentationManager`) already provides this feature.
*  Fixes an issue where certain pre-encoded URLs with non-ascii characters could end up being encoded twice.
*  Fixes a potential stability issue in the accessibility support for line-based page reading.
*  Fixes an issue that could add overlay-based annotations to the wrong page when a redo action is invoked with soft-deleted annotations.
*  Fixes an issue related to text extraction font caching with different widths.
*  Fixes various rare issues when analyzing the document or writing annotations with partial UTF16-LE encoding, invalid document IDs or missing object references.
*  Fixes a rare crash issue related to missing languages and the `PSPDFSpeechSynthesizer`.

__v3.6.5 - 31/Mar/2014__

*  Some internal improvements to prepare for the upcoming stylus support.
*  Improves section styling of the annotation inspector under iOS 7.

__v3.6.4 - 30/Mar/2014__

*  The flexible annotation toolbar now automatically consolidates buttons if space becomes too short.
*  The image/video gallery now loops content by default, unless it's just a single item. (This is controllable by the new `loopEnabled` flag)
*  Improve documentation around gallery-usage and proper removal from full-screen.
*  The percent driven back animation of the inspector now animates the current selected cell out or restores it based on the animation progress.
*  Changes the HMAC format for the PSPDFCryptor from SHA1 to SHA256 to be more consistent with the RNCryptor data format.
*  The `moreBarButtonItem` action sheet is now dismissed when tapped on the button while it being open (instead of showing it again).
*  Allows to add global processor options via a new delegate to `PSPDFDocumentSharingViewController`.
*  `PSPDFProcessor` now has a new drawing hook (`PSPDFProcessorDrawRectBlock`) which can be used to watermark documents on exporting.
*  Fixes an issue that could prevent showing some search highlights if there are multiple on the same page.
*  Fixes a regression where sometimes the original view port wasn't correctly restored when the keyboard is dismissed after free text editing.

__v3.6.3 - 26/Mar/2014__

*  Improves placement precision of draft ink annotations when the device is rotated while in drawing mode.
*  Improves popover placement for the flexible annotation toolbar in vertical mode.
*  Multiple performance and memory improvements, especially for searching and scrolling large documents, and for usage on an iPhone 4.
*  Various cosmetic updates (improved thumbnail scroll bar, better support for iPhone 4 which doesn't support live-blur)
*  Improves search highlighting accuracy for certain document types.
*  Fixes an issue that could move the scroll view for keyboard events that were not inside the scroll view.
*  Small localization updates.

__v3.6.2 - 21/Mar/2014__

*  Improves appearance customization options for the new `PSPDFFlexibleAnnotationToolbar`.
*  The new `PSPDFFlexibleAnnotationToolbar` is easier to customize and also has an `additionalButtons` property to add custom actions.
*  Makes sure the `PSPDFFlexibleAnnotationToolbar` is always removed from the view hierarchy as the `PSPDFViewController` disappears.
*  The `PSPDFGallery` now better deals with custom quality properties for YouTube videos.
*  Ensures that the status bar doesn't change on iOS 7 with view controller based status bar appearance enabled when the `PSPDFStatusHUD` is displayed.
*  Improves the XFDF writer/parser to deal with more action types (`PSPDFRenditionAction`, `PSPDFRichMediaExecuteAction`, `PSPDFSubmitFormAction`, `PSPDFResetFormAction`, `PSPDFHideAction`).
*  Improves popover positioning logic, especially for the search popover.
*  Improves stability when using the new container annotation provider class.
*  API: Removes `aspectRatioEqual` and `aspectRatioVariance` from `PSPDFDocument`. Other performance improvements made this option no longer useful.
*  API: Clarifies usage of the `PSPDFGalleryViewController` by renaming the `allowFullscreen` property to `displayModeUserInteractionEnabled`.
*  Fixes a potential issue with an over-release of NSError when printing a single page with PSPDFKit Viewer.
*  Fixes a stability issue when serializing annotations for certain PDF AcroForm buttons with icons in the appearance characteristics dictionary.
*  Fixes an issue where changing the page via the annotation table view controller could end up on a page that wasn't correctly centered.
*  Fixes a small selection issue with handling multiple equal grouped annotations on the same page.

__v3.6.1 - 17/Mar/2014__

*  Before a document is saved, we now set the annotation state mode to nil, which commits any open annotations like inks.
*  Reverted the use of @import with modules. Apple's module feature seems to have issues with projects that also use C++.
*  Fixes an issue with saving annotations in certain PDFs with corrupted page IDs.

__v3.6.0 - 16/Mar/2014__

We're proud to ship the next milestone of PSPDFKit. Version 3.6 features a completely new annotation toolbar, search within annotation text, note annotations that show up in the thumbnails and countless other improvements.
This release has been fully tested with Xcode 5.1 and iOS 7.1. We now require at least Xcode 5.0.2 and SDK 7 to compile and have dropped support for Xcode 4.6 (Apple no longer accepts apps built with SDK 6/Xcode 4.6)
Applications built with PSPDFKit will still run and work great under iOS 6.

*  Fully compatible and tested with iOS 7.1 and Xcode 5.1.
*  God dag! We've added Swedish to the list of presupplied localization files.
*  All-new flexible annotation toolbar (`PSPDFFlexibleAnnotationToolbar`) that can be dragged to be vertical or horizontal.
   See `PSPDFAnnotationToolbarType` in the `PSPDFAnnotationBarButtonItem` to optionally keep using the old annotation toolbar.
*  PSPDFKit Complete can now create digital signatures. This feature is still in beta - we need more documents to test all possible conditions.
   If you're having issues with this, please contact us so we can further increase the test coverage.
*  Text selection now supports text-to-speech on iOS 7+. See `PSPDFSpeechSynthesizer` for details and options to customize the language.
*  Forms on iPhone/iOS 7 now have an automatic zoom feature that makes it a lot easier to enter text.
*  Search now also includes annotation and form element contents. This is especially useful for note annotations and forms. (PSPDFKit Basic/Complete)
*  Search results are now hidden on page tap (unless that tap finds an action like selecting an annotation.)
*  Note annotations are now always rendererd at the same size and also visible in the thumbnails.
*  PDF annotation writing will now be faster and produce a more compact trailer, reducing target file size.
*  Adds support for mailto: links with multiple email addresses (also for CC and BCC).
*  Saving will now use the correct z-index for annotations and forms in the same ordering as they are added. Saving changed objects will no longer change the z-ordering.
*  Simple JavaScript actions like printing, alert boxes or adding form values now work. If you have a use case for that, please contact us at support@pspdfkit.com.
*  The XFDF parser now parses basic rich text strings as used in Acrobat and keeps color and font informations.
*  Increases contrast for the selection color on form choice list-boxes.
*  `PSPDFTextSelectionView` now allows UIAppearance to customize `selectionColor` and `selectionAlpha`.
*  The `PSPDFActivityViewController` now checks if printing is allowed for the document before even showing the print option.
*  No longer ends the text view edit mode when zooming on iOS 7 (flat mode) and above.
*  File annotations are now evaluated lazily, which improves startup performance for documents with many such annotations.
*  Note annotations now also create popup annotation on PDF saving. These are optional but increase compatibility with certain less standard-compliant 3rd-party software.
*  The behavior of the pdfViewController:didTapOnPage:View:atPoint: has been updated when no `PSPDFPageView` was hit to return nil here, and coordinates relative to the current PSPDFViewController.
*  The `PSPDFThumbnailBar` has a new parameter to optionally enable the page labels: `showPageLabels` (defaults to NO).
*  Many improvements related to PDF AcroForm handling and input validation.
*  Calls to `didHidePageView:` and `didShowPageView:` of views with the `PSPDFAnnotationViewProtocol` are now properly balanced.
*  The text parser now has a more sophisticated text shadow/overlay detection, which improves search results by removing duplicated glyphs.
*  The gallery has a new mode that enables live-blur behind the content (see `blurEnabled` on `PSPDFGalleryViewController`).
*  Fixes an issue where the popover might open at an unexpected location when using the inline multimedia system with the popover:true parameter.
*  Font annotations are now rendered with their AP stream for greater document accuracy.
*  Annotations now support the additional action mouse up event.
*  Greatly improves speed for the XFDF image deserialization process.
*  API: PSPDFKit now requires the Accelerate.framework. If you're using the PSPDFKit.xcconfig file, you don't need to change anything.
*  API: Search related methods are now in the new `searchHighlightViewManager` property of `PSPDFViewController.`
*  API: The HUD and related views have been reorganized. You might have to update some calls (some views are now within `HUDView`)
*  API: `PSPDFProgressHUD` has been replaced with the all-new `PSPDFStatusHUD`, which features a modern iOS 7 design and an improved API.
*  API: `PSPDFDocument` should be treated as an immutable object (apart from settings). Thus, the `files` and `fileURL` properties have been made readonly, and `appendFile:` has been removed. Create a new document with the new files/data objects instead. Use the new helper `documentByAppendingObjects:` to create a modified document with a new file or data objects.
*  API: The `PSPDFAnnotationManager` now supports various protocol strings, thus the property `protocolString` has been renamed to `protocolStrings` and is now an NSArray that takes NSStrings. We've added `embed://` as a second, neutral protocol format.
*  API: The `textSearch` class has been moved from PSPDFDocument to PSPDFViewController.
*  API: `PSPDFNoteAnnotationViewFixedSize` has been removed. Notes are now drawn with a fixed size, however you can define the bounding box to whatever you like. We recommend using 32px, but this value is being ignored by both PSPDFKit and Adobe Acrobat. Other, less capable renderers like Apple Preview.app might use the value, so 32px is a good value - but also depends how large or small your document is.
*  API: The `PSPDFSignatureViewController` no longer dismisses itself. Dismiss the controller in the delegate callbacks.
*  API: Code and subclassing hooks that could be used to change the `PSPDFScrobbleBar` frame have been moved to `PSPDFHUDView`.
*  API: Removes various deprecated code.
*  Fixes an issue related to YouTube video parsing - now compatible with even more video subtypes.
*  Fixes a weird scrolling behavior for some form elements.
*  Fixes an issue where the free text tool wouldn't work if highlighting was selected before that.
*  Fixes an issue where PDF form values could become corrupted because of insufficient escaping in some PDF files.
*  Fixes an issue where drawings could be created on multiple pages if the page is changed while in drawing mode.
*  Fixes multiple issues related to forms on rotated pages.
*  Fixes an issue related to annotation fetching and the `pageRange` feature of `PSPDFDocument`.
*  Fixes multiple issues related to the ink eraser.

__v3.5.2 - 21/Feb/2014__

*  `PSPDFYouTubeAnnotationView` has been removed in favor of the newer `PSPDFGallery`. Te gallery is a much better user experience for embedding YouTube videos.
*  Adds a workaround to prevent unwanted `UIPopoverController` animations that might appear under certain conditions on iOS 7.0.
*  New property `highlightColor` on `PSPDFPageView` to control the color used for link/form touch feedback.
*  Improves reload behavior with an external animation block.
*  The play button for the `PSPDFGallery` is now always white and configurable via `UIAppearance`.
*  Improves fade animation of the page label under iOS 7, especially for the new blur-page label setting on iOS 7.
*  The `PSPDFDocumentPickerController` now uses a dynamic size when displayed as a popover.
*  Various smaller impovements related to the new sidebar example in PSPDFCatalog.
*  `defaultColorOptionsForAnnotationType` now returns an NSArray of string, color tuples.
*  Allows to use UIAppearance to change the default search view highlight color.
*  The note popover now will be dismissed on tap if the annotation state manager is used for highlight mode, just as it does when using the annotation toolbar.
*  The `allowsCopying` property in `PSPDFDocument` no longer controls if the "Copy" option for annotations is displayed. This property only controls text.
*  Makes sure that the ink width while drawing and rotating is always the correct one.
*  API: `padding` of `PSPDFViewController` is now of type `UIEdgeInsets` and also works with `PSPDFPageTransitionScrollContinuous`.
*  Stamps now more closely resemble the look of Adobe Acrobat.
*  Improves content type detection in the gallery.
*  Various localization improvements.
*  The XFDF parser can now write images within appearance streams to Adobe Acrobat.
*  Fixes an issue where the text rect could be CGRectZero if the `shouldSelectText:` delegete was not set.
*  Fixes an positioning issue related to custom scopes in `PSPDFSearchViewController`.
*  Fixes an issue where the `PSPDFMultiDocumentViewController` would not work as expected if the delegate was not set.
*  Fixes an issue where the `PSPDFMultiDocumentViewController` would only show the thumbnails for the first document.
*  Fixes a stability issue related to the "Clear All" feature and the XFDF annotation provider.

__v3.5.1 - 15/Feb/2014__

*  New property in the `PSPDFStyleManager` to control if changes to annotations should be saved as the new defaults: `shouldUpdateDefaultsForAnnotationChanges`.
*  Expose `cornerRadius` in `PSPDFResizableView` to customize the border appearance.
*  Behavior Change: Setting the `annotationSaveMode` to `PSPDFAnnotationSaveModeDisabled` will no longer disable annotation editing features. To disable annotation editing, set the `editableAnnotationTypes` property of the `PSPDFDocument` to nil instead.
*  Adds a new delegate "pdfDocument:provider:shouldSaveAnnotations:" to allow a more fine-grained control over the saving process.
*  No longer removes unknown views from `PSPDFPageView`. Use `prepareForReuse` to manually clean up if you subclass `PSPDFPageView`.
*  Improves compatibility with embedded PDF files.
*  Ensures that document metadata is preserved after writing annotations or forms.
*  Improves compatibility with annotation or form writing for certain less commonly used PDF subformats.
*  Improves several UI details for iOS 7 legacy mode. (`UIUseLegacyUI` or compiled with SDK 6. This mode is not recommended, but will work.)
*  The `PSPDFGallery` can now display YouTube videos. This will most likely replace `PSPDFYouTubeAnnotationView` in future versions.
*  The XFDF parser can now load images within appearance streams from Adobe Acrobat.
*  Fixes an issue on iOS 6 where the gradient background for the page position label could be too small.
*  Fixes a stability issue on iOS 6 related to `PSPDFBarButtonItem` tint color updating.
*  Fixes an issue that prevented to hide the thumbnail bar in `PSPDFThumbnailBarModeScrollable` unless `PSPDFHUDViewAnimationSlide` was also set.
*  Fixes some tiny memory leaks on error situations.
*  Fixes an issue related to re-using `PSPDFSearchViewController`. Thos only happend in custom code, as PSPDFKit recreates this controller as needed.
*  Fixes an issue where subclasses of `PSPDFFileAnnotationProvider` could encounter immutable objects where mutable objects were expected.
*  Fixes a stability issue related to autodetecting link types.
*  Fixes an issue related to exporting apperance streams via XFDF.
*  Fixes an issue where image stamp annotations in rotated documents could have an incorrect transform applied when saved via `PSPDFProcessor`.

__v3.5.0 - 10/Feb/2014__

*  API: The `PSPDFAnnotationToolbar` has been modularized and all state related code is now in `PSPDFAnnotationStateManager`, which is a property of `PSPDFViewController`.
   You might have to update your subclasses to reflect these changes. `PSPDFAnnotationStateManager` should now be used instead of a headless `PSPDFAnnotationToolbar` if you have your own toolbar.
*  New unified setBoundingBox:transform: method on `PSPDFAnnotation`. Adds a helper that transforms the font size on resizing.
*  The Inspector is now sticky and will update itself for the new annotation if one is tapped while the inspector is visible. This simplifies editing and saves some taps.
*  Various smaller animation tweaks.
*  The `PSPDFGallery` now shows the already fetched parts of a video in the progress bar.
*  Bookmarks now use the pageLabel, if one exists, instead of the logical page number.
*  Embedding YouTube objects now support parameters in the URLs.
*  Better handling of exporting annotations into rotated PDF pages via `PSPDFProcessor`.
*  Impoves several cases where phone numbers were not correctly detected before. (`PSPDFTextCheckingTypePhoneNumber`)
*  Correctly displays border for forms that define the border color in the MK dictionary.
*  Adds initial support for text field form validation. (Currently, `AFNumber_Format` is supported.)
*  Adds limited support for drawing rich (formatted) free text annotations on iOS 7. Editing will convert them into plain text annotations.
*  Greatly improves XFDF support for complex PDF Forms, now better matches the output of Acrobat.
*  Fixes an issue that could reset the ink annotation width to 1.
*  Fixes a crash when processing certain sound annotations using PSPDFProcessor.
*  Fixes an issue where tapping into the page when the half modal controller on iPhone was visible could result in a different selected annotation than tapped.
*  Fixes an issue that didn't correctly update the thumbnails when bookmarks were added/removed while displaying the grid.
*  Fixes an issue that could show the signature selector controller when adding the first signature on iPhone only.
*  Fixes an issue where the document label could be visible even though documentLabelEnabled was set to NO.

__v3.4.6 - 1/Feb/2014__

This patch release includes various form related improvements, especially hardware keyboard support and performance tweaks for very complex forms.

*  Tap-to-zoom now starts rendering the page instantly; this improves render performance quite a bit.
*  Visual improvements for the form choice view controller.
*  Multiline Form Text Fields are now vertically aligned to the top.
*  Editable choice form elements now show touch down feedback and keep the keyboard for easier switching on iPad.
*  Long-Pressing on form elements will no longer cancel the tap action.
*  Form elements can now be navigated with a hardware keyboard via the arrow keys and escape/space/enter. (iOS 7 only)
*  Form navigation with prev/next now includes choice form elements, and the value can be toggle with the space bar.
*  Ensures that stamps never draw text outside their boundaries.
*  Render/Update performance for pages with many annotations has been greatly improved.
*  When using the `PSPDFAnnotationTableViewController`, form elements are not only selected but also brought into edit mode.
*  Improves support for file:// links if linkAction is not set to PSPDFLinkActionInlineBrowser.
*  Tweaks link type autodetection to work better on certain types of documents.
*  Expose the completion handler for `UIActivityViewController` inside `PSPDFActivityBarButtonItem`.
*  API: Remove long press support for bar button items. This was only used for the bookmark button and already defaulted to NO.
*  `PSPDFPageView` now sends a `PSPDFPageViewSelectedAnnotationsDidChangeNotification` notification each time the `selectedAnnotations` property changes.
*  Erasing is now faster with custom annotation providers, as cange notifications are now queued and sent on touch end events only.
*  Fixes an issue that could hide the outline bar button in cases where annotations were in the document but no outline.
*  Fixes a potential use-after-free when a form with a editable choice field was edited on iPhone and then dismissed via the input accessory view on iOS 7.
*  Fixes an issue where certain form checkboxes were not checked if appearance streams were missing from the PDF.
*  Fixes an issue where form buttons with named actions sometimes failed to change the page.
*  Fixes an issue where saving certain form objects could hide these form objects in Acrobat.
*  Fixes an issue where manual bookmark reordering wasn't saved in some situations.
*  Fixes a rare recursion issue on iOS 6 when using the old toggle-style for the viewMode bar button item.
*  Fixes an issue where the bookmark bar button not always reflected the actual bookmark state.
*  Fixes a potential over-release with certain rarely used CMaps definitions that include other CMaps.

__v3.4.5 - 24/Jan/2014__

*  Better handles resizing for rotated stamps.
*  The Open In... activity is now displayed for NSData-based documents.
*  Improve availability filtering for the `PSPDFOutlineBarButtonItem`, no longer presents an empty controller if no content is available.
*  Small localization updates.
*  Improve XFDF action writing for non-standard types like GoToR.
*  Improvements to word/new line detection in the text parser for certain documents.
*  Improves rendering performance, expecially for more complex PDF forms.
*  Form updates are now more snappy and no longer animate.
*  Various smaller improvements for the inline web view. (`PSPDFWebAnnotationView`)
*  Fixes an issue where annotations could end up at a different location when rotated documents were re-saved using `PSPDFProcessor`.
*  Fixes an issue where `viewControllers` of the `PSPDFContainerViewController` could return nil.
*  Fixes an issue where annotations saved via `PSPDFProcessor` could end up on a different page.
*  Fixes an issue where the target page of a document/page action sometimes wasn't correctly saved when using the XFDF format.

__v3.4.4 - 22/Jan/2014__

*  Add support for Embedded PDF Files (see http://blogs.adobe.com/insidepdf/2010/11/pdf-file-attachments.html)
*  The `PSPDFGallery` now shows an AirPlay button if AirPlay sources are available.
*  Stamp annotations no longer have disorted text.
*  Update OpenSSL to OpenSSL 1.0.1f.
*  Forms: Checkboxes with the same name and parent form a mutually exclusive group.
*  `zoomToRect:page:animated:` now honors the `animated` option and compensates for the x/y origin depending on the scroll direction for `PSPDFPageTransitionScrollContinuous`.
*  Fixes an regression in the annotation toolbar related to tap handling.
*  Fixes an issue where the `PSPDFOutlineViewController` could display stale data if the outline is complex and documents are switched before the outline parsing operation was done. This basically only happened if the controller was displayed as a side-bar, not when in a popover or modal.

__v3.4.3 - 21/Jan/2014__

*  Code updated to be warning-free with iOS 7.1b4 and Xcode 5.1b4.
*  Extracted all possible `PSPDFMenuItem` identifiers to `PSPDFPageView`.
*  `PSPDFProcessor`'s `generatePDFFromURL:` and `generatePDFFromHTMLString:` methods now support embedding annotations if set via the options dictionary.
*  `PSPDFMultiDocumentViewController` no longer tries to persist NSData- or CGDataProviderRef-based documents. Only file-based documents are persisted between sessions.
*  Improves search animation for the `PSPDFOutlineViewController`.
*  Various small localization updates.
*  API: `PSPDFProcessor`'s generatePDFFromHTMLString: methods have gained a new error parameter.
*  API: `PSPDFAESDecryptor`'s init methods have gained a new error parameter.
*  Fixes a regression where two-finger-scrolling in hightlight mode no longer worked.
*  Fixes a rare timing issue where a mutation error could be thrown if reloadData is called within page loading delegate methods.
*  Fixes an issue where exported annotation via the share sheet could end up on different pages if a document with multiple provider sources is used.

__v3.4.2 - 19/Jan/2014__

*  Improved defaults for the status bar and the activity controller.
*  The document and page label now use blur on iOS 7.
*  Full-page-ads with links now no longer highlight the whole page.
*  The bookmark activity now shows the current bookmarked state.
*  The thumbnail cells use the active tintColor on iOS 7 as their selection border color.
*  New property to control if the HUD should be visible on viewWillAppear. (`shouldShowHUDOnViewWillAppear:`)
*  Slightly darker default background for the `PSPDFViewController` on iOS 7.
*  Fixes an regression with the loupe view and UIInterfaceOrientationLandscapeLeft.
*  Fixes an issue where annotations could be missing when exporting single pages that are backed by XFDF via email.
*  Fixes an issue where the internal web browser wasn't correctly dismissed when an App Store link was detected.
*  Fixes an issue where the contentInset could become too large when using the `PSPDFStampViewController`.

__v3.4.1 - 18/Jan/2014__

*  Fixes an issue with UIActivityViewController on iOS 7.1b3.

__v3.4.0 - 18/Jan/2014__

*  The `PSPDFVideoAnnotationView` has been completely removed as the new `PSPDFGallery` takes over all of this functionality.
   PSPDFKit finally allows to play multiple videos and/or audio at the same time. (The total number of concurrent video streams is hardware dependent and is usually 4)
*  Ink annotations can now be merged via the multiselect tool. This will discard all different styles and use the style of the first object if used.
*  Various annotation changes and page updates are now animated (most visible when using undo/redo).
*  Various improvements and fixes for PDF Forms.
*  Improves the activity bar button item, actions will forward to the bar button items if possible.
*  The annotation toolbar will now attempt to merge highlights if they overlay each other and have the same color.
*  Improves hit testing for smaller annotation types like note annotations.
*  The `PSPDFPrintBarButtonItem` now uses the `PSPDFDocumentSharingViewController` to make it consistent with the Email and Open In action and thus has also new option parameters. (API-Change). This now allows printing the annotation summary.
*  The annotation summary now generates an attributed string when printing or sending via email.
*  Add `PSPDFAnnotationIgnoreNoteIndicatorIconKey` to optionally disable the note indicator rendering.
*  Improves support for links to different documents via URI action type.
*  Adding a signature will now make it smaller and more appropriate for large documents.
*  The `PSPDFSignatureSelectorViewController` is now stateful, has a minimum size and will show "No Signatures" if the last signature was deleted while being open.
*  The use of the outline in the search preview is now configurable via `useOutlineForPageNames` in the `PSPDFSearchViewController`. It defaults to YES.
*  New iPhone popover controller that better fits into iOS 7.
*  The annotation type image in the annotation table view is now colored in the same color as the annotation itself.
*  Adds a workaround for an issue where iOS would change the status bar when showing an UIAlertView without setting it back to the previous setting.
*  Exposes `filteredPagesForType:` to customize what the thumbnail controller displays, and increases the touch target of the thumbnail filter.
*  Fixes an issue when certain annotation types were manually overridden to be displayed as overlay, they could be initially visible until moved on page load.
*  Fixes an UI regression where the `PSPDFProgressHUD` would be rotated wrongly on device rotation.
*  Fixes an issue where YouTube videos were no longer being paused automatically in iOS 7 when in thumbnail mode.
*  Fixes a timing issue when multiple galleries were loaded at a page on the same time.
*  Fixes an issue in `PSPDFTabbedViewController` that could move pages off center when using iOS 7 when the HUD fades out.
*  Fixes an issue with embedding forms into documents with a invalid trailer ID.
*  Fixes an issue where dismissing the half-modal form choice picker could dismiss the current view controller on the iPhone.
*  Fixes an issue with extracting font glyph rect data, especially for CJK documents that use 'usecmap' to link to other CMaps.
*  Fixes a potential assertion in the text parser with certain malformed PDF documents that have invalid font descriptors.
   PSPDFKit will now try to extract as much as possible and not assert, even if the document is partly broken or contains invalid descriptors or font references.

__v3.3.5 - 9/Jan/2014__

*  The gallery now supports more options like autostart, cover views or control customizations.
*  Improved the `highlightedString` feature by narrowing down the target rect. Reduces the chance to extract text above/below the marked text.
*  The render activity view now has a slight delay and animates in and out, making it less disruptive.
*  Extends support for iOS 7 dynamic type to more controls and cells.
*  Localization has been streamlined and requires less entries. If you rely in a specific `identifier` for `PSPDFMenuItem` checks, remove the "..." from the strings.
*  The option view in `PSPDFNoteAnnotationViewController` now uses blur on iOS 7 instead of plain transparency.
*  Adds further workarounds for issues in `UITextView` on iOS 7 which improves caret scrolling and visibility when using external keyboards.
*  The "Clear All" action on `PSPDFAnnotationTableViewController` is now a single undo step instead of one per annotation.
*  Fixes an issue where the redo action of the `PSPDFAnnotationToolbar` would always prefer drawing redos, potentially preferring the wrong actions first.
*  Fixes an issue that blocked moving annotations if they are above a form field.
*  Fixes an issue that could select the wrong annotations when sending a single extracted page from a document via email.

__v3.3.4 - 7/Jan/2014__

*  The annotation table view has been redesigned and also shows the creation user and the last modification date, if available.
*  New property: `skipMenuForNoteAnnotationsOnIPad` to control how the note controller is displayed.
*  Update selection style for the saved annotation cells to better match the iOS 7 design.
*  Improves logic for popover resizing of the container controller.
*  Various tweaks to the stamp controller and the text stamp controller. Now adds default date stamps, automatically shows keyboard once the `PSPDFTextStampViewController` appears and more.
*  Various localization updates, including localization for stamps.
*  The `localizedDescription` for PDF Form Fields is now smarter and won't create strings like Button: Button.
*  The `PSPDFAnnotationToolbar` has a new `backButtonItem` hook to replace the default "Done" back button.
*  Some more icon tweaks: delete now better fits into the iOS 7 `UIMenuController` and sound now is a microphone instead of a note.
*  Fixes an issue with saving custom pspdfkit:// prefixed links via the XFDF provider.

__v3.3.3 - 6/Jan/2014__

*  Re-enables the Clear button in the new `PSPDFFreeTextAccessoryView` after text has been changed.
*  Don't show the ".pdf" file ending in the `PSPDFDocumentPickerController`.
*  The inspector now repositions itself if the annotation changes the `boundingBox`.
*  Saving annotations into the PDF has been optimized and creates a smaller PDF.
*  Form objects no longer are deletable when using the `PSPDFAnnotationTableViewController` but will be cleared instead.
*  API: Removed PSPDFInitialAnnotationLoadDelay. This is no longer a performance problem and has thus been removed and optimized.
*  Improves styling in `PSPDFWebViewController` for iOS 6 when the navigation bar style is dark.
*  The activity button in `PSPDFWebViewController` is now always enabled, not only after the page finished loading.
*  `PSPDFWebViewController` now offers to load the page in Google Chrome, if installed.
*  Fixes an UI issue where the document title label could be offset under iOS 7/iPhone if the HUD was hidden when a modal VC is invoked.
*  Fixes an issue that prevented forms from saving correctly when saved via the Send via Email/Open In feature from a readonly source. 
*  Fixes multiple issues with building/preserving the appearance string for certain PDF form elements.

__v3.3.2 - 4/Jan/2014__

*  Adds new accessory view for free text annotations to quickly access the inspector.
*  The font size in `PSPDFNoteAnnotationViewController` now adapts to iOS 7 content size.
*  The gradient calculation used in `PSPDFNoteAnnotationViewController` now simply returns a default yellow if the base is white.
*  The delete note icon in `PSPDFNoteAnnotationViewController` is now dynamically enabled/disabled depending if there's text in the `UITextView`.
*  Improves the animation and various design details in `PSPDFSearchViewController`, especially on iOS 7.
*  Improves the annotation summary to now repeat type and description if that's the same. (Ink, Ink)
*  Various smaller design updates for the annotation inspector.
*  API Update: `generatePDFFromDocument:` now accepts `pageRanges` as NSArray, which allows to easily re-order document pages (compared to a single NSIndexSet)
*  Fixes an UI issue where the text view wouldn't properly adapt in `PSPDFNoteAnnotationViewController` on iPhone.
*  Fixes an UI issue where the "No Bookmarks" label could be not exactly centered on first load.
*  Fixes an issue where the annotation bar button item would be disabled with `PSPDFAnnotationSaveModeExternalFile`.
*  Fixes an issue where the document sharing controller would sometimes not extract pages out of the PDF if only a subset of the pages are selected.
*  Fixes an issue where wrong options could end up being used if `PSPDFDocumentSharingViewController` was preconfigured so it is invoked without showing the UI.

__v3.3.1 - 2/Jan/2014__

*  PSPDFKit now displays note indicators for annotations with note content.
*  Annotations that can't be erased are no longer hidden while in erase mode.
*  The view controller order in `PSPDFOutlineBarButtonItem` and in `PSPDFThumbnailViewController` has been changed - bookmark is now the last entry.
*  PSPDFSearchViewController now has support for custom scopes with a new optional delegate method.
*  On iOS 7 we now support `shouldAutomaticallyAdjustScrollViewInsets` with `PSPDFPageTransitionScrollContinuous` & `PSPDFScrollDirectionVertical`.
*  The scroll-to-top feature when the status bar is tapped no longer breaks when showing/hiding the thumbnail controller.
*  Fixes an issue with glyph position calculation for certain rotated documents that had a non-nil origin.
*  Fixes an issue that prevented linking the precompiled PSPDFKit.framework with Xcode 4.6.
*  Fixes a timing issue where the annotation menu wasn't always displayed wen selecting an annotation via the `PSPDFAnnotationTableViewController` on iPhone.
*  Fixes a small issue where the `PSPDFNoteAnnotationViewController` could fail to show the keyboard when presented manually with a certain timing.
*  Fixes an issue that could have kept a total 1-2 instances of `PSPDFPageView` around, even when the `PSPDFViewController` was deallocated.
*  Fixes a potential retain cycle in the `PSPDFDocumentSharingViewController` on iOS 7.

__v3.3.0 - 29/Dec/2013__

Happy holidays!

PSPDFKit now requires iOS 6+ and Xcode 5. Keep using PSPDFKit 3.2.x if you're still building with Xcode 4.6 or need to support iOS 5.
Apple will enforce usage of Xcode 5 starting February 1st. (https://developer.apple.com/news/index.php?id=12172013a)
Removing iOS 5 resulted in deleting almost 10.000 lines of code - which will give you a smaller, faster and more efficient binary.

The binary is now again fully universal including armv7, armv7s, arm64, i386 and x86_64.
The separate iOS 7 only (64 bit) library variant has been removed.

PSPDFKit Complete now supports PDF form signature validation and thus links with OpenSSL.
There is an optional build without OpenSSL that disables these cryptographic signature checks.

*  Localization! PSPDFKit now ships with English, Chinese, Korean, Japanese, French, Spanish, Russian, Italian, Danish, German, Portuguese and Brazilian Portuguese.
*  Adds preliminary compatibility with Xcode 5.1 and iOS 7.1b2.
*  Refreshed visuals for both iOS 6 and iOS 7. The icons are now much more polished and can be better customized.
   The remaining icons that were drawn in code are now all inside the PSPDFKit.bundle.
*  PSPDFKit Complete/Enterprise can now validate cryptographic signatures (unless you use the build without OpenSSL)
*  `PSPDFAESCryptoDataProvider` now supports the popular RNCryptor data format: https://github.com/rnapier/RNCryptor/wiki/Data-Format (It autodetects the legacy format and supports that as well)
*  Finally fully suppports the new `UIViewControllerBasedStatusBarAppearance`. (we now support both modes in iOS 7)
*  The `PSPDFAnnotationToolbar` now displays the style picker for text markup annotations (highlights).
*  The `PSPDFGalleryViewController` now supports local/remote video and audio files next to images.
*  The internal `PSPDFWebViewController` now shows a progress bar, much like Safari on iOS 7.
*  Improves automatic font resizing for single line text field form entries.
*  Improved support for `additionalActions` and `nextAction` to add actions to all annotation types.
*  API Change: `PSPDFTextSelectionMenuActionWikipediaAsFallback` has been renamed to `PSPDFTextSelectionMenuActionWikipedia`. Since checking for a word in `UIReferenceLibraryViewController` can be unpredictably slow as of iOS 7.0.3, we had to remove this feature. `Define` will now always be displayed and you can optionally enable Wikipedia as well. The new default will omit Wikipedia by default.
*  Don't show the `PSPDFWebViewController` bottom toolbar on iPhone if there are no `availableActions` defined.
*  Allow detection for a PSPDFKit signature and blocks the "Copy" feature if detected. Will also be saved into the PDF as proprietary extension.
*  If there's no signature saved and customer signature is disabled, we'll show the new signature controller instantly.
*  Adds a new property: `shouldCacheThumbnails` to supress thumbnail cache generation.
*  Adds a new property: `shouldHideHUDOnPageChange` to fine-tine when the HUD is hidden.
*  Highlight etc is no longer offered on text selection if the document can't be saved.
*  Improves Form Element description in the annotation table view.
*  Allow "Clear Field" for Choice Form Elements with editable text.
*  Improve support for hidden form elements or choices that are neither editable nor have options.
*  Add hitTestRectForPoint: on `PSPDFPageView` that allows to customize the rect that is used for tap hit testing to select annotations.
*  Make document parsing more robust to allow dealing with files that have incorrect XRef tables.
*  The text selection handles now have the proper hit test size when zoomed in - improves your ability to interact with other content.
*  YouTube: Add support for http://youtu.be short-form URLs for embedding.
*  The note icon name is now properly serialized when using the XFDF annotation provider.
*  The XFDF provider now only saves if an annotation is changed. Deserialized annotations are set to be not dirty by default now.
*  Annotation and outline classes have been optimized to require less memory and reuse more objects internally.
*  Lots of code cleaning, improved documentation and some reorganization. The binary is now smaller and compiles faster.
*  Moves document parsing to a background thread, improves initial startup time for complex, large documents.
*  GoToR actions with target named destinations are now supported.
*  FreeText annotations are now correctly rendered and displayed even when their bounding box is too small for the text.
*  Audio recordings can now be time limited and the default encoding/bitrate can be customized in `PSPDFAudioHelper`.
*  The default set of stamps is now localizable and localized by default.
*  The Edit button in the annotation table view controller and the bookmark controller is now only enabled if there is content, and edit mode is automatically disabled when there's no more content.
*  Improved touch handling when resizing/moving annotations.
*  Fixes an UX issue that wouldn't deselect the current toolbar state if a saved signature is added via the annotation toolbar while `customerSignatureFeatureEnabled` is disabled in the signature store.
*  Page scroll animations are reduced to allow faster navigation.
*  Annotation overlay views are now loaded and added to the view hierarchy as soon as the page is set up, removing the previous delay that was especially noticeable with note annotations.
*  No longer shows the bounding box when selecting/resizing line annotations.
*  The undo/redo stack is now consolidated - no more difference or disabled undo while in drawing mode.
*  Properly coordinate print controller popover to close when other popovers are activated.
*  Use blurry background for UIPopoverController in the stamp section.
*  The annotation creation menu now only shows the most important annotation types; customize via `createAnnotationMenuTypes` in the `PSPDFViewController`.
*  Removes the IDNSDK to get a smaller binary.
*  When saving text form elements, the AP stream is now included in the PDF. This fixes issues with Acrobat where the content would only be visible when the text field is active.
*  Fixes a rare crash in (poly)line point calculation if the points are on top of each other.
*  Fixes an edge case where the text field would loose focus after the note annotation controller has been dismissed because of tapping into another text field.
*  Fixes a regression where the selected annotation for multiple potentials was reversed.
*  Fixes an issue where annotations with appearance stream could be rendered at the wrong position and/or size.
*  Fixes an issue where annotations could be returned from the last page when forms are in the document, even if a different page was requested.
*  Fixes an issue with the label parser when encountering offset pages.
*  Fixes an issue where when trying to copy a webpage link in the internal web browser, the system could throw a `NSInvalidArgumentException` if the link was nil.

__v3.2.3 - 28/Nov/2013__

*  Improves custom text stamp creation layout and fixes an issue where the text wasn't always displayed within the table view.
*  Form text fields are now no longer clipped when the zoom scale is very low.
*  Border on a form is now only rendered when defined so in the dictionary for widget/form annotations.
*  Signatures now use `PSPDFAnnotationStringSignature` as style key, instead of the `PSPDFAnnotationStringInk` that was used before.
*  Improves support with Microsoft Outlook by making sure we always send the .pdf file ending when sharing via email.
*  Any open menus will now be dismissed before PSPDFKit is presenting a popover. This fixes a behavior change in iOS 7 where `UIMenuController` sometimes stayed visible.
*  Choice form elements now have a click-through-able popover and are highlighted when active.
*  Next/Prev now works across multiple pages and also includes choice form elements.
*  The form highlightColor is now a property on PSPDFFormElement and thus configurable.
*  Works around a bug in iOS 7 where the UITextView wouldn't properly scroll to a new line when entering text in a PDF Form.
*  The `PSPDFOutlineViewController` now shows the empty state if the document has no outline set but the controller is still displayed.
*  Inproves compatibility with parsing invalid URLs in link actions - will correct more variants.
*  Fixes an issue where certain form choice elements with partial dictionaries could be incorrectly parsed/rendered.
*  Fixes an issue that could prevent form choice elements from being saved correctly back into the PDF.
*  Fixes a rare collection mutation regression when erase mode was active while annotation changes for visible inks were processed.
*  Fixes an issue where `allAnnotationsOfType:` sometimes could miss certain annotations when an internal save file was used.
*  Fixes an regression where `hasDirtyAnnotations` could report YES when we really don't have any unsaved changes.
*  Fixes some localizaton issues with line endings in the Inspector.

__v3.2.2 - 24/Nov/2013__

*  The gallery now allows image zooming when in full screen and requires less memory when loading remote images.
*  The gallery is now more customizable, allows custom background colors and recongnizes @2x images when they are local.
*  The `PSPDFDocumentSharingViewController` will now use a temporary directory to save annotations into the PDF if it's in a non-writable location.
*  The password view now automatically shows the keyboard.
*  If annotations can't be embedded, the new annotation menu will not be displayed anymore (to be consistent with the `PSPDFAnnotationBarButtonItem`)
*  The runtime now better deals with multiple annotation subclasses that both change the behavior of a parent class. Use `overrideClass:withClass:` on `PSPDFDocument` to register such subclasses.
*  Set the default ink line width to 3, unless a default is already set.
*  Using undo/redo while in eraser mode will now also allow adding/removing of ink annotations.
*  The undo system will now commit expired actions that are coalesced. This fixes an issue where certain actions would appear undo-able quite late (e.g. first erase action)
*  If the named destination of a link can't be resolved we will ignore the action and no longer scroll to page 0.
*  Improve selection contrast in the `PSPDFAnnotationToolbar`.
*  The `PSPDFSearchResult` class is now immutable and has a new initializer for creation.
*  `PSPDFSearchViewController` now supports iOS 7 dynamic font size and allows a multi-line text preview. The new default are two lines instead of one.
*  Various warning/error messages are now printed with the code location instead of a generic PSPDFError trace.
*  Annotation management now uses equality checks instead of memory-based checks, this makes the code more robust when objects are recreated in the annotation providers.
*  Text field form elements now resize as we are typing and better render multi-lined text.
*  PDF Signature Form elements are now tappable and will offer to add a ink annotation as signature.
*  API change: Renamed `showNewSignatureMenuAtPoint:animated:` with `showNewSignatureMenuAtRect:animated:`. Use a rect with size zero to get the previous behavior.
*  API: Some subclassing hooks that have been declared but weren't called have been properly removed.
*  Undo/Redo is disabled by default on old devices to improve performance. (Notably, the iPad 1 with iOS 5.)
*  Improves error handling for corrupt or missing PDFs.
*  Using the HSV color picker while brightness is set all the way to 0% (black) will do the smart thing to switch to the pure color with 100% brightness.
*  Fixes an issue where ink annotations could change position for PDF documents with non-nil origin points.
*  Fixes an issue where some text in form elements could render incorrectly when the page was rotated.
*  Fixes a potential recursion when parsing malformed documents.
*  Fixes an issue where `annotationsFromDetectingLinkTypes:` could throw an exception if a page returns nil as body text. (e.g. corrupt or password protected files)
*  Fixes an issue where the gallery component could throw an `UIViewControllerHierarchyInconsistency` when used in combination with `PSPDFPageTransitionCurl`.
*  Fixes an issue where we incorrectly detected a regular password protection as custom encryption filter.

__v3.2.1 - 13/Nov/2013__

*  Improved a few cases where the `PSPDFDocumentSharingViewController` was displayed with practially no options to choose.
*  Improves the thumbnail <-> page(s) animation so it even looks great when the thumbnail button is toggled really fast.
*  The `PSPDFNoteAnnotationViewController` no longer shows the 'copy' button by default, the toolbar looked too cramped.
*  Fixes an issue with UID generation when the document isn't inside the app bundle.
*  Fixes an issue where larger XFDF ink annotations could degrade when being parsed.
*  Fixes an issue where the initial call for `annotationsForPage:` in the `PSPDFXFDFAnnotationProvider` could return an empty array.
*  Fixes an issue with UIKit legacy mode and the `PSPDFAnnoationToolbar` in certain setups.
*  Fixes an issue where 'Finish Recording' on sound annotations wouldn't work if the recording was still active but currently paused.
*  Fixes an rare issue with writing annotations if inline UTF-16 (the special Adobe flavor) is used within the `/Pages` root object.
*  Titanium: Exposes `printOptions`, `sendOptions` and `openInOptions` from the corresponding `PSPDF*BarButtonItems`.

__v3.2.0 - 10/Nov/2013__

*  Lots of improvements around sound annotations! Serialization, better selection, context menus, customization.
*  `PSPDFAnnotationTableViewController`: Dynamically calculate cell height and show multiple lines of description per cell.
*  YouTube and Web views now automatically reload themselves when a reachability change is detected.
*  Long-Pressing on text markup will now allow text selection and not select the markup (highlight) annotation. This allows to sub-select text that is already selected in another way.
*  Greatly improves handling of (rotated) FreeText annotations and rotated pages.
*  The search bar is now attached to the top on iPhone, to better match iOS 7 style.
*  Rendered images are now more more likely to be cached to disk, resulting in less work overall.
*  Improves thumbnail scroll performance, especially on the iPad 1.
*  Improvements to the text parser, now can parse another category of documents that use Font Programs to define their glyphs.
*  Form Check Box Elements now render the AP stream by default and fall back to internal rendering if no stream was found.
*  Form background colors are now dynamically parsed and displayed instead of the default light blue.
*  Improves support for various Forms that define the form element across multiple objects.
*  Improves the touch-down-highlight for form elements.
*  Allows overriding of `PSPDFTextSelectionView`.
*  Improves text extraction for highlight annotations when there are multiple overlapping rects.
*  Fixes an issue where the text selection wasn't properly updated on rotation.
*  Fixes a potential deadlock when async saving was called manually while the view controller was popped from the screen which also invokes a save.
*  Fixes an issue where the tab controls of `PSPDFTabbedViewController` wouldn't respect the `minTabWidth` property.
*  Fixes an issue with rendering annotations with overlapping fill-areas in UIKit legacy mode.
*  Fixes an issue where certain `UIActionSheets` on iOS 6 could be mis-placed.
*  Fixes an issue with getting images for iOS 6 when the PSPDFKit.bundle is in a non-standard location.
*  Fixes a potential exception when a PDF contained an annotation with a malformed bounding box.
*  Fixes a potential exception when a free text annotation of size zero was created and subsequently edited.
*  Fixes an issue with saving annotation in certain documents that previously produced warnings.
*  Fixes a potential crash when loading annotations from the disk store while a save filter is active.
*  Fixes an issue where under rare conditions flattened notes could be rendered mirrored.
*  Fixes a rare condition where the cache could get into a state where it no longer pre-renders document pages.
*  Titanium: The plugin is now simply named `com.pspdfkit` (from `com.pspdfkit.source`)
*  Titanium: editableAnnotationTypes can now be set in `documentOptions`.

__v3.1.4 - 3/Nov/2013__

*  Improves rendering of line endings in the selected state.
*  Don't show an "external application" dialog if our own app responds to the URL scheme in question.
*  The PSPDFGallery can now better deal with a single image and will auto-generate the appropriate manifest if a PSPDFLinkAnnotation points to the image.
*  Allows overriding of PSPDFColorSelectionViewController from within the inspector.
*  Allows fine-tuning of the dictionary lookup via PSPDFTextSelectionView's new dictionaryHasDefinitionForTerm: method.
*  Enabling/Disabling the eraser feature no longer flickers the ink annotations.
*  The eraser now respects alpha settings of the ink annotations.
*  While erasing, Undo/Redo now work as expected.
*  Special-cased clearColor for the `fillColor` annotation property when using PSPDFStyleManager. (fill can't have alpha; so previously this would give you a black fill - now it's transparent)
*  Allow parsing for less common color definitions in appearance strings (k and g)
*  Forms: Don't draw background when we have an AP stream for form buttons.
*  Forms: Buttons that define an AP-Stream no longer also have a blue background.
*  Forms: Buttons(Check boxes, radio buttons) now show a touch-down state when tapping them.
*  Forms: No longer flickers when the element is delselected.
*  Fixes a potential crash in the selection view when we select a free text annotation with zero width.
*  Fixes an infinite loop when searching certain characters.

__v3.1.3 - 24/Oct/2013__

*  PSPDFKit now requires the CoreTelephony.framework (this will be added automatically if you use the PSPDFKit.xcconfig file)
*  The `autodetectTextLinkTypes` feature is now faster and will detect more types of phone numbers and URLs, including those that contain spaces/newlines between them.
*  Pressing the delete icon in the note annotation controller will only clear the note, except for note annotations where it will delete the whole annotation.
*  Adds a versioning system for PSPDFKit.bundle. Make sure you always use the bundle we ship with PSPDFKit.
*  Adds a boxRect:forPage:error: method to PSPDFDocument to easily get a different box rect for the defined page.
*  Gallery now supports animated GIFs and downloads images even when the app is in background.
*  Improves default header color for the mail view controller.
*  Fixes an issue where the bounding box for FreeText annotation could be too long when they are edited while zoomed in on iOS 7.
*  Fixes an issue where "Inspector..." was displayed for non-editable annotation types.
*  Fixes an issue where "Clear All" deleted all annotations, even those not displayed in the annotation table view.
*  Fixes an issue where flattened note annotations would sometimes be drawn rotated on rotated documents.
*  Fixes an issue where Free Text annotations added from the toolbar could end up being rotated on rotated documents.
*  Fixes a very rare over-release of a PSPDFPageView object when lots of PSPDFViewControllers are rapidly created/destroyed. (you should always reuse this heavyweight object)

__v3.1.2 - 21/Oct/2013__

*  Faster scrolling, new default page rendering strategy: `PSPDFPageRenderingModeThumbnailIfInMemoryThenFullPage`
*  Improves text selection drawing and text selection menu placing. The few cases where the menu could overlap the selection have been fixed.
*  Add more sophisticated warnings if the PSPDFKit.bundle is missing.
*  PSPDFViewController will now auto-save annotations when the view is dismissed while contained in a child view controller.
*  Add `verticalTextAlignment` to `PSPDFFreeTextAnnotation`. This is not defined in the PDF spec; so it will be a code-only option for now. PSPDFKit will save this into the PDF as a proprietary extension.
*  Fixes an issue with single page documents, forced two-page-mode and pageCurl.
*  Fixes an issue where under certain conditions the navigationBar was not displayed initially.

__v3.1.1 - 19/Oct/2013__

*  Restores compatibility when compiling with Xcode 4.6.
*  Various smaller improvements to the new image gallery.
*  Various smaller performance improvements, moved some more work off the main thread.
*  API cleanup for PSPDFDocumentProvider.
*  No longer blocks the UI when annotations are still loading during a touchDown event.
*  Fixes an UX issue where dismissing the activity popover in the web view controller via a touch on the dimming view sometimes required a second touch on the action button to re-show.
*  Fixes an issue when adding annotation views for invalid rects.

__v3.1.0 - 18/Oct/2013__

*  Brand-new image gallery (define a region in the pdf to be covered by a smooth gallery). Allows configuration via inline-pdf or external JSON.
*  Use menu-based annotation manipulation for text markup annotations.
*  The way how the document UID is generated has been changed. Previously, for files it used the full app path. However since the app UID could change after an upgrade, we had to change this behavior. This is only important if you used bookmarks or allowed annotations saving into the internal storage - not for embedded annotation data. Set the global variable `PSPDFUseLegacyUIDGenerationMethod` to YES to continue using the old path. Those files are in Library/PrivateDocuments. You might want to write a custom migration step to rename the custom data paths from the old UID to the new UID system. The `PSPDFUseLegacyUIDGenerationMethod` can be changed at any time to switch between old and new UID (generate a new PSPDFDocument instance to force UID regeneration).
*  The file-based annotation backing store by default no longer saves link annotations but instead merges the saved annotations and the links from the file. This improves performance for PDFs that have lots of internal links (our current way of saving starts to get slow once there are more than 10.000 objects). In most cases, you don't need to care and your save file will be migrated automatically. If you rely on custom link annotations being saved/deleted, you need to set the new `saveableTypes` property of the fileAnnotationProvider back to the old default `PSPDFAnnotationTypeAll`.
*  The undo/redo buttons are now updated immediately after adding annotations.
*  The interactivePopGesture (new on iOS 7) is now disabled while we're drawing to prevent accidential usage.
*  The PSPDFViewController will now properly clean up state from the annotation creation when dropped from user code while the toolbar is in drawing mode.
*  The outline controller now properly shows page destinations above page 10.000.
*  Hides a harmless log warning when PSPDFKit tried to render an annotation with an empty width/height.
*  When undo is disabled, the undo/redo buttons are now properly hidden when leaving the drawing mode.
*  No longer draws the arrow when flattening choice form elements.
*  Restores sound annotations that were added via the pspdfkit:// protocol.
*  Improves compatibility with UIViewControllerBasedStatusBarAppearance. (ongoing project, still not recommended.)
*  Greatly improves scrolling performance with large outline tables.
*  Fixes placement of the search bar in the outline controller.
*  Fixes a crash when pressing undo while adding free text annotations.
*  Fixes a call to a not implemented method in the file annotation provider when manually replacing annotations.
*  Fixes a crash in arm64 when parsing certain malformed PDF documents.
*  Fixes an issue where the password view wasn't correctly updated when the document was changed while it was displayed.
*  Fixes an issue where one could get stuck in the eraser mode when choosing it from the toolbar when that one was diplayed via the long-press annotation menu.
*  Fixes a timing issue where the text parsing could crash in rare cases.
*  Fixes an off-by-one error that could cut off long lists of ink points when parsing XFDF files.

__v3.0.11 - 10/Oct/2013__

*  Fixes another issue related to UISearchDisplayController and iOS 6/7.

__v3.0.10 - 10/Oct/2013__

*  The search contoller header is now sticky on iPhone (especially improves display on iOS 7)
*  Greatly improves text selection performance when a large number of glyphs is selected.
*  Improves eraser mode - faster, and no longer changes the view port when enabling/disabling.
*  Adds a new convenience method (sortedGlyphs:) when glyphs are manually selected in PSPDFTextSelectionView.
*  Improve various details in the XFDF writer.
*  Allow pspdfkit:// URLs within the PSPDFXFDFAnnotationProvider.
*  Remove confusing search controller animation when it's first presented on iOS 7.
*  Improves outline searching on iOS 7 / iPhone.
*  Various other smaller tweaks related to iOS 7.
*  Don't show the PSPDFDocumentSharingViewController if there are no options available.
*  Ensure the annotation style picker closes when the annotation mode changes.
*  Improves type detection when pspdfkit:// links are used within URLs that have query parameters.
*  Adds a workaround for documents with invalid /Pages structure which previously prevented annotation saving.
*  Add missing localizaton for "Choose Fill Color".
*  The text selection end handle is now prioritized, makes it easier to extend selection for small text.
*  Fixes an issue where changing the position of a note annotation could fail on the first try.
*  Fixes an issue with calling the didCreateDocumentProviderBlock for multiple files.
*  Fixes a 20-pixel offset in the annotation inspector on iPhone/iOS 7.
*  Fixes updating the thumbnail button state.
*  Fixes an issue when showing the annotation toolbar from the bottom.
*  Fixes an issue where popovers could have a width/height of 0 when presented from a bottom toolbar on iOS 7.
*  Fixes a crash on iOS 5 related to the font picker, rotation and early dismissal.

__v3.0.9 - 4/Oct/2013__

*  Greatly improves compatibility with text extraction/search, especially for Chinese/Japanese/Korean fonts.
*  The autosave feature of the PSPDFViewController can now be controller via the 'autosaveEnabled' property. Defaults to YES.
*  Improves the transition between stamps and saved annotations for iOS 7 legacy mode.
*  Hide the downloadable fonts section if there are no fonts to download.
*  Disables an unwanted implicit animation in the annotation style inspector for iOS 7 legacy mode.
*  The "Paste" menu is now more clever and will check if creating the new annotations is allowed before it's displayed instead of failing silently.
*  Re-enables search for the outline controller on iOS 7.
*  Fixes an issue in the PSPDFMultiDocumentViewController when the array of documents was set to nil.
*  Fixes a potential crash when parsing invalid PDFs with AcroForm data.

__v3.0.8 - 2/Oct/2013__

*  Use a background task to save annotations when the application enters the background to make sure it finishes before the app gets killed.
*  Thumbnail page label is now re-enabled by default. (Control this via subclassing PSPDFThumbnailGridViewCell and setting the pageLabelEnabled property.)
*  Ensure the status bar is visible if it was originally visible when showing the note view controller on iPhone.
*  Improves various details for the note controller, bookmark controller, annotation controller and outline controller related to iOS 7 tinting.
*  Fixes an issue where saved note annotations sometimes were not correctly removed from the page view until the page was changed.
*  Fixes an issue where ink annotations could end up on the wrong page when using multiple document providers.
*  Fixes an issue that could prevent the grouping menu from appear in the annotation toolbar.
*  Updated some graphics in the PSPDFKit.bundle.

__v3.0.7 - 1/Oct/2013__

*  Improves compatibility with resolving named actions.
*  Ensures that the PDF outline is hidden if no page action targets could be resolved.
*  Reenable undo/redo by default.
*  Fixes a tiny memory leak.

__v3.0.6 - 1/Oct/2013__

*  Always updates bar button items on a document change. Fixes conditions where a button could be in an disabled state if not used in the main toolbar.
*  The status bar state captured at viewWillAppear is now only restored when the PSPDFVC is poppoed from the stack, not on every disappear.
*  Makes it easier to disable undo/redo. (new undoEnabled property on PSPDFDocument)
*  Improves error return code when saving annotations.
*  Fixes an issue where unsaved annotations could be lost during an low memory event when using the tabbed view controller.
*  Fixes a potential non-main-thread call while preparing for saving.
*  Fixes an issue with saving certain documents.

__v3.0.5 - 30/Sept/2013__

*  Font picker now is searchable and shows downloadable fonts.
*  The eraser UI properties can now be changed via UIApperance proxies.
*  The form text field update logic is now more clever and won't change form objects if they are only tapped.
*  Improves styling of the mail sharing view controller on iOS 7.
*  Improves interoperability with Objective-C++.
*  Improves support for a white global tintColor on iOS 7. (check boxes are no longer white)
*  Improves spacing for the half-modal annotation style inspector on iPhone/iOS 7.
*  The annotation manager now continues to look into other providers if the previous one returns nil.
*  Prevent a case where the HUD could be hidden while we're in the thumbnail transition.
*  Changes 'basePath' to 'baseURL' to fix an API inconsistency in PSPDFDocument.
*  Creating a large set of PSPDFDocument objects is now much faster (e.g. while using PSPDFDocumentPickerController)
*  Fixes an issue that could prevent saving annotations into certain documents.
*  Fixes an issue where rotating the signature controller would increase the line thickness.
*  Fixes an issue that prevented committing the rename action in the PSPDFBookmarkViewController.
*  Fixes a potential crash related to the annotation selection view.

__v3.0.4 - 25/Sept/2013__

*  Further tweaks and changes how tintColor is handled on iOS 7.
*  Improve detection code for checked state of radio/ceckboxes in the AcroForm parser.
*  Improve search controller animation.
*  Improve status bar face/slide animtations for iOS 7.
*  Better protect the undo controller against mis-use.
*  Add a new option to PSPDFProcessor: PSPDFProcessorStripEmptyPages. This will post-process the HTML-to-PDF result to remove any blank pages there might be.
*  The 'contentView' of the PSPDFViewController is now always above the PDF content and below the HUD.
*  Fixes an issue where the scrollable thumbnail bar could sometimes disappear.
*  Fixes an issue where the changes of a open note annotation where not saved when tapping on the note again while the popover was already visible.
*  Fixes various smaller potential crashes for malformed PDF documents.
*  Removes support for the optional alertViewTintColor (was iOS 5/6 only)

__v3.0.3 - 22/Sept/2013__

*  The default PSPDFKit binary is now again compatible with iOS 5. We added a new 64-bit enabled binary for apps that are already iOS 7 exclusive.
*  Greatly improve tintColor handling on iOS 7.
*  Support FDF, XFDF and PDF Form submission methods (next to the existing HTTP)
*  Improves speed for the memory image cache internals.
*  Increase the allowed handle size for the text selection knobs on iOS 7 to make it easier to change the selection.
*  Improves the placement for the page label view on iPhone.
*  Ensure toolbar is set for the PSPDFSavedAnnotationViewController when used standalone.
*  Adds missing localization in various places.
*  Improve animation when a popover resizes on iOS 7.
*  No longer draws the form field background when forms are flattened.
*  Optimized handling of documents that take a huge amount of memory to render.
*  Parsing performance for annotation saving is now up to 3x faster for certain complex documents.
*  Improve `localizedDescription` for form elements.
*  Fixes an issue where the color picker in the half-modal controller on iOS 7 could be sized too small.
*  Fixes an issue where adding annotations could hide the page contents when annotations were added directly to the page dictionary.
*  Fixes an issue where partial label matching was too eager and sometimes picked non-optimal matches.
*  Fixes various rare crashes.

__v3.0.2 - 14/Sept/2013__

*  Exposes some additional helpers in PSPDFDocument.
*  Improves the document sharing controller UI for legacy UIKit mode.
*  Improves support for RichMedia extraction of PDF documents created with Adobe XI 11.0.04.
*  Fixes an issue with rotation when annotations are selected.

__v3.0.1 - 13/Sept/2013__

*  Fixes an issue with the demo.

__v3.0.0 - 12/Sept/2013__

PSPDFKit v3 is a major new milestone with several new features and countless improvements.

Some of the highlights are:

*  Full support for iOS 7, Xcode 5 including new icons and default styles to fully match the new iOS 7 appearance, while also maintaining full backwards compatibility for iOS 5/6.
*  The prebuilt binary is now ready for 64 bit and includes 5 architecture slices: armv7, armv7s, arm64, i386 and x86_64.
*  Support for filling out Adobe AcroForm PDF forms. (PSPDFKit Complete/Enterprise only)
*  Full-Text-Indexed-Search across all available PSPDFDocuments via PSPDFLibrary. (PSPDFKit Complete/Enterprise only)
*  New PSPDFDocumentPickerController for easy selection and search within your documents.
*  Support of the XFDF (XML Forms Data Format) Adobe standard for saving/loading/sharing annotations and forms.
*  Completely redesigned annotation toolbar that groups common annotation types together.
*  New annotation inspector for faster and more convenient annotation editing.
*  Global Undo/Redo for annotation creation/editing.
*  Drawing no longer locks the view, you can scroll and zoom with two fingers without any drawing delay.
*  New PSPDFDocumentSharingViewController to unify annotation flattening from email and open in feature and allow a better page selection.
*  Record and play back sounds from sound annotations (fully compatible with Adobe Acrobat)
*  FreeText annotations autoresize as you type.
*  Squiggly text highlighting.
*  Draw and edit Polygon/Polyline annotations.
*  Stamp annotations are now added aspect ratio correct.
*  Improved PDF generation support in PSPDFProcessor (website/office conversion)
*  Improves handling for very small annotations.
*  Support for non-default locations for PSPDFKit.bundle.
*  The delays for adding/removing annotations has been removed.
*  Link/Widget annotations can now be tapped instantly.
*  The logic for the keyboard avoidance code has been greatly improved.
*  Additional Actions and Action Chains are now properly supported.
*  Supports various new touch actions like Hide, Submit Form, Reset Form and adds support for more Named Actions.
*  Countless performance improvements and bug fixes across the whole framework.

Important! Currently PSPDFKit v3 requires that you set the key UIViewControllerBasedStatusBarAppearance to false in your project Info.plist file. We're working on supporting view controller based status bar appearance in a future update.

Note: Several methods and constants have been updated and renamed to make the API cleaner.
Read the [PSPDFKit 3.0 Migration Guide](https://github.com/PSPDFKit/PSPDFKit-Demo/wiki/PSPDFKit-3.0-Migration-Guide) if you're updating from v2.

Important: PSPDFKit v3 requires a serial number and will run in demo-mode by default.
Visit https://customers.pspdfkit.com to register your app bundle ID and get the serial.
If you are a v2 customer with a license that includes a free v3 update, please contact support@pspdfkit.com with your PET* purchase number to get an invite.

PSPDFKit v3 still supports iOS5, however we plan to drop support for it later this year.
We already see less than 5% usage and expect this number to drop further in the future.

With the release of v3 we will focus development on this version and won't be able to offer support for v2 anymore.
Most customers who bought PSPDFKit after January 14th are eligible for a free update,
if your update window is still open (6 months for Binary/Viewer, 12 months for Source/Enterprise)
Contact us with your PET* purchase number (or invoice ID) for details on your status.

__v2.14.22 - 1/Oct/2013__

*  Fixes a crash when parsing certain documents with invalid font references.

__v2.14.21 - 12/Sept/2013__

*  Adds a workaround for a bug where thumbnail icons could disappear in iOS 7 legacy mode.
*  Ensures we always have a document UID set. Fixes an assert for conditions where this was missing.
*  Fixes a rare crash related to an over-release in certain high-load conditions.
*  Fixes the logic that checks and filters glyphs that are outside of the visible page area.

__v2.14.20 - 29/Aug/2013__

Note: This will likely be the last update of PSPDFKit v2. We're very close to release v3, our next major version.
Try the demo here: http://customers.pspdfkit.com/demo.

*  Fixes an issue where scroll to page doesn't work for zoom levels < 1 in continuous scrolling mode.
*  Fixes an initializer issue in PSPDFOrderedDictionary.
*  Fixes a very rare crash on enqueuing render jobs.

__v2.14.19 - 6/Aug/2013__

*  Ensure didShowPageView is called on the initial display of the controller.
*  Ensure we don't create multiple PSPDFMoreBarButtonItems while creating the toolbar.
*  Ensure 'fileName' only ever uses the last path component. Fixes an issue where the full path would be used in the email send feature.
*  Fixes an issue when using the bookmark filter in the thumbnail controller with a `pageRange` filter set.

__v2.14.18 - 28/Jul/2013__

*  Fixes an issue with setting certain status bar styles.
*  Fixes a regression that could result in a crash "cannot form weak reference" on iOS5.

__v2.14.17 - 26/Jul/2013__

*  Improves memory handling and search performance for very large documents. (> 10.000 pages)
*  Improve URL encoding handling for link annotations, fixing various endoding issues.
*  Fixes an issue where the scrollable thumbnail bar wouldn't properly update when a new document was set.
*  Fixes an exception when the tabs of the container view controller change after being presented (e.g. outline parser detects that there's no outline to show)
*  Fixes a rare crash in PSPDFHighlightAnnotation's highlightedString.

__v2.14.16 - 19/Jul/2013__

*  Further improves text extraction performance (faster searching).
*  Enables to subclass PSPDFAnnotationCell in the PSPDFAnnotationTableViewController.
*  Fixes an issue where logging the PSPDFDocumentProvider within dealloc could lead to resurrection.
*  Fixes an issue with managing certain PDF caches.

__v2.14.15 - 12/Jul/2013__

*  Allow PSPDFMoreBarButtonItem to be subclassable.
*  Improve text parser compatibility with PDFs that have deeply nested XObject structures.
*  Fixes an issue where font metrics could be too small/too large within XObjects when the font key had the same name between global resources and XObject resources.
*  Fixes an issue where the word boundaries could be off-by-one due to manually inserted spaces at the wrong index.
*  Fixes an issue where annotation views were not properly cached when a different view was returned via the annotationView: delegate.

__v2.14.14 - 2/Jul/2013__

*  Improve compatibility of the PSPDFMenuItem image support on iOS7.
*  Fixes a compile issue when the Dropbox SDK is linked in combination with PSPDFKit.
*  Fixes an assert when a link action is long-pressed and no action is set.
*  Fixes an issue when the internal webview receives a NSURLErrorCancelled from an async operation.
*  Fixes an issue when annotation notifications are generated from threads other than main.
*  Fixes a crash in the Titanium proxy for certain link annotation actions.

__v2.14.13 - 27/Jun/2013__

*  Fixes an issue where the tab bar views could be placed inside the navigation bar in PSPDFTabbedViewController when rotated without the HUD being visible.
*  Fixes an issue where the thumbnail bar could show stale information when the document changes.
*  Fixes an assertion when an empty action is evaluated through a long-press.
*  Fixes an issue where under certain conditions the note annotation controller could show redundant toolbar buttons.
*  Fixes a potential crash for documents with weird glyph indexes when moving the text selection handles.
*  Fixes a potential recursion crash while supportedInterfaceOrientations is evaluated.
*  Fixes a potential empty context log warning for iOS7.

__v2.14.12 - 24/Jun/2013__

*  Improves thumbnail animations on device rotation.
*  Improves the efficiency of the memory cache.
*  When adding an image and the size picker is dismissed on iPad, we now use high quality instead of throwing away the image.
*  Be more conservative about memory when kPSPDFLowMemoryMode is enabled. (Enable this if you have complex PDFs and/or memory related issues)
*  Fixes a potential recursive call problem when editing link annotations.
*  Fixes an issue where certain glyph frames could be calculated too small if the PDF is encoded incorrectly.
*  Fixes an issue with generating JSON from stamp annotations.
*  Fixes an issue where images could be rendered upside down/incorrectly when they have certain EXIF rotation settings.
*  Fixes an UI issue when annotations couldn't be fully restored from the Copy/Paste action and created an zero-sized object.

__v2.14.11 - 19/Jun/2013__

*  Allow subclassing of the UIImagePickerController used within PSPDFKit for special use (e.g. to block portrait display for landscape-only apps). Use overrideClass:withClass: for that.
*  Ensure the outline page label frame is properly update in landscape mode.
*  Fixes an issue where the annotation table view controller didn't check the editableAnnotationTypes array before offering a delete.
*  Fixes an issue where highlightedString on PSPDFHighlightAnnotation could return incorrect results.
*  Fixes an issue with text extraction.

__v2.14.10 - 13/Jun/2013__

*  Fixes an issue where the outline controller could hang in the "Loading..." state on older devices.
*  Fixes an issue where in rare cases the stamp annotation text could be larger than the stamp itself.
*  Fixes an issue where search could throw an out of range exception for specific PDF encodings.

__v2.14.9 - 11/Jun/2013__

*  Various smaller fixes for iOS7. The source code now again compiles without any warnings.
*  API: change `delegate` to `annotationToolbarDelegate` for the PSPDFAnnotationToolbar because UIKit now added a delegate property on the toolbar.
*  API: The setDefaultStampAnnotations method in PSPDFStampViewController is now a class method.
*  Fixes an issue where the thumbnail controller could mis-place the filter header after a frame resize.
*  Fixes a potential crash when the search view controller was both scrolled and the search keyword changed at the same time.

__v2.14.8 - 3/Jun/2013__

*  Improves glyph word space detection.
*  Fixes a potential crash on a yet unreleased future version of iOS.

__v2.14.7 - 31/May/2013__

*  Improved memory management for older devices like iPad1 or when kPSPDFLowMemoryEnabled is set. This helps against possible memory exhaustion on very complex documents.
*  Fixes an issue where the play button of an embedded video sometimes would not change to its actual state (playing) when pressed.
*  Fixes an issue with draw mode restoration after showing a modal view controller while in draw mode when using pageCurl transition.
*  Further tweaks to the text extraction engine.

__v2.14.6 - 29/May/2013__

*  It's now easier than ever to change the link border color: [PSPDFLinkAnnotationView setGlobalBorderColor:[UIColor greenColor]].
*  Thumbnail loading in the scrobble bar is now higher priorized, loads faster.
*  The bounding box calculation for line annotation now correctly calculates the size for line endings. Line ending size has also been increased to better match Adobe Acrobat. (Thanks Tony Tomc!)
*  The PSPDFRenderStatusView is now a public class that allows to customize the loading spinner displayed while rendering a PDF page.
*  Annotation resizing when zoomed in deeply has been greatly improved.
*  Further improves text parsing speed and word boundary detection.
*  Fixes an issue where in some cases annotation resizing could fail when changed via the menubar directly before the resize action.
*  Fixes a potential one-pixel rendering bug that could result in thumbnails for certain aspect ratio combinations having white lines at one end of the image.
*  Fixes an issue that would sometimes mark certain PDF links to localhost as "webview" when they in fact only are regular links.

__v2.14.5 - 27/May/2013__

*  PSPDFWebViewController will now use UIActivityViewController on iOS6 by default.
*  Support new "loop" option for video annotations.
*  Use images for the text alignment setting.
*  Improve HSV color picker brightness style.
*  Improve word detection for PDF types that already have spaces added and also improves word-break-behavior for ligatures.
*  PSPDFKit will now attempt to render even unknown annotation as long as they define an appearance stream.
*  Improve search and glyph extraction performance.
*  Fixes an issue that could result in the HUD being in a hidden state after adding line/ellipse annotations from the annotation menu while the annotation toolbar is visible.
*  Fixes a potential crash when the PSPDFDocument was deallocated early.
*  Fixes a rare crash with a malformed PDF in the text extractor.

__v2.14.4 - 23/May/2013__

*  The annotation resize control now shows guides for aspect ratio and square resizing.
*  The outline controller now shows the target page and properly highlights the outline button.
*  Improves rendering of rotated stamps/images on rotated pages.
*  Allow class overriding for PSPDFSearchResultCell and PSPDFSearchStatusCell.
*  The grid control now loads faster for huge documents on iOS5.
*  Adds some additional safeguards that will now warn if methods of UIViewController/PSPDFViewController are overridden without calling super.
*  Removes legacy PSPDFResolvePathNamesEnableLegacyBehavior.
*  Fixes a small memory leak related to stamp annotations.
*  Fixes an issue where the search controller could get into an "empty" state without showing the search bar.

__v2.14.3 - 21/May/2013__

*  Allow to override PSPDFOutlineCell via overrideClass:withClass:.
*  Fixes a nasty issue with one-pixel white thumbnail borders on certain page aspect rations.
*  Fixes an edge case where the menu could appear while the PSPDFViewController is being popped from the navigation stack.
*  Fixes an issue with multiple calls to overrideClass:withClass:
*  Fixes a parsing bug with remote GoToR actions that have a page destination set. The page destination is now evaluated correctly.

__v2.14.2 - 19/May/2013__

*  PSPDFViewController now unloads its views when not visible on a memory warning even on iOS6. This saves memory especially when multiple stacks of viewControllers are used in a navigationController.
*  Improves the thumbnail quality.
*  Polyline/Polygon how shows boundingBox resize knobs + knobs for each line end point. Inner points are green.
*  When no fillColor is defined, color will be used instead of black. This is not defined in the PDF Reference, but more closely matches Apple's Preview.app and looks better.
*  Glyph ligature breaks (e.g. ffi) now no longer are marked as WordBreaker.
*  Improves default boundingBox calculation for new annotations on rotated PDF documents.
*  PSPDFPageRenderer can now be subclassed/changed.
*  Improves bounding box calculation for small FreeText annotations.
*  Stamps are now properly rendered on rotated pages.
*  If a stamp annotation is an appearance stream, PSPDFKit now tries to extract the image when using Copy/Paste.
*  Font variant picker now shows font in title and filters name for better display, e.g. 'Helvetivca-Bold' becomes just 'Bold'.
*  Several improvements to the PSPDFMultiDocumentController.
*  The thumbnail selection background now properly sizes itself based on the negative edgeInsets of the thumbnail cell (= looks better for non-portrait documents)
*  Dashed border now factors in lineWidth.
*  Improves parsing of certain GoToR Actions.
*  Made the color preview in UITableViewCell pixel perfect.
*  Improves title detection to filter out white space, now correctly handles cases where the title is missing but ' ' is set instead.
*  PSPDFKit is now compiled with -O3 (instead of -Os) and and uses link-time optimization to further improve performance.
*  Fixes placement of the image and signature picker for rotated documents.
*  Fixes a rare issue where a annotation could stuck in an invisible state because of a bug in the trackedView when selecting + scrolling happened at the same time.
*  Fixes a regression where thumbnail images could become sized wrongly in their aspect ratio under certain conditions for non-uniformly sized documents.
*  Fixes an offset by one error when resolving named destinations for a specific outline action destination type when there are > 500 outline entries.
*  Fixes a potential crash related to the color picker.
*  Fixes a crash related to parsing invalid outline elements.

__v2.14.1 - 15/May/2013__

*  Add write support for Polygon/Polyline annotations. (In the API, there's no UI for creating yet, but editing the points works)
*  Add new PSPDFThumbnailBar to display scrollable thumbnails as an alternative to the scrobbleBar. The thumbnail bar is a preview and might change API/Featureset in the next releases. We have some big plans for this but couldn't wait to get it out of the door!
*  The PSPDFOutlineViewController now no longer shows a title on iPad if no modes are set. As a detail, its search bar now is named as "Search Outline" instead of just "Search".
*  FreeText annotation is now correctly rotated on rotated PDF pages and also respects the annotation rotation setting (0, 90, 180, 270).
*  Fix password view state positioning when the keyboard is up and the parent resizes itself.
*  Fixes a potential regression/assertion when the PSPDFViewController was used without a navigationController.
*  Fixes an regression where words with ligatures (like the ffi liagure glyph) would be split into two words with certain encodings.
*  Fixes a race condition that could lead to a warning named '<NSRecursiveLock> deallocated while still in use'.
*  Fixes a line annotation serialization issue where line endings would only be serialized if both are set.
*  Fixes an issue for Copy/Paste where preexisting annotations could disappear after they have been copied and edited.
*  Fixes an exception in the PDF parser if a PDF with a corrupt stream object is analyzed.

__v2.14.0 - 12/May/2013__

*  Add support to Copy/Paste annotations. This creates a global UIPasteboard and will work for all apps that use the PSPDFKit framework with 2.14 and up. Alternatively a JSON object is created as well, so that other applications can add support to parse and support PSPDFKit-style-annotations as well.
*  Paste also supports general pasteboard types like Text, URL or Image and will create the appropriate annotations (if this is allowed)

*  New global PSPDFStyleManager that saves various annotation properties and applies them to new annotations. For example, if you change the color of a highlight to red, all future annotations are created red until you change the color back. This already worked in the PSPDFAnnotationToolbar before but is now unified and applied globally (will also save properties like fillColor or fontName). You can disable this with nilling out the styleKeys property of PSPDFStyleManager.

*  The PSPDFFreeTextAnnotationView is now always sharp, even when zoomed in. Because we have to work around the broken contentsScale property, the API has changed a bit. If you previously had textView overridden, you now need to subclass PSPDFFreeTextAnnotationView and change the textViewForEditing method to apply your custom textView.
*  PSPDFStampViewController is now more flexible and will evaluate the new PSPDFStampAnnotationSuggestedSizeKey key for the default annotations. Images in default annotations are now supported as well and the checkmark and X annotation are now added with the correct aspect ratio size. With the new setDefaultStampAnnotations: a different set of default annotations can be set.
*  Various smaller UX fixes inside the  PSPDFNoteViewController.
*  Improves memory usage with very large documents (1000 pages and up)
*  Various smaller performance improvements in the cache.
*  Tinting has been improved for various view controllers.
*  The global "Text..." option has been renamed to "Note..." to make its function more clear.
*  The global "Appearance..." has ben renamed to "Style..." because this is more concise and better fits the iPhone.
*  Fixes an issue where unless controls:YES was set the wrong default was used for web links in the internal browser.
*  Fixes an edge case where the PSPDFPasswordView would not adapt itself correctly if the keyboard was already up before the controller has been pushed.
*  Fixes an issue with opening external URLs via dialog where the preview of the URL could fail.

__v2.13.2 - 10/May/2013__

*  The text selection delegate pdfViewController:didSelectText:withGlyphs:atRect:onPageView: is now also called for deselection.
*  Fixes an issue where PSPDFProcessor would flatten AND add annotations if kPSPDFProcessorAnnotationAsDictionary was used.
*  Fixes an issue with annotation drawing on iPhone on iOS5 where views could be reloaded after a memory warning and then the current drawing was missing.
*  Fixes a small memory leak.

__v2.13.1 - 9/May/2013__

*  Adds read support for Polygon/Polyline annotations, including support for all line ending types.
*  The tinted UIPopoverController subclasses now look much better and now very closely resemble the original including gradients and alpha value.
*  PSPDFTextParser now fully complies to NSCoding, so search results can be persisted and cached. (Thanks to ForeFlight!)
*  Fixes an unbalanced locking call when a page was requested that couldn't be rendered.

__v2.13.0 - 7/May/2013__

PSPDFKit now requires QuickLook.framework, AudioToolbox.framework and sqlite3. Please update your framework dependencies accordingly.

*  Initial support for 'Widget' annotations, supports action and rendering. (not yet writable)
*  Support for 'File' annotations. Will offer QuickLook support on touch.
*  Basic read support for 'Sound' annotations.
*  Add support for 'Rendition' and 'RichMediaExecute' actions that can control Screen/RichMedia annotations. (video/audio. JavaScript is not supported.)
*  Ink/Circle/Ellipse/Line now each save their last used color independently.
*  FreeText and other annotation types inside the annotation toolbar now remember the last used color.
*  Add missing translation for "%d Annotations" and added special case for "%d Annotation" (singular).
*  Add missing "No Annotations" and "Loading..." state text for the PSPDFAnnotationTableViewController.
*  For text selection, the text knob is now priorized over near annotations.
*  API: `cacheDirectory` in PSPDFDocument has been renamed to `dataDirectory`, so that won't be confused with the cache directory setting of PSPDFCache.
*  Improves text parser to properly detect word boundaries for documents that use invalid characters for word separation.
*  For pspdfkit:// based videos controls are now enabled by default if the option is not set.
*  PSPDFProgressHUD now checks if the keyWindow is visible before restoring, fixes an edge case with multiple windows that have rootViewControllers attached.
*  PSPDFSearchViewController now has a protocol to communicate with PSPDFViewController instead of owning that object directly.
*  PSPDFViewController no longer will change the viewMode to document when the view will disappear.
*  Fixes a rare crash when moving the text selection handle.
*  Fixes an issue with writing the page annotation object on malformed PDFs which could lead to annotations being written but not being displayed.
*  Fixes an issue with where sometimes fillColor was set on FreeText annotations even though there shouldn't be one set.

__v2.12.12 - 4/May/2013__

*  The note view controller now will detect links.
*  pdfViewController:shouldSelectAnnotation: is now also honored for long press actions.
*  Fixes an issue where annotations sometimes were not parsed correctly with password protected PDFs.
*  Fixes an issue related to checking the annotation cache receipt.
*  Fixes an encoding issue with annotation links that contained spaces.
*  Fixes a potential crash with an PSPDFActionURL with an nil URL.

__v2.12.11 - 30/April/2013__

*  Add new styles for HUD showing/hiding: PSPDFHUDViewAnimationSlide (in addition to the default fade)
*  Tapping in the previous/next range on first/last page will now toggle the HUD instead of force-showing it.
*  Fixes a UI issue where the document label view could be slightly offset under certain conditions on iPhone after a rotation from portrait to landscape with hidden HUD.
*  Fixes an issue with text extraction for certain PDF encodings.

__v2.12.10 - 30/April/2013__

*  Improves the Loading... state when there's already content in PSPDFTableAnnotationViewController.
*  Fixes an issue with adding/removing bookmarks.
*  Fixes an issue where fixedVerticalPositionForFitToWidthEnabledMode could lead to off-centered pages.
*  Fixes an issue with search and certain PDF encodings that only happened on release builds.
*  PSPDFCatalog: Fixes the map view example with a map:// annotation link.

__v2.12.9 - 28/April/2013__

*  Fixes an issue with text selection handle dragging.

__v2.12.8 - 28/April/2013__

*  Huge performance and memory improvements for text extraction/search.
*  Performance improvements at serializing annotations.
*  Memory improvements, especially for large documents. (>5000 pages)
*  API: useApplicationAudioSession in PSPDFVideoAnnotationView has been removed, since the underlying property is deprecated by Apple. Subclass and change this on the MPMoviePlayerController directly if you rely on the old behavior, but note that this might be gone as of iOS7.
*  New brightnessControllerCustomizationBlock in PSPDFBrightnessBarButtonItem.
*  Fixes an issue that could lead to a crash on deallocating certain objects when OS_OBJECT_USE_OBJC was enabled. (Sourcecode, iSO6 only ARC builds)
*  Fixes an issue where PSPDFKit was sometimes too slow freeing up memory with lots of background task running on low memory sitations.

__v2.12.7 - 24/April/2013__

*  Major performance improvements on annotation parsing.
*  Outline and annotation parsing has been moved to a thread, the controller has now a loading state until parsing is complete.
*  The bookmark controller now supports the pageRange feature, hiding bookmarks that are not accessible.
*  Bookmark cells now allow copy.
*  Bookmark now also uses the PSPDFAction system to execute actions. (allows links, etc)
*  Improves the text parser to better deal with malformed PDF font encodings.
*  Improves accessibility localization in the thumbnail grid view cell. (thanks to Dropbox for providing this patch!)
*  Adds missing localization for text alignment property of free text annotations.
*  Fixes a regression where search table view updates with rapid cancellation could lead to an exception.

__v2.12.6 - 22/April/2013__

*  FreeText annotations now have a text alignment property (compatible with both Preview.app and Adobe Acrobat)
*  Ink annotations now allow setting a fill color (this is an extension to the PDF spec but works fine because we emit an appearance stream)
*  Allows subclassing of PSPDFStampViewController.
*  Expose the drawView of the PSPDFSignatureController.
*  FreeText annotations: Improve parsing of style strings.
*  Don't do expensive (xpc) dictionary lookups on older devices. (iPad1)
*  Fixes an issue where the outline controller could show menu items from the text selection view on iPad.
*  Fixes a crash with a missing selector (didReceiveMemoryWarning) on PSPDFDrawView.
*  Fixes a rare crash with parsing certain malformed PDF documents.

__v2.12.5 - 21/April/2013__

*  FreeText annotations now support fill color (Note: This is only partially implemented in Apple's Preview.app but works fine in Adobe Acrobat)
*  FillColor settings now includes transparent (useful for shapes, free text, lines)
*  Improves color parsing for FreeText annotations.
*  Add basic support for Caret annotations.
*  Improves rendering of rotated stamps.

__v2.12.4 - 19/April/2013__

*  Performance improvements for page scrolling.
*  Improves support for UIAppearance (e.g. navigation bar images)
*  Bookmark and annotation controller now fully respect the tintColor property.
*  API: PSPDFDocument convenience contstructors have been renamed from PDFDocumentWith... to simply documentWith....
*  Improves compatibility with certain GoToR PDF actions that don't define a target page.
*  Fixes an issue where pausing a video without controls could fail on iOS5.
*  Fixes an issue where showing multiple videos with autostart enabled could lead to a crash on iOS5.
*  Fixes a small memory leak when drawing stamp annotations.

__v2.12.3 - 19/April/2013__

*  The setDidCreateDocumentProviderBlock and the didCreateDocumentProvider method will now be called after the documentProviders are fully created, fixing recursion issues if methods are called that require the documentProvider from within that block.
*  Setting a different annotationPath in the PSPDFFileAnnotationProvider will remove all current annotations and try to load new annotations from that path.
*  Fixes an issue where in PSPDFTextSearch didFinishSearch: was always called, even when the search was cancelled (instead of didCancelSearch:)
*  Fixes an issue where changing the note icon could result in restoring the previously set note text.
*  Titanium: Fixes a bug where under certain conditions `useParentNavigationBar` would not work on the first push of the view controller.
*  Titanium: Add setAllowedMenuActions (document setting)

__v2.12.2 - 18/April/2013__

*  PSPDFTabbedViewController learned `openDocumentActionInNewTab`, opens a document in a new tab if set to YES (new default)
*  pdfViewController:documentForRelativePath: now gets the *original* path from the PDF action for resolvement.
*  Respect alpha for fillColor for FreeText annotations.
*  Disable iOS "Speak Selection" menu entries since this does not work. A DTS for this feature is ongoing.
*  Fixes rendering of textAlignment for FreeText annotations.
*  Fixes an issue when pageRange is set with multiple documents and retain documents are completely blocked through it.
*  Fixes PDF generation for different-sized PDFs.
*  Fixes missing update when "Clear All" is used.
*  Fixes a rare race condition on freeing document providers.
*  Fixes a rare issue that could lead to an empty view on loading a document.

__v2.12.1 - 12/April/2013__

*  Uses a sensible default for allowedMenuActions in PSPDFDocument.
*  Fixes an issue with Appcelerator.

__v2.12.0 - 11/April/2013__

*  New class cluster: PSPDFAction. This unifies action between PSPDFOutlineElement, PSPDFBookmark and PSPDFLinkAnnotation. Now you can create outline elements and bookmark that have the same flexibility as links in PSPDFLinkAnnotation, supporting pspdfkit:// style URLs. The parsing code has been unified as well with the best of both worlds (e.g. the 'Launch' action is now supported universally). This improvement required deprecating certain methods - update your code if you used one of those classes directly)
*  Add support for GoBack/GoForward named annotations.
*  Add basic support for JavaScript actions that link to another page.
*  PSPDFNoteAnnotationController now honors the allowEditing state also for the textView and blocks editing if set to NO.
*  New helper to better override classes: overrideClass:withClass: in both PSPDFViewController and PSPDFDocument.
*  Annotation types in the annotation table view are now localized.
*  New delegates in PSPDFViewControllerDelegate to get notified on page dragging and zooming.
*  PSPDFViewState no longer saves the HUD status (this should be handled separately and was confusing for the tabbed controller)
*  Removed legacy coder support for data models that were serialized before 2.7.0.
*  Removes deprecated API support in PSPDFTextSearch and PSPDFAnnotationParser.
*  Fixes an issue in the label parser where page label prefixes were defined without style.
*  Fixes an issue where hiding the progress HUD could make the wrong window keyWindow (if at that time there is more than one visible), thus leading to keyboard problems.
*  Fixes an issue in the document parser that could lead to a recursion for cyclic XRef references for certain PDF documents.
*  Fixes a situation where touch handling could become sluggish when a crazy amount of link annotation is on a page (>500!)
*  Fixes a annotation text encoding issue that could result in breaking serialization of certain character combinations like 小森.
*  Fixes a UI issue where invoking the draw action from the menu while at the same time having the annotation toolbar visible could lead to a hidden toolbar if that one is transparent.
*  Fixes an issue with the text extraction engine for certain PDF files.
*  Appcelerator: Allow setting size properties like thumbnailSize: [300,300]
*  Appcelerator: Add support to set outline controller filter options (outlineControllerFilterOptions = ["Outline"])

__v2.11.2 - 4/April/2013__

*  Drawing annotations is now always sharp, even when the document is zoomed in. (This required changes to the public API of PSPDFDrawView, check your code if you use that class directly)
*  Annotation flattening now shows a circular progress indicator instead of the default spinning indicator.
*  PSPDFProcessor now has a new progressBlock property that calls back on each processed page.
*  New delegates: pdfViewControllerWillDismiss: and pdfViewControllerDidDismiss: to detect controller dismissal.
*  Add allowedMenuActions property to PSPDFDocument to allow easy disabling of Wikipedia, Search, Define text selection menu entries.
*  Internal locking of PSPDFDocument and PSPDFRenderQueue has been improved and is now faster in many situations.
*  Getting all annotations of a document is now faster in some situations.
*  Titanium: setEditableAnnotations: is now exposed (PSPDFKit Basic upwards)
*  Fixes an issue with line annotation selection where sometimes a selection knob was not visible.

__v2.11.1 - 3/April/2013__

*  Add switch to globally enable/disable bookmarks (`bookmarksEnabled` in PSPDFDocument)
*  `annotationsEnabled` in PSPDFDocument now also enabled/disables the annotation menus.
*  The thumbnail view now listens for annotation changes/bookmark changes and updates accordingly.
*  Fixes an issue where the toolbar in the new PSPDFContainerViewController was sometimes not displayed initially.
*  Fixes an issue where the delegate didLoadPageView: was called multiple times with the pageCurl transition.

__v2.11.0 - 1/April/2013__

*  Allows to create Rectangle, Ellipse and Line annotations.
*  Line thickness can now be chosen from the drawing toolbar.
*  Improvements to line annotation drawing.
*  Line annotation endings can now be customized (Square, Circle, Diamond, Arrow, ...)
*  Drawing is now instantly smoothened.
*  New annotation list controller (PSPDFAnnotationListViewController) to quickly see all annotations, zoom onto them or delete them.
*  Renamed Table of Contents to Outline.
*  OutlineBarButton now can show both the new annotation list and the bookmarks. Both are enabled by default.
*  The outline is now searchable.
*  Several menu items have been reorganized to both fit better on iPad and iPhone.
*  The long-press to show the bookmark view controller is now disabled by default.
*  The PSPDFKit folder has been restructured.
*  The `pageRange` feature if PSPDFDocument now works across multiple data sources. (This allows more flexibility for PSPDFProcessor and faster document creation)
*  It's now easier to disable the PDF page label feature with the new property `pageLabelsEnabled` in PSPDFDocument. (enabled by default, disable if you see 'weird' page labels)
*  API: PSPDFAnnotationView has been deprecated and renamed into PSPDFAnnotationViewProtocol.
*  Fixes an issue where small text on free text annotations was not rendered at all when the boundingBox was too small for it.
*  Fixes a potential crash on iOS5.

__v2.10.2 - 27/March/2013__

*  PSPDFCache is even smarter and faster when using PDF documents that are very slow to render.
*  PSPDFCache no longer deadlocks if you remove the delegate while the delegate is being called.
*  If a new PSPDFViewController is created based on a PDF action that links to a new document modally, all important settings are copied over to the new controller.
*  PSPDFKit will no longer create empty highlight annotations when using the annotation toolbar and tapping on a point without text.
*  No longer retains the view controller while the document background cache is being build (less memory pressure)
*  Adds some more safeguards against abuse of certain methods.
*  The render queue now retains the document while rendering. This fixes cases where image requests never returned because the document disappeared before.
*  Fixes a regression from 2.10 where through an event optimization sometimes the text of a note annotation was not properly saved. PSPDFDocument now sends out a PSPDFDocumentWillSaveNotification before a save will be made to give all open editors a chance to persist it's last state in time.
*  Fixes an issue where the contentRect was calculated wrong for uncommon view embedding use cases.
*  Fixes an issue where the thumbnail filter values were hardcoded.
*  Fixes a potential timing-related crash on iOS5 when the search controller was shown too fast.
*  Titanium: Add thumbnailFilterOptions property.

__v2.10.1 - 26/March/2013__

*  Shape annotations border and fill color can now be customized.
*  Clearing the memory cache will now also clear any open document references.
*  Add white color to common color picker colors (except for highlights, replacing purple)
*  PSPDFRenderQueue now has a cancelAllJobs to clear any running requests.
*  The render queue now better priorizes between cache requests and user requests (zooms) to allow even faster rendering.
*  FreeText annotations can now no longer be created outside boundaries.
*  Add support for text alignment for FreeText annotations. (It seems that Adobe Acrobat has a bug here and ignores this property - other Applications are compliant to the PDF spec and do display this, e.g. Apple's Preview.app)
*  Edit mode now directly hides the HUDView.
*  API change: The color picker now has a context: flag to allow state storage. Update your delegates if you use this class directly.
*  Fixes some minor issues with the new cache.
*  Fixes a UI weirdness where the scrollview had a slow scroll-back animation when text was edited at the very top.
*  Titanium: Add new linkAnnotationHighlightColor property.

__v2.10.0 - 22/March/2013__

PSPDFKit 2.10 is another major milestone. The cache has been rewritten from the ground up to be both faster and more reliable. Annotations are now cached, they are no longer an "afterthought" and will show up in the thumbnails and even the scrobble bar. The disk cache now limits itself to 500MB (this is customizable) and cleans up the least recently used files. The memory cache is now also smarter and better limits itself to a fixed number of pixels (~50MB of modern devices in the default setting). Loading images from the cache is now more logical and highly customizable with PSPDFCacheOptions. The two render code paths have been unified, PSPDFRenderQueue now does all rendering and can now render multiple requests at the same time and also priorizes between low priority cache requests and high priority user zoom requests. In this process some very old code has been completely reworked (PSPDFGlobalLock) and is now much more solid.
Several methods have been renamed, upgrading will require a little bit of effort to adapt to the new method names. It's definitely worth it. If you find any regressions or missing features for your particular use case, contact me at peter@pspdfkit.com.

*  Completely rewritten cache that now renders all screen sizes and shows annotations.
*  PSPDFThumbnailViewController now has a new filter to only show annotated/bookmarked pages. See filterOptions for details. http://twitter.com/PSPDFKit/status/314333301664006144/photo/1
*  PSPDFViewController has a new setting: `showAnnotationMenuAfterCreation` to automatically show the menu after an annotation has been created. (disabled by default)
*  On iPhone, scrolling down the search results will now automatically hide the keyboard.
*  Text loupe no longer fades zoomed content. (looks better for text scope loupe)
*  Prevent too fast tableView updates (and thus flickering) in PSPDFSearchViewController.
*  Increases loupe magnification on iPhone to 1.6 and make kPSPDFLoupeDefaultMagnification customizable at runtime.
*  A UISplitViewController in the hierarchy is automatically detected and the pan gesture will be blocked while the PSPDFViewController is in drawing mode (else this would interfere with drawing).
*  The note annotation controller now no longer generates change events per typed key, but will wait for a viewWillDisappear/app background event to sync the changed text back into the annotation object.
*  Expose availableLineWidths and availableFontSizes in PSPDFPageView to customize menu options.
*  On iPhone, scrolling down the search results will now automatically hide the keyboard.
*  Improves performance for overlay annotation rendering.
*  Improves annotation selection, especially drawings are now pretty much pixel perfect.
*  Disables the long press gesture (and the new annotation menu) when a toolbar annotation mode is active.
*  Use PSPDFAnnotationBorderStyleNone instead of PSPDFAnnotationBorderStyleSolid when the border style is undefined (to match Adobe Acrobat)
*  The annotation selection border is now independent of the zoomScale.
*  FreeText annotations no longer "jitter" when resizing.
*  The stamp controller now dismisses the keyboard when changing switches or pressing return on the keyboard.
*  Allow note annotations outside the page area (to match Adobe Acrobat behavior).
*  Allow overrideClassNames for PSPDFDocument when it's created from within PSPDFViewController (e.g. when an external annotation link target is touched)
*  Add workaround against rdar://13446855 (UIMenuController doesn't properly reset state for multi-page menu)
*  The selectionBackgroundColor of PSPDFSearchHighlightView can be updated after it's displayed now.
*  PSPDFTabBarView of PSPDFTabbedViewController can now be overridden with the overrideClassNames dictionary.
*  API change: The renderBackgroundColor, renderInvertEnabled, renderContentOpacity methods have been removed from PSPDFViewController. Please instead update the dictionary in PSPDFDocument to set these effects. (e.g. document.renderOptions = @{kPSPDFInvertRendering : @YES}).
*  API change: PSPDFViewController's renderAnnotationTypes has been deprecated and will update the renderOptions in PSPDFDocument instead.
*  API change: renderPage: and renderImageForPage: will now automatically fetch annotations if the annotations array is nil. To render a page without annotations, supply an empty array as the annotations array (as soon as an array is set, auto-fetching will be disabled).
*  API change: PSPDFCacheStrategy is now PSPDFDiskCacheStrategy, the enum options have been updated as well.
*  Fixes some minor problems and deprecation warnings when compiling PSPDFKit with iOS6 as minimum deployment target and autoretained GCD objects.
*  Fixes an issue where some annotations got set to overlay and were not properly restored.
*  Fixes an issue with centering after returning from thumbnails in continuous scrolling mode.
*  Fixes an issue where a thumbnail could be animated that was not visible.
*  Fixes an UIAcessibility mistake where Undo was labeled Redo in the drawing toolbar.
*  Fixes encoding issues with localization files.
*  Fixes some potential crashes when parsing certain PDF documents.
*  Fixes several non-critical log warnings when opeing continuous scrolling with an invalid document.
*  Fixes various potential crashes around screen annotations and stream extraction.

__v2.9.0 - 9/March/2013__

*  The loupe has been improved, it's now fast in every zoom level and now 100% matches UIKit's look. Developers can now easily update the magnification level.
*  Greatly improved UIAccessibility support. Reading mode is now line-based and reading column-based layouts works much better.
*  New feature: PSPDFScrobbleBar can control tap behavior outside the page area with allowTapsOutsidePageArea.
*  Improved PDF rendering speed for pageCurl mode.
*  RichMediaAnnotations (directly embedded video) now support autoplay set directly via Adobe Acrobat (Both page visibility modes will enable autoplay)
*  Removes deprecated methods from PSPDFViewController and PSPDFPageView.
*  NSNull entries are now properly filtered out from the PDF metadata.
*  Greatly improves outline parsing speed. In some cases parsing of extremely complex outlines went down from 120 seconds to 2 seconds (in a ~5000 pages document)
*  Add progress while data is transferring when using the "Open In…" feature.
*  PSPDFAnnotation model version is now at 1, boundingBox is now serialized as string and no longer as NSValue (fixes JSON serialization)
*  Improves animation when adding/removing bookmarks while the popover controller is resizing at the same time.
*  Add support for long-press toolbar button detection when useBorderedToolbarStyle is enabled.
*  useBorderedToolbarStyle is now also evaluated in PSPDFAnnotationToolbar.
*  PSPDFOpenInBarButtonItem now has the option to directly add the 'print' action into the list of applications. Disabled by default. See 'showPrintAction'.
*  UIMenuController is now smarter and no longer places the menu above the toolbar when there's space underneath as well.
*  'allowTwoFingerScrollPanDuringLock' in PSPDFAnnotationToolbar now defaults to NO, since this delays drawing.
*  API change: Refactored the thumbnail view out of PSPDFViewController into it's own controller: PSPDFThumbnailViewController. If your code relied on modifying the collection view delegates within PSPDFViewController, you must update your code to override PSPDFThumbnailViewController instead. PSPDFViewController' gridView has been deprecated. Use thumbnailController.collectionView instead.
*  API change: Removed iPhoneThumbnailSizeReductionFactor. item size is now set conditionally during initialization. The best way to set this is in PSPDFCache.sharedCache.thumbnailSize.
*  API change: The delegate didRenderPage:didRenderPage:inContext:withSize:clippedToRect:withAnnotations:options: has been moved over to PSPDFDocumentDelegate.
*  Drawing Ink annotations now closely matches the line width when zoomed in.
*  Fixes a possible scrolling "freezing" issue when pageCurl is enabled.
*  Fixes a potential crash with extracting the page title of the PDF.
*  Fixes a potential crash when the Open In... action was invoked multiple times too quickly. (Thanks to Evernote for this fix)
*  Fixes a bug that could change the cursor position in the note annotation controller.
*  Fixes various potential crashes when parsing invalid PDF data.
*  Fixes an issue where thumbnails could not properly be selected with VoiceOver enabled.
*  Fixes an issue with image selection on rotated documents.
*  Fixes an issue with annotationViewClassForAnnotation: and the call ordering of defaultAnnotationViewClassForAnnotation.

__v2.8.7 - 22/February/2013__

*  Improved scrollview centering. Now allows to pan while bounce-zoomed out.
*  PSPDFMultiDocumentController now can advance to next/prev document with tapping at the last page of the current one.
*  Slightly increases the smart zoom border on iPad.
*  New helper in PSPDFNoteAnnotationController to allow easy customization: setTextViewCustomizationBlock.
*  New property in PSPDFViewController: scrollOnTapPageEndAnimationEnabled.
*  New property in PSPDFViewController: shouldRestoreNavigationBarStyle (via Dropbox request)
*  Fixes a rare scroll view locking issues that was triggered by an UIKit bug.
*  Fixes an off-by-one error in PSPDFOutlineParser's resolveDestinationNameForOutlineElement.

__v2.8.6 - 20/February/2013__

*  PSPDFShapeAnnotation now creates appearance stream data. This is needed to work around a bug in Adobe Acrobat for iOS. This behavior can be disabled with setting kPSPDFGenerateAPForShape to @NO in renderingOptions of PSPDFDocument. As a side effect, this also improves display of transparent shapes with Apple's Preview.app
*  Improvements to smart zoom - text block choose method is now smarter.
*  viewLock no longer locks the HUD (just the view state)
*  Improves animation for the Table of Contents controller cells.
*  Setting the pageRange now automatically invalidates the current document.
*  PSPDFTabbedViewController has become more modular with the new superclass PSPDFMultiDocumentViewController.
*  Fixes a rare crash when using the drawing tool very quickly with only one resulting draw point.
*  Fixes a rendering issue with images added from the camera in pageCurl mode.
*  Fixes an issue where the scrobble bar could be displayed even though it's disabled.
*  Fixes a regression in the appearance stream generator.
*  Fixes a regression with updating the bookmark bar button status when the toolbar is transparent.
*  Titanium: Fixes toolbar detection for annotation toolbar.

__v2.8.5 - 16/February/2013__

*  Fixes a text glyph frame calculation bug when a font contains both a unicode map and an encoding array.
*  Improves glyph shadow detection to be more accurate, less false positives.

__v2.8.4 - 16/February/2013__

*  Improves text block detection speed.
*  Fixes certain crashes when parsing malformed PDFs.
*  Fixes an issue where outline elements linked to the same named destination would not all be correctly resolved.

__v2.8.3 - 15/February/2013__

*  Allow UIAppearance for PSPDFRoundedLabel.
*  Added a mailComposeViewControllerCustomizationBlock in PSPDFEmailBarButtonItem to easily change the default email body text.
*  New property: thumbnailMargin in PSPDFViewController.
*  Thumbnail view now dynamically updates the sectionInset if the HUD is hidden during thumbnail view.
*  API change: Renamed siteLabel to pageLabel in PSPDFThumbnailGridViewCell.
*  Replaces PSPDFAddLocalizationFileForLocale with the more flexible PSPDFSetLocalizationBlock.
*  Add double-tap to fullscreen for YouTube views.
*  Add fallback to use associated objects for annotation views that don't comply to PSPDFAnnotationView. (Fixes duplicate view adding)
*  Disables the yellow block highlighting on a double-tap zoom.
*  The Save To Camera Roll is now faster and no longer blocks the main thread during JPG compression.
*  Certain smaller tweaks/improvements for the HUD.
*  Fixes a regression where on a long press the annotation menu would reappear then disappear for highlight annotations.
*  Fixes a regression that broke re-positioning of search highlights on a frame change.
*  Fixes an issue where the pdfController could be dismissed when using the "send via email" feature.
*  Fixes a rare condition in which the progressView (PSPDFProgressHUD) could get stuck.
*  Fixes an issue where videos that were set to autostart=NO could still autostart on iOS5.
*  Fixes an issue where CMYK encoded JPGs would be extracted inverted upon saving.
*  Fixes an issue where ink annotations could be added in the wrong size when the device directly rotates after finishing a drawing
*  Fixes a rounding error that made certain pages scroll-able in pageCurl mode.
*  Fixes a page blurriness issue because of rounding errors when zooming out/zooming in a lot.
*  Removed deprecated options from PSPDFEmailBarButtonItem.

__v2.8.2 - 10/February/2013__

*  HUD visibility/transparenty can now be set more fine-grained with the new properties transparentHUD, shouldHideNavigationBarWithHUD, shouldHideStatusBarWithHUD and statusBarStyle. Check your code and let me know if this breaks something. Setting statusBarStyleSetting will update all those properties.
*  Resize view now snaps to aspect ratio on resizing. Middle knobs are hidden if space is low.
*  Document link annotations now resolve symbolic links.
*  After editing annotation properties (e.g. color) the menu will re-appear.
*  Annotation menu is re-displayed after a rotation.
*  Finishing a drawing no longer disappears/reappears because of the page rendering process.
*  Search view controller cells now animate better and have better sized margins.
*  PSPDFBarButtonItem's pdfController property is now weak. Update your code to use notifications if you previously relied on KVO.
*  NavigationBar/ScrobbleBar are now rasterized before a fade out/fade in, which improves the fade animation (no more bleed-through)
*  Annotation Toolbar now in all cases correctly adapts to statusbar frame size changes (calling, personal hotspot, ...)
*  Improves compatibility with writing PDF trailer data with certain corrupt PDF files.
*  Adds new helper: PSPDFAddLocalizationFileForLocale, parses a localization text file.
*  Fixes an UX issue where the annotation tool could be deselected when using the two-finger scroll while the annotation toolbar is active and a tool (e.g. highlight is selected).
*  Fixes a touch inconsistency where a annotation deselection could be done without marking the touch as processed.
*  Fixes several entries in the localization table.
*  Fixes a regression introduced in 2.8.1, a potential crash when using the highlight annotation tool outside of a glyph.
*  Fixes a potential crash in the search view controller due to invalid state handling.
*  Fixes an issue where part of the drawing state was lost when opening a modal controller while in drawing mode. (e.g. iPhone/color picker)
*  Various typos fixed, and some very minor API changes due to spelling corrections (thanks to Tony Tomc).

__v2.8.1 - 6/February/2013__

*  The highlight tool now matches full words. A single touch will highlight the complete word instead of just one character.
*  A new syntax for link annotations to control UI. For now pspdfkit://control:outline is supported to open the TOC directly from the document.
*  The signature controller now uses "Signatures" as title instead of "Choose Signature" on iPhone, since later was too long and got cut off.
*  Fixes an issue where setFileURL: could generate a new UID if one was already set.
*  Fixes an UI issue when resizing an annotation purely horizontally would result in no redraw.
*  Fixes an UI issue where the thumbnail indicator could move behind the thumbnail image in some cases.
*  Fixes an UI issue in PSPDFFixNavigationBarForNavigationControllerAnimated() that could potentially shift down the navigationBar for unusual view controller setups.
*  Fixes an UX issue where a second tap was sometimes required after using certain modes in the annotation toolbar.
*  Fixes an issue where an external PSPDFBarButtonItem would not update on iPhone.
*  Fixes an issue where videos played in a popover continued to play even after the popover was dismissed.
*  Fixes an issue where thumbnailSize could not be changed after the PSPDFViewController has been displayed.
*  Fixes an issue with incorrect view controller locking after switching from highlight to draw mode in the annotation toolbar.

__v2.8.0 - 5/February/2013__

*  Image annotations. PSPDFKit can now add images from the camera and the photo library and embedd them as stamp annotations.
*  Search / Text extraction is now more than twice as fast and reports the current page.
*  The whole AP stream generation system has been improved and performance optimized to allow bigger streams like images.
*  PSPDFKit will now require Xcode 4.6/SDK 6.1 to compile. (4.5 should still work fine, but we follow Apple's best practice with always compiling with the latest SDK available.)
*  API change: editableAnnotationTypes is now an *ordered* set. Using a regular set to change this property will work for the time being, but please update your code. The order now will change the ordering of the buttons in the annotation toolbar and the new annotation menu.
*  Add experimental phone/link detection: detectLinkTypes:forPagesInRange: in PSPDFDocument. This will create annotations for phone numbers and links found in the document, if they are not linked already. This is the same that Preview/Mac and Adobe Acrobat do - they allow to click URLs even if they don't have any link set on them.
*  Search now displays the current processed page.
*  Further tweaks to PSPDFHighlightAnnotation highlightedString.
*  Add setting to enable/disable the "Customer Signature" feature. (customerSignatureFeatureEnabled in PSPDFSignatureStore)
*  The signature controller has now landscape as preferred rotation under iOS6. (but still supports portrait)
*  Controllers presented via the PSPDFViewController helper now use a custom PSPDFNavigationController that queries the iOS6 rotation methods of the topmost view controller. This makes it easier to customize rotation for PSPDF* controllers without hacks.
*  Performance improvement: deleted annotations now are no longer serialized if the external annotation format is used.
*  The "hide small links" feature now works better on iPhone.
*  FreeText annotations now parse even more font definition styles.
*  Improvements to the heursitic in PSPDFHighlightAnnotation highlightedString.
*  Annotations added via a modal view (e.g. Signatures on iPhone) are now also selected. (annotation selection is preserved during reloadData)
*  Smart zoom now uses less border when zooming into a text block, which looks better. (other columns usually are no longer visible)
*  Taps that dismiss an annotation editing popover no longer modify the HUD state.
*  The scrobble bar thumbnail size has been tweaked to be a little bigger. This now can also be fine-tuned, see PSPDFScrobbleBar.h.
*  The font selector now selects the currently chosen font.
*  Various performance improvements. (esp. search and the color picker)
*  Thumbnails are now sharper and always aligned to pixel grid (fixes a bug in UICollectionViewFlowLayout)
*  Text selection knobs are now pixel aligned as well.
*  When thumbnails are loaded from scratch, they are loaded in order. (PSPDFCache's numberOfConcurrentCacheOperations has been set to 1)
*  Fixes an UX issue where PSPDFKit could end up displaying something like '1 (1 of 2)' for page labels.
*  Fixes an UX issue where a tap wasn't set to being processed when the delegate delegateDidTapOnAnnotation:annotationPoint:... was being used.
*  Fixes an UIKit bug that in some cases froze the UIScrollView when we zoomed out programmatically (e.g. a double tap after already zoomed in)
*  Fixes a potential crash when saving NSData-based PDFs with a corrupt XRef table.
*  Fixes a rendering issue where some landscape documents were incorrectly scaled when using renderImageForPage:withSize in PSPDFDocument.
*  Fixes a regression that stopped the [popover:YES] option form working properly. (A formsheet was presented instead)
*  Fixes a regression in the 2.7.x branch that caused movies loaded in the PSPDFWebViewController to fail with the error "Plugin handled load".
*  Fixes an issue when using Storyboard and setting the viewState to thumbnails initially.
*  Fixes an issue where the signature selector controller dismissed the whole pdfController under certain conditions.
*  Fixes an issue with annotations moving to other pages on a document with multiple document providers.
*  Fixes an issue where the note view controller would hide the close button on iPhone if edit was set to NO.
*  Fixes an issue with frame displacement under certain conditions on embedded UINavigationControllers.
*  Fixes an issue with zooming when in text edit mode and page centering.
*  Fixes an issue with searching for certain characters that are reserved regex characters (like []()*+).
*  Fixes an encoding issue with annotation content and certain Chinese characters.

__v2.7.5 - 25/January/2013__

*  Signatures are now securely saved in the Keychain and a list of signatures is presented. To disable this feature, set PSPDFSignatureStore.sharedSignatureStore.signatureSavingEnabled = NO in your appDelegate.
*  While annotation mode is active (highlight, drawing, etc) scrolling is now enabled with using two fingers. The old behavior can be restored with setting allowTwoFingerScrollPanDuringLock in PSPDFAnnotationToolbar to NO.
*  PSPDFKit now requires Security.framework.
*  Fixes an issue that could cause an initial "white page" when the controller is first loaded, even when there's cache data available.
*  Fixes an UX issue where, with creating a new note, the menu could be displayed on iPhone, stealing the keyboard from the newly created note controller.
*  Fixes a regression of 2.7.4 that broke some remote videos/audios.
*  Fixes a potential issue when reordering bookmarks.
*  Fixes an issue where the last letter was cut off when using PSPDFHighlightAnnotation highlightedString.

__v2.7.4 - 24/January/2013__

*  Line annotations are now writeable.
*  A second tap now enables the edit mode in a free text annotation.
*  Annotation selection is now properly pixel aligned, resulting in sharper border, drag points and content - especially on the iPad Mini.
*  The drawing toolbar no longer forces the HUD to show before displaying itself.
*  If enableKeyboardAvoidance is set to NO, the firstResponder won't be tampered with anymore.
*  New property: allowToolbarTitleChange on PSPDFViewController, controls it title is set or not.
*  PSPDFOutlineParser now lazily evaluates named destinations if an outline has more than a specified threshold. (This is currently set to 500). This greatly improves loading times for documents with complex outlines.
*  Allow audio file types for RichMedia/Screen annotations.
*  Add more audio file formats to the support list. (aiff, cif, ...)
*  Ensure that addAnnotation:animated: in PSPDFPageView sets the page and documentProvider.
*  Better workaround for MPMoviePlayer's problem with multiple audio/video views on the same window. (A play button is now displayed in those cases)
*  Normalizes extracted text, allow searching within text that contains non-normalized ligatures.
*  Opacity menu now draws a checked white background instead of using the menu background (now it's more like Photoshop, looks better)
*  Add spanish translation (thanks to Tony Tomc!)
*  The maximum software dimming value is less dark.
*  Fixes a problem in PSPDFProcessor with NSData-based documents and adding annotation trailers.
*  Fixes a bug where the scrollview would update it's position when a UIAlertView with a TextField was visible.
*  Fixes a bug in the outline parser that resulted in the loop for (invalid) cyclid PDF referenced objects.
*  Fixes an issue where parsing certain PDF dates failed.
*  Fixes an issue with view state restoration and continuous scrolling.
*  Fixes a rare issue where the bookmark thumbnail view indicator could be behind the thumbnail image.
*  Fixes an issue with inline editing and the split screen keyboard.

__v2.7.3 - 20/January/2013__

*  FreeText annotations are now editable inline.
*  Improves stamp and signature rect placement (no longer places the rect outside of page boundaries)
*  Drawing overlay is now transparent. You can restore this behavior with subclassing PSPDFDrawView and setting the backgroundColor to [UIColor colorWithWhite:1.0 alpha:0.5].
*  When chaning the thickness of a drawing, the selection border will now automatically adapt itself to fit the new bounds.
*  Renamed "Colors..." menu entry to "Color...".
*  Fixes a potential issue with annotation rotation handling.
*  Fixes a potential crash on stamp creation on iPhone.
*  Fixes an issue where the drawing toolbar was added behind the HUD toolbar.
*  Fixes an issue where PSPDFKit could end up displaying something like 'Page 2-3 of 2'.
*  Fixes an issue where certain pages could be skipped with scroll to prev/nextPage in double page mode (via touching the borders).
*  Fixes some typos and spelling mistakes.

__v2.7.2 - 18/January/2013__

*  PSPDFScrollView will now move up if a keyboard is displayed.
*  Free Text annotation now have sensible defaults when created in code. (Helvetica, font-size 20)
*  Several tweaks for PSPDFProcessor PDF from web/office files generation.
*  Fixes a potential crash in the iPhone popover controller.
*  Fixes in the annotation selection handling logic.
*  Fixes a minor UX issue where Open In... could result in a second tap needed to activate.

__v2.7.1 - 17/January/2013__

*  Note annotation flattening.
*  Text selection is now always priorized over image selection.
*  For the continuous scrolling page transition, all visible pages are now animated when showing/hiding the thumbnail view.
*  Improve PDF serialization of custom stamp annotations.
*  Fixes an animation issue with continuous scrolling.
*  Fixes an UI issue where under certain conditions a second tap was required on a toolbar button to hide the active popover.
*  Fixes an UI issue with creating note annotations.
*  Fixes an issue where annotation resizing was disabled when textSelectionEnabled was set to NO.
*  Fixes a rounding bug in continuous scrolling that could lead to a x AND y scrolling on zoomScale 1.0
*  Fixes several issues with certain RichMedia embedded video annotations.

__v2.7.0 - 16/January/2013__

*  PSPDFKit model classes now have a common base model class 'PSPDFModel' - allows to serialize/deserialize via JSON easily using externalRepresentationInFormat:.
   To get the JSON dictionary, use annotation externalRepresentationInFormat:PSPDFModelJSONFormat.
   (The old annotation serialization format is still supported for the time being)
*  PSPDFKit now requires AssetsLibrary.framework - if you're using PSPDFKit.xcproj or the source distribution, this is already been taken cared of. If you added the frameworks manually and get a linker error, make sure you are linking sAssetsLibrary.framework.
*  PSPDFMenuItem learned to show images in UIMenuController - this beautifies many of the annotation menus, images are now used for annotation types/colors where appropriate.
*  PSPDFKit has learned to write apperance streams. Currently they are emitted for Stamp and Ink annotations. This will help to further improve annotation compatibility with some apps that behave less standard compliant (like Adobe Acrobat/iOS, last tested version is 10.4.4, which doesn't show Ink annotations if they do not have an attached AP stream, even if this is invalid behavior according to the PDF spec. (GoodReader/Preview.app/Adobe Reader on the Mac don't require an AP stream and work in compliance to the spec.))
*  Annotation menus have been cleaned up a little, Opacity... has been moved into a submenu of Color for highlight annotations.
*  PSPDFProcessor has learned to write annotations as dictionary, not only flatten. This will be used e.g. for Open In... when the original PDF is not writeable and thus annotations are saved in an external file.
*  Open In... will now create a new file if there are annotations and the source PDF is not writeable itself.
*  Stamp annotations now have limited support for appearance streams.
*  Stamp annotations can now be added via the new PSPDFStampViewController.
*  Add experimental pageRange feature in PSPDFDocument to allow showing of a subset of the pages.
*  Highlight annotation hit testing is now more accurate, checking the specific rects of the highlights, not the outer boundingBox.
*  Annotation rendering now checks if the annotation will be visible at all and only then renders the annotation. This speeds up zooming on complex documents with many annotations.
*  Improves search by ignoring certain whitespace characters like no-break-spaces.
*  Allows to create password protected PDFs with PSPDFProcessor up to AES-128 (and mix other CGPDFContext properties like kCGPDFContextAllowsPrinting or kCGPDFContextAllowsCopying)
*  Improves word detection with splitting words between a line of thought and adding special logic for non-default whitespace characters.
to use the old behavior.
*  Improves french translation.
*  zIndex of annotation images is now below zIndex of links, so that links are always displayed before annotation images.
*  Email sending using PSPDFEmailSendMergedFilesIfNeeded will not perform a merge if there is only one source document.
*  Links are now handled even if they are overlapped or hidden underneath other views.
*  Hides the page label and the scrobble bar if the document is password protected and not yet unlocked.
*  PSPDFAnnotation now shows if an appearanceStream is attached.
*  PSPDFAnnotation now as a userInfo dictionary to add any custom data.
*  Annotations now have a creationDate.
*  When note annotations are tapped, don't fade-animate the former annotation out.
*  Page label will not be displayed if the page label is simply the real page number. (Prevent titles like 2 (2 of 10))
*  The internal web browser will now display an error within the HTML, much like Safari on iOS: https://twitter.com/steipete/status/287272056524001280
*  Selected images now have a (default iOS light blue) selection state, matching the selection behavior of glyphs.
*  Brightness control now has indicator images for less/more brightness and a better icon.
*  Improves performance for pages with many links by dynamically disabling the rounded corners in that case.
*  External PDF links can now be opened modally in a new controller, use [modal:YES] in the option field, e.g. pspdfkit://[modal:YES]localhost/two.pdf#page=4.
*  Video extension with a cover now no longer has a dark background and is transparent. If you set cover:YES it will simply show the play button without any background.
*  API change: Words are now detected if they are completely within the rect specified. Use kPSPDFObjectsTestIntersection
*  API change: OutlineElement.page is now 0-based, not 1-based.
*  API change: Several PSPDFProcessor methods now have an additional error part.
*  API change: PSPDFInkAnnotation has been simplified, will automatically recalculate bounding box and paths on line change.
*  API change: Setting the annotation color will now also set the alpha value, if one is set in color.
*  API change: objectsAtPoint: now automatically does an intersection test unless specified otherwise, but objectsAtRect will not, so you need to specify that. Also, in previous version the rect check was done incorrectly to check if the test rect is within the object, now we check if the object is within the test rect OR intersects with it, if intersection is set to YES.
*  API change: Links to external files now reference the page, not page+1. (pspdfkit://localhost/two.pdf#page=4 will move to page 4, before it was page 5)
*  Add support for older PDF standard of defining Dest arrays for page links (for example those produced by LaTeX with PDF version 1.3)
*  Annotation option parsing is now more robust and will tolerate whitespace.
*  Annotation text (and thus the annotation menu) is now even displayed if editableAnnotationType is set to NO.
*  Adds a workaround for certain PDFs with large embedded videos that previously couldn't be parsed.
*  PSPDFKit now uses OS_OBJECT_USE_OBJC instead of OS version checking to check of GCD objects are collected via ARC or not (This is iOS6 only and the new default, can be disabled by the compiler)
*  Text in the password view is now viewable on iPhone in landscape.
*  Fixes an issue with font caching on search and certain documents.
*  Fixes an off-by-one error on writing link annotations that link to internal pages.
*  Fixes an issue with the "Save To Camera Roll" feature and iOS6 - the required rights are now checked fore before writing the image, and an error dialog is displayed for the user in case image saving failed.
*  Fixes an issue where PDF images in CMYK format could not be saved to the Camera Roll.
*  Fixes an issue where PSPDFTabbedViewController failed to show the tab bar if restoreState wasn't called and thus the documents array was nil.
*  Fixes an issue with opening internal html links on PDF link annotations on the device (worked fine on the Simulator)
*  Fixes an issue where the cancel button of the search controller was disabled sometimes (iPhone only)
*  Fixes an issue where under certain conditions link annotations were marked as dirty right after reading them from the PDF which could result in some slowdown when hiding the PSPDFViewController.
*  Fixes a crash with LifeScribe PDF documents when there's an embedded video annotation.
*  Fixes a weird potential crashing issue where setting the controlStyle of the MPMoviePlayerController could throw an exception (which is not documented and should not happen according to the MPMoviePlayer documentation).
*  Fixes a bug that prevented setting of the defaultColorPickerStyles.
*  Fixes an issue where the cover view of movie annotations showed outdated content in some cases.
*  Fixes a potential stack overflow when a PDF that had recursive XObjects with font informations was parsed.
*  Fixes an UIKit bug where the statusbar sometimes was placed above the navigationBar on certain occasions.
*  Fixes issue where certain isOverlay=YES annotations became unmovable after a save until the page had been changed.
*  Fixes issue where a highlight annotation was re-added to the backing store after a color change.
*  Fixes an issue where encryptImage:fromDocument: wasn't actually using the encrypted data.
*  Fixes an issue in the text extractor with parsing certain special formatted CMaps wit bfranges. This should especially help for text extraction errors in languages like turkish or chinese.
*  Fixes a missing setter for PSPDFLineAnnotation.
*  Fixes a retain cycle with PSPDFAnnotationToolbar because the delegate was retained.
*  Fixes a issue with AES-128 encrypted documents that failed to open with a "failed to create default crypt filter." error.
*  Fixes the delegate in the PSCAnnotationTestController (thanks to Peter Li)
*  Titanium: Fixes several issues and adding compatibility for Titanium 3, also added new searchForString(string, animated) and setAnnotationSaveMode(1) functions.

__v2.6.4 - 21/December/2012__

*  Note annotations now adapt itself to the zoomScale and are no longer scaled when zooming in.
*  Note annotation dragging has been unified with all other annotation types (Notes are now selectable as well)
*  Text/Note annotation popover is now less modal and allows one-touch clickthrough to other annotations and UI.
*  New annotationContainerView container in PSPDFPageView makes it easier to coordinate the zIndex of annotation views with your own custom views.
*  Add encryption/decryption block helper for PSPDFCache. (PSPDFKit Annotate feature)
*  Moved MFMailComposeViewControllerDelegate to PSPDFViewController (from PSPDFEmailBarButtonItem)
*  Annotations now have a new isResizable that controls if they can be resized or not.
*  With + (void)setDefaultColorPickerStyles: in PSPDFColorSelectionViewController the default color pickers can be configured easily. (e.g. disable the new HSV Picker)
*  Better support for annotation borders.
*  Improves performance for text extraction engine with cyclic XObjects.
*  No longer breaks between a word after a font ligature.
*  Properly sets the cropBox for each page in PSPDFProcessor.
*  Adds a fallback for weird URI encodings on link annotations.
*  No longer sets the title for the internal web browser if that is nil (show URL instead)
*  Fixes a bug on toolbar building with correctly adding the moreBarButtonItem when the first button is filtered.
*  Fixes an issue where the signature jumped to a different page when added to the right page in landscape mode.
*  Fixes an issue with the initialization of the continuous scroll mode (especially when using it within a childViewController)
*  Fixes an issue with text extraction on fonts that don't define any base encoding.
*  Fixes an issue where custom bookmark names were not correctly saved.
*  Fixes an issue with video rotation and iOS 5 - current page state is now preserved in all states.
*  Fixes a potential crash when annotations were written back that do not define any color information.
*  Titanium: Fixes issue with the didTapOnAnnotation callback and event.

__v2.6.3 - 17/December/2012__

*  New font picker for FreeText annotations.
*  Allow changing the text color of the free text annotation.
*  FreeText annotations will now persist the color state.
*  Supports more formats for textColor and fontName in free text annotation.
*  Selected annotations are now rendered in full resolution and no longer appear blurry when zoomed in.
*  Don't block double tap for selected annotations that are not movable (like text highlights)
*  After creating a note or a freetext annotation, the toolbar will be set to none. (to match iPad behavior)
*  Fixes color picker placement for annotations when zoomed all the way in.
*  Fixes various minor issues with annotation menu showing/placement.
*  Fixes a UI issue where the Open In... menu didn't disappear on tapping the button a second time.

__v2.6.2 - 16/December/2012__

*  New HSV color picker.
*  Color picker now selects the page where the color is selected, or the generic picker if none of the pallette colors matches.
*  Brightness control is now properly displayed within a custom popover on iPhone.
*  Highlight selection control now selects using the natural text flow, not just the selected rect. (Preview: https://twitter.com/PSPDFKit/status/279636900590006272)
*  Further improve document shadow for non-equal sized documents.
*  Undo/Redo buttons now have icons instead of text. (Annotation drawing toolbar)
*  Open In... now asks for flattening.
*  Print now optionally allows annotation printing.
*  Ensure documentProvider is always added when annotations are added.
*  Add support for annotation links like tel://4343434 and generally improves handling of external URLs.
*  Add support for PDF labels that have a offset and are plain numbered labels.
*  Fixed a rare condition where menus within UIMenuController could fail to execute their block target.
*  Fixes an issue where PSPDFNoteAnnotation sometimes used the wrong overrideClassNames dict for lookup.
*  Fixes a situation where pdfViewController:didDisplayDocument: wasn't called correctly.
*  Fixes issue where in pageCurl mode after selecting a new color on iPhone the drawing overlay vanished.
*  Fixes crash when trying to change highlight annotation type on long-tap.
*  Adds a workaround for an UIKit bug that only appears on iOS 5 with videos that are playing inline and have a incorrect frame after exit from fullscreen.

__v2.6.1 - 10/December/2012__

*  Video annotations can now have a specified offset. (e.g. offset=10) in seconds. Optional parameter.
*  PSPDFResizableView can now optionally be set in a way that it only allows moving, not resizing.
*  New toolbar style option in PSPDFViewController: useBorderedToolbarStyle. Will add regular bordered toolbar buttons. Optional.
*  tintColor can now be changed after the PSPDFViewController has been displayed.
*  Fixes an issue where video was autostarted even if autostart was set to NO.
*  Fixes an issue where the last toolbar item on the right toolbar could vanish if the style is bordered.
*  Fixes some issues regarding the textParser. More documents are now supported (especially with multiple nested XObject streams)
*  Fixes an issue where PSPDFStatusBarDisable could sometimes trigger statusbar showing/hiding.

__v2.6.0 - 9/December/2012__

*  New feature: Add signature. It's enabled by default. If you don't need it, set the editableAnnotationTypes on PSPDFDocument.
*  New Opacity... menu item for Ink and Highlight annotations. This can be disabled via the menu delegates (PSPDFViewControllerDelegate)
*  New Create Annotations menu after a long-tap on a space without text or image. This is now enabled by default. See createAnnotationMenuEnabled on PSPDFViewController.
*  Imoroved text block detection (this also improves smart zoom)
*  New convenience method defaultAnnotationUsername in PSPDFDocument. You should set this to the user name if you're using annotations.
*  DualPage display will now center pages vertically if they don't have the same aspect ratio, and will draw a nicer shadow spanning exactly both page rects.
*  PSPDFProgressHUD now has support to show a circular progress status. (Try the new Dropbox upload sample)
*  Exposes applicationActivities and excludedActivities in PSPDFActivityBarButtonItem.
*  Adds support for Web/Email URLs in the PDF Outline.
*  Adds a workaround for an UIKit bug that could result in an partly unresponsive scrollView when zooming out programmatically all the way to zoomLevel 1.0 (e.g. after tapping an already zoomed in text block, only affected the default pageTransition, only on device)
*  If only Highlighting is allowed (and not Underscore or Strikeout), the Type... menu option will be hidden (since there is no point one could change it to)
*  PSPDFScrobbleBar now has left/rightBorderMargin properties. (e.g. to make space to a custom button at one end)
*  Allows subclassing of PSPDFThumbnailGridViewCell via overrideClassNames.
*  Uses the shared alpha property for fillColor, to be compliant to the PDF standard. (mostly affects shape annotations)
*  Ensure annotation selection is cleared before a pageCurl transition starts.
*  Simplifies toolbar code by removing the copiedToolbar subclasses. (This should not affect your code at all, simply found a better way to trigger UIKit to refresh the image property)
*  Fixes a rare crash for parsing certain MMType1 PDF fonts.
*  Fixes an issue where the annotation toolbar could be overlayed by the underlying toolbar buttons when the toolbar (not navigtionBar) was updated afterwards.
*  Fixes an issue where the search highlighting was incorrectly applied on certain rotated documents.
*  Fixes a bug where under certain conditions the initial page set on the PSPDFViewController was ignored.
*  Fixes an issue where not rendered annotations where still selectable.
*  Fixes a situation where the PDF annotation user wasn't written unless contents was set.
*  Fixes an issue where the page offset for document providers sometimes was calculated incorrectly, this showing the wrong page labels.
*  Fixes a crash on iOS6 when viewMode was set to PSPDFViewModeThumbnails before the controller was actually displayed.
*  Fixes an issue where a late view frame change could result in an incorrectly rendered PDF view (black borders, could happen under certain conditions with Storyboarding)
*  Fixes a bug with using brightnessBarButtonItem on iPhone.
*  Fixes a situation where one could initiate a pageCurl during adding an annotation.
*  Titanium: Fixes an issue where setLinkAnnotationBorderColor would not work on the first page. Also adds support for "clear" color.

__v2.5.4 - 26/November/2012__

*  Makes PSPDFLinkAnnotation writeable and adds a new targetString method to customize the preview URL that is displayed on a long press annotation.
*  PDF link annotations are now editable. This is not added by default. Enable this by adding PSPDFAnnotationTypeStringLink to the editableAnnotationTypes of PSPDFDocument.
*  PSPDFAnnotation now parses and write the name (NM) property. (Optional, used to uniquely identift PDF annotations)
*  Exposes some new methods in PSPDFNoteViewController.
*  Expose PSPDFPageView's showLinkPreviewActionSheetForAnnotation:fromRect:animated to allow customization of the link preview sheet (invoked on long press)
*  Ensures that the minimum size of annotations is not smaller than the current size (to prevent weird resizing)
*  Fixes a potential wrong private API detection issue where "visibleBounds" was incorrectly flagged.
*  Fixes an issue where the search controller was sometimes misplaced when search was directly invoked from the selected text.
*  Fixes an issue where scrolling was disabled when setting a document delayed in scrollperpage mode after no document was set before.
*  Fixes an UI glitch where the page label background was blurry for certain conditions.
*  Fixes a rare issue where the background color of a link annotation could get stuck when using inter-document links.

__v2.5.3 - 24/November/2012__

*  Allows to render certain annotations as always overlay and still preserve movement features.
*  Fixes for text selection handling, especially for -90/270 degree rotated documents.
*  Fixes image selection rects for rotated documents.
*  Fixes a crash with searching certain arabic documents.
*  Fixes a one-pixel-bleedthrough in between the pages in dualPage / pageCurl mode.

__v2.5.2 - 22/November/2012__

*  New convenience helper: setUpdateSettingsForRotationBlock in PSPDFViewController. (e.g. to switch between pageCurl and scrolling on rotation)
*  Moves the logic that returns the default classes for supported annotations out of PSPDFFileAnnotationProvider into PSPDFAnnotationProvider - so if the annotationProvider is customized to use only custom annotation providers, annotations will still work.
*  Handles corrupt PDF more gracefully, failing faster (esp. important if you're using a custom CGDataProvider)
*  Search no longer searches between words (but between lines)
*  API: Renamed fixedVerticalPositionForfitToWidthEnabledMode to fixedVerticalPositionForFitToWidthEnabledMode.
*  Turned on a lot more warnings (like missing newlines.) PSPDFKit is now warning free even under pedantic settings.
*  Fixes a UX issue where sometimes a second tap was needed to show the bookmark view controller.
*  Fixes a crash when deleting bookmarks that has a custom name.
*  Fixes the delegate call pdfViewController:annotationView:forAnnotation:onPageView: (wasn't called before due to a typo in the selector check)
*  Fixes an issue with generating link annotations in code using the initWithType initalizer.
*  Fixes an issue where overrideClass wasn't checked for PSPDFWebViewController in one case.
*  Fixes an issue that could result in a non-rendered PSPDFPageView if the scrollView contentOffset was set manually without animation.
*  Fixes an issue where the text block detection could take a very long time on some documents.
*  Fixes an issue where a log warning was displayed when a highlight annotation was loaded from disk.
*  Fixes an issue where a low memory warning while editing annotation could lead to a non-scrollable document and/or a not saved annotation.
*  Fixes an issue where the keyboard was no longer displayed automatically for new text annotations on iPhone.
*  Fixes an issue where note/text annotations could be mis-placed when a document has a non-nil origin and a non-nil rotation value.

__v2.5.1 - 19/November/2012__

*  Dismisses the search bar keyboard at the same time the popover fades out, not afterwards.
*  Exposes some more methods on PSPDFAnnotationToolbar.
*  Fixes an issue with text selection being offset/invalid for certain documents (this change fixes A LOT of documents that previously had problems)
*  Fixes an issue with text encoding on some PDFs.

__v2.5.0 - 17/November/2012__

*  Images can now be selected and copied to the clipboard or saved to the camera roll. There's a new delegate to customize this.
*  A long-press on an annotation will switch over to edit-mode. Either moving if allowed, or showing the menu and cancelling the gesture if not.
*  Changes the default PDF Box back to kCGPDFCropBox. You can customize this with using the "PDFBox" property on PSPDFDocument.
*  Annotations can now be moved and resized, and the selection view is much sexier now (matches popular iOS apps like Pages)
*  Words are highlighted as they are being highlighted using the annotation toolbar.
*  Update color picker to include more colors and for better use space on iPhone 5 and iPad.
*  Default drawing color is now blue.
*  Highlight annotation color menu will now no longer show the currently used color and has a new option "Custom..." that will show the default color picker.
*  The options in PSPDFEmailBarButtonItem have been changed to a bit field, it's more flexible now. The flattenedAnnotations parameter is gone and is is now a subset of the bit field.
*  Annotation toolbar has now properties expoed for easy drawing color/width change.
*  Add initial implementation for stamp annotations (text and images are supported, no complex AP streams)
*  Support for "Named" PDF link annotations. (like NextPage/PrevPage/FirstPage/LastPage)
*  Add "Key" image for note annotations.
*  Add support for dashed borders on various annotation types.
*  PSPDFPageLabelView how shows a custom label for double page mode that displays all visible pages, not only the first. (2-3 of 42) instead of (2 of 42).
*  Refactoring of the search subsystem. Some methods have been renamed/deprecated. The interface is now much cleaner.
*  Search now search pages in the natural order, no longer visible pages first. You can revert this behavior change with setting searchVisiblePagesFirst to YES in PSPDFSearchViewController.
*  Search now also finds words that are split up via newline and/or a hyphenations character. This is enabled by default. See PSPDFTextSearch.compareOptions.
*  PSPDFSearchResult now has a PSPDFTextBlock as selection type (because it mighy have words on multiple lines). PSPDFSearchHighlightView now supports highlighting of multiple words.
*  Search now is more tolerant on single/double quotation marks.
*  Improves annotation toolbar animation for iPhone/landscape.
*  PSPDFHighlightAnnotation has a new helper "highlightedString" to get the string value of the highlighted area. Here, the document content is evaluated, since the annotation just contains CGRect values.
*  The annotation toolbar now remembers all last used colors per annotation type IF they are changed while the annotation toolbar is visible. (e.g. create yellow highlights, change annotation color to red, make new highlights -> red. But if you change color at a point where the annotation toolbar is closed, the color will not be remembered.)
*  PSPDFGlyph/PSPDFWord/PSPDFTextBlock frame now needs to be converted using the convertViewRectToGlyphRect/convertGlyphRectToViewRect to get the correct results.
*  New helper: PSPDFBezierPathGetPoints to convert UIBezierPaths into the representation needed in PSPDFInkAnnotation.
*  Adds some missing annotation change events.
*  A visible annotation toolbar will be removed when the viewController disappears.
*  Improved the performance of outline parsing and animation.
*  New HUD mode: PSPDFHUDViewAutomaticNoFirstLastPage - similar to PSPDFHUDViewAutomatic but doesn't show the HUD on the first/last page automatically.
*  Delegate didRenderPage:inContext: is now only called for current rendering. (not manual calls or cache)
*  PSPDFAnnotationToolbar now exposes cancelDrawingAnimated/doneDrawingAnimated to manually cancel/confirm a open drawing.
*  PSPDFSearchBarButtonItem, PSPDFOutlineBarButtonItem, PSPDFViewModeBarButtonItem can now also be overridden using overrideClassNames.
*  PSPDFOutlineParsers's isOutlineAvailable now parses the outline and always returns the correct value.
*  If the keyboard whas displayed on a PDF password prompt, that is now hidden again after the viewController is removed from the view.
*  A single paged document is now displayed centered on pageCurl transition mode (instead of right-aligned)
*  Adds the iPod touch (4G) to the list of old devices, because that one has Retina but only 256MB RAM.
*  Allows click-through selection of annotations that are on different pages. (before, you needed sometimes one extra-touch to hide the current selection)
*  PSPDFGlyph, PSPDFWord, PSPDFTextLine and PSPDFTextBlock can now be properly compared using isEqual.
*  The text selection is now hidden before the callout menu hides, not afterwards (to match default iOS behavior)
*  On the Thickness... menu, the option that is currently active is hidden.
*  The link selection touch-down gray is now less dark to better match Apple's default look.
*  The tinted popover background is now retina optimized and no longer draws an arrow outside of the rounded corner area.
*  Fixes a potential stack overflow when parsing really large PDF outlines (>3000 items).
*  Fixes an UI issue where the annotation toolbar active mode overlay wasn't updated on an annotation frame change.
*  Fixes an UI bug where note annotations could show with an outdated view (e.g. no color cange visible on page change)
*  Fixes a rare crash when searching certain documents.
*  Fixes a rare crash regarding ink annotation saving.
*  Fixes an issue where tapping on an empty HUD space would somtimes wrongly zoom out the view.
*  Fixes some minor issues with video cover.
*  Fixes some settings where didLoadPageView: was not called anymore.
*  Fixes a rare UIKit crash in UIPageViewController by adding a workaround.
*  Fixes a potential crash when hot-swapping the document from/to a 1-page document while using UIPageViewController in dual page mode.
*  Fixes an issue where the text selection menu sometimes wasn't correctly displayed on the right site of a zoomed in page in pageCurl mode.
*  Fixes a potential crash when a document was hot-swapped during a render operation.
*  Fixes a rare rendering issue with certain PDF documents that have weird rotation values.
*  Fixes an issue with the CMap parser where the second part of font ligatures was ignored. (See http://en.wikipedia.org/wiki/Typographic_ligature for details)
*  Fixes PSPDFProcessor's output of generatePDFFromDocument on rotated PDFs (documents had white border).
*  Fixes a issue where parsed text coordinates were offset on some non-standard PDFs that had both rotation and a non-null CropBox origin.

KNOWN ISSUE: Annotations can't yet be moved *between* pages. This feature is on our roadmap.

__v2.4.0 - 2/November/2012__

PSPDFKit now requires iOS 5.0+ and Xcode 4.5+ (iOS SDK 6.0) to compile. (Support for iOS 4.3/Xcode 4.4 has been removed, support for iOS 6.1 and Xcode 4.6b1 has been added.)

2.4 is a big release and a great new milestone of PSPDFKit. If you upgrade, make sure to read through the full header diffs to make sure methods you were calling/overriding still exist and are not moved.
Common methods like pageScrolling will always get a compatibility method for the time being. Methods/Properties are are deeper within the framework won't get a compatibility method, but it's usually pretty easy to figure out what the propert was named before. I am planning on working on PSPDFKit for a long time, and as the API evolves, it's sometimes necessary to clean up and rename things so that the API stays clean and logical.

*  Huge refactoring of PSPDFAnnotationParser. It's now much easier to add custom annotation providers (see PSPDFAnnotationProvider). If you have sublcassed saving/loading or other parts of PSPDFAnnotationParser, you most likely need to change this over to the new PSPDFFileAnnotationProvider.
*  Page scrolling is now even smoother. And finally removes the slight stuttering when pushing the PSPDFViewController - now animates like butter.
*  PSPDFShapeAnnotation can now be saved into the PDF.
*  Ink drawings can now customize the Thickness. Select an annotation and use the new "Thickness..." menu item.
*  Ink drawings and shape annotations can now also contain comment text.
*  Annotations now support the title/user "T" flag. Change the default user name by changing the property in PSPDFFileAnnotationProvider.
*  Add support for embedded and external RichMedia and Screen (Video) annotations of any size.
*  PSPDFBarButtonItem now has longPress-support. Long-Press on the bookmarkBarButtonItem to see the new PSPDFBookmarkViewController. Bookmarks can now also be renamed/reordered.
*  If there's no searchButton visible, the search invoked from the text selection menu now will originate from the selection rect.
*  The Open In... action now also works on multi-file documents and/or data/cgdocumentprovider based documents (will merge the document on-the-fly, shows a progress window if it'll take some time)
*  PSPDFBarButtonItem now also accepts a generic UIView as sender on presentAnimated:sender:. (makes it easier to manually call menu items from custom code)
*  Better support when barButtonItems are added to custom UIToolbars.
*  The internal used BarButtonItem subclasses are now exposed, so that they can be overridden and their icon changed.
*  New activityBarButtonItem to share pages to Facebook/Twitter on iOS6.
*  Double-Tapping on a video now enables full-screen (instead of zooming the page. This does not apply to YouTube movies)
*  Greatly improves handling of multiple video views on one page/screen.
*  Annotation views now have a optional xIndex. Video has a high index by default, so link annotations won't overlap a video anymore.
*  No longer allowing text selection above video annotations.
*  PSPDFDocument now has a new property 'PDFBox' to customize the used PDF box (ClipRect/MediaRect/etc).
*  PSPDFPositionView has been renamed to PSPDFPageLabelView. PSPDFPageLabelView and PSPDFDocumentLabelView are now easier skinable with the common superclass PSPDFLabelView.
*  PSPDFLabelView has now a second predefined style (PSPDFLabelStyleBordered)
*  PSPDFPageLabelView can now show a toolbar item. Check out the "Settings for a magazine" example how to enable this.
*  PSPDFLinkAnnotationView and the other multimedia annotation views can now be subclassed via overrideClassNames.
*  The Edit button for the text editor on note annotations can now be hidden. (showColorAndIconOptions)
*  UI: Moved the Edit button of the PSPDFNoteAnnotationController to the left side. (only visible for PSPDFNoteAnnotation)
*  Improves annotation parsing speed.
*  Shape/Circle annotations now correctly display their fillColor.
*  Improved color parsing for PSPDFFreeTextAnnotation (now honoring the default style string setting)
*  The icons in the viewModeBarButtonItem now have the same shadow as the toolbar icons (iPhone for now).
*  No longer displays annotation menus when they can't be saved (PSPDFKit Basic)
*  Expose outlineIntentLeftOffset and outlineIndentMultiplicator as properties on PSPDFOutlineViewController and PSPDFOutlineCell.
*  Exposes firstLineRect, lastLineRect and selectionRect on PSPDFTextSelectionView.
*  The text loupe now fades our correctly when in drag-handle-mode.
*  Improved caching of external resources like annotations/text glyphs on page init. Caching now won't overflow the dispatch queues anymore if A LOT of pages are loaded at the same time.
*  PSPDFWord now has a lineBreaker property to detect line changes.
*  PSPDFPageInfo now regenerates the pageRotationTransform when the pageRotation is changed manually.
*  PSPDFKit now checks if a URL can be handled by the system and weird/nonrecognizable URLS no longer open the "Leave Appliction" alert.
*  The PSPDFAnnotationBarButtonItem is now smart enough to choose the right animation depending if the toolbar is at the top/bottom (slide in/out from top/bottom)
*  Setting the UIPopoverController no longer removes preexisting passthroughViews.
*  The renderQueue now no longer renders the requested image if the delegate has been released in the mean time. (The delegate is now weak instead of strong)
*  UI: Undo/Redo buttons on the drawing toolbar are better placed on iPhone.
*  UI: The color selection button is now smaller on iPhone/Landscape.
*  API: PSPDFPageInfo is not calculated in PSPDFDocumentProvider. If you've overridden methods that affect PSPDFPageInfo in PSPDFDocument, you should move that code to a PSPDFDocumentProvider subclass.
*  API: "realPage" has been renamed to "page" and is now set-able. The old "page" has been renamed to "screenPage". This finally cleans up the confusion that has been around page and realPage. In 99% of all cases, you're just interested in page and can ignore screenPage. Please update your bindings accordingly. If you formerly did KVO on realPage, change this to page too. (There's a deprecated compatibility property for realPage, but not for the KVO event)
*  API: additionalRightBarButtonItems has been renamed to additionalBarButtonItems.
*  API: pageScrolling has been renamed to scrollDirection. A deprecated compatibility call has been added.
*  API: handleTouchUpForAnnotationIgnoredByDelegate has been moved to PSPDFAnnotationController.
*  API: pdfViewController has been renamed to pdfController on PSPDFTabbedViewController.
*  API: Warning! If you've used pspdf_dispatch_sync_reentrant in your own code, you now absolutely must create your dispatch queues with pspdf_dispatch_queue_create. Apple has deprecated dispatch_get_current_queue(), so we're now using a different solution. This will most likely affect you if you're using the "Kiosk" sample code of PSPDFCatalog.
*  Titanium: The pdfView now has a hidePopover(true) method so PSPDF popovers can better be coordinated with appcelerator code popovers.
*  Fixes the lag introduced in 2.3.x when tapping on the screen and the textParser hasn't been finished yet.
*  Fixes a potential crash when the view was removed on PSPDFKit Basic Titanium.
*  Fixes a potential crash when parsing the text of malformed PDFs.
*  Fixes a race condition during PSPDFFreeTextAnnotation drawing that could lead to a crash.
*  Fixes some issues with PSPDFPageScrollContinuousTransition when the document is invalid or view size is nil.
*  Fixes an issue where the background color of link annotations could get stuck.
*  Fixes an issue where PSPDFTabbedViewController did not properly align the tab bars in fullscreen mode.
*  Fixes an issue with creating PSPDFShapeAnnotation in code.
*  Fixes an issue where the isEditable flag on a PSPDFAnnotation was not honored when dragging note annotations.
*  Fixes an issue where the page could disappear on strong scrolling in pageCurl mode under iOS6.
*  Fixes an issue where scrolling on the tab bar (PSPDFTabbedViewController) sometimes didn't work.
*  Fixes an issue where the color picker was not properly displayed on bottom UIToolbars.
*  Fixes an UI issue where the selection and drawing of annotations on rotated pages was handled incorrectly.
*  Fixes an UI issue where the tabbed controller tabs could be mis-placed when rotating without visible HUD.
*  Fixes an UI issue where the thumbnails could slightly overlap the toolbar if the statusbar is transparent/auto-hiding.
*  Fixes several conditions where the PSPDFViewController could be deallocated on a background thread.
*  Fixes new warnings that popped up with Xcode 4.6. (pretty much all false positives)

__v2.3.4 - 18/October/2012__

*  Fixes a rare race condition that could lead to a deadlock on initializing PSPDFDocumentProvider and PSPDFAnnotationParser.

__v2.3.3 - 18/October/2012__

Note: This will be the last release that supports iOS 4.3*. The next version will be iOS 5+ only and will require Xcode 4.5+ (iOS SDK 6.0) If you're having any comments on this, I would love to hear from you: pspdfkit@petersteinberger.com
The binary variant is already links with SDK 6.0 and will not link with 5.1 anymore. (It still works down to iOS 4.3 though)

(*) There is no device that supports iOS 4.3 and can't be upgraded to iOS5, and PSPDFKit already dropped iOS4.2 and with it armv6 in 2.0.

*  PSPDFShapeAnnotation and PSPDFLineAnnotation can now be created programmatically.
*  New flag: kPSPDFLowMemoryMode that combines a lot of settings to ease memory pressure for complex apps.
*  Annotations now have a new flag: controls:false to hide browser/movie controls. If videos have controls disabled, they can be controled via gestures. (tap=pause, pinch=full screen)
*  Text loupe now also moves if it's not anchored on a PSPDFPageView. (fixes stuck loupe issue)
*  Fixes a regression on view point restoration that could restore the view point at a different position.
*  Fixes an issue where the annotation toolbar could lock up rotation even after being dismissed.
*  Fixes an issue where bookmarks were checked for pages that were not visible.
*  Fixes the needless log statement "Password couldn't be converted to ASCII: (null)".
*  Fixes a text loupe regression where the loupe was not rotated on modal controllers.
*  Fixes a issue where in rare cases the document label (default displayed on iPhone only) was offset by a few pixels.

__v2.3.2 - 17/October/2012__

*  The text loupe is now displayed above all other contents (navigation bar, status bar, …)
*  New status bar style: PSPDFStatusBarSmartBlackHideOnIpad, which now is also the new default (changed from PSPDFStatusBarSmartBlack). Will hide the HUD AND the statusbar on tap now both on iPhone and on iPad.
*  Improves Website->PDF conversion. Now supports Websites, Pages, Keynote, Excel, Word, RTF, TXT, JPG, etc... (see PSPDFProcessor. This is a PSPDFKit Annotate feature)
*  PSPDFKit now uses the MediaBox everywhere. Previously the CropBox was used for rendering, which can display areas that are only intended for printing. See http://www.prepressure.com/pdf/basics/page_boxes.
*  New additionalActionsButtonItem allows to mark where the additional actions menu should be placed on the toolbar. (Default is left next to the last rightBarButtonItem)
*  New initializer in PSPDFDocument that makes handling with single-file multiple-page documents much easier. (PDFDocumentWithBaseURL:fileTemplate:startPage:endPage:)
*  Add support for GoToR link annotations.
*  Add method to search for a specific page label. See PSCGoToPageButtonItem in PSPDFCatalog for an example how to use it. (DevelopersGuide.pdf has labels)
*  The page popover now shows the page label if one is set in the PDF (e.g. to replace numbers with roman numbering)
*  Links to the external applications (e.g. AppStore, Mail) are now detected and a alert view is displayed asking to open the application or not.
*  Add workaround for a UIKit issue in iOS5.x that would sometimes dismiss the keyboard when removing characters from the search view controller. (Issues has been fixed in iOS6)
*  Fixes a UI issue in search results. If a search result was found more than one time in a string, the first occurence was marked bold. Now the actual result is marked bold.
   (This was mostly noticable when searching for very small words)
*  Fixes a issue where too fast drawing could result in some lines now being displayed.
*  Fixes isLastPage/isFirstPage methods for landscape mode.
*  Fixes a issue where sometimes overrideClassNames for annotation was ignored.
*  Fixes a issue where the cache could return a wrong image in some rare cases.

__v2.3.1 - 11/October/2012__

*  Fixes a potential memory corruption with PSPDFAESCryptoDataProvider.

__v2.3.0 - 11/October/2012__

*  Experimental features: Add support to create PDF documents from html string or even a website.
*  Annotations now can be flattened before the document is sent via email. PSPDFEmailBarButtonItem has new options, and there is a new class PSPDFProcessor to generate new PDFs.
*  Outline elements that have no target page now no longer redirect to page 1 and will expand/collapse a section if there are child outline elements.
*  Add minimumZoomScale and setZoomScale:animated: to PSPDFViewController.
*  Glyphs that are outside of the page rect are now not displayed in the extracted text per default. You can restore the old behavior with setting PSPDFDocument's textParserHideGlyphsOutsidePageRect to YES.
*  Further tweaks for the iOS5 YouTube plugin version, ensure it's always correctly resized.
*  viewLockEnabled now also disables zooming with double tapping.
*  Don't show outline on search result if it's just one entry (most likely just the PDF name)
*  The keyboard of the note annotation controller now moves out at the same time as the popover dismisses (before keyboard animated out AFTER the popover animation)
*  Software dimming view now also covers the status bar.
*  Adding/Removing bookmarks now correctly hides any open popovers.
*  PSPDFCatalog: can now receive PDF documents from other apps.
*  PSPDFCatalog: added basic full-text-search feature across multiple documents.
*  Removed kPSPDFKitDebugMemory and kPSPDFDebugScrollViews.
*  API: renamed PSPDFSearchDelegate -> PSPDFTextSearchDelegate and added the PSPDFTextSearch class as parameter.
*  API: removes certain deprecated methods.
*  API: renamed kPSPDFKitPDFAnimationDuration to kPSPDFAnimationDuration.
*  Fixes possible inconsistency between displayed and used drawing color.
*  Fixes a race conditions when using appendFile: in PSPDFDocument and cacheDocument:startAtPage:size:.
*  Fixes a rotation issue when the annotation toolbar is displayed.
*  Fixes a issue where the popover of a ink annotation wasn't correctly sized.
*  Fixes a issue where the outline button was displayed when the document was invalid (instead of being hidden as expected)

__v2.2.2 - 5/October/2012__

*  Properly restore the PSPDFLinkAnnotationView backgroundColor.

__v2.2.1 - 4/October/2012__

*  The original backgroundColor of a PSPDFLinkAnnotationView is now preserved.
*  YouTube embedding now supported on iOS6.
*  Video embeddings with a cover image now don't show the cover if play has already been pressed after a page change.
*  Annotations now are cached much like UITableViewCells. (faster; preserve video state, etc)
*  Fixes a "sticky" scrolling issue that was introduced in 2.2.

__v2.2.0 - 4/October/2012__

*  New scrolling mode: PSPDFPageScrollContinuousTransition (similar to UIWebView's default mode)
*  Support text selection on rotated PDF documents.
*  UIPopoverController is now styleable with a tintColor. This is enabled by default if tintColor is set. Use .shouldTintPopovers to disable this.
   As long as you use presentViewControllerModalOrPopover:embeddedInNavigationController:withCloseButton:animated:sender:options: your custom popovers will be styled the same way.
*  Adds support for adding annotations for double page mode on the right page. (Note: drawing still isn't perfect)
*  Add new property renderAnnotationTypes to PSPDFViewController to allow control about the types of annotations that should be rendered.
*  Add support for PDF Link Launch annotations (link to a different PDF within a PDF, see http://pspdfkit.com/documentation.html#annotations)
*  Annotation selection is now smarter and selects the annotation that's most likely chosen (e.g. a small note annotation now is clickable even if it's behind a big ink drawing annotation)
*  It's now possible to properly select an annotation while in highlight mode.
*  Allow changing the drawing color using the menu. (invokes the color picker)
*  Add a isEditable property to be able to lock certain annotations against future edits.
*  Add printing support for small CGDataProviderRef-based PSPDFDocuments.
*  Improve OpenIn… feature, annotations are auto-saved before opening in another app and a log warning will be displated for incompatible document compositions.
*  The password in PSPDFDocument is now saved and will be relayed to any added file (e.g. when using appendFile)
*  Improved performance for outline and annotation parsing (up to 400% faster, especially for large complex documents with huge outlines)
*  Massively improved performance for search, especially for documents with many fonts.
*  Text loupe is faster; less delays on the main thread when waiting for a textParser (more fine-grained locking)
*  PSPDFViewController now saves any unsaved annotation data when app moves to background.
*  Add PSPDFBrightnessBarButtonItem and optional software-dimming to darken the screen all the way down to black.
*  PSPDFDocuments objectsAtPDFRect:page:options: now can also search for annotations and text blocks.
*  Smart Zoom is now even smarter and picks the most likely tapped text block if the detection shows multiple overlaying blocks.
*  Adds italian translation.
*  Restores PDF page label feature from v1.
*  removeCacheForDocument:deleteDocument:error: now also removes any document metadata files (bookmarks, annotations [if they were saved externally])
*  The cancel button in PSPDFSearchViewController can now be localized.
*  PSPDFKit now uses UICollectionView on iOS6, and PSTCollectionView on iOS4/5.
*  When annotations are deserialized from disk, the proper annotation subclasses set in document.overrideClassNames will be used.
*  Ensure annotation toolbar is closed when view controller pops.
*  Thumbnails no longer are layed out behind the tab bar if PSPDFTabbedViewController is used. (they now correctly align beneath the bar)
*  Add workaround for a UIKit problem where a UIPopoverController could be resized to zero on iPad/landscape when it's just above the keyboard.
*  Greatly reduced the black hair line that was visible in double page modes between the pages. Should now be invisible in most cases.
*  The last used drawing color is now saved in the user defaults.
*  The bookmark image is now saved proportionaly to the thumbnail image.
*  Ensures that for PSPDFTabbedViewController, tabs always have a title.
*  The close button added when using the presentModal: api of PSPDFViewController now uses the Done-button style.
*  API: bookmark save/load now exposes NSError object. Also new; clearAllBookmarks.
*  API: willStartSearchOperation:forString:isFullSearch: in PSPDFSearchOperationDelegate is now optional.
*  API: PSPDFDocument now implements PSPDFDocumentProviderDelegate and also is set as the default delegate.
*  API: PSPDFDocumentDelegate now has methods for didSaveAnnotations and failedToSaveAnnotations.
*  API: removeCacheForDocument:deleteDocument:waitUntilDone: is now removeCacheForDocument:deleteDocument:error: -
*  Fixes a rotation issue when the annotation toolbar is displayed use dispatch_async to make the call async..
*  API: tabbedPDFController:willChangeVisibleDocument: has been renamed to tabbedPDFController:shouldChangeVisibleDocument:
*  Fixes a bug where annotations were not saved correctly on multi-file documents when saving into external file was used. You need to delete the annotations.pspdfkit file in /Library/PrivateDocuments/UID to update to the new saving version (PSPDFKit still first tries to read that file to be backwards compatible)
*  Fixes freezing if there are A LOT of search results. They are not limited to 600 by default. This can be changed in PSPDFSearchViewController, see maximumNumberOfSearchResultsDisplayed.
*  Fixes a issue where similar PDF documents could create a equal UID when initialized via NSData.
*  Fixes "jumping" of the annotation toolbar when the default toolbar style was used.
*  Fixes calling the shouldChangeDocuments delegate in PSPDFTabbedViewController.
*  Fixes issue with rotation handling under iOS6.
*  Fixes a bug that prevented selecting annotations for documents with multiple files on all but the first file
*  Fixes a bug where the text editor sometimes could have a transparent background.
*  Fixes a toolbar bug when using UIStoryboard and modal transitions to PSPDFViewController.
*  Fixes a rare placement bug with the document title label overlay on iPhone.
*  Fixes a regression of 2.1 where search on iPhone sometimes didn't jump to the correct page.
*  Fixes issue with certain unselectable words.
*  Fixes always-spinning activity indicator when internal WebBrowser was closed while page was still loading. ActivityIndicator management now also can be customized and/or disabled.
*  Fixes a page displacement issue with pageCurl and the app starting up in landscape, directly showing a PSPDFViewController. (workaround for a UIKit issue; has been fixed in iOS6)
*  Fixes invalid page coordinates sent to didTapOnPageView:atPoint: delegate on right page in landscape mode.
*  Fixes a race condition where annotations could be missing on display after repeated saving until the document has been reloaded.
*  Fixes issue with word detection where sometimes words were split apart after the first letter on the beginning of a line.
*  Fixes viewState generation. (Was always using page instead of realPage which lead to errors when using landscape mode)
*  Fixes missing background drawing for shape annotations.
*  Fixes a issue where certain link-annotations did not work when using the long-press and then tap on the sheet-button way.
*  Fixes a rare bug where pages could been missing when reloading the view of the PSPDFPerPageScrollTransition in a certain way.
*  Fixes issue where viewLockEnabled was ignored after calling reloadData.

Known Issues:
*  Dragging note anotations from one page to another doesn't yet work.
*  Drawing across multiple pages doesn't yet work.


__v2.1.0 - 17/September/2012__

*  New: PSPDFAESCryptoDataProvider. Allows fast, secure on-the-fly decryption of AES256-secured PDF documents. (PSPDFKit Annotate feature)
   Unlike NSData-based solutons, the PDF never is *fully* decrypted, and this even works with very large (> 100MB) documents.
   Uses 50.000 PBKDF iterations and a custom IV vector for maximum security.
   Includes the AESCryptor helper Mac app to properly encrypt your PDF documents.
*  Allow to customize caching strategy per document with the new cacheStrategy property.
   This is automatically set to PSPDFCacheNothing when using PSPDFAESCryptoDataProvider.
*  Annotations now have a blue selection view when they are selected.
*  Add Black and Red to general annotation color options.
*  Font name/size for FreeText annotations is now parsed.
*  Added write support for FreeText annotations.
*  Allow to show/edit the associated text of highlight annotations.
*  Improves extensibility of the annotation system with adding a isOverlay method to PSPDFAnnotation.
   (Instead of hard-coding this to Link and Note annotations)
*  Moves the clipsToBounds call in PSPDFPageView so that delegate can change this (of UIView <PSPDFAnnotationView>).
*  Adds static helper [PSPDFTextSelectionView isTextSelectionFeatureAvailable] to make runtime checks between PSPDFKit and PSPDFKit Annotate.
*  Adds new isWriteable static method to PSPDFAnnotation subclasses to determine what classes can be written back to PDF.
*  Add kPSPDFAllowAntiAliasing as optional render option.
*  PSPDFOpenInBarButtonItem no longer performs a check for compatible apps. Checking this is pretty slow. An info alert will be displayed to the user if no compatible apps are installed (which is highly unlikely for PDF). You can restore the original behavior with setting kPSPDFCheckIfCompatibleAppsAreInstalled to YES.
*  The viewState is now preserved when another controller is displayed/dismissed modally. This mostly happend with showing/hiding the inline browser or the note text controller on an iPhone. After that the zoom rate was reset; this is now properly preserved.
*  The annotation toolbar now flashes if the user tries to hide the HUD while the bar is still active (and blocking that)
*  Various performance optimizations; especially scrolling and initial controller creation.
*  Removes sporadic vertical transition of the navigationController's navigationBar when HUD faded out.
*  Fixes "Persistent Text Loupe" when moving over a link annotation while selecting.
*  Fixes a memory leak when CGDataProviderRef is used to initialize a PSPDFDocument.
*  Fixes a issue where the UI could sometimes freeze for a while waiting for background tasks in low-memory situations.
*  Fixes a issue where the popover page display wasn't hidden after a rotation.
*  Fixes a issue where sometimes the page was not correctly restored after rotation (was +1).
*  Fixes a issue where, if email wasn't configured on the device, the internal web browser would be launched with a mailto: link. Now a alert is displayed.
*  Fixes a issue where a page could, under certain rare conditions, escape the page tracking and be "sticky" behind the new managed page views.
*  Titanium: Add saveAnnotation method to manually save annotations (needed for createView, automatically called in showPDFAnimated).
*  Titanium: Limit usage of useParentNavigationBar to iOS5 and above.
*  Titanium: fixes a rare condition where using document.password to unlock sometimes resulted in an incorrect value for isLocked.

__v2.0.3 - 14/September/2012__

*  Add a new "renderOptions" property to PSPDFDocument to fine-tune documents (e.g. fixes gray border lines in mostly-black documents)
*  Reduces file size of PSPDFKit.bundle by about 50%; improves speed of certain helper plists parsing.
*  Fixes potential category clashing
*  Fixes a bug that sneeked in because PSPDFKit is now compiled with Xcode 4.5. This release now also works with 4.4 for binary.

__v2.0.2 - 13/September/2012__

*  Support for iPhone 5, Xcode 4.5, armv7s and the new screen resolution.
*  Supports a new cover property to have a custom cover screen for videos (big play button; custom preview-images)
*  Don't show browse popover/actionsheet for multimedia extensions during a long press.
*  Don't allow long-press over a UIControl. (e.g. a UIButton)
*  Fixes a issue where soemtimes multimedia annotations would be added multiple times to the document.
*  Fixes a issue where sometimes you get blank space instead of a page when PSPDFPageRenderingModeFullPageBlocking and PSPDFPageScrollPerPageTransition was combined and the scrobble bar used heavily. This is a workaround for a UIKit bug.
*  Removes libJPGTurbo; Apple's own implementation has gotten faster (especially in iOS6)

__v2.0.1 - 12/September/2012__

*  Faster search (document pattern detection if deplayed until needed, outline results get cached)
*  Improved reaction time for complex PDF documents (e.g. annotations are only evaluated if they're already loaded; but won't lock the main thread due to lazy parsing)
*  Add additional checks so that even incorrectly converted NSURL-paths (where description instead of path has been called) work.
*  Fixes a issue where annotations were not saved with multiple-file documents on all but the first file.
*  Fixes problems where link annotations lost their page/link target after saving annotations into a file.
*  Fixes a problem where fittingWidth was always overridden when run on the iPhone.
*  Fixes a race condition in the new render stack that could lead to an assert in debug mode (non-critical)
*  Fixes the toolbar overlapping text issue in the PSPDFCatalog Kiosk Example; added comments how to work around that UIKit bug.
*  Made the pageRotation property of PSPDFPageInfo writeable; useful for manually rotation PDF documents.
*  Fixes some issues with the Titanium module; adds support for NavigationGroups.
*  Improved memory usage, especially on iPad1.

__v2.0.0 - 08/September/2012__

PSPDFKit v2 is a major updates with lots of changes and a streamlined API.
There are some API deprecations and some breaking changes; but those are fairly straightforward and well documented.

You need at least Xcode 4.4.1 to compile. (Xcode 4.4/4.5 both run fine on Lion, Mountain Lion is not needed but recommended)
PSPDFKit v2 is compatible with iOS 4.3 upwards. (armv7, i386 - thus dropping iOS 4.2/armv6 from v1)

The installation has been simplified. You now just drop the "PSPDFKit.embeddedframework" container into your project.
Next, enable the PSPDFKit.xcconfig project configuration. Here's a screenshot: http://cl.ly/image/1e1I2Z2e1D3F
(Select your project (top left), select project again in the PROJECT/TARGETS tree, select Info, then change in "Based on Configuration file" from None to PSPDFKit.)

If you have the sources and embedd PSPDFKit as a subproject, don't forget to also add PSPDFKit.bundle.


MAJOR NEW FEATURES:
*  Text selection! (PSPDFKit Annotate) (Includes Copy, Dictionary, Wikipedia support)
*  Annotations! (PSPDFKit Annotate) Highlight, Underscore, Strikeout, Note, Draw etc. Annotations also will be written back into the PDF.
   There is a new annptationBarButtonItem that shows the new annotation toolbar.
*  Smart Zoom (Text blocks are detected and zoomed onto on a double-tap; much like Safari)
   The PDF is now also dynamically re-rendered at *every* zoom level for maximal sharpness and quality.
*  Customizable render modes (enable/disable use of upscaled thumbnails). PSPDFPageRenderingModeFullPageBlocking is great for magazines.
*  Greatly improved Search. Faster, parses more font styles, compatible with international characters (chinese, turkish, arabic, ...)
*  Site Bookmarks (see bookmarksBarButtonItem and PSPDFBookmarkParser)
*  Support for VoiceOver accessibility (yes, even within the PDF!)

Further, PSPDFKit has been improved in virtually every area and a lot of details have been tweaked.

*  Inline password view. (Before, just a empty screen was shown when document wasn't unlocked.)
*  Adobe DRM detection (They are just marked as not viewable, instead of showing garbage)
*  PDF rendering indicator. (see pdfController.renderAnimationEnabled)
*  Even better view reuse. PSPDFPageView is now reused, scrolling is even smoother.
*  PSPDFDocument can now be initialized with a CGDataProviderRef or a dataArray.
*  The search/outline controllers now dynamically update their size based on the content height.
*  The Table of Contents/Outline controller now shows titles in multiple lines if too long (this is customizable)
*  Support for Table Of Contents (Outline) linking to external PDF documents.
*  Page Content/Background Color/Inversion can now be changed to modify rendering.
*  On the iPhone, a new documentLabel shows the title. (the navigationBar is too small for this)
*  PSPDFScrobbleBar now uses the small height style on iPhone/Landscape.
*  PSPDFViewController can now programatically invoke a search via searchForString:animated:.
*  PSPDFViewController now has a margin and a padding property to add custom margin/padding on the pdf view.
*  PSPDFViewController now has a HUDViewMode property to fine-tune the HUD.
*  PSPDFTabbedViewController now has a minTabWidth property (defaults to 100)
*  It's now possible to pre-supply even fully-rendered page images. PSPDFDocument's thumbnailPathForPage has been replaced with cachedImageURLForPage:andSize:.
*  PSPDFDocument now has a overrideClassNames dictionary, much like PSPDFViewController.
*  PSPDFDocument now has objectsAtPDFPoint/objectsAtPDFRect to return found glyphs and words.
*  PSPDFDocument now has convenience methods to render PDF content. (renderImageForPage:withSize:.../renderPage:inContext:...)
*  PSPDFDocument now exposes some more common metadata keys for the PDF metadata.
*  PSPDFDocument now has convenience methods to add and get annotations (addAnnotations:forPage:)
*  PSPDFDocument now has a property called annotationSaveMode to switch between PDF annotation embedding or an external file.
*  Support for documents with multiple sources(files/dataArray/documentProvider) is now greatly improved due to the new PSPDFDocument/PSPDFDocumentProvider structure.
*  PSPDFPageView now has convenience methods to calculate between PDF and screen coordinate space (convertViewPointToPDFPoint/convertPDFPointToViewPoint/etc)
*  PSPDFPageView no longer uses CATiledLayer; this has been replaced by a much faster and better custom solution.
*  PSPDFScrollView no longer accepts a tripple-tap for zooming out; this was a rarely-used feature in iOS and it increased the reaction time for the much more used double tap.
   Zooming in/out is now smarter (smart zoom) and does the right thing depending on the zoom position.
*  PSPDFWebViewController now supports printing.
*  A long-press on a PDF link annotation now shows the URL/Document/Page target in a popover.
*  When switching between DEMO/FULL; the change is automatically detected and the cache cleared. (No more watermark problems)
*  The image annotation view now properly displays and animates animated GIFs.
*  GMGridView has been replaced by the new and better PSCollectionView, which is a API compatible copy of UICollectionView.
*  Internal modernization; literals, subscripting, NS_ENUM, NS_OPTIONS.
*  Better internal error handling; more functions have error parameters.

Fixes/API changes:

*  The navigationBar title is no longer set on every page change.
*  PSPDFDocument's PDFDocumentWithUrl has been renamed to PDFDocumentWithURL.
*  Delegates are now called correctly (only once instead of multiple times) in pageCurl mode.
*  pdfViewController:willShowController:embeddedInController:animated: has been changed to (BOOL)pdfViewController:*SHOULD*ShowController:embeddedInController:animated:
*  tabbedPDFController:willChangeDocuments has been renamed to tabbedPDFController:shouldChangeDocuments.
*  New delegate: - (void)pdfViewController:(PSPDFViewController *)pdfController didEndPageDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset -> completes dragging delegates; zooming delegates were already available in PSPDFKit v1.
*  Changed willShowController... delegate to shouldShowController... that returns a BOOL.
*  Fixes a problem in the annotation parser where some named page links failed to resolve properly.
*  Fixes a problem where the Cancel button of the additionalBarButtonItem menu wasn't fully touch-able on iPhone.
*  Fixes a problem with PSPDFBarButtonItem image updating.
*  Lots of other minor and major changes.


__v1.10.5 - 1/Aug/2012__

*  Add a workaroung for unusable back buttton in a certain unreleased version of iOS. (This is most likely a temporal iOS bug)
*  Improve PSPDFCloseBarButtonItem to be context-aware if we should close a modal view or pop from the navigation stack.
*  Fixes a issue where zooming was difficult on pages with lots of PDF link annotations.
*  Fixes two harmless warnings with Xcode 4.4.
*  Fixes the delete all tabs action sheet in the TabbedExample on iPhone.
*  Fixes a certain issue with embedding PSPDFViewController.
*  Fixes a rare memory leak when image decompression fails.

__v1.10.4 - 12/Jul/2012__

*  New delegates: shouldScrollToPage, resolveCustomAnnotationPathToken.
*  If annotation is set to a file and this file doesn't exist, annotation type will be set to undefined.
*  Improve tap change speed and touch area of PSPDFTabbedViewController.
*  Another possible bugfix for UIPageViewController rotation changes.
*  Don't change navigationController if embedded into a parentViewController on default. (See useParentNavigationBar).
*  Allow to subclass PSPDFPageView via the overrideClassNames property in PSPDFViewController.
*  Allow parsing of PDF outlines with party invalid information.
*  Removed preloadedPagesPerSide. Changing this turned out to not bring any noticable performance benfits.
*  Fixes a case where some link annotations were not correctly parsed.

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
