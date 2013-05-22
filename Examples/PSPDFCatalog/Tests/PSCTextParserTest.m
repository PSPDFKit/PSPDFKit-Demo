//
//  PSCTextParserTest.m
//  PSPDFCatalog-
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
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
    NSLog(@"%@", self.document);
    [self.document unlockWithPassword:@"test123"];
    NSLog(@"%@", self.document);
    PSPDFTextSearch *search = [[PSPDFTextSearch alloc] initWithDocument:self.document];
    search.delegate = self;
    [search searchForString:@"encrypted"];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFTextSearchDelegate

- (void)didFinishSearch:(PSPDFTextSearch *)textSearch forTerm:(NSString *)searchTerm
          searchResults:(NSArray *)searchResults isFullSearch:(BOOL)isFullSearch {

    NSLog(@"Search results: %@", searchResults);
}

@end
