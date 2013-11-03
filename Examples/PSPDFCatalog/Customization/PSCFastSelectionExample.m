//
//  PSCFastSelectionExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCFastSelectionExample.h"
#import "PSCAssetLoader.h"

@interface PSCFastTextSelectionView : PSPDFTextSelectionView @end

@implementation PSCFastSelectionExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Faster Text Selection";
        self.category = PSCExampleCategoryViewCustomization;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    [pdfController overrideClass:PSPDFTextSelectionView.class withClass:PSCFastTextSelectionView.class];
    return pdfController;
}

@end

@implementation PSCFastTextSelectionView

// The default will call [UIReferenceLibraryViewController dictionaryHasDefinitionForTerm:term], which can be slow.
// Override this method to customize; in this case we say that there's always a dictionary term available - even if there isn't.
- (BOOL)dictionaryHasDefinitionForTerm:(NSString *)term {
    return YES;
}

@end
