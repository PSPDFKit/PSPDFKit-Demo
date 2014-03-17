//
//  PSPDFSpeechSynthesizer.h
//  PSPDFKit
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/// Controls text-to-speach features. iOS 7+ only.
@interface PSPDFSpeechSynthesizer : NSObject

/// Shared instance. Only one element can speak at a time.
+ (instancetype)sharedSynthesizer;

/// Speak string.
- (IBAction)speakText:(NSString *)speechString delegate:(id<AVSpeechSynthesizerDelegate>)delegate;

/// If this delegate is set, stop current text.
- (BOOL)stopSpeakingForDelegate:(id<AVSpeechSynthesizerDelegate>)delegate;

/// The internally sed speech synthesizer.
@property (nonatomic, strong, readonly) AVSpeechSynthesizer *speechSynthesizer;

/// Speech language.
@property (nonatomic, copy) NSString *selectedLanguage;

/// Speech rate.
@property (nonatomic, assign) float speakRate;

/// Speech pitch.
@property (nonatomic, assign) float pitchMultiplier;

@end
