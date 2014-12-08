//
//  LibraryExample.swift
//  SwiftExample
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

import Foundation
import PSPDFKit

class LibraryExample : NSObject {

    func indexDocuments () {
        let library = PSPDFLibrary.defaultLibrary()
        let fileURL = NSBundle.mainBundle().bundleURL.URLByAppendingPathComponent("Samples/PSPDFKit QuickStart Guide.pdf")
        let document = PSPDFDocument(URL: fileURL)
        library.enqueueDocuments([document])

        // Indexing is async, we could use notifications to track the state,
        // but for this example it's easy enought to just delay this for a second.
        dispatch_after(1, dispatch_get_main_queue(), {
            library.documentUIDsMatchingString("pdf", options: nil, completionHandler: nil) { (searchString : String!, resultSet : [NSObject : AnyObject]!) -> Void in
                println("For \(searchString) found \(resultSet)")
            }
        })
    }
}