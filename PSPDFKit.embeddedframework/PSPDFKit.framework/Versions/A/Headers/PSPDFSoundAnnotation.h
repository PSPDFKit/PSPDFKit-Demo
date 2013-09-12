//
//  PSPDFSoundAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFLinkAnnotation.h"

/// A sound annotation (PDF 1.2) shall analogous to a text annotation except that instead of a text note, it contains sound recorded from the computer’s microphone or imported from a file.
@interface PSPDFSoundAnnotation : PSPDFLinkAnnotation

/// The sound icon name.
@property (nonatomic, copy) NSString *iconName;

/// URL to the sound content.
@property (nonatomic, strong) NSURL *soundURL;

/// Bits of the sound stream.
@property (nonatomic, assign, readonly) NSUInteger bits;

/// Sampling rate of the sound stream.
@property (nonatomic, assign, readonly) NSUInteger rate;

/// Channel count of the sound stream.
@property (nonatomic, assign, readonly) NSUInteger channels;

/// Encoding of the sound stream.
@property (nonatomic, copy, readonly) NSString *encoding;

- (id)initWithRate:(NSUInteger)rate channels:(UInt32)channels bits:(UInt32)bits encoding:(NSString *)encoding;

- (NSData *)soundStreamData;

- (void)setStreamPropertiesWithDescription:(NSDictionary *)streamDescription;

@end
