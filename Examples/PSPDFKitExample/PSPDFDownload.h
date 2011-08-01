//
//  PSPDFDownload.h
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/24/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSPDFDownload : NSObject {
    NSURL *url_;
}

+ (PSPDFDownload *)PDFDownloadWithURL:(NSURL *)url;
- (id)initWithURL:(NSURL *)url;

- (void)start;

@property(nonatomic, retain, readonly) NSURL *url;

@end
