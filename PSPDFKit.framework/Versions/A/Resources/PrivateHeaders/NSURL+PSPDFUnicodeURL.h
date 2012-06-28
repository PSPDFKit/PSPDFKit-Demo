//
//  NSURL+PSPDFUnicodeURL.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@interface NSURL (PSPDFUnicodeURL)

// These two take a normal NSString that may (or may not) contain a URL with a non-ASCII host name.
// Normally NSURL doesn't work with these kinds of URLs (at least on iPhoneOS as of 3.2).
// This will decode them according to the various RFCs into the ASCII host name and return a normal NSURL
// object instance made with the converted host string in place of the unicode one.
// NOTE: These methods also sanitize the path/query by decoding and re-encoding any percent escaped stuff.
// NSURL doesn't normally do anything like that, but I found it handy to have.
- (id)initWithUnicodeString_pspdf:(NSString *)str;

// This will return the same thing as NSURL's absoluteString method, but it converts the domain back into
// the unicode characters that a user would expect to see in a UI, etc.
- (NSString *)pspdf_unicodeAbsoluteString;

// Returns the same as NSURL's host method, but will convert it back into the unicode characters if possible.
- (NSString *)pspdf_unicodeHost;

@end
