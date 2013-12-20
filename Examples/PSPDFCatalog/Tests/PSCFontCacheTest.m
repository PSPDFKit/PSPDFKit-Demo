//
//  PSCFontCacheTest.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCFontCacheTest.h"

@interface PSCFontCacheTest () <PSPDFTextSearchDelegate>
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) PSPDFDocument *doc;
@end

@implementation PSCFontCacheTest

static PSCFontCacheTest *instance = nil;

+ (void)runWithDocumentAtPath:(NSString *)path {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [PSCFontCacheTest new];
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

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFTextSearchDelegate

- (void)didFinishSearch:(PSPDFTextSearch *)textSearch term:(NSString *)searchTerm
        searchResults:(NSArray *)searchResults isFullSearch:(BOOL)isFullSearch {
  NSLog(@"%@\n\n\n\n\n\n\n\n\n\n\n\n-----------------------------------------------------------------------------------------------------------------------", [self.doc textParserForPage:9].text);

  self.doc = nil;
  [self performSelector:@selector(runWithDocumentAtPath:) withObject:self.path afterDelay:2];
}

@end
