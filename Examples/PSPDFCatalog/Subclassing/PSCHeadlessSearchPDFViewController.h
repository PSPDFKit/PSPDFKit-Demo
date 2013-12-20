//
//  PSCHeadlessSearchPDFViewController.h
//  PSPDFCatalog
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

/// Example how to have a "persistent" search mode.
@interface PSCHeadlessSearchPDFViewController : PSPDFViewController <PSPDFViewControllerDelegate>

@property (nonatomic, copy) NSString *highlightedSearchText;

@end
