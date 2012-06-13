//
//  PSActionSheet.m
//
//  Based on PLActionSheet by Landon Fuller on 7/3/09.
//  Modified by Peter Steinberger
//

#import "PSActionSheet.h"

@interface PSActionSheet ()
@property (nonatomic, strong) UIActionSheet *sheet;
@end

@implementation PSActionSheet
@synthesize sheet = sheet_;

+ (id)sheetWithTitle:(NSString *)title {
    return [[PSActionSheet alloc] initWithTitle:title];
}

- (id)initWithTitle:(NSString *)title {
    if ((self = [super init])) {
        // Create the action sheet
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        self.sheet = actionSheet;
        
        // Create the blocks storage for handling all button actions
        blocks_ = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    self.sheet.delegate = nil;
}

- (void)setDestructiveButtonWithTitle:(NSString *)title block:(void (^)())block {
    assert([title length] > 0 && "sheet destructive button title must not be empty");
    
    [self addButtonWithTitle:title block:block];
    sheet_.destructiveButtonIndex = (sheet_.numberOfButtons - 1);
}

- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)())block {
    assert([title length] > 0 && "sheet cancel button title must not be empty");
    
    [self addButtonWithTitle:title block:block];
    sheet_.cancelButtonIndex = (sheet_.numberOfButtons - 1);
}

- (void)addButtonWithTitle:(NSString *)title block:(void (^)())block {
    assert([title length] > 0 && "cannot add button with empty title");
    [blocks_ addObject:block ? [block copy] : [NSNull null]];
    [sheet_ addButtonWithTitle:title];
}

- (void)showInView:(UIView *)view {
    [sheet_ showInView:view];
    
    // Ensure that the delegate (that's us) survives until the sheet is dismissed.
    // Release occurs in -actionSheet:clickedButtonAtIndex:
    CFRetain((__bridge void*)self);
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated {
    [sheet_ showFromBarButtonItem:item animated:animated];

    // Ensure that the delegate (that's us) survives until the sheet is dismissed.
    // Release occurs in -actionSheet:clickedButtonAtIndex:
    CFRetain((__bridge void*)self);
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated {
    [sheet_ showFromRect:rect inView:view animated:animated];

    // Ensure that the delegate (that's us) survives until the sheet is dismissed.
    // Release occurs in -actionSheet:clickedButtonAtIndex:
    CFRetain((__bridge void*)self);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // Run the button's block
    if (buttonIndex >= 0 && buttonIndex < [blocks_ count]) {
        id obj = blocks_[buttonIndex];
        if (![obj isEqual:[NSNull null]]) {
            ((void (^)())obj)();
        }
    }
    
    // Sheet to be dismissed, drop our self reference.
    // Retain occurs in -showInView:
    CFRelease((__bridge void*)self);
}

- (NSUInteger)buttonCount {
    return [blocks_ count];
}

@end
