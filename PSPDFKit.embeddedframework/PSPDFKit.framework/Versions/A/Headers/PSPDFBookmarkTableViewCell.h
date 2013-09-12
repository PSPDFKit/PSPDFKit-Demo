//
//  PSPDFBookmarkTableViewCell.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFTableViewCell.h"

@class PSPDFBookmarkTableViewCell;

/// Delegate when we use inline cell editing.
@protocol PSPDFBookmarkTableViewCellDelegate <NSObject>

/// Called when the bookmark cell did update the text.
- (void)bookmarkCell:(PSPDFBookmarkTableViewCell *)cell didUpdateBookmarkString:(NSString *)bookmarkString;

@end


/// Custom cell used for bookmarks.
@interface PSPDFBookmarkTableViewCell : PSPDFTableViewCell <UITextFieldDelegate>

/// Visible string.
@property (nonatomic, copy) NSString *bookmarkString;

/// Delegate to communicate with the controller.
@property (nonatomic, weak) id<PSPDFBookmarkTableViewCellDelegate> delegate;

@end


@interface PSPDFBookmarkTableViewCell (SubclassingHooks)

/// Internally used text field.
@property (nonatomic, strong) UITextField *textField;

@end
