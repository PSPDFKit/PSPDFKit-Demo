# PSPDFKit Changelog

Subscribe to updates: [RSS](https://github.com/PSPDFKit/PSPDFKit-Demo/commits/master.atom) | [Twitter](http://twitter.com/PSPDFKit)

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
