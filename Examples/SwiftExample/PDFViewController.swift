//
//  PDFViewController.swift
//  SwiftExample
//
//  Created by Peter Steinberger on 21/06/14.
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//

import UIKit
import PSPDFKit

class PDFViewController: PSPDFViewController, PSPDFViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    // PSPDFViewControllerDelegate

    func pdfViewController(pdfController: PSPDFViewController!, didLoadPageView pageView: PSPDFPageView!) {
        println("Page loaded: %@", pageView)
    }
}
