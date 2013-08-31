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
        _annotationProviderQueue = dispatch_queue_create([[NSString stringWithFormat:@"com.PSPDFCatalog.%@", self] UTF8String], DISPATCH_QUEUE_SERIAL);
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

                NSMutableArray *newAnnotations = [NSMutableArray array];
                for (PSCCoreDataAnnotation *coreDataAnnotation in fetchedAnnotations) {
                    PSPDFAnnotation *annotation = nil;
                    @try {
                        annotation = [NSKeyedUnarchiver unarchiveObjectWithData:coreDataAnnotation.annotationData];
                    }
                    @catch (NSException *exception) {
                        NSLog(@"Failed to unarchive annotation: %@", exception);
                    }
                    if (annotation) [newAnnotations addObject:annotation];
                }

                // Save in the annotation cache
                annotations = [NSArray arrayWithArray:newAnnotations];
                self.annotationCache[@(page)] = annotations;
            }];
        }
    });
    return annotations;
}

- (NSArray *)addAnnotations:(NSArray *)annotations {
    dispatch_async(_annotationProviderQueue, ^{
        [_managedObjectContext performBlock:^{
            // Iterate over all annotations and create objects in CoreData.
            for (PSPDFAnnotation *annotation in annotations) {
                [self convertAnnotationToCoreData:annotation initialInsert:YES];

                // Clear cache
                [self.annotationCache removeObjectForKey:@(annotation.page)];
            }
        }];
    });
    return annotations;
}

- (NSArray *)removeAnnotations:(NSArray *)annotations {
    __block BOOL success = YES;

    dispatch_sync(_annotationProviderQueue, ^{
        [_managedObjectContext performBlock:^{
            for (PSPDFAnnotation *annotation in annotations) {
                // Iterate over all annotations and create objects in CoreData.
                PSCCoreDataAnnotation *coreDataAnnotation = [self coreDataAnnotationFromAnnotation:annotation];
                if (coreDataAnnotation) {
                    [_managedObjectContext deleteObject:coreDataAnnotation];
                }else {
                    success = NO;
                }
                // Clear cache
                [self.annotationCache removeObjectForKey:@(annotation.page)];
            }
        }];
    });
    return annotations;
}

- (PSCCoreDataAnnotation *)coreDataAnnotationFromAnnotation:(PSPDFAnnotation *)annotation {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass(PSCCoreDataAnnotation.class)];
    request.predicate = [NSPredicate predicateWithFormat:@"uuid = %@", annotation.name];
    request.fetchLimit = 1; // We only check
    NSArray *result = [_managedObjectContext executeFetchRequest:request error:NULL];
    return result.count > 0 ? result[0] : nil;

}

- (void)convertAnnotationToCoreData:(PSPDFAnnotation *)annotation initialInsert:(BOOL)initialInsert {
    // Fetch or Create root user data managed object
    [_managedObjectContext performBlock:^{
        PSCCoreDataAnnotation *coreDataAnnotation = nil;
        if (!initialInsert) {
            coreDataAnnotation = [self coreDataAnnotationFromAnnotation:annotation];
        }else {
            // Use 'name' to create a UUID for every annotation so we can uniquify them.
            // PSPDFKit v3 already sets a UUID in name, but we need to manually add this in v2.
            if (!annotation.name) {
                CFUUIDRef uuidRef = CFUUIDCreate(NULL);
                annotation.name = CFBridgingRelease(CFUUIDCreateString(NULL, uuidRef));
                CFRelease(uuidRef);
            }
        }

        // If we can't find the annotation in the database, insert a new one.
        if (!coreDataAnnotation) {
            coreDataAnnotation = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(PSCCoreDataAnnotation.class) inManagedObjectContext:_managedObjectContext];
            coreDataAnnotation.uuid = annotation.name;
        }

        // Serialize annotations and set page.
        coreDataAnnotation.annotationData = [NSKeyedArchiver archivedDataWithRootObject:annotation];
        coreDataAnnotation.page = annotation.page;
    }];
}

- (void)didChangeAnnotation:(PSPDFAnnotation *)annotation keyPaths:(NSArray *)keyPaths options:(NSDictionary *)options {
    // Immediately serialize annotation to CoreData.
    [self convertAnnotationToCoreData:annotation initialInsert:NO];
}

// Saves the context.
- (BOOL)saveAnnotationsWithOptions:(NSDictionary *)options error:(NSError *__autoreleasing*)error {
    __block BOOL success;
    dispatch_sync(_annotationProviderQueue, ^{
        success = [_managedObjectContext save:error];
    });
    return success;
}

// Return all cached annotations so we tell PSPDFKit that we always want to be saved.
- (NSDictionary *)dirtyAnnotations {
    NSMutableDictionary *dirtyAnnotations = [[NSMutableDictionary alloc] init];
    dispatch_sync(_annotationProviderQueue, ^{
        [self.annotationCache enumerateKeysAndObjectsUsingBlock:^(NSNumber *page, NSArray *annotations, BOOL *stop) {
            dirtyAnnotations[page] = [annotations copy];
        }];
    });
    return dirtyAnnotations;
}

- (BOOL)shouldSaveAnnotations {
    return YES; // always save.
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Core Data Initialization

- (NSString *)storePath {
    return [self.documentProvider.document.dataDirectory stringByAppendingPathComponent:@"PSCCoreDataExample.sqlite"];
}

- (void)setupCoreDataStack {
	// Load the model
    NSURL *modelURL = [NSBundle.mainBundle URLForResource:@"CoreDataAnnotationExample" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    // Create folder
    [[NSFileManager new] createDirectoryAtPath:[self.storePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:NULL];

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
