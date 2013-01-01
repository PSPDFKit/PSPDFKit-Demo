//
//  PSCCustomLinkAnnotationView.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
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
