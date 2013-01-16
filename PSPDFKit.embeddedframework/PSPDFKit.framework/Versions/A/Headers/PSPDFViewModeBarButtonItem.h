//
//  PSPDFViewModeBarButtonItem.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFBarButtonItem.h"

@interface PSPDFViewModeBarButtonItem : PSPDFBarButtonItem

@property (nonatomic, strong, readonly) UISegmentedControl *viewModeSegment;

@end
