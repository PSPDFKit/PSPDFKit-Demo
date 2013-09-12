//
//  PSPDFChoiceFormElement.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAbstractTextRenderingFormElement.h"
#import "PSPDFChoiceEditorViewController.h"

typedef NS_OPTIONS(NSUInteger, PSPDFChoiceFlag) {
    PSPDFChoiceFlagCombo             = 1 << (18-1),
    PSPDFChoiceFlagEdit              = 1 << (19-1),
    PSPDFChoiceFlagSort              = 1 << (20-1),
    PSPDFChoiceFlagMultiSelect       = 1 << (22-1),
    PSPDFChoiceFlagDoNotSpellCheck   = 1 << (23-1),
    PSPDFChoiceFlagCommitOnSelChange = 1 << (27-1)
};

@class PSPDFViewController;

/// Choice Form Element.
@interface PSPDFChoiceFormElement : PSPDFAbstractTextRenderingFormElement<PSPDFChoiceEditorViewControllerDataSource, PSPDFChoiceEditorViewControllerDelegate>

/// Designated initializer.
- (id)initWithAnnotationDictionary:(CGPDFDictionaryRef)annotDict documentRef:(CGPDFDocumentRef)documentRef parent:(PSPDFFormElement *)parentFormElement fieldsAddressMap:(NSMutableDictionary *)fieldsAddressMap;

/// If set, the field is a combo box; if clear, the field is a list box.
- (BOOL)isCombo;

/// If set, the combo box shall include an editable text box as well as a drop-down list; if clear, it shall include only a drop-down list. This flag shall be used only if the Combo flag is set.
- (BOOL)isEdit;

/// (PDF 1.4) If set, more than one of the field’s option items may be selected simultaneously; if clear, at most one item shall be selected.
- (BOOL)isMultiSelect;

/// (Optional) An array of options that shall be presented to the user. Each element of the array is either a text string representing one of the available options or an array consisting of two text strings: the option’s export value and the text that shall be displayed as the name of the option. If this entry is not present, no choices should be presented to the user.
@property (nonatomic, strong) NSArray *options;

/// (Sometimes required, otherwise optional; PDF 1.4) For choice fields that allow multiple selection (MultiSelect flag set), an array of integers, sorted in ascending order, representing the zero-based indices in the Opt array of the currently selected option items. This entry shall be used when two or more elements in the Opt array have different names but the same export value or when the value of the choice field is an array. This entry should not be used for choice fields that do not allow multiple selection. If the items identified by this entry differ from those in the V entry of the field dictionary (see discussion following this Table), the V entry shall be used.
@property (nonatomic, strong) NSMutableIndexSet *selectedIndices;

/// For combo boxes only, is the selection a default or custom value
@property (nonatomic, assign) BOOL customSelection;

/// Optional) For scrollable list boxes, the top index (the index in the Opt array of the first option visible in the list). Default value: 0.
@property (nonatomic, assign) NSUInteger topIndex;

- (NSUInteger)numberOfOptions;
- (NSString *)optionTextAtIndex:(NSUInteger)index;
- (NSString *)optionExportValueAtIndex:(NSUInteger)index;

@end
