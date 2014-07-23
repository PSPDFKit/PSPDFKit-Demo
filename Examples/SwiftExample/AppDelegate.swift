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

        var fileURL = NSBundle.mainBundle().bundleURL.URLByAppendingPathComponent("Samples/PSPDFKit QuickStart Guide.pdf")
        var document = PSPDFDocument(URL: fileURL)
        var pdfController = PDFViewController(document: document)
        pdfController.thumbnailBarMode = .Scrollable

        self.window!.rootViewController = UINavigationController(rootViewController: pdfController)
        self.window!.makeKeyAndVisible()
        return true
    }
}

