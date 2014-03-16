//
//  PSPDFByteRange.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFModel.h"

extern const int PSPDF_BYTERANGE_PLACEHOLDER_LENGTH;

@interface PSPDFByteRange : PSPDFModel

- (id)initWithCGPDFByteRangeArray:(CGPDFArrayRef)byteRanges;
- (id)initWithCGPDFDictionary:(CGPDFDictionaryRef)dict withKey:(NSString *)key;
- (id)initWithRangeArray:(NSArray *)ranges;
- (id)initWithFirstLocation:(NSUInteger)firstLocation firstLength:(NSUInteger)firstLength secondLocation:(NSUInteger)secondLocation secondLength:(NSUInteger)secondLength;

@property (nonatomic, assign) NSRange firstRange;
@property (nonatomic, assign) NSRange secondRange;

- (NSString *)PDFRepresentation;

@end
