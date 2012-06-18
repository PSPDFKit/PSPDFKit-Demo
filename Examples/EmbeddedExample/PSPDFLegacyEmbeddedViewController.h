//
//  PSPDFLegacyEmbeddedViewController.h
//  EmbeddedExample
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

// Shows the iOS4-way of integrating a UIViewController as a childViewController.
// If you can, use the iOS5 way. Much better, less error phrone, less code.
@interface PSPDFLegacyEmbeddedViewController : UIViewController

@property(nonatomic, strong) PSPDFViewController *pdfController;

@end
