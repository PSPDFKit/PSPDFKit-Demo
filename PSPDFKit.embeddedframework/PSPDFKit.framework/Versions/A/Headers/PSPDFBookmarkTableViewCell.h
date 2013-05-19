//
//  PSPDFBookmarkTableViewCell.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFBookmarkTableViewCell;

/// Delegate when we use inline cell editing.
@protocol PSPDFBookmarkTableViewCellDelegate <NSObject>

/// Called when the bookmark cell did update the text.
- (void)bookmarkCell:(PSPDFBookmarkTableViewCell *)cell didUpdateBookmarkString:(NSString *)bookmarkString;

@end


/// Custom cell used for bookmarks.
@interface PSPDFBookmarkTableViewCell : UITableViewCell <UITextFieldDelegate>

/// Visible string.
@property (nonatomic, copy) NSString *bookmarkString;

/// Delegate to communicate with the controller.
@property (nonatomic, weak) id<PSPDFBookmarkTableViewCellDelegate> delegate;

@end


@interface PSPDFBookmarkTableViewCell (SubclassingHooks)

/// Internally used text field.
@property (nonatomic, strong) UITextField *textField;

@end
