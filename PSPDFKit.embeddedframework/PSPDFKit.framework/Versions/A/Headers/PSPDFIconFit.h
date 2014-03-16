//
//  PSPDFIconFit.h
//  PSPDFKit
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFModel.h"

typedef NS_ENUM(NSUInteger, PSPDFIconFitScaleMode) {
    PSPDFIconFitScaleModeAlways,    // A Always scale.
    PSPDFIconFitScaleModeIfBigger,  // B Scale only when the icon is bigger than the annotation rectangle.
    PSPDFIconFitScaleModeIfSmaller, // S Scale only when the icon is smaller than the annotation rectangle.
    PSPDFIconFitScaleModeNever,     // N Never scale.
};

typedef NS_ENUM(NSUInteger, PSPDFIconFitScaleType) {
    PSPDFIconFitScaleTypeAnamorphic,    // A Anamorphic scaling: Scale the icon to fill the annotation rectangle exactly, without regard to its original aspect ratio (ratio of width to height).
    PSPDFIconFitScaleTypeProportional,  // P Proportional scaling: Scale the icon to fit the width or height of the annotation rectangle while maintaining the icon’s original aspect ratio. If the required horizontal and vertical scaling factors are different, use the smaller of the two, centering the icon within the annotation rectangle in the other dimension.
};

@interface PSPDFIconFit : PSPDFModel

// Create model from the PDF dictionary.
+ (instancetype)iconFitFromPDFDictionary:(CGPDFDictionaryRef)iconFitDict;

// (Optional) The circumstances under which the icon shall be scaled inside the annotation rectangle.
// Defaults to `PSPDFIconFitScaleAlways`.
@property (nonatomic, assign) PSPDFIconFitScaleMode scaleMode;

// (Optional) The type of scaling that shall be used. Defaults to `PSPDFIconFitScaleTypeProportional`.
@property (nonatomic, assign) PSPDFIconFitScaleType scaleType;

// (Optional) An array of two numbers that shall be between 0.0 and 1.0 indicating the fraction of leftover space to allocate at the left and bottom of the icon. A value of [0.0 0.0] shall position the icon at the bottom-left corner of the annotation rectangle. A value of [0.5 0.5] shall center it within the rectangle. This entry shall be used only if the icon is scaled proportionally. Default value: [0.5 0.5].
@property (nonatomic, copy) NSArray *leftoverSpace;

// (Optional; PDF 1.5) If true, indicates that the button appearance shall be scaled to fit fully within the bounds of the annotation without taking into consideration the line width of the border.
// Default value: NO.
@property (nonatomic, assign) BOOL scaleButtonAppearanceWithoutConsideringBorder;

@end

@interface PSPDFIconFit (PDFRepresentation)

- (NSString *)PDFString;

@end
