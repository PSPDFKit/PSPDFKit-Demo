//
//  PSCCustomLinkAnnotationView.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCCustomLinkAnnotationView.h"

@implementation PSCCustomLinkAnnotationView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        self.highlightBackgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5f];
    }
    return self;
}

@end
