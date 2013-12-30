//
//  PSPDFButtonFormElement.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFFormElement.h"

typedef NS_OPTIONS(NSUInteger, PSPDFButtonFlag) {
    PSPDFButtonFlagNoToggleToOff  = 1 << (15-1),
    PSPDFButtonFlagRadio          = 1 << (16-1),
    PSPDFButtonFlagPushButton     = 1 << (17-1),
    PSPDFButtonFlagRadiosInUnison = 1 << (26-1),
};

/// Button Form Element.
@interface PSPDFButtonFormElement : PSPDFFormElement

/// Designated initializer.
- (id)initWithAnnotationDictionary:(CGPDFDictionaryRef)annotDict documentRef:(CGPDFDocumentRef)documentRef parent:(PSPDFFormElement *)parentFormElement fieldsAddressMap:(NSMutableDictionary *)fieldsAddressMap;

/// A push button is a purely interactive control that responds immediately to user input without retaining a permanent value (see 12.7.4.2.2, “Pushbuttons”).
- (BOOL)isPushButton;

/// A check box toggles between two states, on and off (see 12.7.4.2.3, “Check Boxes”).
- (BOOL)isCheckBox;

/// Radio button fields contain a set of related buttons that can each be on or off. Typically, at most one radio button in a set may be on at any given time, and selecting any one of the buttons automatically deselects all the others. (There are exceptions to this rule, as noted in "Radio Buttons.")
- (BOOL)isRadioButton;

/// Returns `YES` if button is selected.
- (BOOL)isSelected;

/// Select the button.
- (void)select;

/// Deselect the button.
- (void)deselect;

/// Toggle button selection state.
- (BOOL)toggleButtonSelectionState;

/// (Optional; inheritable; PDF 1.4) An array containing one entry for each widget annotation in the Kids array of the radio button or check box field. Each entry shall be a text string representing the on state of the corresponding widget annotation. When this entry is present, the names used to represent the on state in the AP dictionary of each annotation (for example, /1, /2) numerical position (starting with 0) of the annotation in the Kids array, encoded as a name object. This allows distinguishing between the annotations even if two or more of them have the same value in the Opt array.
@property (nonatomic, copy) NSArray *opt;

/// The appearance state to be used in the 'on' position. This will be a key in the dictionary of appearance streams for the different states. The off state is always "Off".
@property (nonatomic, copy, readonly) NSString *onState;

@end
