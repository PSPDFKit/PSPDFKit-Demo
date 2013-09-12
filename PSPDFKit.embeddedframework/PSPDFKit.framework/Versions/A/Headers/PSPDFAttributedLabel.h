// PSPDFAttributedLabel.h (originated as TTTAttributedLabel, renamed to prevent naming conflicts)
//
// Copyright (c) 2011-2012 Mattt Thompson (http://mattt.me)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <CoreText/CoreText.h>
#import "PSPDFKitGlobal.h"

/**
 Vertical alignment for text in a label whose bounds are larger than its text bounds
 */
typedef NS_ENUM(NSInteger, PSPDFAttributedLabelVerticalAlignment) {
    PSPDFAttributedLabelVerticalAlignmentCenter   = 0,
    PSPDFAttributedLabelVerticalAlignmentTop      = 1,
    PSPDFAttributedLabelVerticalAlignmentBottom   = 2,
};

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
extern CTTextAlignment PSPDFTextAlignmentToCTTextAlignment(NSTextAlignment alignment);
#endif

@protocol PSPDFAttributedLabelDelegate;

// Override UILabel @property to accept both NSString and NSAttributedString
@protocol PSPDFAttributedLabel <NSObject>
@property (nonatomic, copy) id text;
@end

/**
 `PSPDFAttributedLabel` is a drop-in replacement for `UILabel` that supports `NSAttributedString`, as well as automatically-detected and manually-added links to URLs, addresses, phone numbers, and dates.

 # Differences Between `PSPDFAttributedLabel` and `UILabel`

 For the most part, `PSPDFAttributedLabel` behaves just like `UILabel`. The following are notable exceptions, in which `PSPDFAttributedLabel` properties may act differently:

 - `text` - This property now takes an `id` type argument, which can either be a kind of `NSString` or `NSAttributedString` (mutable or immutable in both cases)
 - `lineBreakMode` - This property displays only the first line when the value is `UILineBreakModeHeadTruncation`, `UILineBreakModeTailTruncation`, or `UILineBreakModeMiddleTruncation`
 - `adjustsFontsizeToFitWidth` - This property is effective for any value of `numberOfLines` greater than zero
 */
@interface PSPDFAttributedLabel : UILabel <PSPDFAttributedLabel, UIGestureRecognizerDelegate> {
@private
    NSAttributedString *_attributedText;
    CTFramesetterRef _framesetter;
    BOOL _needsFramesetter;
    NSDataDetector *_dataDetector;
    UITapGestureRecognizer *_tapGestureRecognizer;
}

///-----------------------------
/// @name Accessing the Delegate
///-----------------------------

/**
 The receiver's delegate.

 @discussion A `PSPDFAttributedLabel` delegate responds to messages sent by tapping on links in the label. You can use the delegate to respond to links referencing a URL, address, phone number, date, or date with a specified time zone and duration.
 */
@property (nonatomic, weak) IBOutlet id<PSPDFAttributedLabelDelegate> delegate;

///--------------------------------------------
/// @name Detecting, Accessing, & Styling Links
///--------------------------------------------

/**
 A bitmask of `UIDataDetectorTypes` which are used to automatically detect links in the label text. This is `UIDataDetectorTypeNone` by default.

 @warning You must specify `dataDetectorTypes` before setting the `text`, with either `setText:` or `setText:afterInheritingLabelAttributesAndConfiguringWithBlock:`.
 */
@property (nonatomic, assign) UIDataDetectorTypes dataDetectorTypes;

/**
 An array of `NSTextCheckingResult` objects for links detected or manually added to the label text.
 */
@property (readonly, nonatomic, copy) NSArray *links;

/**
 A dictionary containing the `NSAttributedString` attributes to be applied to links detected or manually added to the label text. The default link style is blue and underlined.

 @warning You must specify `linkAttributes` before setting autodetecting or manually-adding links for these attributes to be applied.
 */
@property (nonatomic, copy) NSDictionary *linkAttributes;

///---------------------------------------
/// @name Accessing Text Style Attributes
///---------------------------------------

/**
 The shadow blur radius for the label. A value of 0 indicates no blur, while larger values produce correspondingly larger blurring. This value must not be negative. The default value is 0.
 */
@property (nonatomic, assign) CGFloat shadowRadius;

///--------------------------------------------
/// @name Accessing Paragraph Style Attributes
///--------------------------------------------

/**
 The distance, in points, from the leading margin of a frame to the beginning of the paragraph's first line. This value is always nonnegative, and is 0.0 by default.
 */
@property (nonatomic, assign) CGFloat firstLineIndent;

/**
 The space in points added between lines within the paragraph. This value is always nonnegative and is 0.0 by default.
 */
@property (nonatomic, assign) CGFloat leading;

/**
 The line height multiple. This value is 0.0 by default.
 */
@property (nonatomic, assign) CGFloat lineHeightMultiple;

/**
 The distance, in points, from the margin to the text container. This value is `UIEdgeInsetsZero` by default.

 @discussion The `UIEdgeInset` members correspond to paragraph style properties rather than a particular geometry, and can change depending on the writing direction.

 ## `UIEdgeInset` Member Correspondence With `CTParagraphStyleSpecifier` Values:

 - `top`: `kCTParagraphStyleSpecifierParagraphSpacingBefore`
 - `left`: `kCTParagraphStyleSpecifierHeadIndent`
 - `bottom`: `kCTParagraphStyleSpecifierParagraphSpacing`
 - `right`: `kCTParagraphStyleSpecifierTailIndent`

 */
@property (nonatomic, assign) UIEdgeInsets textInsets;

/**
 The vertical text alignment for the label, for when the frame size is greater than the text rect size. The vertical alignment is `PSPDFAttributedLabelVerticalAlignmentCenter` by default.
 */
@property (nonatomic, assign) PSPDFAttributedLabelVerticalAlignment verticalAlignment;


///----------------------------------
/// @name Setting the Text Attributes
///----------------------------------

/**
 Sets the text displayed by the label.

 @param text An `NSString` or `NSAttributedString` object to be displayed by the label. If the specified text is an `NSString`, the label will display the text like a `UILabel`, inheriting the text styles of the label. If the specified text is an `NSAttributedString`, the label text styles will be overridden by the styles specified in the attributed string.

 @discussion This method overrides `UILabel -setText:` to accept both `NSString` and `NSAttributedString` objects. This string is `nil` by default.
 */
- (void)setText:(id)text;

/**
 Sets the text displayed by the label, after configuring an attributed string containing the text attributes inherited from the label in a block.

 @param text An `NSString` or `NSAttributedString` object to be displayed by the label.
 @param block A block object that returns an `NSMutableAttributedString` object and takes a single argument, which is an `NSMutableAttributedString` object with the text from the first parameter, and the text attributes inherited from the label text styles. For example, if you specified the `font` of the label to be `[UIFont boldSystemFontOfSize:14]` and `textColor` to be `UIColor.redColor`, the `NSAttributedString` argument of the block would be contain the `NSAttributedString` attribute equivalents of those properties. In this block, you can set further attributes on particular ranges.

 @discussion This string is `nil` by default.
 */
- (void)setText:(id)text afterInheritingLabelAttributesAndConfiguringWithBlock:(NSMutableAttributedString *(^)(NSMutableAttributedString *mutableAttributedString))block;

///-------------------
/// @name Adding Links
///-------------------

/**
 Adds a link to an `NSTextCheckingResult`.

 @param result An `NSTextCheckingResult` representing the link's location and type.
 @param attributes The attributes to be added to the text in the range of the specified link. If `nil`, no attributes are added.
 */
- (void)addLinkWithTextCheckingResult:(NSTextCheckingResult *)result attributes:(NSDictionary *)attributes;

/**
 Adds a link to a URL for a specified range in the label text.

 @param url The url to be linked to
 @param range The range in the label text of the link. The range must not exceed the bounds of the receiver.
 */
- (void)addLinkToURL:(NSURL *)url withRange:(NSRange)range;

/**
 Adds a link to an address for a specified range in the label text.

 @param addressComponents A dictionary of address components for the address to be linked to
 @param range The range in the label text of the link. The range must not exceed the bounds of the receiver.

 @discussion The address component dictionary keys are described in `NSTextCheckingResult`'s "Keys for Address Components."
 */
- (void)addLinkToAddress:(NSDictionary *)addressComponents withRange:(NSRange)range;

/**
 Adds a link to a phone number for a specified range in the label text.

 @param phoneNumber The phone number to be linked to.
 @param range The range in the label text of the link. The range must not exceed the bounds of the receiver.
 */
- (void)addLinkToPhoneNumber:(NSString *)phoneNumber withRange:(NSRange)range;

/**
 Adds a link to a date for a specified range in the label text.

 @param date The date to be linked to.
 @param range The range in the label text of the link. The range must not exceed the bounds of the receiver.
 */
- (void)addLinkToDate:(NSDate *)date withRange:(NSRange)range;

/**
 Adds a link to a date with a particular time zone and duration for a specified range in the label text.

 @param date The date to be linked to.
 @param timeZone The time zone of the specified date.
 @param duration The duration, in seconds from the specified date.
 @param range The range in the label text of the link. The range must not exceed the bounds of the receiver.
 */
- (void)addLinkToDate:(NSDate *)date timeZone:(NSTimeZone *)timeZone duration:(NSTimeInterval)duration withRange:(NSRange)range;

@end

/**
 The `PSPDFAttributedLabelDelegate` protocol defines the messages sent to an attributed label delegate when links are tapped. All of the methods of this protocol are optional.
 */
@protocol PSPDFAttributedLabelDelegate <NSObject>

///-----------------------------------
/// @name Responding to Link Selection
///-----------------------------------
@optional

/**
 Tells the delegate that the user did select a link to a URL.

 @param label The label whose link was selected.
 @param url The URL for the selected link.
 */
- (void)attributedLabel:(PSPDFAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url;

/**
 Tells the delegate that the user did select a link to an address.

 @param label The label whose link was selected.
 @param addressComponents The components of the address for the selected link.
 */
- (void)attributedLabel:(PSPDFAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents;

/**
 Tells the delegate that the user did select a link to a phone number.

 @param label The label whose link was selected.
 @param phoneNumber The phone number for the selected link.
 */
- (void)attributedLabel:(PSPDFAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber;

/**
 Tells the delegate that the user did select a link to a date.

 @param label The label whose link was selected.
 @param date The date for the selected link.
 */
- (void)attributedLabel:(PSPDFAttributedLabel *)label didSelectLinkWithDate:(NSDate *)date;

/**
 Tells the delegate that the user did select a link to a date with a time zone and duration.

 @param label The label whose link was selected.
 @param date The date for the selected link.
 @param timeZone The time zone of the date for the selected link.
 @param duration The duration, in seconds from the date for the selected link.
 */
- (void)attributedLabel:(PSPDFAttributedLabel *)label didSelectLinkWithDate:(NSDate *)date timeZone:(NSTimeZone *)timeZone duration:(NSTimeInterval)duration;
@end
