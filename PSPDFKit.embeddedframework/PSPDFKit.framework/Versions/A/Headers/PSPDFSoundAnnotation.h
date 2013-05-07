//
//  PSPDFSoundAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFLinkAnnotation.h"

/// A sound annotation (PDF 1.2) shall analogous to a text annotation except that instead of a text note, it contains sound recorded from the computer’s microphone or imported from a file.
@interface PSPDFSoundAnnotation : PSPDFLinkAnnotation

/// The sound icon name.
@property (nonatomic, copy) NSString *iconName;

/// URL to the file content.
@property (nonatomic, strong) NSURL *URL;

@end
