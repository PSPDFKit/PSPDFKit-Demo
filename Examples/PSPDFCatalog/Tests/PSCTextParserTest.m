//
//  PSCTextParserTest.m
//  PSPDFCatalog-
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSCTextParserTest.h"

@interface PSCTextParserTest () <PSPDFTextSearchDelegate>
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) PSPDFDocument *document;
@end

@implementation PSCTextParserTest

static PSCTextParserTest *instance = nil;

+ (void)runWithDocumentAtPath:(NSString *)path {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [PSCTextParserTest new];
    });

    [instance runWithDocumentAtPath:path];
}

- (void)runWithDocumentAtPath:(NSString *)path {
    self.path = path;
    self.document = [[PSPDFDocument alloc] initWithURL:[NSURL fileURLWithPath:path]];
    PSPDFTextSearch *search = [[PSPDFTextSearch alloc] initWithDocument:self.document];
    search.delegate = self;
    [search searchForString:@"batman"];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFTextSearchDelegate

- (void)didFinishSearch:(PSPDFTextSearch *)textSearch forTerm:(NSString *)searchTerm
          searchResults:(NSArray *)searchResults isFullSearch:(BOOL)isFullSearch {

    NSLog(@"Search results: %@", searchResults);
}

@end
