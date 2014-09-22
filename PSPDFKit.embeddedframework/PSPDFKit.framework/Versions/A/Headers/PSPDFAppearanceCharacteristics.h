//
//  PSPDFAppearanceCharacteristics.h
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

@class PSPDFStream, PSPDFIconFit;

typedef NS_ENUM(NSUInteger, PSPDFAppearanceCharacteristicsTextPosition) {
    PSPDFAppearanceCharacteristicsTextPositionNoIcon,               // 0 No icon; caption only
    PSPDFAppearanceCharacteristicsTextPositionNoCaption,            // 1 No caption; icon only
    PSPDFAppearanceCharacteristicsTextPositionCaptionBelowIcon,     // 2 Caption below the icon
    PSPDFAppearanceCharacteristicsTextPositionCaptionAboveIcon,     // 3 Caption above the icon
    PSPDFAppearanceCharacteristicsTextPositionCaptionLeftFromIcon,  // 4 Caption to the right of the icon
    PSPDFAppearanceCharacteristicsTextPositionCaptionRightFromIcon, // 5 Caption to the left of the icon
    PSPDFAppearanceCharacteristicsTextPositionCaptionOverlaid,      // 6 Caption overlaid directly on the icon
};

// Saves all elements of the appearance characteristics dictionary. Not all options are supported yet.
// Rotation, border and fill color are defined in the widget annotation directly.
@interface PSPDFAppearanceCharacteristics : PSPDFModel

+ (instancetype)appearanceCharacteristicsFromPDFDictionary:(CGPDFDictionaryRef)apCharacteristicsDict;

// (Optional; button fields only) The widget annotation’s normal caption, which shall be displayed when it is not interacting with the user.
// Unlike the remaining entries listed in this Table, which apply only to widget annotations associated with pushbutton fields (see Pushbuttons in 12.7.4.2, “Button Fields”), the CA entry may be used with any type of button field, including check boxes (see Check Boxes in 12.7.4.2, “Button Fields”) and radio buttons (Radio Buttons in 12.7.4.2, “Button Fields”).
@property (nonatomic, copy) NSString *normalCaption;

// (Optional; pushbutton fields only) The widget annotation’s rollover caption, which shall be displayed when the user rolls the cursor into its active area without pressing the mouse button.
@property (nonatomic, copy) NSString *rolloverCaption;

// (Optional; pushbutton fields only) The widget annotation’s alternate (down) caption, which shall be displayed when the mouse button is pressed within its active area.
@property (nonatomic, copy) NSString *alternateCaption;

// (Optional; pushbutton fields only) A code indicating where to position the text of the widget annotation’s caption relative to its icon. Default value: 0.
@property (nonatomic, assign) PSPDFAppearanceCharacteristicsTextPosition textPosition;

// (Optional; pushbutton fields only; shall be an indirect reference) A form XObject defining the widget annotation’s normal icon, which shall be displayed when it is not interacting with the user.
@property (nonatomic, strong) PSPDFStream *normalIcon;

// Optional; pushbutton fields only; shall be an indirect reference) A form XObject defining the widget annotation’s rollover icon, which shall be displayed when the user rolls the cursor into its active area without pressing the mouse button.
@property (nonatomic, strong) PSPDFStream *rolloverIcon;

// (Optional; pushbutton fields only; shall be an indirect reference) A form XObject defining the widget annotation’s alternate (down) icon, which shall be displayed when the mouse button is pressed within its active area.
@property (nonatomic, strong) PSPDFStream *alternateIcon;

// (Optional; pushbutton fields only) An icon fit dictionary (see Table 247) specifying how the widget annotation’s icon shall be displayed within its annotation rectangle. If present, the icon fit dictionary shall apply to all of the annotation’s icons (normal, rollover, and alternate).
@property (nonatomic, strong) PSPDFIconFit *iconFit;

@end

@interface PSPDFAppearanceCharacteristics (PDFRepresentation)

// Not a complete /MK dictionary (some data is in the widget annotation as well)
- (NSString *)partialPDFString;

@end
