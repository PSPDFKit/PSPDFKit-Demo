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

@interface PSCCoreDataAnnotationProvider()
@property (nonatomic, copy) NSString *databasePath;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

@implementation PSCCoreDataAnnotationProvider

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (instancetype)initWithDocumentProvider:(PSPDFDocumentProvider *)documentProvider databasePath:(NSString *)databasePath {
    if (self = [super initWithDocumentProvider:documentProvider]) {
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
    [self performBlockForReading:^{
        annotations = [super annotationsForPage:page];
    }];

    // If no annotations are cached, load them from the core data store.
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
            PSPDFDocument *document = self.documentProvider.document;
            for (PSCCoreDataAnnotation *coreDataAnnotation in fetchedAnnotations) {
                PSPDFAnnotation *annotation = nil;
                @try {
                    // Set up the unarchiver
                    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:coreDataAnnotation.annotationData];

                    // Check for custom annotation subclasses and make sure they are used when annotations are loaded.
                    PSPDFAnnotationRegisterOverrideClasses(unarchiver, document);

                    annotation = [unarchiver decodeObjectForKey:@"root"];
                    if (![annotation isKindOfClass:PSPDFAnnotation.class]) {
                        annotation = nil;
                    }
                    annotation.page = page; // Don't trust the page saved inside the archive, always manually set.
                }
                @catch (NSException *exception) {
                    NSLog(@"Failed to unarchive annotation: %@", exception);
                }
                if (annotation) [newAnnotations addObject:annotation];
            }

            // Save in the annotation cache
            annotations = [NSArray arrayWithArray:newAnnotations]; // immutable copy
            [self setAnnotations:newAnnotations forPage:page append:NO];
        }];
    }

    return annotations;
}

- (NSArray *)addAnnotations:(NSArray *)annotations options:(NSDictionary *)options {
    if (annotations.count == 0) return annotations;

    [self.managedObjectContext performBlock:^{
        // Iterate over all annotations and create objects in CoreData.
        for (PSPDFAnnotation *annotation in annotations) {
            [self convertAnnotationToCoreData:annotation initialInsert:YES];
        }
    }];

    return [super addAnnotations:annotations options:options];
}

- (NSArray *)removeAnnotations:(NSArray *)annotations options:(NSDictionary *)options {
    if (annotations.count == 0) return annotations;

    [self.managedObjectContext performBlockAndWait:^{
        for (PSPDFAnnotation *annotation in annotations) {
            // Iterate over all annotations and create objects in CoreData.
            PSCCoreDataAnnotation *coreDataAnnotation = [self coreDataAnnotationFromAnnotation:annotation];
            if (coreDataAnnotation) {
                [self.managedObjectContext deleteObject:coreDataAnnotation];
            }
        }
    }];

    return [super removeAnnotations:annotations options:options];
}

- (PSCCoreDataAnnotation *)coreDataAnnotationFromAnnotation:(PSPDFAnnotation *)annotation {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass(PSCCoreDataAnnotation.class)];
    request.predicate = [NSPredicate predicateWithFormat:@"uuid = %@", annotation.name];
    request.fetchLimit = 1; // We only check
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:NULL];
    return result.count > 0 ? result[0] : nil;

}

- (void)convertAnnotationToCoreData:(PSPDFAnnotation *)annotation initialInsert:(BOOL)initialInsert {
    // Fetch or Create root user data managed object
    [self.managedObjectContext performBlock:^{
        PSCCoreDataAnnotation *coreDataAnnotation = nil;
        if (!initialInsert) {
            coreDataAnnotation = [self coreDataAnnotationFromAnnotation:annotation];
        }

        // If we can't find the annotation in the database, insert a new one.
        if (!coreDataAnnotation) {
            coreDataAnnotation = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(PSCCoreDataAnnotation.class) inManagedObjectContext:self.managedObjectContext];
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
    [self.managedObjectContext performBlockAndWait:^{
        success = [self.managedObjectContext save:error];
    }];
    return success;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Subclassing Hooks

- (NSUInteger)pageForAnnotation:(PSPDFAnnotation *)annotation {
    return annotation.page;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Advanced Annotation Moving

- (void)insertPagesAtRange:(NSRange)pageRange {
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
        [self removeAllAnnotationsWithOptions:@{PSPDFAnnotationOptionSuppressNotificationsKey: @YES}];
    }];

    // Save changes.
    [self.managedObjectContext save:NULL];
}

- (void)deletePagesInRange:(NSRange)pageRange {
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
        [self removeAllAnnotationsWithOptions:@{PSPDFAnnotationOptionSuppressNotificationsKey: @YES}];
    }];

    // Save changes.
    [self.managedObjectContext save:NULL];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Core Data Initialization

- (void)setupCoreDataStack {
	// Load the model
    NSURL *modelURL = [NSBundle.mainBundle URLForResource:@"CoreDataAnnotationExample" withExtension:@"momd"];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    // Create folder
    [[NSFileManager new] createDirectoryAtPath:[self.databasePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:NULL];

	// Setup persistent store coordinator
	NSURL *storeURL = [NSURL fileURLWithPath:self.databasePath];
	NSError *error = nil;
	self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
	if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
		// Remove store and retry once.
		[NSFileManager.defaultManager removeItemAtURL:storeURL error:NULL];
		if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
			NSLog(@"Failed to create sqlite store: %@", error.localizedDescription);
			abort();
		}
	}

	// Create managed object context
	self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
	[self.managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
}

@end
