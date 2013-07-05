//
//  PSCCoreDataAnnotationProvider.m
//  PSPDFCatalog
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCCoreDataAnnotationProvider.h"
#import "PSCCoreDataAnnotation.h"

@interface PSCCoreDataAnnotationProvider() {
    dispatch_queue_t _annotationProviderQueue;
}
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSMutableDictionary *annotationCache;
@end

@implementation PSCCoreDataAnnotationProvider

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDocumentProvider:(PSPDFDocumentProvider *)documentProvider {
    if (self = [super init]) {
        _documentProvider = documentProvider;
        _annotationCache = [[NSMutableDictionary alloc] initWithCapacity:documentProvider.pageCount];
        _annotationProviderQueue = dispatch_queue_create([NSString stringWithFormat:@"com.PSPDFCatalog.%@", self].UTF8String, DISPATCH_QUEUE_SERIAL);
        [self setupCoreDataStack];
    }
    return self;
}

- (void)dealloc {
    PSPDFDispatchRelease(_annotationProviderQueue);
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFAnnotationProvider

- (NSArray *)annotationsForPage:(NSUInteger)page {
    __block NSArray *annotations = nil;
    
    dispatch_sync(_annotationProviderQueue, ^{
        annotations = _annotationCache[@(page)];
        if (!annotations) {
            [self.managedObjectContext performBlockAndWait:^{

                // We don't care about sorting
                NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass(PSCCoreDataAnnotation.class)];
                request.predicate = [NSPredicate predicateWithFormat:@"page = %d", page];
                NSError *error = nil;
                NSArray *fetchedAnnotations = [self.managedObjectContext executeFetchRequest:request error:&error];
                if (error) {
                    NSLog(@"Error while fetching annotations: %@", error.localizedDescription);
                }

                // Save in the annotation cache
                self.annotationCache[@(page)] = [NSArray arrayWithArray:fetchedAnnotations];
            }];
        }
    });
    return annotations;
    
/*
    Document *document = (Document *)[[NSManagedObjectContext contextForCurrentThread] existingObjectWithID:self.documentID error:nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"page = %d AND document = %@", page, document];
    NSArray *annotations = [Annotation findAllWithPredicate:predicate inContext:[NSManagedObjectContext contextForCurrentThread]];
    if (page == 0) {
        NSLog(@"core data annotations %@ in page %d", annotations, page);
    }
    return annotations;


    NSArray *annotationsForPage = nil;
    @synchronized (self) {
        NSArray *cachedAnnotationsForPage = [self pageCacheForPage:page];
        annotationsForPage = [cachedAnnotationsForPage valueForKey:@"annotation"];
    }
    return annotationsForPage;*/
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Core Data Initialization

- (NSString *)storePath {
    return [self.documentProvider.document.dataDirectory stringByAppendingPathComponent:@"PSCCoreDataExample.sqlite"];
}

- (void)setupCoreDataStack {
	// Load the model
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PSCCoreDataAnnotationExample" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

	// Setup persistent store coordinator
	NSURL *storeURL = [NSURL fileURLWithPath:self.storePath];
	NSError *error = nil;
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
	if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
		// Remove store and retry once.
		[[NSFileManager defaultManager] removeItemAtURL:storeURL error:NULL];
		if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
			NSLog(@"Failed to create sqlite store: %@", error.localizedDescription);
			abort();
		}
	}

	// Create managed object context
	_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
	[_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
}

@end
