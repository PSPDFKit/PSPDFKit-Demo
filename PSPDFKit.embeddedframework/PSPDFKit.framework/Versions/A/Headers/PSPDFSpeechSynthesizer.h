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

// Language auto-detection.
extern NSString *const PSPDFSpeechSynthesizerAutoDetectLanguage;
// Force a specific language.
extern NSString *const PSPDFSpeechSynthesizerLanguageKey;
// Provide text to sample a language.
extern NSString *const PSPDFSpeechSynthesizerLanguageHintKey;

/// Controls text-to-speech features.
/// @note This class should only be used from the main thread.
@interface PSPDFSpeechSynthesizer : NSObject

/// Shared instance. Only one element can speak at a time.
+ (instancetype)sharedSynthesizer;
+ (BOOL)isSharedSynthesizerLoaded;

/// Speak string.
/// Setting `language` to nil will use the default language set here.
- (IBAction)speakText:(NSString *)speechString options:(NSDictionary *)options delegate:(id<AVSpeechSynthesizerDelegate>)delegate;

/// If this delegate is set, stop current text.
- (BOOL)stopSpeakingForDelegate:(id<AVSpeechSynthesizerDelegate>)delegate;

/// The internally used speech synthesizer.
@property (nonatomic, strong, readonly) AVSpeechSynthesizer *speechSynthesizer;

/// Speech language. Defaults to `PSPDFSpeechSynthesizerAutoDetectLanguage`.
@property (nonatomic, copy) NSString *selectedLanguage;

/// Available language codes, use for `selectedLanguage`.
@property (nonatomic, copy, readonly) NSArray *languageCodes;

/// Speech rate.
@property (nonatomic, assign) float speakRate;

/// Speech pitch. Defaults to 0.5f.
@property (nonatomic, assign) float pitchMultiplier;

@end
