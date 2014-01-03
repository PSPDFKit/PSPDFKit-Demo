//
//  PSCCoreDataAnnotationProvider.m
//  PSPDFCatalog
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCCoreDataAnnotationProvider.h"
#import "PSCCoreDataAnnotation.h"

@interface PSCCoreDataAnnotationProvider() {
    dispatch_queue_t _annotationProviderQueue;
}
@property (nonatomic, copy) NSString *databasePath;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSMutableDictionary *annotationCache;
@end

@implementation PSCCoreDataAnnotationProvider

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDocumentProvider:(PSPDFDocumentProvider *)documentProvider databasePath:(NSString *)databasePath {
    if (self = [super init]) {
        _documentProvider = documentProvider;
        _annotationCache = [[NSMutableDictionary alloc] initWithCapacity:documentProvider.pageCount];
        _annotationProviderQueue = dispatch_queue_create([NSString stringWithFormat:@"com.PSPDFCatalog.%@", self].UTF8String, DISPATCH_QUEUE_SERIAL);

        // Save database path or set up default.
        _databasePath = databasePath ?: [documentProvider.document.dataDirectory stringByAppendingPathComponent:@"PSCCoreDataExample.sqlite"];

        [self setupCoreDataStack];
    }
    return self;
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
                        annotation.page = page; // Don't trust the page saved inside the archive, always manually set.
                    }
                    @catch (NSException *exception) {
                        NSLog(@"Failed to unarchive annotation: %@", exception);
                    }
                    if (annotation) [newAnnotations addObject:annotation];
                }

                // Save in the annotation cache
                annotations = [NSArray arrayWithArray:newAnnotations]; // immutable copy
                self.annotationCache[@(page)] = newAnnotations; // save as mutable
            }];
        }
    });
    return annotations;
}

NS_INLINE void psc_dispatch_main_async(dispatch_block_t block) {
    !NSThread.isMainThread ? dispatch_async(dispatch_get_main_queue(), block) : block();
}

- (NSArray *)addAnnotations:(NSArray *)annotations {
    if (annotations.count == 0) return annotations;

    dispatch_async(_annotationProviderQueue, ^{
        [_managedObjectContext performBlock:^{
            // Iterate over all annotations and create objects in CoreData.
            for (PSPDFAnnotation *annotation in annotations) {
                [self convertAnnotationToCoreData:annotation initialInsert:YES];

                // Update cache, add annotation
                NSUInteger page = [self pageForAnnotation:annotation];
                NSMutableArray *cachedAnnotations = self.annotationCache[@(page)];
                if ([cachedAnnotations indexOfObjectIdenticalTo:annotation] == NSNotFound) {
                    [cachedAnnotations addObject:annotation];
                }
            }
        }];
    });

    // Send notification.
    // Timing is important here. If on main thread, must be sent instantly!
    psc_dispatch_main_async(^{
        [NSNotificationCenter.defaultCenter postNotificationName:PSPDFAnnotationsAddedNotification object:annotations];
    });

    return annotations;
}

- (NSArray *)removeAnnotations:(NSArray *)annotations {
    if (annotations.count == 0) return annotations;

    NSMutableArray *removedAnnotations = [NSMutableArray array];
    dispatch_sync(_annotationProviderQueue, ^{
        [_managedObjectContext performBlockAndWait:^{
            for (PSPDFAnnotation *annotation in annotations) {
                // Iterate over all annotations and create objects in CoreData.
                PSCCoreDataAnnotation *coreDataAnnotation = [self coreDataAnnotationFromAnnotation:annotation];
                if (coreDataAnnotation) {
                    [_managedObjectContext deleteObject:coreDataAnnotation];
                    [removedAnnotations addObject:annotation];
                }

                // Update cache
                NSUInteger page = [self pageForAnnotation:annotation];
                NSMutableArray *cachedAnnotations = self.annotationCache[@(page)];
                [cachedAnnotations removeObject:annotation];
            }
        }];
    });

    // Send notification.
    if (removedAnnotations.count > 0) {
        psc_dispatch_main_async(^{
            [NSNotificationCenter.defaultCenter postNotificationName:PSPDFAnnotationsRemovedNotification object:removedAnnotations];
        });
    }

    return removedAnnotations;
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
        }

        // If we can't find the annotation in the database, insert a new one.
        if (!coreDataAnnotation) {
            coreDataAnnotation = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(PSCCoreDataAnnotation.class) inManagedObjectContext:_managedObjectContext];
            coreDataAnnotation.uuid = annotation.name;
        }

        // Serialize annotations and set page.
        coreDataAnnotation.annotationData = [NSKeyedArchiver archivedDataWithRootObject:annotation];
        coreDataAnnotation.page = [self pageForAnnotation:annotation];
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
    NSMutableDictionary *dirtyAnnotations = [NSMutableDictionary new];
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
#pragma mark - Subclassing Hooks

- (NSUInteger)pageForAnnotation:(PSPDFAnnotation *)annotation {
    return annotation.page;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Advanced Annotation Moving

- (void)insertPagesAtRange:(NSRange)pageRange {
    dispatch_sync(_annotationProviderQueue, ^{
        [self.managedObjectContext performBlockAndWait:^{

            // Get all affected annotations
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass(PSCCoreDataAnnotation.class)];
            request.predicate = [NSPredicate predicateWithFormat:@"page >= %d", pageRange.location];

            NSError *error = nil;
            NSArray *fetchedAnnotations = [self.managedObjectContext executeFetchRequest:request error:&error];
            if (error) {
                NSLog(@"Error while fetching annotations: %@", error.localizedDescription);
            }

            // Move pages up!
            for (PSCCoreDataAnnotation *coreDataAnnotation in fetchedAnnotations) {
                coreDataAnnotation.page += pageRange.length;
            }

            // Completely trash cache.
            [self.annotationCache removeAllObjects];
        }];
        
        // Save changes.
        [self.managedObjectContext save:NULL];
    });
}

- (void)deletePagesInRange:(NSRange)pageRange {
    dispatch_sync(_annotationProviderQueue, ^{
        [self.managedObjectContext performBlockAndWait:^{

            // Get all affected annotations
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass(PSCCoreDataAnnotation.class)];
            request.predicate = [NSPredicate predicateWithFormat:@"page >= %d", pageRange.location];

            NSError *error = nil;
            NSArray *fetchedAnnotations = [self.managedObjectContext executeFetchRequest:request error:&error];
            if (error) {
                NSLog(@"Error while fetching annotations: %@", error.localizedDescription);
            }

            // Either delete entries or move pages around.
            for (PSCCoreDataAnnotation *coreDataAnnotation in fetchedAnnotations) {
                if (NSLocationInRange(coreDataAnnotation.page, pageRange)) {
                    [self.managedObjectContext deleteObject:coreDataAnnotation];
                }else {
                    coreDataAnnotation.page -= pageRange.length;
                }
            }

            // Completely trash cache.
            [self.annotationCache removeAllObjects];
        }];

        // Save changes.
        [self.managedObjectContext save:NULL];
    });
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Core Data Initialization

- (void)setupCoreDataStack {
	// Load the model
    NSURL *modelURL = [NSBundle.mainBundle URLForResource:@"CoreDataAnnotationExample" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    // Create folder
    [[NSFileManager new] createDirectoryAtPath:[self.databasePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:NULL];

	// Setup persistent store coordinator
	NSURL *storeURL = [NSURL fileURLWithPath:self.databasePath];
	NSError *error = nil;
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
	if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
		// Remove store and retry once.
		[NSFileManager.defaultManager removeItemAtURL:storeURL error:NULL];
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
