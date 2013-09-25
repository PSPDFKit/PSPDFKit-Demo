//
//  PSPDFFormElement.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFWidgetAnnotation.h"
#import "PSPDFResetFormAction.h"

typedef NS_OPTIONS(NSUInteger, PSPDFFormElementFlag) {
    PSPDFFormElementFlagReadOnly = 1 << (1-1),
    PSPDFFormElementFlagRequired = 1 << (2-1),
    PSPDFFormElementFlagNoExport = 1 << (3-1)
};

@class PSPDFPageView;

/// Represents a PDF form element.
@interface PSPDFFormElement : PSPDFWidgetAnnotation

/** Initializes allocated instance of a form element.
 * @param   annotDict           Field dictionary.
 * @param   documentRef         Document.
 * @param   fieldsAddressMap    annotDict to FormElement map.
 */
- (id)initWithAnnotationDictionary:(CGPDFDictionaryRef)annotDict documentRef:(CGPDFDocumentRef)documentRef  fieldsAddressMap:(NSMutableDictionary *)fieldsAddressMap;

/** Initializes allocated instance of a form element.
 * @param   annotDict           Field dictionary.
 * @param   documentRef         Document.
 * @param   parentFormElement   Parent form element.
 * @param   fieldsAddressMap    annotDict to FormElement map.
 */
- (id)initWithAnnotationDictionary:(CGPDFDictionaryRef)annotDict documentRef:(CGPDFDocumentRef)documentRef parent:(PSPDFFormElement *)parentFormElement fieldsAddressMap:(NSMutableDictionary *)fieldsAddressMap;

/** Allocates and initializes an instance of a form element.
 * @param   annotDict           Field dictionary.
 * @param   documentRef         Document.
 * @param   parentFormElement   Parent form element.
 * @param   fieldsAddressMap    annotDict to FormElement map.
 */
+ (PSPDFFormElement *)formElementWithAnnotationDictionary:(CGPDFDictionaryRef)annotDict documentRef:(CGPDFDocumentRef)documentRef parent:(PSPDFFormElement *)parentFormElement fieldsAddressMap:(NSMutableDictionary *)fieldsAddressMap;

/// The field that is the immediate parent of this one (the field, if any, whose
/// Kids array includes this field). A field can have at most one parent; that
/// is, it can be included in the Kids array of at most one other field.
@property (nonatomic, weak) PSPDFFormElement *parent;

/// An array of indirect references to the immediate children of this field.
@property (nonatomic, copy) NSArray *kids;

/// Field type (see table 220, PDF Reference).
/// (Required for terminal fields; inheritable).
@property (nonatomic, copy) NSString *fieldType;

/// The partial field name.
@property (nonatomic, copy) NSString *fieldName;

/// (Optional; PDF 1.3) The mapping name that shall be used when exporting interactive form field data from the document.
@property (nonatomic, copy) NSString *mappingName;

/// (Optional; PDF 1.3) An alternate field name that shall be used in place of the actual field name wherever the field shall be identified in the user interface (such as in error or status messages referring to the field). This text is also useful when extracting the document’s contents in support of accessibility to users with disabilities or for other purposes (see 14.9.3, “Alternate Descriptions”).
@property (nonatomic, copy) NSString *alternateFieldName;

/// (Optional; inheritable) A set of flags specifying various characteristics of the field (see Table 221). Default value: 0.
@property (nonatomic, assign) NSUInteger fieldFlags;

/// (Optional; inheritable) The field’s value, whose format varies depending on the field type. See the descriptions of individual field types for further information.
@property (nonatomic, strong) id value;

/// (Optional; inheritable) The default value to which the field reverts when a reset-form action is executed (see 12.7.5.3, “Reset-Form Action”). The format of this value is the same as that of V.
@property (nonatomic, strong) id defaultValue;

/// (Required if the appearance dictionary AP contains one or more subdictionaries; PDF 1.2) The annotation’s appearance state, which selects the applicable appearance stream from an appearance subdictionary.
@property (nonatomic, strong) NSString *appearanceState;

/// The value which the field is to export when submitted. Can return either a string or an array of strings in the case of multiple selection.
@property (nonatomic, readonly) id exportValue;

/// Links for previous control in tab order.
@property (nonatomic, weak) PSPDFFormElement *next;

/// Links for next control in tab order.
@property (nonatomic, weak) PSPDFFormElement *previous;

// Page that this form element is on, set during parse.
@property (nonatomic, assign) NSUInteger tabbingPage;
@property (nonatomic, assign) NSUInteger tabbingStructureIndex;
@property (nonatomic, assign) NSUInteger tabbingManualIndex;
@property (nonatomic, assign) NSUInteger structParent;

// Tab ordering property of the page this form element is on. Possible values are @"R" (Row order), @"C" (column order), @"S" (structural order), and nil if none is set.
@property (nonatomic, copy) NSString *tabOrder;

/// If set, the user may not change the value of the field. Any associated widget annotations will not interact with the user; that is, they will not respond to mouse clicks or change their appearance in response to mouse motions. This flag is useful for fields whose values are computed or imported from a database.
- (BOOL)isReadOnly;

/// If set, the field shall have a value at the time it is exported by a submit- form action (see 12.7.5.2, “Submit-Form Action”).
- (BOOL)isRequired;

/// If set, the field shall not be exported by a submit-form action (see 12.7.5.2, “Submit-Form Action”).
- (BOOL)isNoExport;

/// The T entry in the field dictionary (see Table 220) holds a text string defining the field’s partial field name. The fully qualified field name is not explicitly defined but shall be constructed from the partial field names of the field and all of its ancestors. For a field with no parent, the partial and fully qualified names are the same. For a field that is the child of another field, the fully qualified name shall be formed by appending the child field’s partial name to the parent’s fully qualified name, separated by a PERIOD (2Eh) — PDF Spec
- (NSString *)fullyQualifiedFieldName;

/// You should implement this method in subclasses to handle tap on the form element: change state, show visual editor.
- (BOOL)handleTapInView:(PSPDFPageView *)pdfPageView;

- (void)appendCommonFormElementPDFData:(NSMutableData *)pdfData;

/// Appends value of a field in PDF syntax. It must be implemented by children of the class.
- (void)appendFieldValuePDFData:(NSMutableData *)pdfData;

- (void)resetWithAction:(PSPDFResetFormAction *)action;

@end
