//
//  PSPDFAbstractLineAnnotation+Private.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//
#import "PSPDFAbstractLineAnnotation.h"

@interface PSPDFAbstractLineAnnotation (Private)

@property (nonatomic, strong) UIBezierPath *bezierPath;

// Fast internal representation of the points.
@property (nonatomic, assign) CGPoint *CGPoints;
@property (nonatomic, assign) NSUInteger CGPointsCount;

- (BOOL)parseVerticesFromAnnotationDictionary:(CGPDFDictionaryRef)annotDict;
- (void)recalculateBoundingBox;
- (BOOL)closesPath;

@end

@interface PSPDFAbstractLineAnnotation (WritingSupport)

// Creates the /LE[/%@/%@] line representation string.
- (NSString *)lineEndPDFRepresentation;

// Create Vertices string with all points.
- (NSString *)veticesPDFRepresentation;

@end


@interface PSPDFAbstractLineAnnotation (LegacyFormatSupport)

+ (NSDictionary *)dictionaryValueFromArchivedExternalRepresentation:(NSDictionary *)externalRepresentation version:(NSUInteger)fromVersion;

@end
