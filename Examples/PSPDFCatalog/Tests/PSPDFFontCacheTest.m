//
//  PSPDFFontCacheTest.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFFontCacheTest.h"

@interface PSPDFFontCacheTest () <PSPDFTextSearchDelegate>
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) PSPDFDocument *doc;
@end

@implementation PSPDFFontCacheTest

static PSPDFFontCacheTest *instance = nil;

+ (void)runWithDocumentAtPath:(NSString *)path {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [PSPDFFontCacheTest new];
    });

    [instance runWithDocumentAtPath:path];
}

- (void)runWithDocumentAtPath:(NSString *)path {
  self.path = path;
  self.doc = [[PSPDFDocument alloc] initWithURL:[NSURL fileURLWithPath:path]];
  PSPDFTextSearch *search = [[PSPDFTextSearch alloc] initWithDocument:self.doc];
  search.delegate = self;
  [search searchForString:@"test"];
}

- (void)didFinishSearch:(PSPDFTextSearch *)textSearch forTerm:(NSString *)searchTerm
          searchResults:(NSArray *)searchResults isFullSearch:(BOOL)isFullSearch {
  NSLog(@"%@\n\n\n\n\n\n\n\n\n\n\n\n-----------------------------------------------------------------------------------------------------------------------", [self.doc textParserForPage:9].text);
  
  self.doc = nil;
  [self performSelector:@selector(runWithDocumentAtPath:) withObject:self.path afterDelay:2];
}

@end
