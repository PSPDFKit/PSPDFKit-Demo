# PSPDFKit - A drop-in-ready framework that helps in almost every aspect of PDF-rendering on iOS

PSPDFKit is a heavily optimized framework for displaying PDF files with horizontal scrolling.  
It is fast, flexible, has intelligent caching and renders pages usually faster than iBooks.

*Amazingly easy to use and impressive PDF performance - closest thing to iBooks so far.* -- [Martin Reichart, iOS Developer](http://twitter.com/martinr_vienna/status/95823509506359296)

If you just need a Quick'n'Dirty way to display PDF, use Apple's QuickLook. (Example included)  
If you need something faster, with more control, thumbnails, search, etc - PSPDFKit is for you.

PSPDFKit is fully compatible with iPhone/iPad on iOS4 and iOS5, works with classical retain/release or ARC.

__[Check out the homepage for a screencast, purchase informations and the full feature list](http://pspdfkit.com)__

# You can purchase a license and the full source code at http://pspdfkit.com.

[![PSPDFKit](http://pspdfkit.com/images/header.png)](http://pspdfkit.com)

Features
--------
* Single or double page view support, including automatic mode that changes on landscape switch.

* Multimedia Annotations (link annotations that start with pspdfkit://, supporting video, audio and web pages)
* PDF Outline/Table Of Contents parsing & display.
* Annotations support (Page Links, Web Links).
* Optional setting to show first page in single mode, everything else in two pages. (magazine style)
* Beautiful side page sliding, with shadow & gap between pages.
* Pinch to Zoom / Double Tap to to zoom in and out.
* Tap right for next page, Tap left for previous page.
* HUD that shows/hides on tap.
* Fast Thumbnail extraction, grid display and caching.
* Want even more speed? Preprocessed Thumbnails can be provided, per document setting.
* Intelligent caching features - you control how much should be cached.
* Automatic page sizing via PDF crop-box metadata. Multiple aspect-ratios per document supported.
* PDF text extraction for full text search. 
* Delegates to fine-control pdf display, with callbacks for custom overlays.
* Logical PDF container, lets you combine multiple PDFs into one big pdf.
* Fully customizable interface: You can disable features like search, thumbnails or the whole HUD and replace it with your own.
* Highly Multi-Threaded. Grand Central Dispatch is used throughout the framework to ensure maximum speed, and use every core available.

Integration
-----------
You can either integrate PSPDFKit as a drop-in framework or just drag the static library project into Xcode (don't forget to add it as a dependency and library).

Open the PSPDFViewController with a simple call:

``` objective-c
// create the PSPDFDocument (container for one or multiple PDFs)
NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Sample.pdf"];
PSPDFDocument *document = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:path]];

// open view controller
PSPDFViewController *pdfController = [[[PSPDFViewController alloc] initWithDocument:magazine] autorelease];
[self presentModalViewController:pdfController animated:YES];
```

See MinimalExample for a working demo. You need at least CoreText.framework, QuartzCore.framework, MessageUI.framework, libz.dylib, ImageIO.framework, CoreMedia.framework, MediaPlayer.framework, AVFoundation.framework, and the linker flag -ObjC.

Logging
-------
The log level can be set at runtime, from anywhere in your project. The default log level is PSPDFLogLevelError.

``` objective-c
kPSPDFKitDebugLogLevel = PSPDFLogLevelInfo;
// Available Log Levels: PSPDFLogLevelNothing, PSPDFLogLevelError, PSPDFLogLevelInfo
```

Example Project Features
------------------------
* Two minimal examples, with ARC and with classical retain/release.

* Full featured magazine kiosk app.
* Large file download support, even continues in the background.
* Loads magazines from document folder and displays them in an animated grid.
* Shows how you extend and implement all features of PSPDFKit.
* Lets you play around with the cache settings.

* Embedding Example (how to use PSPDFKit within another UIViewController)

PSPDFKit.framework includes the compiled static library for armv6, armv7 and i386.

Licensing
---------
This is example code to show you the features of PSPDFKit.  
You need a license if you want to distribute this within your application, see [License.md](https://github.com/steipete/PSPDFKit-Demo/blob/master/LICENSE.md) for details.  

[Click here to purchase a commercial license with full source code](http://pspdfkit.com/purchase.html)

PSPDFKit uses 3rd-party code, see [ACKNOWLEDGEMENTS](https://github.com/steipete/PSPDFKit-Demo/blob/master/ACKNOWLEDGEMENTS) for contributions.

Screenshots
-----------

![Kiosk Example](http://f.cl.ly/items/2E470I2U172u1W3m1v2j/pspdfkit1.png)
Grid view of example kiosk app.
  

![Dual Page Mode](http://f.cl.ly/items/3B1i3w1f202E1F3R2O18/pspdfkit2.png)
Dual Page mode.
  

![Thumbnails](http://f.cl.ly/items/421N2M000A2W3245041c/pspdfkit4.png)
Thumbnail Grid.
  

![Single Page](http://f.cl.ly/items/1h1E462k352E43050a1K/pspdfkit5.png)
Single Page View.
  

![Single Page Scrolling](http://f.cl.ly/items/070p2Q1R020S25010X3C/pspdfkit6.png)
Single Page View while scrolling. (Shadow, Gap)
