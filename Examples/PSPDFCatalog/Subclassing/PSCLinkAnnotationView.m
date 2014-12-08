//
//  PSCLinkAnnotationView.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCLinkAnnotationView.h"

@implementation PSCLinkAnnotationView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    }
    return self;
}

@end
