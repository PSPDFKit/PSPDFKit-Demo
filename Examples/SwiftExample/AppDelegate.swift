//
//  AppDelegate.swift
//  SwiftExample
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

import UIKit
import PSPDFKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()

        // Custom apps will require either a demo or commercial license key from http://pspdfkit.com
        PSPDFKit.setLicenseKey("YOUR_LICENSE_KEY_GOES_HERE")

        let fileURL = NSBundle.mainBundle().bundleURL.URLByAppendingPathComponent("Samples/PSPDFKit QuickStart Guide.pdf")
        let document = PSPDFDocument(URL: fileURL)
        let configuration = PSPDFConfiguration  { (builder) -> Void in
            builder.thumbnailBarMode = .Scrollable;
        }
        let pdfController = PDFViewController(document: document, configuration: configuration)

        self.window!.rootViewController = UINavigationController(rootViewController: pdfController)
        self.window!.makeKeyAndVisible()

        // Example how to use the library and start background indexing.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            let libraryExample = LibraryExample()
            libraryExample.indexDocuments()
        })

        return true
    }
}

