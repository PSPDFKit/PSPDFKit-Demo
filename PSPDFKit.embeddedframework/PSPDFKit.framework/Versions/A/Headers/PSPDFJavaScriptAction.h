//
//  PSPDFJavaScriptAction.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAction.h"
#import "PSPDFFormElement.h"

@class PSPDFViewController;

// Posted when a action is triggered coorresponding to one of the 'K, F, V, C' keys in the additional actions dict
extern NSString * const PSPDFFormAdditionalJavaScriptActionTriggerEventDidOccurNotification;

// UserInfo keys for the notification above.
extern NSString * const PSPDFFormAdditionalJavaScriptActionTriggerEventActionsKey;
extern NSString * const PSPDFFormAdditionalJavaScriptActionTriggerEventActionEventKey;

// The domain for errors originating from javascript execution in the context of PSPDFJavascriptAction.
extern NSString * const PSPDFJavascriptErrorDomain;

typedef NS_ENUM(NSInteger, PSPDFJavascriptErrorCode) {
    PSPDFJavascriptErrorScriptExecutionFailed = 100
};

@interface PSPDFJavaScriptAction : PSPDFAction

/// Designated initializer.
- (id)initWithScript:(NSString *)script;
- (id)initWithPDFDictionary:(CGPDFDictionaryRef)actionDictionary documentRef:(CGPDFDocumentRef)documentRef;

/// The javascript content.
@property (nonatomic, copy) NSString *script;

/// Tries to execute the JavaScript in the context of a view controller.
/// Execution is asynchronous and calls the passed completion block when complete.
/// If the eventProvider is set, it is used to gather further information about what
/// triggered the event that may be used in the script.
- (void)executeScriptAppliedToViewController:(PSPDFViewController *)viewController eventDictionary:(NSDictionary *)eventDictionary sender:(id)sender completionBlock:(void (^)())completionBlock;

/// Tries to execute an arbirary script not attached to a specific action in the context of a view controller and an event.
/// For a list of keys for the event dictionary and an overview of action event objects see above.
/// Execution is asynchronous and calls the passed completion block when complete.
/// Used for testing purposes. Do not use for scripts that ref Event objects.
+ (void)executeScript:(NSString *)script appliedToViewController:(PSPDFViewController *)viewController eventDictionary:(NSDictionary*)eventDictionary sender:(id)sender completionBlock:(void (^)())completionBlock;

@end

@interface PSPDFFormElement (JavascriptEventsAdditions)
- (NSDictionary *)eventDictionaryForAction:(PSPDFJavaScriptAction *)sender;
@end


/* The following string constants represent the keys for the event dictionary
 corresponding to the action event.
 Form the Adobe Javascript for Acrobat Reference:

 All JavaScript scripts are executed as the result of a particular event. For each of these events, JavaScript creates an event object. During the occurrence of each event, you can access this object to get and possibly manipulate information about the current state of the event.
 Each event has a type and a name property that uniquely identify the event. This section describes all the events, listed as type/name pairs, and indicates which additional properties, if any, they define.
 */


/*
 For the Field/Validate event, it is the value that the field contains when it is committed. For a
 combo box, it is the face value, not the export value.
 */
extern NSString *const PSPDFActionEventValueKey;

/* 
 The name of the current event as a text string. The type and name together uniquely identify the event.
 The valid values defined at the end of this file.
 Valid names are:
 
 Keystroke
 Validate
 Focus
 Blur
 Format
 Calculate
 Mouse Up
 Mouse Down
 Mouse Enter
 Mouse Exit
 WillPrint
 DidPrint
 WillSave
 DidSave
 Init
 Exec
 Open
 Close

 */
extern NSString *const PSPDFActionEventNameKey;

/*
 The type of the current event. The type and name together uniquely identify the event. Valid types are:

 Batch
 External
 Console
 Bookmark
 App
 Link
 Doc
 Field
 Page
 Menu

 */
extern NSString *const PSPDFActionEventTypeKey;
extern NSString *const PSPDFActionEventSourceKey;
extern NSString *const PSPDFActionEventTargetKey;


/* The following string constants represent values for the action event dictionary keys with fixed discrete range.
 */

/// Name Values
extern NSString *const PSPDFActionEventNameValueMouseDown;

/// Type Values
extern NSString *const PSPDFActionEventTypeValueField;
