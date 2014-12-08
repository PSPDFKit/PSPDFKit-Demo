//
//  PDFViewController.swift
//  SwiftExample
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

import UIKit
import PSPDFKit

class PDFViewController: PSPDFViewController, PSPDFViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    // MARK: PSPDFViewControllerDelegate
    
    func pdfViewController(pdfController: PSPDFViewController!, didLoadPageView pageView: PSPDFPageView!) {
        println("Page loaded: %@", pageView)
    }
}
